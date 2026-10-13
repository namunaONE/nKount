// Typography scale (ClayTypography) + M3 themes (ClayTheme).
// (Theme lives here — not worth a sixth file for one class.)
part of '../design_system.dart';

/// Typography: Inter (Latin) + Noto Sans Devanagari (fallback).
///
/// M3 type scale — 5 roles × 3 sizes = 15 tokens. Sizes/line-heights/
/// tracking follow https://m3.material.io/styles/typography.
/// Never hard-code `TextStyle(fontSize: …)` in screens; use
/// `Theme.of(context).textTheme.*` or the helpers below.
abstract final class ClayTypography {
  static const String latinFamily = 'Inter';
  static const List<String> fallback = ['Noto Sans Devanagari'];

  static TextStyle _withFallback(TextStyle? s) =>
      (s ?? const TextStyle()).copyWith(fontFamilyFallback: fallback);

  /// Inter-based M3 scale with Devanagari fallback on every style.
  static TextTheme textTheme([TextTheme? base]) {
    final resolved = base ?? ThemeData.light().textTheme;
    final inter = GoogleFonts.interTextTheme(resolved);
    return TextTheme(
      displayLarge: _withFallback(inter.displayLarge
          ?.copyWith(fontSize: 57, height: 64 / 57, letterSpacing: -0.25)),
      displayMedium: _withFallback(inter.displayMedium
          ?.copyWith(fontSize: 45, height: 52 / 45, letterSpacing: 0)),
      displaySmall: _withFallback(inter.displaySmall
          ?.copyWith(fontSize: 36, height: 44 / 36, letterSpacing: 0)),
      headlineLarge: _withFallback(inter.headlineLarge
          ?.copyWith(fontSize: 32, height: 40 / 32, letterSpacing: 0)),
      headlineMedium: _withFallback(inter.headlineMedium
          ?.copyWith(fontSize: 28, height: 36 / 28, letterSpacing: 0)),
      headlineSmall: _withFallback(inter.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          letterSpacing: 0,
          fontWeight: FontWeight.w600)),
      titleLarge: _withFallback(inter.titleLarge?.copyWith(
          fontSize: 22,
          height: 28 / 22,
          letterSpacing: 0,
          fontWeight: FontWeight.w600)),
      titleMedium: _withFallback(inter.titleMedium?.copyWith(
          fontSize: 16,
          height: 24 / 16,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500)),
      titleSmall: _withFallback(inter.titleSmall?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500)),
      bodyLarge: _withFallback(inter.bodyLarge
          ?.copyWith(fontSize: 16, height: 24 / 16, letterSpacing: 0.5)),
      bodyMedium: _withFallback(inter.bodyMedium
          ?.copyWith(fontSize: 14, height: 20 / 14, letterSpacing: 0.25)),
      bodySmall: _withFallback(inter.bodySmall
          ?.copyWith(fontSize: 12, height: 16 / 12, letterSpacing: 0.4)),
      labelLarge: _withFallback(inter.labelLarge?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500)),
      labelMedium: _withFallback(inter.labelMedium?.copyWith(
          fontSize: 12,
          height: 16 / 12,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500)),
      labelSmall: _withFallback(inter.labelSmall?.copyWith(
          fontSize: 11,
          height: 16 / 11,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500)),
    );
  }

  /// Tabular figures for currency / KPI values (keeps digits aligned).
  static TextStyle tabular(TextStyle? s) => (s ?? const TextStyle()).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

/// App themes: M3 fidelity scheme from the navy seed (keeps brand
/// identity — tonalSpot would wash it to steel blue), with the secondary
/// roles pinned to the green tonal palette. All roles meet M3 contrast.
abstract final class ClayTheme {
  static const Color seedPrimary = Color(0xFF002C6D);

  static ColorScheme _scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: seedPrimary,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    if (brightness == Brightness.light) {
      return base.copyWith(
        secondary: const Color(0xFF006E27),
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFF7CFD8C),
        onSecondaryContainer: const Color(0xFF002107),
      );
    }
    return base.copyWith(
      secondary: const Color(0xFF5EE072),
      onSecondary: const Color(0xFF003910),
      secondaryContainer: const Color(0xFF00531B),
      onSecondaryContainer: const Color(0xFF7CFD8C),
    );
  }

  static TextTheme _text(TextTheme base) => ClayTypography.textTheme(base);

  static ThemeData get lightTheme {
    final scheme = _scheme(Brightness.light);
    final text = _text(ThemeData.light(useMaterial3: true).textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF1F2F6),
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: text.titleLarge,
      ),
      iconTheme: const IconThemeData(size: ClayIconSize.md),
      cardTheme: const CardThemeData(
        elevation: ClayElevation.level2,
        shadowColor: Colors.black12,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          iconSize: WidgetStatePropertyAll(ClayIconSize.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
        border: const OutlineInputBorder(borderRadius: ClayRadius.medium),
        enabledBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: text.bodySmall,
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: scheme.secondary,
        labelStyle: text.labelLarge!,
        brightness: Brightness.light,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.large),
      ),
      dividerTheme: DividerThemeData(
          color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle:
            text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      ),
    );
  }

  static ThemeData get darkTheme {
    final scheme = _scheme(Brightness.dark);
    final text = _text(ThemeData.dark(useMaterial3: true).textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: text.titleLarge,
      ),
      iconTheme: const IconThemeData(size: ClayIconSize.md),
      cardTheme: const CardThemeData(
        elevation: ClayElevation.level2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          iconSize: WidgetStatePropertyAll(ClayIconSize.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
        border: const OutlineInputBorder(borderRadius: ClayRadius.medium),
        enabledBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: text.bodySmall,
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: scheme.secondary,
        labelStyle: text.labelLarge!,
        brightness: Brightness.dark,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.large),
      ),
      dividerTheme: DividerThemeData(
          color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle:
            text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
