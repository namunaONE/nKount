// One-shot: print full M3 tonal palettes for brand seeds.
// Run: flutter test tool/tones_test.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

String hex(int argb) {
  String h(int v) => v.toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${h((argb >> 16) & 0xFF)}${h((argb >> 8) & 0xFF)}${h(argb & 0xFF)}';
}

void dump(String name, int seed) {
  final p = TonalPalette.fromHct(Hct.fromInt(seed));
  const tones = [
    0, 5, 10, 15, 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 95, 98, 99, 100
  ];
  debugPrint('== $name seed ${hex(seed)} ==');
  for (final t in tones) {
    debugPrint('tone $t: ${hex(p.get(t))}');
  }
}

void main() {
  test('print brand tonal palettes', () {
    dump('PRIMARY', 0xFF002C6D);
    dump('SECONDARY', 0xFF4FD166);
  });

  test('print fromSeed schemes', () {
    for (final v in DynamicSchemeVariant.values) {
      final s = ColorScheme.fromSeed(
        seedColor: const Color(0xFF002C6D),
        brightness: Brightness.light,
        dynamicSchemeVariant: v,
      );
      String h(Color c) =>
          '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
      debugPrint(
          '== ${v.name} light: P=${h(s.primary)} PC=${h(s.primaryContainer)} S=${h(s.secondary)} SC=${h(s.secondaryContainer)} T=${h(s.tertiary)} TC=${h(s.tertiaryContainer)} ==');
    }
  });
}
