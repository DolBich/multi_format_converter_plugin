import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) {
      return;
    }

    final packageName = input.packageName;
    final codeConfig = input.config.code;

    if (codeConfig.targetOS != OS.android) {
      return;
    }

    final compiler = codeConfig.cCompiler;
    if (compiler == null) {
      throw Exception(
        'Flutter не передал компилятор C. '
            'Проверьте установку Android NDK.',
      );
    }

    // ----------------------------------------------------------
    // Internal CMake build directory.
    // This is only a temporary build location.
    // ----------------------------------------------------------

    final buildDir = Directory.fromUri(
      input.packageRoot.resolve(
        '.dart_tool/native_assets_builder/mupdf_build/',
      ),
    );

    if (buildDir.existsSync()) {
      buildDir.deleteSync(recursive: true);
    }

    buildDir.createSync(recursive: true);

    // ----------------------------------------------------------
    // Locate Android NDK.
    // ----------------------------------------------------------

    final compilerPath = compiler.compiler.toFilePath();

    String ndkPath = '';
    var directory = File(compilerPath).parent;

    while (directory.path != '/' && directory.path.isNotEmpty) {
      final checkDir = Directory(
        '${directory.path}/build/cmake',
      );

      if (checkDir.existsSync()) {
        ndkPath = directory.path;
        break;
      }

      directory = directory.parent;
    }

    if (ndkPath.isEmpty) {
      throw Exception(
        'Не удалось автоматически вычислить путь к Android NDK '
            'по пути компилятора:\n$compilerPath',
      );
    }

    final toolchainPath =
        '$ndkPath/build/cmake/android.toolchain.cmake';

    // ----------------------------------------------------------
    // CMake configuration.
    // ----------------------------------------------------------

    final cmakeArgs = <String>[
      '-S',
      'src',
      '-B',
      buildDir.path,
      '-DCMAKE_TOOLCHAIN_FILE=$toolchainPath',
      '-DCMAKE_C_COMPILER=$compilerPath',
      '-DANDROID_NATIVE_API_LEVEL=${codeConfig.android.targetNdkApi}',
    ];

    final abiString =
        codeConfig.targetArchitecture.toString().split('.').last;

    String cmakeAbi = abiString;

    if (abiString == 'arm64') {
      cmakeAbi = 'arm64-v8a';
    } else if (abiString == 'arm') {
      cmakeAbi = 'armeabi-v7a';
    }

    cmakeArgs.add(
      '-DCMAKE_ANDROID_ARCH_ABI=$cmakeAbi',
    );

    // ----------------------------------------------------------
    // 1. Configure CMake.
    // ----------------------------------------------------------

    final configResult = await Process.run(
      'cmake',
      cmakeArgs,
      workingDirectory: input.packageRoot.toFilePath(),
    );

    if (configResult.exitCode != 0) {
      throw Exception(
        'Ошибка генерации CMake:\n'
            'STDOUT:\n${configResult.stdout}\n'
            'STDERR:\n${configResult.stderr}',
      );
    }

    // ----------------------------------------------------------
    // 2. Build MuPDF.
    // ----------------------------------------------------------

    final buildResult = await Process.run(
      'cmake',
      <String>[
        '--build',
        buildDir.path,
        '--config',
        'Release',
      ],
      workingDirectory: input.packageRoot.toFilePath(),
    );

    if (buildResult.exitCode != 0) {
      throw Exception(
        'Ошибка компиляции MuPDF через NDK:\n'
            'STDOUT:\n${buildResult.stdout}\n'
            'STDERR:\n${buildResult.stderr}',
      );
    }

    // ----------------------------------------------------------
    // 3. Locate resulting shared library.
    // ----------------------------------------------------------

    final builtLibrary = File(
      '${buildDir.path}/libmulti_format_converter.so',
    );

    if (!builtLibrary.existsSync()) {
      throw Exception(
        'CMake завершился успешно, но библиотека не найдена:\n'
            '${builtLibrary.path}\n\n'
            'STDOUT:\n${buildResult.stdout}\n'
            'STDERR:\n${buildResult.stderr}',
      );
    }

    // ----------------------------------------------------------
    // 4. Copy the generated asset to the shared output directory.
    //
    // Native Assets expects generated assets to live there.
    // ----------------------------------------------------------

    final outputLibraryUri =
    input.outputDirectoryShared.resolve(
      'libmulti_format_converter.so',
    );

    final outputLibrary = File.fromUri(
      outputLibraryUri,
    );

    await outputLibrary.parent.create(
      recursive: true,
    );

    await builtLibrary.copy(
      outputLibrary.path,
    );

    if (!outputLibrary.existsSync()) {
      throw Exception(
        'Не удалось разместить native asset:\n'
            '${outputLibrary.path}',
      );
    }

    // ----------------------------------------------------------
    // 5. Register the native asset.
    // ----------------------------------------------------------

    output.assets.code.add(
      CodeAsset(
        package: packageName,
        name: '$packageName.dart',
        linkMode: DynamicLoadingBundled(),
        file: outputLibrary.uri,
      ),
    );

    print(
      'MuPDF native asset собран: '
          '${outputLibrary.path}',
    );
  });
}