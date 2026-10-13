/// Single date formatter for UI text (retires 6 competing variants:
/// private `_formatDate` copies, inline `d/M/yyyy`, `toString().split`,
/// `substring(0, 10)`, and the pdf-only `intl` usage stays in pdf_service).
///
/// Returns '' for null so subtitles stay clean.
String formatDate(DateTime? date) =>
    date == null ? '' : '${date.day}/${date.month}/${date.year}';
