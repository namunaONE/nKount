import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/app/app.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/features/onboarding/presentation/onboarding_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Onboarding: first-run gate + business registration.
///
/// Order matters in this file (Hive write-chain rule): the only box write
/// is the final registration save. Everything before it is reads.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_onboard');
    await hiveService.initialize(testPath: dir.path);
  });

  GoRouter makeRouter(String initial) => GoRouter(
        initialLocation: initial,
        redirect: (context, state) => onboardingRedirect(state),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('home')),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
        ],
      );

  Future<void> pumpRouter(WidgetTester tester, String initial) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: ClayTheme.lightTheme,
          routerConfig: makeRouter(initial),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('empty box lands on onboarding', (tester) async {
    expect(hiveService.companiesBox.isEmpty, isTrue);
    await pumpRouter(tester, '/');
    expect(find.text('Welcome to nKount'), findsOneWidget);
    expect(find.text('home'), findsNothing);
  });

  testWidgets('empty business name blocks continue', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Business name is required'), findsOneWidget);
    expect(hiveService.companiesBox.isEmpty, isTrue);
  });

  testWidgets('full registration saves and enters the app', (tester) async {
    // Tall viewport: the contact step holds six fields; no scrolling
    // needed to reach every input and action.
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await pumpRouter(tester, '/onboarding');

    // Step 0: business.
    final step0 = find.byType(TextFormField);
    await tester.enterText(step0.at(0), 'Shree Traders');
    await tester.enterText(step0.at(1), 'Ram Bahadur');
    await tester.enterText(step0.at(2), 'REG-42');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 1: contact (mobile left empty — optional).
    final step1 = find.byType(TextFormField);
    await tester.enterText(step1.at(0), 'Ward 5, New Road');
    await tester.enterText(step1.at(1), 'Kathmandu');
    await tester.enterText(step1.at(2), 'Kathmandu');
    await tester.enterText(step1.at(3), '+977 1 4444444');
    await tester.enterText(step1.at(5), 'info@shree.com.np');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: tax.
    final step2 = find.byType(TextFormField);
    await tester.enterText(step2.at(0), '123456789');
    await tester.enterText(step2.at(1), '600000000');
    await tester.tap(find.text('Register Business'));
    await tester.pump();
    // Real Hive IO cannot complete under the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    final saved = hiveService.companiesBox.values.single;
    expect(saved.name, 'Shree Traders');
    expect(saved.ownerName, 'Ram Bahadur');
    expect(saved.registrationNumber, 'REG-42');
    expect(saved.phone, '+977 1 4444444');
    expect(saved.email, 'info@shree.com.np');
    expect(saved.panNumber, '123456789');
    expect(saved.vatNumber, '600000000');
  });

  testWidgets('registered box bounces onboarding back home', (tester) async {
    expect(hiveService.companiesBox.isNotEmpty, isTrue);
    await pumpRouter(tester, '/onboarding');
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Welcome to nKount'), findsNothing);
  });
}
