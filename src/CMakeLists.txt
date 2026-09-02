cmake_minimum_required(VERSION 3.10.2)
project(multi_format_converter VERSION 1.0.0 LANGUAGES C CXX)

enable_language(C)

set(MUPDF_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mupdf)
set(MUPDF_SRC_DIR ${MUPDF_DIR}/source)
set(THIRDPARTY_DIR ${MUPDF_DIR}/thirdparty)

# Включаем флаги форматов, отключаем JavaScript, старый цвет и лишние модули FreeType
add_definitions(
    -DFZ_ENABLE_PDF=1
    -DFZ_ENABLE_HTML=1
    -DFZ_ENABLE_XPS=1
    -DFZ_ENABLE_CBZ=1
    -DFZ_ENABLE_SVG=1
    -DSHARE_ZLIB=0
    -DNOTO_BUILD=1
    -DFZ_ENABLE_ICC=0

    # Флаги FreeType
    -DFT2_BUILD_LIBRARY=1
    -DFT_CONFIG_OPTION_DISABLE_AUTOFITTER=1
    -DTT_CONFIG_OPTION_EMBEDDED_BITMAPS=1

    # Отключаем во FreeType регистрацию ненужных драйверов древних форматов
    -DPC_CONFIG_OPTION_NO_ANY=1
    -DFT_CONFIG_OPTION_PURE_C=1
)

# Папки для поиска заголовочных (.h) файлов
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${MUPDF_DIR}/include
    ${THIRDPARTY_DIR}/zlib
    ${THIRDPARTY_DIR}/freetype/include
    ${THIRDPARTY_DIR}/brotli/c/include
    ${THIRDPARTY_DIR}/openjpeg/src/lib/openjp2
    ${THIRDPARTY_DIR}/libjpeg
    ${THIRDPARTY_DIR}/jbig2dec
    ${THIRDPARTY_DIR}/harfbuzz/src
    ${THIRDPARTY_DIR}/gumbo-parser/src
    ${THIRDPARTY_DIR}/cmark-gfm/src
    ${THIRDPARTY_DIR}/cmark-gfm/extensions
)

# --- АВТОМАТИЧЕСКИЙ СБОР ИСХОДНИКОВ ПО МОДУЛЯМ ---

# 1. Базовое ядро (Fitz) + ручное добавление скрытых файлов подсистем
file(GLOB FITZ_SOURCES "${MUPDF_SRC_DIR}/fitz/*.c")
list(FILTER FITZ_SOURCES EXCLUDE REGEX ".*color-lcms\\.c")
list(FILTER FITZ_SOURCES EXCLUDE REGEX ".*output-docx\\.c")
list(FILTER FITZ_SOURCES EXCLUDE REGEX ".*output-html\\.c")

# 2. Модуль работы с PDF
file(GLOB PDF_SOURCES "${MUPDF_SRC_DIR}/pdf/*.c")
list(FILTER PDF_SOURCES EXCLUDE REGEX ".*pdf-js\\.c")

# 3. Модуль HTML/Текста (DOCX, EPUB, FB2, MD)
file(GLOB HTML_SOURCES "${MUPDF_SRC_DIR}/html/*.c")

# 4. Дополнительные форматы (XPS, CBZ, SVG)
file(GLOB XPS_SOURCES "${MUPDF_SRC_DIR}/xps/*.c")
file(GLOB CBZ_SOURCES "${MUPDF_SRC_DIR}/cbz/*.c")
file(GLOB SVG_SOURCES "${MUPDF_SRC_DIR}/svg/*.c")

# 5. Распаковщик архивов ZLIB
file(GLOB ZLIB_SOURCES "${THIRDPARTY_DIR}/zlib/*.c")
set_source_files_properties(${ZLIB_SOURCES} PROPERTIES COMPILE_FLAGS "-include unistd.h")

# 6. Нативный сборщик кода Brotli
file(GLOB BROTLI_SOURCES
    "${THIRDPARTY_DIR}/brotli/c/common/*.c"
    "${THIRDPARTY_DIR}/brotli/c/dec/*.c"
    "${THIRDPARTY_DIR}/brotli/c/enc/*.c"
)

# 7. Нативный сборщик openjpeg
file(GLOB OPENJPEG_SOURCES "${THIRDPARTY_DIR}/openjpeg/src/lib/openjp2/*.c")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*cidx.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*phix.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*thix.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*tpix.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*ppix.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*opj_server.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*opj_malloc\\.c")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*bench.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*test.*")
list(FILTER OPENJPEG_SOURCES EXCLUDE REGEX ".*generate.*")

# 8. Нативный сборщик libjpeg
file(GLOB LIBJPEG_SOURCES "${THIRDPARTY_DIR}/libjpeg/*.c")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*example.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*ckconfig.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*cjpeg.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*djpeg.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jpegtran.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*rdjpgcom.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*wrjpgcom.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*tjunittest.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jmemdos.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jmemansi.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jmemmac.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jmemname.*")
list(FILTER LIBJPEG_SOURCES EXCLUDE REGEX ".*jmemnobs\\.c")

