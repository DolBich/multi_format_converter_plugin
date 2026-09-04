cmake_minimum_required(VERSION 3.22)
project(multi_format_converter LANGUAGES C CXX)

set(MUPDF_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mupdf)
set(MUPDF_SRC_DIR ${MUPDF_DIR}/source)
set(MUPDF_INCLUDE_DIR ${MUPDF_DIR}/include)
set(MUPDF_GENERATED_DIR ${MUPDF_DIR}/generated)
set(THIRDPARTY_DIR ${MUPDF_DIR}/thirdparty)

# Features requested by the plugin.
set(MUPDF_DEFINITIONS
    FZ_ENABLE_PDF=1
    FZ_ENABLE_XPS=1
    FZ_ENABLE_CBZ=1
    FZ_ENABLE_SVG=1
    FZ_ENABLE_HTML=1
    FZ_ENABLE_HTML_ENGINE=1
    FZ_ENABLE_EPUB=1
    FZ_ENABLE_MOBI=1
    FZ_ENABLE_FB2=1
    FZ_ENABLE_TXT=1
    FZ_ENABLE_MD=1
    FZ_ENABLE_JS=0
    FZ_ENABLE_OFFICE=0
    FZ_ENABLE_DOCX_OUTPUT=0
    FZ_ENABLE_ICC=0
    FZ_ENABLE_BARCODE=0
    FZ_ENABLE_BROTLI=1
    SHARE_ZLIB=0
)

# FreeType: exact list from MuPDF 1.28.3 Makelists
set(FREETYPE_SRC
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftbase.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftbbox.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftbitmap.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftdebug.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftfstype.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftgasp.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftglyph.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftinit.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftstroke.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftsynth.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/ftsystem.c
    ${MUPDF_DIR}/thirdparty/freetype/src/base/fttype1.c
    ${MUPDF_DIR}/thirdparty/freetype/src/cff/cff.c
    ${MUPDF_DIR}/thirdparty/freetype/src/cid/type1cid.c
    ${MUPDF_DIR}/thirdparty/freetype/src/psaux/psaux.c
    ${MUPDF_DIR}/thirdparty/freetype/src/pshinter/pshinter.c
    ${MUPDF_DIR}/thirdparty/freetype/src/psnames/psnames.c
    ${MUPDF_DIR}/thirdparty/freetype/src/raster/raster.c
    ${MUPDF_DIR}/thirdparty/freetype/src/sfnt/sfnt.c
    ${MUPDF_DIR}/thirdparty/freetype/src/smooth/smooth.c
    ${MUPDF_DIR}/thirdparty/freetype/src/truetype/truetype.c
    ${MUPDF_DIR}/thirdparty/freetype/src/type1/type1.c
)

# Gumbo: exact list from MuPDF 1.28.3 Makelists
set(GUMBO_SRC
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/attribute.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/char_ref.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/error.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/parser.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/string_buffer.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/string_piece.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/tag.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/tokenizer.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/utf8.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/util.c
    ${MUPDF_DIR}/thirdparty/gumbo-parser/src/vector.c
)

# HarfBuzz: exact list from MuPDF 1.28.3 Makelists
set(HARFBUZZ_SRC
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/graph/gsubgpos-context.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-aat-layout.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-aat-map.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-blob.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-buffer.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-buffer-verify.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-buffer-serialize.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-common.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-draw.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-face.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-face-builder.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-fallback-shape.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-font.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ft.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-map.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-number.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-cff1-table.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-cff2-table.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-color.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-face.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-font.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-layout.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-map.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-math.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-meta.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-metrics.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-name.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shape.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shape-fallback.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shape-normalize.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-arabic.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-default.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-hangul.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-hebrew.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-indic.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-indic-table.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-khmer.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-myanmar.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-syllabic.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-thai.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-use.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-shaper-vowel-constraints.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-tag.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ot-var.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-outline.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-paint.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-paint-bounded.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-paint-extents.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-set.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-shape.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-shape-plan.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-shaper.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-static.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-cff1.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-cff2.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-cff-common.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-input.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-instancer-iup.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-instancer-solver.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-plan.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-plan-layout.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-plan-var.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-table-cff.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-table-color.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-table-layout.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-table-other.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-subset-table-var.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-ucd.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/hb-unicode.cc
    ${MUPDF_DIR}/thirdparty/harfbuzz/src/OT/Var/VARC/VARC.cc
)

