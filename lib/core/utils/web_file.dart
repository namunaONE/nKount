/// JSON backup file download/upload with a VM-safe stub fallback.
///
/// Import this file (never the implementations directly). On web the real
/// implementations load; everywhere else (tests, desktop) the stub throws
/// [UnsupportedError] / returns null so callers can show honest messages.
library;

/// Web file download/upload with a VM-safe stub fallback.
export 'web_file_stub.dart' if (dart.library.js_interop) 'web_file_web.dart';
