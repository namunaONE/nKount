import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Compact-only navigation + brand/destructive dialog buttons.
///
/// Wide windows (medium and expanded) share one compact [NavigationRail]
/// on every platform — no expanded sidebar. Form dialogs pair a neutral
/// Cancel with a brand-primary Save; only destructive Delete/Discard
/// confirmations use the error-red roles.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_rail');
    await hiveService.initialize(testPath: dir.path);
  });

  Future<void> pumpScaffold(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: ClayScaffold(
            appBar: const ClayAppBar(title: Text('Shell')),
            body: const Text('content'),
            bottomNavigationBar: ClayBottomNavigation(
              currentIndex: 0,
              items: kMainNavItems,
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  group('compact rail on all wide windows', () {
    testWidgets('expanded window uses the compact rail', (tester) async {
      await pumpScaffold(tester, const Size(1400, 900));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      // Rail carries the same destinations as the bottom bar.
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Payments'), findsOneWidget);
    });

    testWidgets('medium window uses the same compact rail', (tester) async {
      await pumpScaffold(tester, const Size(800, 1200));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('compact window keeps the bottom bar', (tester) async {
      await pumpScaffold(tester, const Size(400, 800));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });
  });

  group('dialog buttons (brand + destructive roles)', () {
    testWidgets('form dialog shows neutral Cancel and brand Save',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ClayFormDialog(
                  title: const Text('Add thing'),
                  onSave: () {},
                  child: const Text('body'),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      final save = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Save'),
      );
      expect(save.onPressed, isNotNull);
      // Cancel is neutral — not the error color.
      final scheme = ClayTheme.lightTheme.colorScheme;
      final cancel = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Cancel'),
      );
      expect(
        cancel.style?.foregroundColor?.resolve({}),
        scheme.onSurfaceVariant,
      );

      // Cancel dismisses without saving.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Add thing'), findsNothing);
    });

    testWidgets('destructive confirm uses error-red confirm only',
        (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showClayConfirmDialog(
                  context,
                  title: 'Delete?',
                  message: 'Sure?',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final scheme = ClayTheme.lightTheme.colorScheme;
      final confirm = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Delete'),
      );
      expect(confirm.style?.backgroundColor?.resolve({}), scheme.error);
      expect(confirm.style?.foregroundColor?.resolve({}), scheme.onError);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });
  });
}
