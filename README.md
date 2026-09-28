# Multi Format Converter Plugin

A Flutter plugin for converting multiple document formats to PDF using a native MuPDF-based implementation.

## Overview

`multi_format_converter_plugin` integrates native document conversion into Flutter through Dart FFI.

The plugin provides a Dart API for converting supported document formats to PDF while keeping the conversion logic in native code.

## Supported Formats

The native converter is currently designed to support formats such as:

* DOCX
* EPUB
* FB2
* Markdown
* SVG
* XPS
* CBZ

## How It Works

The plugin uses:

* **Dart FFI** to communicate with native code
* **C** for the native conversion layer
* **CMake** to build the native library
* **Android NDK** for Android native compilation
* **Flutter native assets / dynamic libraries** for packaging the native component

At runtime, Dart loads the native library, resolves the conversion function, passes the input data through the FFI boundary, and receives the conversion result.

## Project Structure

```text
lib/
└── multi_format_converter_plugin.dart

src/
├── CMakeLists.txt
└── multi_format_converter.c

hook/
└── build.dart
```

## Technical Highlights

The project demonstrates:

* Dart ↔ C interoperability through FFI
* Native memory management across the FFI boundary
* Dynamic library loading and symbol lookup
* Native asset bundling for Flutter
* Cross-platform native build integration
* Integration of a third-party native document engine
* Automated native compilation through a Flutter build hook

## Usage

```dart
final result = await MultiFormatConverterPlugin.convertToPdf(
  inputPath: '/path/to/input.docx',
  outputPath: '/path/to/output.pdf',
);
```

> API details may change while the plugin is being prepared for publication on pub.dev.

## Status

This project is currently under development and is being prepared for publication on [pub.dev](https://pub.dev/).

## License

The original code in this repository is licensed under the MIT License.

See [LICENSE](LICENSE) for details.

### Third-party components

This project integrates third-party software, including MuPDF, which is subject to its own licensing terms. Third-party licenses and notices apply separately from the license of this repository's original code.
