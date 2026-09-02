import 'dart:io';
import 'package:code_assets/code_assets.dart'; // Для CodeAsset, OS, DynamicLoadingBundled
import 'package:hooks/hooks.dart';             // Для build и HookInput

void main(List<String> args) async {
  await build(args, (input, output) async {

    if (input.config.buildCodeAssets) {
      final packageName = input.packageName;
      final codeConfig = input.config.code;

      // Сбрасываем старый кэш CMake перед новой сборкой
      final buildDir = Directory('.dart_tool/native_assets_builder/mupdf_build');
      if (buildDir.existsSync()) {
        buildDir.deleteSync(recursive: true);
      }
      buildDir.createSync(recursive: true);

      if (codeConfig.targetOS == OS.android) {
        final compiler = codeConfig.cCompiler;
        if (compiler == null) {
          throw Exception('Flutter не передал компилятор C. Проверьте установку NDK в Android Studio.');
        }

        // --- УМНЫЙ АВТОПОИСК NDK ---
        // Получаем путь к clang, например: /path/to/ndk/2X.X.XXXXX/toolchains/llvm/prebuilt/linux-x86_64/bin/clang
        final compilerPath = compiler.compiler.toFilePath();

        // Поднимаемся вверх до корня версии NDK (папка, где лежит "build/cmake")
        String ndkPath = '';
        var directory = File(compilerPath).parent;

        // На Linux корень файловой системы — это просто '/'
        while (directory.path != '/' && directory.path.isNotEmpty) {
          final checkDir = Directory('${directory.path}/build/cmake');
          if (checkDir.existsSync()) {
            ndkPath = directory.path;
            break;
          }
          directory = directory.parent;
        }

        if (ndkPath.isEmpty) {
          throw Exception('Не удалось автоматически вычислить путь к Android NDK по пути компилятора: $compilerPath');
        }

        final toolchainPath = '$ndkPath/build/cmake/android.toolchain.cmake';

        // Аргументы конфигурации CMake
        final cmakeArgs = [
          '-S', 'src',
          '-B', buildDir.path,
          '-DCMAKE_TOOLCHAIN_FILE=$toolchainPath',
          '-DCMAKE_C_COMPILER=$compilerPath',
          '-DANDROID_NATIVE_API_LEVEL=${codeConfig.android.targetNdkApi}',
        ];

        // Корректируем ABI под стандарты Android NDK
        final abiString = codeConfig.targetArchitecture.toString().split('.').last;
        String cmakeAbi = abiString;
        if (abiString == 'arm64') cmakeAbi = 'arm64-v8a';
        if (abiString == 'arm') cmakeAbi = 'armeabi-v7a';
        cmakeArgs.add('-DCMAKE_ANDROID_ARCH_ABI=$cmakeAbi');

        // 1. Конфигурация проекта CMake
        final configResult = await Process.run('cmake', cmakeArgs);
        if (configResult.exitCode != 0) {
          throw Exception(
              'Ошибка генерации CMake:\n'
                  'STDOUT: ${configResult.stdout}\n'
                  'STDERR: ${configResult.stderr}'
          );
        }

        // 2. Компиляция Си-кода MuPDF
        final buildResult = await Process.run('cmake', ['--build', buildDir.path]);
        if (buildResult.exitCode != 0) {
          throw Exception(
              'Ошибка компиляции MuPDF через NDK:\n'
                  'STDOUT: ${buildResult.stdout}\n'
                  'STDERR: ${buildResult.stderr}'
          );
        }

        // 3. Регистрация скомпилированной .so библиотеки
        output.assets.code.add(
          CodeAsset(
            package: packageName,
            name: '$packageName.dart',
            linkMode: DynamicLoadingBundled(),
            file: Uri.file('${buildDir.path}/libmulti_format_converter.so'),
          ),
        );
        print('Библиотека MuPDF успешно скомпилирована под Android!');
      }
    }
  });
}