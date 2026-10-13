import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/transaction_model.dart';

void main() {
  group('VAT rules (IRD 13%)', () {
    test('VAT = (subtotal - discount) * rate / 100', () {
      const subtotal = 1000.0;
      const discount = 100.0;
      const rate = AppConstants.defaultVatRate;
      final vat = (subtotal - discount) * rate / 100;
      expect(vat, 117.0);
      expect(subtotal - discount + vat, 1017.0);
    });

    test('TransactionModel.create computes totals with 13% VAT', () {
      final tx = TransactionModel.create(
        type: AppConstants.transactionSale,
        contactId: 'c1',
        items: [
          TransactionItem.create(
            productId: 'p1',
            productName: 'Item',
            quantity: 2,
            unitPrice: 500,
          ),
        ],
      );
      expect(tx.subtotal, 1000.0);
      expect(tx.tax, 130.0);
      expect(tx.total, 1130.0);
      expect(tx.invoiceNumber, isNotEmpty);
    });
  });

  group('Contact balances', () {
    test('purchase increases balance, sale decreases it', () {
      var contact = ContactModel.create(name: 'Supplier A');
      contact = contact.copyWithTransaction(
        transactionType: AppConstants.transactionPurchase,
        amount: 500,
      );
      expect(contact.balance, 500);
      expect(contact.totalPurchases, 500);

      contact = contact.copyWithTransaction(
        transactionType: AppConstants.transactionSale,
        amount: 200,
      );
      expect(contact.balance, 300);
      expect(contact.totalSales, 200);
    });
  });
}
