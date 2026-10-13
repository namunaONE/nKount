// One-shot logo rasterizer (NOT part of CI): renders the nKount brand mark
// to PNGs using the host's Arial fonts. Run with:
//   flutter test tool/render_logo_test.dart
// Output: assets/images/logo-512.png, logo-192.png (+ maskable variants).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFonts() async {
  final loader = FontLoader('BrandSans');
  for (final path in [
    r'C:\Windows\Fonts\arialbd.ttf',
    r'C:\Windows\Fonts\arial.ttf',
  ]) {
    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Missing host font: $path');
    }
    loader.addFont(Future.value(ByteData.view(file.readAsBytesSync().buffer)));
  }
  await loader.load();
}

ui.Paragraph _text(
  String value,
  double size, {
  bool bold = true,
  Color color = const Color(0xFFFDFBF8),
  double letterSpacing = 0,
}) {
  final builder = ui.ParagraphBuilder(
    ui.ParagraphStyle(textAlign: TextAlign.center),
  )
    ..pushStyle(
      ui.TextStyle(
        fontFamily: 'BrandSans',
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
        letterSpacing: letterSpacing,
      ),
    )
    ..addText(value);
  final paragraph = builder.build();
  paragraph.layout(const ui.ParagraphConstraints(width: 512));
  return paragraph;
}

Future<void> _render(String outPath, int size, {bool maskable = false}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  // Background: full-bleed gradient (maskable) or rounded badge.
  final bgRect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
  final gradient = ui.Gradient.linear(
    Offset.zero,
    Offset(size.toDouble(), size.toDouble()),
    const [Color(0xFF002C6D), Color(0xFF0A3D85)],
  );
  final bgPaint = Paint()..shader = gradient;
  if (maskable) {
    canvas.drawRect(bgRect, bgPaint);
  } else {
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(bgRect, Radius.circular(size * 0.22)),
      bgPaint,
    );
  }

  // Content scale for maskable safe zone (~72%).
  canvas.save();
  if (maskable) {
    final s = size * 0.72;
    canvas.translate((size - s) / 2, (size - s) / 2);
    canvas.scale(s / 512);
  } else {
    canvas.scale(size / 512);
  }

  final mono = _text('nK', 185);
  canvas.drawParagraph(mono, const Offset(0, 40));

  final linePaint = Paint()
    ..color = const Color(0xFF4FD166)
    ..strokeWidth = 20
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(const Offset(110, 285), const Offset(402, 285), linePaint);
  canvas.drawLine(const Offset(110, 329), const Offset(402, 329), linePaint);

  final word = _text('nKount', 56, letterSpacing: 2);
  canvas.drawParagraph(word, const Offset(0, 366));

  final tag =
      _text('by namunaONE', 30, bold: false, color: const Color(0xFF7CFD8C));
  canvas.drawParagraph(tag, const Offset(0, 434));
  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  await File(outPath).writeAsBytes(bytes!.buffer.asUint8List());
}

void main() {
  test('render logo PNGs', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
    await _render('assets/images/logo-512.png', 512);
    await _render('assets/images/logo-192.png', 192);
    await _render('assets/images/logo-maskable-512.png', 512, maskable: true);
    await _render('assets/images/logo-maskable-192.png', 192, maskable: true);
  });
}
