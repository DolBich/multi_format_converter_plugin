#include <mupdf/fitz.h>
#include <stdio.h>

#if defined(_WIN32)
#define FFI_EXPORT __declspec(dllexport)
#else
#define FFI_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

FFI_EXPORT int convert_to_pdf(const char *source_path, const char *target_pdf_path) {
    fz_context *ctx = NULL;
    fz_document *doc = NULL;
    fz_document_writer *writer = NULL;

    // Инициализируем базовый контекст управления ресурсами MuPDF
    ctx = fz_new_context(NULL, NULL, FZ_STORE_DEFAULT);
    if (!ctx) return 1;

    fz_try(ctx) {
        // Регистрируем встроенные модули чтения (PDF, HTML, DOCX, EPUB, XPS, CBZ, SVG)
        fz_register_document_handlers(ctx);

        // Инициализируем внутренние шрифты MuPDF
        fz_install_load_system_font_funcs(ctx, NULL, NULL, NULL);

        // Открываем исходный документ (формат определится автоматически)
        doc = fz_open_document(ctx, source_path);

        // Создаем писатель в PDF-файл с дефолтными параметрами
        writer = fz_new_document_writer(ctx, target_pdf_path, "pdf", NULL);

        // Цикл постраничного рендеринга данных в PDF-поток
        int page_count = fz_count_pages(ctx, doc);
        for (int i = 0; i < page_count; i++) {
            fz_page *page = fz_load_page(ctx, doc, i);

            // Вычисляем оригинальные физические границы текущей страницы документа
            fz_rect mediabox = fz_bound_page(ctx, page);

            // Открываем страницу в писателе документов, получая устройство рендеринга
            fz_device *dev = fz_begin_page(ctx, writer, mediabox);

            // Направляем графический поток и разметку страницы в устройство-писатель
            fz_run_page(ctx, page, dev, fz_identity, NULL);

            // Фиксируем запись страницы в версии 1.28.2 (всего 2 аргумента)
            fz_end_page(ctx, writer);

            fz_drop_page(ctx, page);
        }

        // Закрываем писатель и сохраняем сгенерированный PDF на диск
        fz_close_document_writer(ctx, writer);
    }
    fz_catch(ctx) {
        if (writer) fz_drop_document_writer(ctx, writer);
        if (doc) fz_drop_document(ctx, doc);
        fz_drop_context(ctx);
        return 2; // Ошибка обработки документа
    }

    // Успешный финал: освобождаем всю выделенную оперативную память
    fz_drop_document_writer(ctx, writer);
    fz_drop_document(ctx, doc);
    fz_drop_context(ctx);
    return 0; // Успех!
}