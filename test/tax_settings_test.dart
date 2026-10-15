import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/core/models/tax_rate_model.dart';
import 'package:nkount/features/settings/presentation/settings_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Tax settings UI: live rows, add-rate validation, one persisted toggle.
/// The single box write (the toggle) runs last (Hive write-chain rule);
/// multi-write rate logic lives in tax_rates_test.dart as plain tests.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_taxui');
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

    for (final rate in [
      TaxRateModel.createVatRate(),
      TaxRateModel.create(
        name: 'VAT (0%)',
        code: 'VAT0',
        rate: 0.0,
        isVat: true,
      ),
      TaxRateModel.create(
        name: 'Service Charge',
        code: 'SERVICE',
        rate: 10.0,
      ),
      TaxRateModel.create(
        name: 'Excise Duty',
        code: 'EXCISE',
        rate: 5.0,
      ),
    ]) {
      await hiveService.taxRatesBox.put(rate.id, rate);
    }
  });

  Future<void> pumpSettings(WidgetTester tester) async {
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
  }

  testWidgets('shows the live default rate and company VAT', (tester) async {
    await pumpSettings(tester);

    expect(find.text('13%'), findsOneWidget);
    expect(find.text('600000000'), findsWidgets);
    expect(find.text('My Company'), findsNothing);
  });

  testWidgets('add-rate validation blocks an empty save', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Manage Tax Rates'));
    await tester.pumpAndSettle();
    expect(find.textContaining('VAT (13%)'), findsOneWidget);

    await tester.tap(find.text('Add Rate'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    expect(hiveService.taxRatesBox.length, 4);
  });

  testWidgets('toggling Show VAT on Invoice persists', (tester) async {
    await pumpSettings(tester);

    final row = find
        .ancestor(
          of: find.text('Show VAT on Invoice'),
          matching: find.byType(Row),
        )
        .first;
    await tester.tap(
      find.descendant(
        of: row,
        matching: find.byType(Switch),
      ),
    );
    await tester.pump();
    // Real Hive IO cannot complete under the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(
      hiveService.companiesBox.values.single.showTaxOnInvoice,
      isFalse,
    );
  });
}
