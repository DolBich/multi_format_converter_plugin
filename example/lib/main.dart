import 'package:flutter/material.dart';
import 'package:multi_format_converter_plugin/multi_format_converter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multi Format Converter Test'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Тестовый вызов (пока просто проверяем, что метод вызывается без краша FFI)
              try {
                final success = await MultiFormatConverterPlugin.convert(
                    '/path/to/input.docx',
                    '/path/to/output.pdf'
                );
                print('Результат конвертации: $success');
              } catch (e) {
                print('Ошибка FFI: $e');
              }
            },
            child: const Text('Проверить конвертер Word в PDF'),
          ),
        ),
      ),
    );
  }
}
