import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/features/dashboard/presentation/dashboard_screen.dart';
import 'package:nkount/features/profile/presentation/profile_screen.dart';
import 'package:nkount/features/settings/presentation/settings_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Registered-company display: profile details, dashboard welcome,
/// settings live values. Reads only — no box writes after setUpAll.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_codisplay');
    await hiveService.initialize(testPath: dir.path);

    final company = CompanyModel.create(
      name: 'Shree Traders',
      ownerName: 'Ram Bahadur',
      registrationNumber: 'REG-42',
      address: 'Ward 5, New Road',
      city: 'Kathmandu',
      province: 'Bagmati',
      district: 'Chitwan',
      palika: 'Bharatpur',
      phone: '+977 1 4444444',
      email: 'info@shree.com.np',
      panNumber: '123456789',
      vatNumber: '600000000',
    );
    await hiveService.companiesBox.put(company.id, company);
  });

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1280, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('profile shows the registered business details', (tester) async {
    await pumpScreen(tester, const ProfileScreen());

    expect(find.text('Shree Traders'), findsOneWidget);
    expect(find.text('Ram Bahadur'), findsOneWidget);
    expect(find.text('Registered business'), findsOneWidget);
    expect(find.text('Business account'), findsNothing);
    expect(find.text('REG-42'), findsOneWidget);
    expect(find.text('+977 1 4444444'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    expect(find.text('600000000'), findsOneWidget);
    expect(
      find.text('Bharatpur, Chitwan, Bagmati'),
      findsOneWidget,
    );
    expect(find.textContaining('Ward 5, New Road'), findsWidgets);
  });

  testWidgets('dashboard welcomes the business by name', (tester) async {
    await pumpScreen(tester, const DashboardScreen());

    expect(find.textContaining('Shree Traders'), findsOneWidget);
    expect(
      find.text('Ram Bahadur • Chitwan, Bagmati'),
      findsOneWidget,
    );
  });

  testWidgets('settings shows live company values, no placeholders',
      (tester) async {
    await pumpScreen(tester, const SettingsScreen());

    expect(find.text('Shree Traders'), findsWidgets);
    expect(find.text('Ram Bahadur'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    // Twice: the live company row plus the live tax row.
    expect(find.text('600000000'), findsWidgets);
    expect(find.text('My Company'), findsNothing);
    expect(find.text('info@mycompany.com.np'), findsNothing);
  });
}
