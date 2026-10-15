import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/utils/money.dart';

/// Payment → contact balance rule (README): recording a payment decreases
/// the supplier balance, recording a receipt increases the customer balance.
///
/// These are service-level tests and live in their own file: a Hive write
/// performed inside a widget test wipes that box's write chain for the rest
/// of the isolate, so the UI flow tests and these direct writes must not
/// share an isolate.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_payment');
    await hiveService.initialize(testPath: dir.path);
  });

  group('payment → contact balance (README rule)', () {
    test('recording a receipt increases the contact balance', () async {
      final contact = ContactModel.create(name: 'Customer A');
      await hiveService.contactsBox.put(contact.id, contact);

      final sale = TransactionModel.create(
        type: AppConstants.transactionSale,
        contactId: contact.id,
        items: [
          TransactionItem.create(
            productId: 'p1',
            productName: 'Widget',
            quantity: 1,
            unitPrice: 1000,
          ),
        ],
      );
      await hiveService.transactionsBox.put(sale.id, sale);
      expect(sale.dueAmount, 1130.0);

      // Mirrors the record-payment wiring: payment record + transaction
      // update + contact balance, all in the same direction.
      final payment = PaymentModel.create(
        type: 'receipt',
        transactionId: sale.id,
        contactId: contact.id,
        amount: 1130.0,
        method: AppConstants.paymentCash,
      );
      await hiveService.paymentsBox.put(payment.id, payment);

      final updatedContact = contact.copyWithTransaction(
        transactionType: 'receipt',
        amount: 1130.0,
      );
      await hiveService.contactsBox.put(updatedContact.id, updatedContact);

      final stored = hiveService.contactsBox.get(contact.id)!;
      expect(stored.totalReceipts, 1130.0);
      expect(stored.balance, 1130.0); // customer paid down their purchase

      await hiveService.paymentsBox.clear();
      await hiveService.transactionsBox.clear();
      await hiveService.contactsBox.clear();
    });

    test('recording a payment decreases the supplier balance', () async {
      final supplier = ContactModel.create(
          name: 'Supplier B', type: AppConstants.contactSupplier);
      await hiveService.contactsBox.put(supplier.id, supplier);

      // A purchase puts the supplier into payable territory...
      var afterPurchase = supplier.copyWithTransaction(
        transactionType: AppConstants.transactionPurchase,
        amount: 500,
      );
      await hiveService.contactsBox.put(afterPurchase.id, afterPurchase);
      expect(afterPurchase.balance, 500);

      // ...and paying it back down reduces the balance.
      afterPurchase = afterPurchase.copyWithTransaction(
        transactionType: 'payment',
        amount: 500,
      );
      await hiveService.contactsBox.put(afterPurchase.id, afterPurchase);

      final stored = hiveService.contactsBox.get(supplier.id)!;
      expect(stored.totalPayments, 500);
      expect(stored.balance, 0);
      expect(formatCurrency(stored.balance), 'रू 0.00');
    });
  });
}
