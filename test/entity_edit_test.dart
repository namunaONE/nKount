import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/features/contacts/presentation/contacts_screen.dart';
import 'package:nkount/features/products/presentation/products_screen.dart';
import 'package:nkount/features/transactions/presentation/transactions_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Entity edits: one widget-zone write per box (contacts, products,
/// transactions), so all three flows share this isolate safely.
void main() {
  late String contactId;
  late String productId;
  late String transactionId;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_entityedit');
    await hiveService.initialize(testPath: dir.path);

    final contact = ContactModel.create(name: 'Edit Me');
    await hiveService.contactsBox.put(contact.id, contact);
    contactId = contact.id;

    final product = ProductModel.create(
      name: 'Edit Widget',
      purchasePrice: 10,
      salePrice: 15,
      quantity: 5,
      minQuantity: 1,
    );
    await hiveService.productsBox.put(product.id, product);
    productId = product.id;

    final tx = TransactionModel.create(
      type: AppConstants.transactionSale,
      contactId: 'c1',
      items: const [],
      subtotal: 1000,
      tax: 130,
      total: 1130,
    );
    await hiveService.transactionsBox.put(tx.id, tx);
    transactionId = tx.id;
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

  Future<void> saveAndSettle(WidgetTester tester) async {
    await tester.tap(find.text('Save'));
    await tester.pump();
    // Real Hive IO cannot complete under the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5)); // snackbar auto-dismiss
  }

  testWidgets('contact edit preserves identity and balances', (tester) async {
    await pumpScreen(tester, const ContactsScreen());

    await tester.tap(find.text('Edit Me').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Contact'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Edited Name',
    );
    await saveAndSettle(tester);

    expect(find.text('Edit Contact'), findsNothing);
    final stored = hiveService.contactsBox.get(contactId)!;
    expect(stored.name, 'Edited Name');
    expect(stored.id, contactId);
    expect(stored.balance, 0);
  });

  testWidgets('product edit preserves identity and stock', (tester) async {
    await pumpScreen(tester, const ProductsScreen());

    await tester.tap(find.text('Edit Widget').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Product'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Edited Widget',
    );
    await saveAndSettle(tester);

    expect(find.text('Edit Product'), findsNothing);
    final stored = hiveService.productsBox.get(productId)!;
    expect(stored.name, 'Edited Widget');
    expect(stored.id, productId);
    expect(stored.quantity, 5);
  });

  testWidgets('transaction edit recalculates totals, keeps identity',
      (tester) async {
    await pumpScreen(tester, const TransactionsScreen());

    // Select the row via its invoice cell: the detail pane's Edit action
    // is on-screen, unlike the table's trailing Actions column.
    final invoice =
        hiveService.transactionsBox.get(transactionId)!.invoiceNumber!;
    await tester.tap(find.text(invoice).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Transaction'), findsOneWidget);

    final fields = tester.widgetList<TextFormField>(
      find.byType(TextFormField),
    );
    final total = fields.firstWhere((f) => f.initialValue == '1130.0');
    await tester.enterText(find.byWidget(total), '2000');
    await saveAndSettle(tester);

    expect(find.text('Edit Transaction'), findsNothing);
    final stored = hiveService.transactionsBox.get(transactionId)!;
    expect(stored.total, 2000);
    expect(stored.dueAmount, 2000);
    expect(stored.id, transactionId);
  });
}