# JPEG XR: exact list from MuPDF 1.28.3 Makelists
set(JPEGXR_SRC
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/algo.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/api.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/cr_parse.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/flags.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/init.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/io.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/jpegxr_pixelformat.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/r_parse.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/r_strip.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/r_tile_frequency.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/r_tile_spatial.c
    ${MUPDF_DIR}/thirdparty/jpegxr/Software/x_strip.c
)

# libjpeg: exact list from MuPDF 1.28.3 Makelists
set(LIBJPEG_SRC
    ${MUPDF_DIR}/thirdparty/libjpeg/jaricom.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcapimin.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcapistd.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcarith.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jccoefct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jccolor.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcdctmgr.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jchuff.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcinit.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcmainct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcmarker.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcmaster.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcomapi.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcparam.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcprepct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jcsample.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdapimin.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdapistd.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdarith.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdatadst.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdatasrc.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdcoefct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdcolor.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jddctmgr.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdhuff.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdinput.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdmainct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdmarker.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdmaster.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdmerge.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdpostct.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdsample.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jdtrans.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jerror.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jfdctflt.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jfdctfst.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jfdctint.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jidctflt.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jidctfst.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jidctint.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jmemmgr.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jquant1.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jquant2.c
    ${MUPDF_DIR}/thirdparty/libjpeg/jutils.c
)

# zlib: exact list from MuPDF 1.28.3 Makelists
set(ZLIB_SRC
    ${MUPDF_DIR}/thirdparty/zlib/adler32.c
    ${MUPDF_DIR}/thirdparty/zlib/compress.c
    ${MUPDF_DIR}/thirdparty/zlib/crc32.c
    ${MUPDF_DIR}/thirdparty/zlib/deflate.c
    ${MUPDF_DIR}/thirdparty/zlib/inffast.c
    ${MUPDF_DIR}/thirdparty/zlib/inflate.c
    ${MUPDF_DIR}/thirdparty/zlib/inftrees.c
    ${MUPDF_DIR}/thirdparty/zlib/trees.c
    ${MUPDF_DIR}/thirdparty/zlib/uncompr.c
    ${MUPDF_DIR}/thirdparty/zlib/zutil.c
)

# JBIG2: exact list from MuPDF 1.28.3 Makelists
set(JBIG2DEC_SRC
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_arith.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_arith_iaid.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_arith_int.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_generic.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_halftone.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_huffman.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_hufftab.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_image.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_mmr.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_page.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_refinement.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_segment.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_symbol_dict.c
    ${MUPDF_DIR}/thirdparty/jbig2dec/jbig2_text.c
)

# OpenJPEG: exact list from MuPDF 1.28.3 Makelists
set(OPENJPEG_SRC
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/bio.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/cio.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/dwt.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/event.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/function_list.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/ht_dec.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/image.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/invert.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/j2k.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/jp2.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/mct.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/mqc.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/openjpeg.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/pi.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/sparse_array.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/t1.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/t2.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/tcd.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/tgt.c
    ${MUPDF_DIR}/thirdparty/openjpeg/src/lib/openjp2/thread.c
)

# Brotli: exact list from MuPDF 1.28.3 Makelists
set(BROTLI_SRC
    ${MUPDF_DIR}/thirdparty/brotli/c/common/constants.c
    ${MUPDF_DIR}/thirdparty/brotli/c/common/context.c
    ${MUPDF_DIR}/thirdparty/brotli/c/common/dictionary.c
    ${MUPDF_DIR}/thirdparty/brotli/c/common/platform.c
    ${MUPDF_DIR}/thirdparty/brotli/c/common/shared_dictionary.c
    ${MUPDF_DIR}/thirdparty/brotli/c/common/transform.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/bit_reader.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/decode.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/huffman.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/prefix.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/state.c
    ${MUPDF_DIR}/thirdparty/brotli/c/dec/static_init.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/backward_references.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/backward_references_hq.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/bit_cost.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/block_splitter.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/brotli_bit_stream.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/cluster.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/command.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/compound_dictionary.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/compress_fragment.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/compress_fragment_two_pass.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/dictionary_hash.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/encode.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/encoder_dict.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/entropy_encode.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/fast_log.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/histogram.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/literal_cost.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/memory.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/metablock.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/static_dict.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/static_dict_lut.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/static_init.c
    ${MUPDF_DIR}/thirdparty/brotli/c/enc/utf8_util.c
)

