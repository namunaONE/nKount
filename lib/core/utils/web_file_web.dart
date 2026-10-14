import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Downloads [content] as [filename] via an object URL + anchor click.
Future<void> downloadJsonFile(String filename, String content) async {
  final blob = web.Blob(
    [content.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  try {
    final anchor = web.HTMLAnchorElement();
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
  } finally {
    web.URL.revokeObjectURL(url);
  }
}

/// Opens a JSON file picker. Completes with the file text, or null when
/// the user cancels (detected via window refocus) or reading fails.
Future<String?> pickJsonFile() {
  final completer = Completer<String?>();
  var done = false;
  void finish(String? value) {
    if (!done) {
      done = true;
      completer.complete(value);
    }
  }

  final input = web.HTMLInputElement();
  input.type = 'file';
  input.accept = 'application/json,.json';
  input.addEventListener(
    'change',
    ((web.Event _) {
      final files = input.files;
      if (files == null || files.length == 0) {
        finish(null);
        return;
      }
      final file = files.item(0);
      if (file == null) {
        finish(null);
        return;
      }
      final reader = web.FileReader();
      reader.addEventListener(
        'load',
        ((web.Event _) {
          final result = reader.result;
          finish(result.isA<JSString>() ? (result as JSString).toDart : null);
        }).toJS,
      );
      reader.addEventListener(
        'error',
        ((web.Event _) => finish(null)).toJS,
      );
      reader.readAsText(file);
    }).toJS,
  );
  // Cancellation fires no change event; refocus means the dialog closed.
  web.window.addEventListener(
    'focus',
    ((web.Event _) {
      Future.delayed(const Duration(milliseconds: 300), () => finish(null));
    }).toJS,
  );
  input.click();
  return completer.future;
}
