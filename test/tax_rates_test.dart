import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/tax_rate_model.dart';
import 'package:nkount/core/utils/tax_rates.dart';

/// Tax rate catalog logic as plain tests (no widgets): the multi-write
/// flows â€” set-default batching, add/delete round-trips â€” run in the real
/// zone here, where repeated Hive writes are safe.
void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('nkount_taxlogic');
    await hiveService.initialize(testPath: dir.path);

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

  test('seeded default VAT rate is 13%', () {
    expect(hiveService.taxRatesBox.length, 4);
    expect(defaultVatRate(hiveService.taxRatesBox), 13.0);
  });

  test('set-default batches to exactly one default (single putAll)', () async {
    final vatZero =
        hiveService.taxRatesBox.values.firstWhere((r) => r.code == 'VAT0');
    await hiveService.taxRatesBox.putAll({
      for (final r in hiveService.taxRatesBox.values.where((r) => r.isVat))
        r.id: r.copyWith(isDefault: r.id == vatZero.id),
    });

    expect(defaultVatRate(hiveService.taxRatesBox), 0.0);
    expect(
      hiveService.taxRatesBox.values.where((r) => r.isVat && r.isDefault),
      hasLength(1),
    );

    // Restore the 13% default for the tests below.
    final vat =
        hiveService.taxRatesBox.values.firstWhere((r) => r.code == 'VAT');
    await hiveService.taxRatesBox.putAll({
      for (final r in hiveService.taxRatesBox.values.where((r) => r.isVat))
        r.id: r.copyWith(isDefault: r.id == vat.id),
    });
    expect(defaultVatRate(hiveService.taxRatesBox), 13.0);
  });

  test('deactivated default falls back to the standard', () async {
    final vat =
        hiveService.taxRatesBox.values.firstWhere((r) => r.code == 'VAT');
    await hiveService.taxRatesBox.put(
      vat.id,
      vat.copyWith(isActive: false),
    );
    // No active default left: falls back across inactive, then standard.
    expect(defaultVatRate(hiveService.taxRatesBox), 13.0);

    await hiveService.taxRatesBox.put(
      vat.id,
      vat.copyWith(isActive: true),
    );
    expect(defaultVatRate(hiveService.taxRatesBox), 13.0);
  });

  test('add and delete round-trip', () async {
    final custom = TaxRateModel.create(
      name: 'Luxury Tax',
      code: 'LUX',
      rate: 5.0,
    );
    await hiveService.taxRatesBox.put(custom.id, custom);
    expect(hiveService.taxRatesBox.length, 5);

    await hiveService.taxRatesBox.delete(custom.id);
    expect(hiveService.taxRatesBox.length, 4);
  });
}
