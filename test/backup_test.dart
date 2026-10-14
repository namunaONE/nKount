import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';

/// Backup integrity: export → clear → import round-trips every record.
/// (Runs against a scratch dir via the [HiveService.initialize] testPath
/// seam; settings_screen.dart exercises the same path through the UI.)
void main() {
  late final String contactId;
  late final String productId;

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('nkount_backup');
    await hiveService.initialize(testPath: dir.path);
    final contact = ContactModel.create(name: 'Backup Probe');
    contactId = contact.id;
    await hiveService.contactsBox.put(contactId, contact);
    final product = ProductModel.create(
        name: 'Probe Widget', purchasePrice: 5, salePrice: 8);
    productId = product.id;
    await hiveService.productsBox.put(productId, product);
  });

  test('export produces JSON containing seeded records', () async {
    final data = await hiveService.exportAllData();
    expect(data, contains('contacts'));
    expect(data, contains('products'));
    final text = jsonEncode(data);
    expect(text, contains('Backup Probe'));
    expect(text, contains('Probe Widget'));
  });

  test('clear + import round-trips records', () async {
    final data = await hiveService.exportAllData();
    final text = jsonEncode(data);

    await hiveService.clearAllData();
    expect(hiveService.contactsBox.isEmpty, isTrue);
    expect(hiveService.productsBox.isEmpty, isTrue);

    await hiveService.importData(jsonDecode(text) as Map<String, dynamic>);
    expect(hiveService.contactsBox.length, 1);
    expect(hiveService.productsBox.length, 1);
    // Keys survive the round-trip: deletes/updates by id keep working.
    expect(hiveService.contactsBox.get(contactId)?.name, 'Backup Probe');
    expect(hiveService.productsBox.get(productId)?.name, 'Probe Widget');
  });
}