# cmark-gfm: exact list from MuPDF 1.28.3 Makelists
set(CMARKGFM_SRC
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/arena.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/blocks.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/buffer.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/cmark.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/cmark_ctype.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/footnotes.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/houdini_href_e.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/houdini_html_e.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/houdini_html_u.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/html.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/inlines.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/iterator.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/linked_list.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/map.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/node.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/plugin.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/references.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/registry.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/scanners.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/syntax_extension.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/src/utf8.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/autolink.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/core-extensions.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/ext_scanners.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/strikethrough.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/table.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/tagfilter.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/tasklist.c
    ${MUPDF_DIR}/thirdparty/cmark-gfm/extensions/autoheaderid.c
)

# MuPDF core source directories copied from platform/java/Android.mk
file(GLOB MUPDF_CORE_C CONFIGURE_DEPENDS
    "${MUPDF_SRC_DIR}/fitz/*.c"
    "${MUPDF_SRC_DIR}/pdf/*.c"
    "${MUPDF_SRC_DIR}/xps/*.c"
    "${MUPDF_SRC_DIR}/svg/*.c"
    "${MUPDF_SRC_DIR}/cbz/*.c"
    "${MUPDF_SRC_DIR}/html/*.c"
    "${MUPDF_SRC_DIR}/reflow/*.c"
    "${MUPDF_SRC_DIR}/helpers/pkcs7/*.c"
)
file(GLOB MUPDF_CORE_CPP CONFIGURE_DEPENDS "${MUPDF_SRC_DIR}/fitz/*.cpp")
file(GLOB MUPDF_GENERATED_URW CONFIGURE_DEPENDS "${MUPDF_GENERATED_DIR}/resources/fonts/urw/*.c")
file(GLOB MUPDF_GENERATED_HYPHEN CONFIGURE_DEPENDS "${MUPDF_GENERATED_DIR}/resources/hyphen/*.c")

# MuPDF 1.28.3 ships the Noto/Source Han/Charis font binaries in the
# source archive but this checkout does not contain their generated .c
# wrappers. Generate them exactly as Makefile does when objcopy is not used.
file(GLOB MUPDF_FONT_NOTO CONFIGURE_DEPENDS
    "${MUPDF_DIR}/resources/fonts/noto/*.otf"
    "${MUPDF_DIR}/resources/fonts/noto/*.ttf"
)
file(GLOB MUPDF_FONT_SIL CONFIGURE_DEPENDS
    "${MUPDF_DIR}/resources/fonts/sil/*.cff"
)
file(GLOB MUPDF_FONT_HAN CONFIGURE_DEPENDS
    "${MUPDF_DIR}/resources/fonts/han/*.ttc"
)

set(MUPDF_GENERATED_EXTRA_FONTS)
foreach(_font IN LISTS MUPDF_FONT_NOTO MUPDF_FONT_SIL MUPDF_FONT_HAN)
    get_filename_component(_font_name "${_font}" NAME)
    string(REGEX REPLACE "[-.]" "_" _font_symbol "${_font_name}")
    set(_font_out "${CMAKE_CURRENT_BINARY_DIR}/generated_fonts/${_font_name}.c")
    add_custom_command(
        OUTPUT "${_font_out}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/generated_fonts"
        COMMAND bash -c "bash \"${MUPDF_DIR}/scripts/hexdump.sh\" \"${_font}\" > \"${_font_out}\""
        DEPENDS "${_font}" "${MUPDF_DIR}/scripts/hexdump.sh"
        VERBATIM
    )
    list(APPEND MUPDF_GENERATED_EXTRA_FONTS "${_font_out}")
endforeach()

add_custom_target(mupdf_generated_fonts DEPENDS ${MUPDF_GENERATED_EXTRA_FONTS})

set(MUPDF_CORE_SOURCES
    ${MUPDF_CORE_C}
    ${MUPDF_CORE_CPP}
    ${MUPDF_GENERATED_URW}
    ${MUPDF_GENERATED_HYPHEN}
    ${MUPDF_GENERATED_EXTRA_FONTS}
)

