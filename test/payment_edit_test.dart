import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/features/shared/money_flow.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Payment edit: amount delta re-applied to transaction paid/due and the
/// supplier balance. The only widget-zone writes in this file.
void main() {
  late String paymentId;
  late String transactionId;
  late String supplierId;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_payedit');
    await hiveService.initialize(testPath: dir.path);

    // Supplier owes 500 on a purchase; 200 already paid.
    final supplier = ContactModel.create(
      name: 'Supplier B',
      type: AppConstants.contactSupplier,
    ).copyWithTransaction(
      transactionType: AppConstants.transactionPurchase,
      amount: 500,
    );
    await hiveService.contactsBox.put(supplier.id, supplier);
    supplierId = supplier.id;

    var tx = TransactionModel.create(
      type: AppConstants.transactionPurchase,
      contactId: supplier.id,
      items: const [],
      subtotal: 500,
      tax: 0,
      total: 500,
    );
    await hiveService.transactionsBox.put(tx.id, tx);
    transactionId = tx.id;

    final payment = PaymentModel.create(
      type: 'payment',
      transactionId: tx.id,
      contactId: supplier.id,
      amount: 200,
      method: AppConstants.paymentCash,
    );
    await hiveService.paymentsBox.put(payment.id, payment);
    paymentId = payment.id;

    tx = tx.copyWithPayment(
      amount: 200,
      paymentMethod: AppConstants.paymentCash,
    );
    await hiveService.transactionsBox.put(tx.id, tx);

    final updated = supplier.copyWithTransaction(
      transactionType: 'payment',
      amount: 200,
    );
    await hiveService.contactsBox.put(updated.id, updated);
  });

  testWidgets('payment edit shifts paid, due and balance by the delta',
      (tester) async {
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: const MoneyFlowScreen(config: MoneyFlowConfig.payment),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('रू 200.00').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Payment'), findsOneWidget);

    final fields = tester.widgetList<TextFormField>(
      find.byType(TextFormField),
    );
    final amount = fields.firstWhere((f) => f.initialValue == '200.0');
    await tester.enterText(find.byWidget(amount), '300');

    await tester.tap(find.text('Save'));
    await tester.pump();
    // Real Hive IO cannot complete under the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5)); // snackbar auto-dismiss

    expect(find.text('Edit Payment'), findsNothing);
    expect(hiveService.paymentsBox.get(paymentId)!.amount, 300);

    final tx = hiveService.transactionsBox.get(transactionId)!;
    expect(tx.paidAmount, 300);
    expect(tx.dueAmount, 200);

    final supplier = hiveService.contactsBox.get(supplierId)!;
    expect(supplier.totalPayments, 300);
    expect(supplier.balance, 200);
  });
}
