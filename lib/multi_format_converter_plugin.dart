import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Описываем сигнатуру Си-функции для FFI
typedef ConvertToPdfC = Int32 Function(Pointer<Utf8> sourcePath, Pointer<Utf8> targetPdfPath);
typedef ConvertToPdfDart = int Function(Pointer<Utf8> sourcePath, Pointer<Utf8> targetPdfPath);

class MultiFormatConverterPlugin {
  static const String _libName = 'multi_format_converter';

  /// Метод конвертации любого поддерживаемого документа в PDF
  /// Возвращает true в случае успеха, false при ошибке
  static Future<bool> convert(String sourcePath, String targetPdfPath) async {
    try {
      // Динамически открываем нашу скомпилированную Native Assets библиотеку
      final DynamicLibrary nativeLib = DynamicLibrary.open('lib$_libName.so');

      // Ищем нашу Си-функцию внутри библиотеки
      final ConvertToPdfDart convertFunc = nativeLib
          .lookup<NativeFunction<ConvertToPdfC>>('convert_to_pdf')
          .asFunction<ConvertToPdfDart>();

      // Переводим Dart-строки путей в понятные для Си указатели Pointer<Utf8>
      final Pointer<Utf8> sourcePtr = sourcePath.toNativeUtf8();
      final Pointer<Utf8> targetPtr = targetPdfPath.toNativeUtf8();

      // Вызываем нативный метод MuPDF
      final int resultCode = convertFunc(sourcePtr, targetPtr);

      // Обязательно освобождаем выделенную память под строки в куче Си
      malloc.free(sourcePtr);
      malloc.free(targetPtr);

      // Возвращаем результат: 0 — это успех (как мы написали в Си-коде)
      return resultCode == 0;
    } catch (e) {
      print('Ошибка выполнения FFI конвертера: $e');
      return false;
    }
  }
}