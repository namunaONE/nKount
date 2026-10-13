import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/utils/money.dart';
import 'package:nkount/features/gallery/presentation/gallery_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// P5 design-system audits: type scale, WCAG contrast, touch targets,
/// card tokens, money formatting, and large-text scaling.
///
/// Deterministic (no goldens here): font fetching is disabled so tests
/// don't hit the network.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('type scale (M3 spec)', () {
    test('ClayTypography sizes match m3.material.io/styles/typography', () {
      final scale = ClayTypography.textTheme(ThemeData.light().textTheme);
      const expected = {
        'displayLarge': 57.0,
        'displayMedium': 45.0,
        'displaySmall': 36.0,
        'headlineLarge': 32.0,
        'headlineMedium': 28.0,
        'headlineSmall': 24.0,
        'titleLarge': 22.0,
        'titleMedium': 16.0,
        'titleSmall': 14.0,
        'bodyLarge': 16.0,
        'bodyMedium': 14.0,
        'bodySmall': 12.0,
        'labelLarge': 14.0,
        'labelMedium': 12.0,
        'labelSmall': 11.0,
      };
      final actual = {
        'displayLarge': scale.displayLarge?.fontSize,
        'displayMedium': scale.displayMedium?.fontSize,
        'displaySmall': scale.displaySmall?.fontSize,
        'headlineLarge': scale.headlineLarge?.fontSize,
        'headlineMedium': scale.headlineMedium?.fontSize,
        'headlineSmall': scale.headlineSmall?.fontSize,
        'titleLarge': scale.titleLarge?.fontSize,
        'titleMedium': scale.titleMedium?.fontSize,
        'titleSmall': scale.titleSmall?.fontSize,
        'bodyLarge': scale.bodyLarge?.fontSize,
        'bodyMedium': scale.bodyMedium?.fontSize,
        'bodySmall': scale.bodySmall?.fontSize,
        'labelLarge': scale.labelLarge?.fontSize,
        'labelMedium': scale.labelMedium?.fontSize,
        'labelSmall': scale.labelSmall?.fontSize,
      };
      expect(actual, expected);
    });

    test('every role carries the Devanagari fallback', () {
      final scale = ClayTypography.textTheme(ThemeData.light().textTheme);
      for (final style in [
        scale.displayLarge,
        scale.displayMedium,
        scale.displaySmall,
        scale.headlineLarge,
        scale.headlineMedium,
        scale.headlineSmall,
        scale.titleLarge,
        scale.titleMedium,
        scale.titleSmall,
        scale.bodyLarge,
        scale.bodyMedium,
        scale.bodySmall,
        scale.labelLarge,
        scale.labelMedium,
        scale.labelSmall,
      ]) {
        expect(
          style?.fontFamilyFallback,
          contains('Noto Sans Devanagari'),
        );
      }
    });

    test('tabular() enables tabular figures for currency', () {
      final style = ClayTypography.tabular(
        const TextStyle(fontSize: 14),
      );
      expect(
        style.fontFeatures?.map((f) => f.feature),
        contains('tnum'),
      );
    });
  });

  group('contrast (WCAG 2.1)', () {
    // Relative luminance per WCAG 2.1 (sRGB, gamma 2.4).
    double luminance(Color c) {
      double linear(int v) {
        final s = v / 255.0;
        if (s <= 0.03928) return s / 12.92;
        return math.pow((s + 0.055) / 1.055, 2.4).toDouble();
      }

      return 0.2126 * linear(c.red) +
          0.7152 * linear(c.green) +
          0.0722 * linear(c.blue);
    }

    double ratio(Color fg, Color bg) {
      final l1 = luminance(fg);
      final l2 = luminance(bg);
      final lighter = l1 > l2 ? l1 : l2;
      final darker = l1 > l2 ? l2 : l1;
      return (lighter + 0.05) / (darker + 0.05);
    }

    test('scheme text pairs meet AA (4.5:1) in both modes', () {
      for (final scheme in [
        ClayTheme.lightTheme.colorScheme,
        ClayTheme.darkTheme.colorScheme,
      ]) {
        expect(
          ratio(scheme.onPrimaryContainer, scheme.primaryContainer),
          greaterThanOrEqualTo(4.5),
          reason: 'primary container pair',
        );
        expect(
          ratio(scheme.onSecondaryContainer, scheme.secondaryContainer),
          greaterThanOrEqualTo(4.5),
          reason: 'secondary container pair',
        );
        expect(
          ratio(scheme.onSurface, scheme.surface),
          greaterThanOrEqualTo(4.5),
          reason: 'surface pair',
        );
        expect(
          ratio(scheme.onSurfaceVariant, scheme.surface),
          greaterThanOrEqualTo(3.0),
          reason: 'surface-variant pair (secondary text, ≥3.0)',
        );
      }
    });

    test('semantic accents read on light surfaces (≥3.0, text ≥4.5)', () {
      const bg = Colors.white;
      for (final color in [
        ClayColors.success,
        ClayColors.warning,
        ClayColors.error,
        ClayColors.info,
      ]) {
        expect(ratio(color, bg), greaterThanOrEqualTo(3.0));
      }
      // Success/error double as body-text colors (balances, totals).
      expect(ratio(ClayColors.success, bg), greaterThanOrEqualTo(4.5));
      expect(ratio(ClayColors.error, bg), greaterThanOrEqualTo(4.5));
    });
  });

  group('touch targets + tokens', () {
    testWidgets('ClayIconButton is at least 48x48', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: const Scaffold(
            body: ClayIconButton(icon: ClayIcons.search),
          ),
        ),
      );
      final size = tester.getSize(find.byType(ClayIconButton));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });

    testWidgets('ClayButton meets 48dp height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Scaffold(
            body: ClayButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(ElevatedButton));
      expect(size.height, greaterThanOrEqualTo(48));
    });

    test('spacing follows the 4pt grid', () {
      for (final v in [
        ClaySpacing.xs,
        ClaySpacing.sm,
        ClaySpacing.md,
        ClaySpacing.lg,
        ClaySpacing.xl,
        ClaySpacing.xxl,
      ]) {
        expect(v % 4, 0);
      }
    });

    test('card sizes map to distinct radii', () {
      expect(
        ClayRadius.forSize(ClayCardSize.compact),
        ClayRadius.smallPlus,
      );
      expect(ClayRadius.forSize(ClayCardSize.medium), ClayRadius.medium);
      expect(ClayRadius.forSize(ClayCardSize.large), ClayRadius.large);
    });
  });

  group('money', () {
    test('formatCurrency keeps रू + 2 decimals by default', () {
      expect(formatCurrency(12.5), 'रू 12.50');
      expect(formatCurrency(0), 'रू 0.00');
      expect(
        formatCurrency(1234.567, decimalPlaces: 0),
        'रू 1235',
      );
    });
  });

  group('BS dates', () {
    test('ClayBsDate formats a known AD date', () {
      // 2024-01-01 AD = Poush 17, 2080 BS.
      expect(ClayBsDate.format(DateTime(2024, 1, 1)), '2080-09-17');
      expect(
        ClayBsDate.formatLong(DateTime(2024, 1, 1)),
        'Poush 17, 2080 BS',
      );
      expect(ClayBsDate.format(null), isEmpty);
    });

    test('BS calendar table covers 12 months', () {
      expect(ClayBsDate.months, hasLength(12));
      expect(ClayBsDate.weekdays, hasLength(7));
      // Ashwin 2083 is a real month with a plausible length.
      final days = ClayBsDate.daysInMonth(2083, 6);
      expect(days, inInclusiveRange(28, 32));
    });

    testWidgets('ClayBsDateInput shows BS by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Scaffold(
            body: ClayBsDateInput(
              label: 'Fiscal start',
              value: DateTime(2024, 1, 1),
              onChanged: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Poush 17, 2080 BS'), findsOneWidget);
    });
  });

  group('narrow layouts (Edge overflow regressions)', () {
    Future<void> pumpFixed(
      WidgetTester tester,
      double width,
      Widget child,
    ) async {
      tester.view.physicalSize = Size(width, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Scaffold(body: child),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    testWidgets('action tiles grid survives a 330px side column',
        (tester) async {
      // Mirrors _QuickActions: 6 tiles, max-extent delegate, fixed height.
      await pumpFixed(
        tester,
        330,
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 150,
          ),
          children: const [
            ClayActionTile(icon: ClayIcons.sales, title: 'New Sale'),
            ClayActionTile(icon: ClayIcons.purchases, title: 'New Purchase'),
            ClayActionTile(icon: ClayIcons.contacts, title: 'New Contact'),
            ClayActionTile(icon: ClayIcons.products, title: 'New Product'),
            ClayActionTile(icon: ClayIcons.payments, title: 'New Payment'),
            ClayActionTile(icon: ClayIcons.reports, title: 'Reports'),
          ],
        ),
      );
      expect(find.text('New Sale'), findsOneWidget);
    });

    testWidgets('v3 stat card survives a 160px grid cell', (tester) async {
      await pumpFixed(
        tester,
        160,
        const ClayStatCard(
          title: 'Revenue',
          value: 'रू 12,340.00',
          icon: ClayIcons.revenue,
          iconColor: ClayColors.success,
          subtitle: 'Outstanding',
          trend: ClayTrend(pct: 12.5),
          spark: [3.0, 5.0, 4.0, 7.0, 6.0, 9.0],
        ),
      );
      expect(find.text('Revenue'), findsOneWidget);
    });
  });

  group('large text scaling', () {
    testWidgets('gallery survives 1.3x text scaling', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: MaterialApp(
            theme: ClayTheme.lightTheme,
            home: const GalleryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Typography'), findsOneWidget);
      expect(find.text('Cards · Outlined'), findsOneWidget);
    });
  });
}