# FreeType
add_library(mupdf_freetype STATIC ${FREETYPE_SRC})
target_include_directories(mupdf_freetype PRIVATE ${THIRDPARTY_DIR}/freetype/include ${MUPDF_DIR}/scripts/freetype)
target_compile_definitions(mupdf_freetype PRIVATE FT2_BUILD_LIBRARY FT_CONFIG_MODULES_H="slimftmodules.h" FT_CONFIG_OPTIONS_H="slimftoptions.h")

# Gumbo
add_library(mupdf_gumbo STATIC ${GUMBO_SRC})
target_include_directories(mupdf_gumbo PRIVATE ${THIRDPARTY_DIR}/gumbo-parser/src)
target_compile_options(mupdf_gumbo PRIVATE -std=c99)

# JBIG2
add_library(mupdf_jbig2dec STATIC ${JBIG2DEC_SRC})
target_include_directories(mupdf_jbig2dec PRIVATE ${THIRDPARTY_DIR}/jbig2dec ${MUPDF_INCLUDE_DIR})
target_compile_definitions(mupdf_jbig2dec PRIVATE HAVE_STDINT_H JBIG_EXTERNAL_MEMENTO_H="mupdf/memento.h")
target_compile_options(mupdf_jbig2dec PRIVATE -Wno-shadow)

# libjpeg
add_library(mupdf_libjpeg STATIC ${LIBJPEG_SRC})
target_include_directories(mupdf_libjpeg PRIVATE ${THIRDPARTY_DIR}/libjpeg ${MUPDF_DIR}/scripts/libjpeg)

# zlib
add_library(mupdf_zlib STATIC ${ZLIB_SRC})
target_include_directories(mupdf_zlib PRIVATE ${THIRDPARTY_DIR}/zlib)
target_compile_definitions(mupdf_zlib PRIVATE HAVE_UNISTD_H HAVE_STDARG_H)

# OpenJPEG
add_library(mupdf_openjpeg STATIC ${OPENJPEG_SRC})
target_include_directories(mupdf_openjpeg PRIVATE ${THIRDPARTY_DIR}/openjpeg/src/lib/openjp2)
target_compile_definitions(mupdf_openjpeg PRIVATE OPJ_STATIC OPJ_HAVE_INTTYPES_H OPJ_HAVE_STDINT_H MUTEX_pthread=0)

# Brotli
add_library(mupdf_brotli STATIC ${BROTLI_SRC})
target_include_directories(mupdf_brotli PRIVATE ${THIRDPARTY_DIR}/brotli/c/include)

# cmark-gfm
set(CMARK_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/cmark-gfm)
file(MAKE_DIRECTORY "${CMARK_BUILD_DIR}/src")

# cmark-gfm upstream CMake runs CHECK_INCLUDE_FILE(stdbool.h).
# Android NDK always provides it, so reproduce the resulting define directly.
set(HAVE_STDBOOL_H 1)
set(HAVE___BUILTIN_EXPECT 1)
set(HAVE___ATTRIBUTE__ 1)

configure_file(
    "${THIRDPARTY_DIR}/cmark-gfm/src/config.h.in"
    "${CMARK_BUILD_DIR}/src/config.h"
)

add_library(mupdf_cmarkgfm STATIC ${CMARKGFM_SRC})
target_include_directories(mupdf_cmarkgfm PRIVATE
    ${CMARK_BUILD_DIR}/src
    ${THIRDPARTY_DIR}/cmark-gfm/src
    ${MUPDF_DIR}/scripts/cmark-gfm
    ${THIRDPARTY_DIR}/cmark-gfm/extensions
)
target_compile_definitions(mupdf_cmarkgfm PRIVATE CMARK_GFM_STATIC_DEFINE)
# MuPDF vendor snapshot carries a minimal src/config.h which defines HAVE_STDBOOL_H
# but does not itself include stdbool.h. The upstream cmark CMake-generated config does.
target_compile_options(mupdf_cmarkgfm PRIVATE -include stdbool.h)

