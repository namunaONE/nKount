/// Non-web fallback: backup files are a web-only feature for now.
Future<void> downloadJsonFile(String filename, String content) async {
  throw UnsupportedError(
      'File backup is only supported on web (asked for $filename).');
}

/// Always null off-web so callers show the "not supported" message.
Future<String?> pickJsonFile() async => null;
