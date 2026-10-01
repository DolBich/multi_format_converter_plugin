# Multi Format Converter

A Flutter plugin that converts multiple document formats to PDF on-device using MuPDF and Dart FFI.

The package was created as a native conversion layer for [SimpleReader](https://github.com/DolBich), an Android-first offline reading application. The goal is to support additional document formats without building a separate reader UI and renderer for every format.

## Why this package exists

SimpleReader is designed to work offline. Supporting every input format directly in the reader would require separate rendering pipelines and platform-specific implementations.

Instead, the application can normalize supported documents into a single format:

```text
Input document
      ↓
Native conversion
      ↓
PDF
      ↓
Shared PDF reader
```

This allows the reader UI to remain focused on a single rendering format while document conversion stays isolated in a reusable package.

Two alternatives were considered but did not fit the application's goals:

- **Online conversion** would require uploading documents to an external service and would break the application's offline-first approach.
- **Using an office application installed on the device** would make the reader dependent on external software and prevent it from being fully self-contained.

## Technical Approach

The package combines Flutter FFI, Flutter native asset build hooks, CMake, the Android NDK and MuPDF.

```text
Flutter / Dart
      ↓
      FFI
      ↓
Native Asset Build Hook
      ↓
    CMake
      ↓
 Android NDK
      ↓
  C wrapper
      ↓
    MuPDF
      ↓
      PDF
```

### Dart FFI

The Dart API exposes native conversion functionality through FFI, allowing the Flutter application to call the native converter without introducing an additional Kotlin/JNI bridge.

### Native build pipeline

A custom build hook configures and builds the native library as part of the Flutter package build process.

The build step:

- obtains the compiler configuration from Flutter Native Assets;
- detects the Android target ABI;
- configures CMake;
- builds the required MuPDF components;
- builds the custom native wrapper;
- registers the resulting native asset.

This keeps the native dependency integrated into the package rather than requiring a prebuilt `.so` to be checked into the repository.

### C wrapper around MuPDF

A small C wrapper provides the conversion boundary used by Dart FFI.

The native conversion flow is:

```text
Input file
    ↓
MuPDF document open
    ↓
Page-by-page processing
    ↓
PDF document writer
    ↓
Output PDF
```

## Custom MuPDF Build

MuPDF supports a broad set of document formats. The package configures the native build to include the formats relevant to the planned reader while excluding components that are not needed by the converter.

This reduces unnecessary native build content and keeps the resulting package focused on document conversion.

## Current Status

**Work in progress.**

The native conversion pipeline is implemented and the package can be used as a standalone Flutter plugin, but format compatibility is still being validated.

At the current stage:

- the package is implemented for **Android**;
- **DOCX conversion has been tested**, but the current result still requires improvement;
- other configured formats have not yet been fully validated;
- the package has not yet been integrated into SimpleReader;
- future iOS support is planned;
- the package is intended to be published to **pub.dev** after further development and testing.

## Why FFI + Native Assets

The package intentionally keeps the native converter behind a platform-independent Dart API.

This approach allows the native implementation to evolve separately from the Flutter UI and leaves room for adding other platform implementations later, including iOS.

The native build is also configured through Flutter's build-hook mechanism rather than requiring platform-specific wrapper code for each call from Dart.

<details>
<summary>More technical details</summary>

### Build configuration

The native build uses a custom CMake configuration to selectively include the required MuPDF components.

The package also relies on the Android NDK to compile the native code for the target ABI.

### Error handling

The current Dart API only needs to know whether conversion succeeded or failed, so the native layer currently exposes a compact success/failure result.

The error model can be expanded later without changing the overall FFI architecture.

</details>

## Planned Use in SimpleReader

The intended integration is:

```text
SimpleReader
   ├── PDF → open directly
   ├── supported book/document format
   │        ↓
   │   Multi Format Converter
   │        ↓
   │       PDF
   │        ↓
   └── shared PDF reading pipeline
```

The package is being developed as a reusable building block for this architecture rather than as a standalone end-user application.

## Tech Stack

- **Dart**
- **Flutter**
- **Dart FFI**
- **Flutter Native Assets / build hooks**
- **C**
- **CMake**
- **Android NDK**
- **MuPDF**

## Development Status

This repository represents an ongoing implementation. The architecture and native build pipeline are in place, while broader format validation, integration with SimpleReader, and future platform support are still planned.
