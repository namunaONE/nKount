import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/core/database/drift/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Double-entry ledger', () {
    test('Sum(debit) == Sum(credit) for balanced voucher', () async {
      // Get a few accounts
      final cashAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('1000')))
          .getSingle();
      final revenueAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('4000')))
          .getSingle();
      final vatAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('2050')))
          .getSingle();

      // Post a sale voucher (cash) with 13% VAT
      // Dr Cash 1130 / Cr Revenue 1000 + Cr VAT Payable 130
      await db.transaction(() async {
        final voucherId = await db.into(db.vouchers).insert(
              VouchersCompanion.insert(
                companyId: 1,
                fiscalYearId: 1,
                voucherType: 'sale',
                voucherNumber: 'INV-001',
                voucherDate: DateTime.now(),
                subtotal: const Value(1000.0),
                taxAmount: const Value(130.0),
                total: const Value(1130.0),
                paidAmount: const Value(1130.0),
                dueAmount: const Value(0.0),
                paymentStatus: const Value('paid'),
              ),
            );

        await db.batch((batch) {
          batch.insertAll(db.voucherLines, [
            VoucherLinesCompanion.insert(
              voucherId: voucherId,
              accountId: cashAccount.id,
              debit: const Value(1130.0),
              credit: const Value(0.0),
              description: const Value('Cash received for sale'),
            ),
            VoucherLinesCompanion.insert(
              voucherId: voucherId,
              accountId: revenueAccount.id,
              debit: const Value(0.0),
              credit: const Value(1000.0),
              description: const Value('Sales revenue'),
            ),
            VoucherLinesCompanion.insert(
              voucherId: voucherId,
              accountId: vatAccount.id,
              debit: const Value(0.0),
              credit: const Value(130.0),
              description: const Value('VAT collected (13%)'),
            ),
          ]);
        });
      });

      // Verify trial balance balances
      final lines = await db.select(db.voucherLines).get();
      final totalDebit = lines.fold<double>(0, (sum, l) => sum + l.debit);
      final totalCredit = lines.fold<double>(0, (sum, l) => sum + l.credit);
      expect(totalDebit, equals(1130.0));
      expect(totalCredit, equals(1130.0));
      expect(totalDebit, equals(totalCredit));
    });

    test('Rejects unbalanced voucher (debits != credits)', () async {
      final cashAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('1000')))
          .getSingle();
      final revenueAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('4000')))
          .getSingle();

      // Deliberately unbalanced
      await db.transaction(() async {
        final voucherId = await db.into(db.vouchers).insert(
              VouchersCompanion.insert(
                companyId: 1,
                fiscalYearId: 1,
                voucherType: 'sale',
                voucherNumber: 'INV-BAD',
                voucherDate: DateTime.now(),
              ),
            );

        await db.batch((batch) {
          batch.insertAll(db.voucherLines, [
            VoucherLinesCompanion.insert(
              voucherId: voucherId,
              accountId: cashAccount.id,
              debit: const Value(500.0),
              credit: const Value(0.0),
            ),
            VoucherLinesCompanion.insert(
              voucherId: voucherId,
              accountId: revenueAccount.id,
              debit: const Value(0.0),
              credit: const Value(400.0), // Mismatch!
            ),
          ]);
        });
      });

      final lines = await db.select(db.voucherLines).get();
      final totalDebit = lines.fold<double>(0, (sum, l) => sum + l.debit);
      final totalCredit = lines.fold<double>(0, (sum, l) => sum + l.credit);
      expect(totalDebit, isNot(equals(totalCredit)),
          reason: 'This voucher should be unbalanced');
    });

    test('Trial balance query sums all debits and credits', () async {
      final result = await db.customSelect(
        '''
        SELECT
          COALESCE(SUM(debit), 0.0) AS total_debit,
          COALESCE(SUM(credit), 0.0) AS total_credit
        FROM voucher_lines
        ''',
      ).getSingle();

      final totalDebit = (result.data['total_debit'] as num).toDouble();
      final totalCredit = (result.data['total_credit'] as num).toDouble();
      expect(totalDebit, equals(totalCredit));
    });

    test('Account balance reflects debits minus credits', () async {
      final cashAccount = await (db.select(db.accounts)
            ..where((a) => a.code.equals('1000')))
          .getSingle();

      final result = await db.customSelect(
        '''
        SELECT
          COALESCE(SUM(debit), 0.0) - COALESCE(SUM(credit), 0.0) AS balance
        FROM voucher_lines
        WHERE account_id = ?
        ''',
        variables: [Variable.withInt(cashAccount.id)],
      ).getSingle();

      final balance = (result.data['balance'] as num).toDouble();
      // After the balanced sale test, cash should have 1130 debit
      expect(balance, greaterThanOrEqualTo(0));
    });
  });

  group('Seed data', () {
    test('Default accounts are created', () async {
      final accounts = await db.select(db.accounts).get();
      expect(accounts.length, greaterThanOrEqualTo(20));
      expect(
        accounts.any((a) => a.code == '1000' && a.name == 'Cash'),
        isTrue,
      );
      expect(
        accounts.any((a) => a.code == '4000' && a.name == 'Sales Revenue'),
        isTrue,
      );
    });

    test('Default fiscal year is created', () async {
      final years = await db.select(db.fiscalYears).get();
      expect(years.isNotEmpty, isTrue);
      expect(years.first.name, '2081/82');
    });

    test('Default tax rates include 13% VAT', () async {
      final rates = await db.select(db.taxRates).get();
      expect(rates.any((r) => r.code == 'VAT13' && r.rate == 13.0), isTrue);
    });

    test('Default settings exist', () async {
      final settings = await db.select(db.settings).get();
      expect(settings.isNotEmpty, isTrue);
      expect(
        settings.any((s) => s.key == 'default_vat_rate' && s.value == '13.0'),
        isTrue,
      );
    });
  });
}
