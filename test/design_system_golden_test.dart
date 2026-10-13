import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// P5 golden tests: pixel baselines for the core design-system surfaces.
///
/// Regenerate with: `flutter test --update-goldens test/design_system_golden_test.dart`
/// Fonts are bundled (assets/fonts), so goldens are deterministic and
/// offline-safe. Goldens are machine-specific; the committed PNGs are a
/// Windows baseline — regenerate on your platform if they mismatch.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpPreview(
    WidgetTester tester, {
    required ThemeData theme,
    required String golden,
  }) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(body: _Preview()),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(_Preview),
      matchesGoldenFile('goldens/$golden'),
    );
  }

  testWidgets('preview, light', (tester) async {
    await pumpPreview(
      tester,
      theme: ClayTheme.lightTheme,
      golden: 'design_system_preview_light.png',
    );
  });

  testWidgets('preview, dark', (tester) async {
    await pumpPreview(
      tester,
      theme: ClayTheme.darkTheme,
      golden: 'design_system_preview_dark.png',
    );
  });
}

/// Compact showcase: stat cards, card variants, buttons, section title.
class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClaySectionTitle(
              'Gallery preview',
              subtitle: 'Stat cards · variants · buttons',
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClayStatCard(
                    title: 'Revenue',
                    value: 'रू 12,340.00',
                    icon: ClayIcons.revenue,
                    iconColor: ClayColors.success,
                    subtitle: 'This month',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ClayStatCard(
                    title: 'Payables',
                    value: 'रू 4,120.50',
                    icon: ClayIcons.payables,
                    iconColor: ClayColors.warning,
                    subtitle: 'This month',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ClayCard(
              variant: ClayCardVariant.elevated,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Elevated · surfaceContainerLow · elevation 1'),
              ),
            ),
            SizedBox(height: 12),
            ClayCard(
              variant: ClayCardVariant.filled,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Filled · surfaceContainerHighest · elevation 0'),
              ),
            ),
            SizedBox(height: 12),
            ClayCard(
              variant: ClayCardVariant.outlined,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Outlined · outlineVariant border'),
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ClayButton(onPressed: null, child: Text('Elevated')),
                ClayButton.outlined(onPressed: null, child: Text('Outlined')),
                ClayButton.text(onPressed: null, child: Text('Text')),
              ],
            ),
          ],
        ),
      );
}
