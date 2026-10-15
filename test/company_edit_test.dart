import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/features/settings/presentation/settings_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Settings company edit: the single write in this file. Everything else
/// is reads (Hive write-chain rule).
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_coedit');
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

  testWidgets('edit company info updates the profile in place', (tester) async {
    tester.view.physicalSize = const Size(900, 2500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Edit Company Info'));
    await tester.pumpAndSettle();
    expect(find.text('Business name'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Shree Traders Pvt. Ltd.',
    );
    await tester.tap(find.text('Save'));
    await tester.pump();
    // Real Hive IO cannot complete under the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5)); // snackbar auto-dismiss

    // Dialog closed, settings shows the new name, same record updated.
    expect(find.text('Edit Company Info'), findsOneWidget);
    expect(find.text('Shree Traders Pvt. Ltd.'), findsWidgets);
    final stored = hiveService.companiesBox.values.single;
    expect(stored.name, 'Shree Traders Pvt. Ltd.');
    expect(stored.ownerName, 'Ram Bahadur');
    expect(stored.district, 'Chitwan');
  });
}