# 9. Нативный сборщик JBIG2
file(GLOB JBIG2_SOURCES "${THIRDPARTY_DIR}/jbig2dec/*.c")
list(FILTER JBIG2_SOURCES EXCLUDE REGEX ".*getopt.*")
list(FILTER JBIG2_SOURCES EXCLUDE REGEX ".*jbig2dec\\.c")
list(FILTER JBIG2_SOURCES EXCLUDE REGEX ".*_png\\.c")
list(FILTER JBIG2_SOURCES EXCLUDE REGEX ".*pbm2png\\.c")
list(FILTER JBIG2_SOURCES EXCLUDE REGEX ".*memento\\.c")

# 10. Нативный сборщик HarfBuzz
set(HARFBUZZ_SOURCES ${THIRDPARTY_DIR}/harfbuzz/src/harfbuzz.cc)
if(NOT EXISTS ${THIRDPARTY_DIR}/harfbuzz/src/harfbuzz.cc)
    file(GLOB HARFBUZZ_SOURCES "${THIRDPARTY_DIR}/harfbuzz/src/hb-*.cc")
    list(FILTER HARFBUZZ_SOURCES EXCLUDE REGEX ".*-main.*")
    list(FILTER HARFBUZZ_SOURCES EXCLUDE REGEX ".*-test.*")
endif()

# 11. Нативный сборщик Gumbo-parser
file(GLOB GUMBO_SOURCES "${THIRDPARTY_DIR}/gumbo-parser/src/*.c")

# 12. Нативный сборщик Markdown cmark-gfm
file(GLOB CMARK_SOURCES "${THIRDPARTY_DIR}/cmark-gfm/src/*.c")
list(FILTER CMARK_SOURCES EXCLUDE REGEX ".*main\\.c")
set_source_files_properties(${CMARK_SOURCES} PROPERTIES COMPILE_FLAGS "-include stdbool.h")

# 13. РАСШИРЕННЫЙ СБОР ИСХОДНИКОВ ДВИЖКА ШРИФТОВ FREETYPE (Добавили недостающие файлы ядра)
file(GLOB FREETYPE_SOURCES
    "${THIRDPARTY_DIR}/freetype/src/base/ftbase.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftbbox.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftbitmap.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftgasp.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftglyph.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftinit.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftstroke.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftsynth.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftsystem.c"
    "${THIRDPARTY_DIR}/freetype/src/base/ftdebug.c"   # Добавлен для FT_Trace
    "${THIRDPARTY_DIR}/freetype/src/base/fttype1.c"   # Добавлен для FSType_Flags
    "${THIRDPARTY_DIR}/freetype/src/gzip/ftgzip.c"     # Добавлен для FT_Gzip
    # Рендереры и парсеры форматов контуров букв
    "${THIRDPARTY_DIR}/freetype/src/truetype/truetype.c"
    "${THIRDPARTY_DIR}/freetype/src/cff/cff.c"
    "${THIRDPARTY_DIR}/freetype/src/sfnt/sfnt.c"
    "${THIRDPARTY_DIR}/freetype/src/psnames/psnames.c"
    "${THIRDPARTY_DIR}/freetype/src/psaux/psaux.c"
    "${THIRDPARTY_DIR}/freetype/src/pshinter/pshinter.c"
    "${THIRDPARTY_DIR}/freetype/src/raster/raster.c"
    "${THIRDPARTY_DIR}/freetype/src/smooth/smooth.c"
)

# --- ОБЪЕДИНЕНИЕ И ОЧИСТКА ОТ КОНФЛИКТНЫХ ФАЙЛОВ ---
set(ALL_MUPDF_SOURCES
    ${FITZ_SOURCES}
    ${PDF_SOURCES}
    ${HTML_SOURCES}
    ${XPS_SOURCES}
    ${CBZ_SOURCES}
    ${SVG_SOURCES}
)

list(FILTER ALL_MUPDF_SOURCES EXCLUDE REGEX ".*tool.*")
list(FILTER ALL_MUPDF_SOURCES EXCLUDE REGEX ".*test.*")
list(FILTER ALL_MUPDF_SOURCES EXCLUDE REGEX ".*main.*")

# --- СБОРКА ИТОГОВОЙ ДИНАМИЧЕСКОЙ БИБЛИОТЕКИ ---
add_library(multi_format_converter SHARED
    multi_format_converter.c
    ${ALL_MUPDF_SOURCES}
    ${ZLIB_SOURCES}
    ${BROTLI_SOURCES}
    ${OPENJPEG_SOURCES}
    ${LIBJPEG_SOURCES}
    ${JBIG2_SOURCES}
    ${HARFBUZZ_SOURCES}
    ${GUMBO_SOURCES}
    ${CMARK_SOURCES}
    ${FREETYPE_SOURCES}
)

if(NOT MSVC)
    target_link_libraries(multi_format_converter m log)
endif()