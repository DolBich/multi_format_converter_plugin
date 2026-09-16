import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Описываем типы данных Си-функции для FFI
typedef ConvertToPdfC = Int32 Function(Pointer<Utf8> sourcePath, Pointer<Utf8> targetPdfPath);
typedef ConvertToPdfDart = int Function(Pointer<Utf8> sourcePath, Pointer<Utf8> targetPdfPath);

class MultiFormatConverterPlugin {
  static const String _libName = 'multi_format_converter';

  // Открываем динамическую библиотеку, сгенерированную системой Native Assets
  static final DynamicLibrary _nativeLib = DynamicLibrary.open('lib$_libName.so');

  // Находим Си-символ функции внутри библиотеки
  static final ConvertToPdfDart _convertFunc = _nativeLib
      .lookup<NativeFunction<ConvertToPdfC>>('convert_to_pdf')
      .asFunction<ConvertToPdfDart>();

  /// Нативный метод конвертации документа (DOCX, EPUB, FB2, MD, SVG, XPS, CBZ) в PDF.
  ///
  /// Возвращает [true] в случае стопроцентного успеха (код 0 из Си).
  static Future<bool> convert(String sourcePath, String targetPdfPath) async {
    try {
      // Выделяем память в куче Си и кодируем Dart-строки в UTF-8 указатели
      final Pointer<Utf8> sourcePtr = sourcePath.toNativeUtf8();
      final Pointer<Utf8> targetPtr = targetPdfPath.toNativeUtf8();

      // Вызываем наш скомпилированный нативный метод MuPDF
      final int resultCode = _convertFunc(sourcePtr, targetPtr);

      // Обязательно освобождаем память, чтобы избежать утечек!
      malloc.free(sourcePtr);
      malloc.free(targetPtr);

      // 0 — это код успеха, который мы заложили в файле multi_format_converter.c
      return resultCode == 0;
    } catch (e) {
      print('Ошибка выполнения FFI конвертера: $e');
      return false;
    }
  }
}