# HarfBuzz
add_library(mupdf_harfbuzz STATIC ${HARFBUZZ_SRC})
target_include_directories(mupdf_harfbuzz PRIVATE ${THIRDPARTY_DIR}/harfbuzz/src ${MUPDF_INCLUDE_DIR} ${THIRDPARTY_DIR}/freetype/include ${MUPDF_DIR}/scripts/freetype)
target_compile_definitions(mupdf_harfbuzz PRIVATE HAVE_FALLBACK=1 HAVE_FREETYPE HAVE_OT HAVE_ROUND HAVE_UCDN HB_NO_MT HB_NO_PRAGMA_GCC_DIAGNOSTIC hb_malloc_impl=fz_hb_malloc hb_calloc_impl=fz_hb_calloc hb_free_impl=fz_hb_free hb_realloc_impl=fz_hb_realloc)
target_compile_options(mupdf_harfbuzz PRIVATE -w -fno-exceptions -fno-rtti -fno-threadsafe-statics -fvisibility-inlines-hidden -std=gnu++11)

# JPEG XR
set(MUPDF_HAVE_JPEGXR TRUE)
foreach(_jxr IN LISTS JPEGXR_SRC)
    if(NOT EXISTS "${_jxr}")
        set(MUPDF_HAVE_JPEGXR FALSE)
    endif()
endforeach()

if(MUPDF_HAVE_JPEGXR)
    add_library(mupdf_jpegxr STATIC ${JPEGXR_SRC})
    target_include_directories(mupdf_jpegxr PRIVATE ${THIRDPARTY_DIR}/jpegxr ${THIRDPARTY_DIR}/jpegxr/Software)
    target_compile_definitions(mupdf_jpegxr PRIVATE HAVE_JPEGXR)
    target_compile_options(mupdf_jpegxr PRIVATE -Wno-tautological-compare)
else()
    message(STATUS "MuPDF JPEG XR sources are not present; XPS JPEG XR support disabled")
endif()

# Core
foreach(_mupdf_static_target IN ITEMS mupdf_freetype mupdf_gumbo mupdf_jbig2dec mupdf_libjpeg mupdf_zlib mupdf_openjpeg mupdf_brotli mupdf_cmarkgfm mupdf_harfbuzz)
    set_target_properties(${_mupdf_static_target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
endforeach()

add_library(mupdf_core STATIC ${MUPDF_CORE_SOURCES})
set_target_properties(mupdf_core PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_include_directories(mupdf_core PRIVATE
    ${MUPDF_INCLUDE_DIR}
    ${MUPDF_SRC_DIR}
    ${MUPDF_GENERATED_DIR}
    ${THIRDPARTY_DIR}/freetype/include
    ${MUPDF_DIR}/scripts/freetype
    ${THIRDPARTY_DIR}/gumbo-parser/src
    ${THIRDPARTY_DIR}/harfbuzz/src
    ${THIRDPARTY_DIR}/jbig2dec
    ${THIRDPARTY_DIR}/libjpeg
    ${MUPDF_DIR}/scripts/libjpeg
    ${THIRDPARTY_DIR}/zlib
    ${THIRDPARTY_DIR}/openjpeg/src/lib/openjp2
    ${THIRDPARTY_DIR}/brotli/c/include
    ${THIRDPARTY_DIR}/cmark-gfm/src
    ${THIRDPARTY_DIR}/cmark-gfm/extensions
    ${MUPDF_DIR}/scripts/cmark-gfm
    ${THIRDPARTY_DIR}/jpegxr
    ${THIRDPARTY_DIR}/jpegxr/Software
)
target_compile_definitions(mupdf_core PRIVATE ${MUPDF_DEFINITIONS} _FILE_OFFSET_BITS=32 AA_BITS=8 CMARK_GFM_STATIC_DEFINE OPJ_STATIC OPJ_HAVE_INTTYPES_H OPJ_HAVE_STDINT_H)
add_dependencies(mupdf_core mupdf_generated_fonts)
target_compile_options(mupdf_core PRIVATE -ffunction-sections -fdata-sections)

# Flutter/native wrapper
add_library(multi_format_converter SHARED ${CMAKE_CURRENT_SOURCE_DIR}/multi_format_converter.c)
target_include_directories(multi_format_converter PRIVATE ${MUPDF_INCLUDE_DIR})
target_compile_definitions(multi_format_converter PRIVATE HAVE_ANDROID)
set_target_properties(multi_format_converter PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(multi_format_converter PRIVATE mupdf_core mupdf_harfbuzz mupdf_freetype mupdf_gumbo mupdf_jbig2dec mupdf_libjpeg mupdf_zlib mupdf_openjpeg mupdf_brotli mupdf_cmarkgfm m log)
target_link_options(multi_format_converter PRIVATE -Wl,--gc-sections)



