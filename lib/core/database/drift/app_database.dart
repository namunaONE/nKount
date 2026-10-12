import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

/// Chart of Accounts - standard 1xxx-7xxx
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code =>
      text().withLength(min: 4, max: 10).unique()(); // e.g., 1000, 4001
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text().withLength(
      min: 1, max: 20)(); // asset, liability, equity, revenue, expense
  TextColumn get subtype =>
      text().nullable()(); // current, fixed, receivable, payable, etc.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Fiscal Years (BS - Shrawan 1 to Ashadh end)
class FiscalYears extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(min: 1, max: 50).unique()(); // e.g., "2081/82"
  IntColumn get bsStartYear => integer()(); // 2081
  IntColumn get bsEndYear => integer()(); // 2082
  DateTimeColumn get adStartDate => dateTime()();
  DateTimeColumn get adEndDate => dateTime()();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Companies
class Companies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get vatNumber => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  IntColumn get fiscalYearId =>
      integer().nullable().references(FiscalYears, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Contacts (Customers & Suppliers)
class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type =>
      text().withLength(min: 1, max: 20)(); // customer, supplier, both
  TextColumn get phone => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get vatNumber => text().nullable()();
  TextColumn get panNumber => text().nullable()();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Products / Inventory Items
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get code => text().withLength(min: 1, max: 50).unique()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get unit => text().nullable()(); // e.g., PCS, KG, LTR
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get salePrice => real().withDefault(const Constant(0.0))();
  RealColumn get costPrice => real().withDefault(const Constant(0.0))();
  RealColumn get quantity => real().withDefault(const Constant(0.0))();
  RealColumn get minQuantity => real().withDefault(const Constant(0.0))();
  RealColumn get taxRate => real().withDefault(const Constant(13.0))();
  BoolColumn get isTaxable => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get barcode => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tax Rates
class TaxRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get code =>
      text().withLength(min: 1, max: 20).unique()(); // VAT13, VAT0, etc.
  RealColumn get rate => real()(); // percentage
  BoolColumn get isVat => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Voucher Headers (main transaction entry)
class Vouchers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  IntColumn get fiscalYearId => integer().references(FiscalYears, #id)();
  TextColumn get voucherType => text().withLength(
      min: 1, max: 20)(); // sale, purchase, payment, receipt, journal
  TextColumn get voucherNumber =>
      text().withLength(min: 1, max: 50)(); // INV-001, CR-001, etc.
  IntColumn get contactId => integer().nullable().references(Contacts, #id)();
  DateTimeColumn get voucherDate => dateTime()(); // AD date
  TextColumn get bsDate => text().nullable()(); // BS date string
  IntColumn get bsYear => integer().nullable()();
  IntColumn get bsMonth => integer().nullable()();
  IntColumn get bsDay => integer().nullable()();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get total => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get dueAmount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentStatus =>
      text().withLength(min: 1, max: 20).withDefault(
          const Constant('pending'))(); // pending, partial, paid, cancelled
  TextColumn get paymentMethod =>
      text().nullable()(); // cash, bank, cheque, online
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isVatIncluded => boolean().withDefault(const Constant(true))();
  RealColumn get vatRate => real().withDefault(const Constant(13.0))();
  BoolColumn get isCancelled => boolean().withDefault(const Constant(false))();
  TextColumn get cancellationReason => text().nullable()();
  IntColumn get createdBy => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}

/// Voucher Lines (double-entry legs)
class VoucherLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get voucherId =>
      integer().references(Vouchers, #id, onDelete: KeyAction.cascade)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get contactId => integer().nullable().references(Contacts, #id)();
  TextColumn get description => text().nullable()();
  RealColumn get debit => real().withDefault(const Constant(0.0))();
  RealColumn get credit => real().withDefault(const Constant(0.0))();
  IntColumn get sequence =>
      integer().withDefault(const Constant(0))(); // line order
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Voucher Items (inventory detail for sale/purchase)
class VoucherItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get voucherId =>
      integer().references(Vouchers, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get productName => text().withLength(min: 1, max: 100)();
  RealColumn get quantity => real()();
  TextColumn get unit => text().nullable()();
  RealColumn get unitPrice => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get taxRate => real().withDefault(const Constant(13.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get amount => real()(); // quantity * unitPrice - discount + tax
  IntColumn get sequence => integer().withDefault(const Constant(0))();
}

/// Stock Movements (inventory tracking)
class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get voucherId => integer().references(Vouchers, #id)();
  IntColumn get voucherItemId =>
      integer().nullable().references(VoucherItems, #id)();
  TextColumn get movementType =>
      text().withLength(min: 1, max: 20)(); // in, out, adjustment
  RealColumn get quantity => real()();
  RealColumn get unitCost => real().withDefault(const Constant(0.0))();
  RealColumn get runningBalance => real()();
  DateTimeColumn get movementDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Payments / Receipts (separate table for payment tracking)
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get type =>
      text().withLength(min: 1, max: 20)(); // payment, receipt
  IntColumn get voucherId => integer().nullable().references(Vouchers, #id)();
  TextColumn get paymentNumber =>
      text().withLength(min: 1, max: 50).unique()(); // PAY-001, RCV-001
  IntColumn get contactId => integer().references(Contacts, #id)();
  RealColumn get amount => real()();
  TextColumn get method =>
      text().withLength(min: 1, max: 20)(); // cash, bank, cheque, online
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get chequeNumber => text().nullable()();
  DateTimeColumn get chequeDate => dateTime().nullable()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isCleared => boolean().withDefault(const Constant(true))();
  DateTimeColumn get clearedDate => dateTime().nullable()();
  BoolColumn get isCancelled => boolean().withDefault(const Constant(false))();
  TextColumn get cancellationReason => text().nullable()();
  IntColumn get createdBy => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Sync Log (for future cloud sync)
class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get entityType => text().withLength(min: 1, max: 50)();
  IntColumn get entityId => integer()();
  TextColumn get action =>
      text().withLength(min: 1, max: 20)(); // create, update, delete
  TextColumn get status => text()
      .withLength(min: 1, max: 20)
      .withDefault(const Constant('pending'))(); // pending, completed, failed
  TextColumn get errorMessage => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}

/// Audit Log (immutable audit trail)
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get entityType => text().withLength(min: 1, max: 50)();
  IntColumn get entityId => integer()();
  TextColumn get action =>
      text().withLength(min: 1, max: 20)(); // create, update, delete, reverse
  TextColumn get description => text().nullable()();
  TextColumn get oldValues => text().nullable()(); // JSON
  TextColumn get newValues => text().nullable()(); // JSON
  TextColumn get changedFields => text().nullable()(); // JSON
  IntColumn get userId => integer().nullable()();
  TextColumn get userName => text().nullable()();
  TextColumn get ipAddress => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Settings
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().nullable().references(Companies, #id)();
  TextColumn get key => text().withLength(min: 1, max: 100)();
  TextColumn get value => text().nullable()();
  TextColumn get category =>
      text().withLength(min: 1, max: 50).withDefault(const Constant('app'))();
  TextColumn get description => text().nullable()();
  BoolColumn get isSystemSetting =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isEditable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [
  Accounts,
  FiscalYears,
  Companies,
  Contacts,
  Products,
  TaxRates,
  Vouchers,
  VoucherLines,
  VoucherItems,
  StockMovements,
  Payments,
  SyncLogs,
  AuditLogs,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  /// Default constructor for production (opens file-based database).
  AppDatabase() : super(_openConnection());

  /// Test constructor allowing in-memory database injection.
  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultData(m);
        },
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
      );

  Future<void> _seedDefaultData(Migrator m) async {
    // Seed default accounts (standard chart of accounts)
    final defaultAccounts = [
      // Assets (1xxx)
      AccountsCompanion.insert(
          code: '1000',
          name: 'Cash',
          type: 'asset',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '1010',
          name: 'Bank',
          type: 'asset',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '1100',
          name: 'Accounts Receivable',
          type: 'asset',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '1150',
          name: 'VAT Receivable',
          type: 'asset',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '1200',
          name: 'Inventory',
          type: 'asset',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '1500',
          name: 'Fixed Assets',
          type: 'asset',
          subtype: const Value('fixed')),
      AccountsCompanion.insert(
          code: '1510',
          name: 'Accumulated Depreciation',
          type: 'asset',
          subtype: const Value('fixed')),

      // Liabilities (2xxx)
      AccountsCompanion.insert(
          code: '2000',
          name: 'Accounts Payable',
          type: 'liability',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '2050',
          name: 'VAT Payable',
          type: 'liability',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '2100',
          name: 'TDS Payable',
          type: 'liability',
          subtype: const Value('current')),
      AccountsCompanion.insert(
          code: '2200',
          name: 'Short-term Loans',
          type: 'liability',
          subtype: const Value('current')),

      // Equity (3xxx)
      AccountsCompanion.insert(
          code: '3000',
          name: 'Owner\'s Equity',
          type: 'equity',
          subtype: const Value('capital')),
      AccountsCompanion.insert(
          code: '3100',
          name: 'Retained Earnings',
          type: 'equity',
          subtype: const Value('retained')),

      // Revenue (4xxx)
      AccountsCompanion.insert(
          code: '4000',
          name: 'Sales Revenue',
          type: 'revenue',
          subtype: const Value('sales')),
      AccountsCompanion.insert(
          code: '4100',
          name: 'Other Income',
          type: 'revenue',
          subtype: const Value('other')),

      // Expenses (5xxx)
      AccountsCompanion.insert(
          code: '5000',
          name: 'Cost of Goods Sold',
          type: 'expense',
          subtype: const Value('cogs')),
      AccountsCompanion.insert(
          code: '5100',
          name: 'Rent Expense',
          type: 'expense',
          subtype: const Value('operating')),
      AccountsCompanion.insert(
          code: '5200',
          name: 'Salary Expense',
          type: 'expense',
          subtype: const Value('operating')),
      AccountsCompanion.insert(
          code: '5300',
          name: 'Utilities Expense',
          type: 'expense',
          subtype: const Value('operating')),
      AccountsCompanion.insert(
          code: '5400',
          name: 'Office Expense',
          type: 'expense',
          subtype: const Value('operating')),
      AccountsCompanion.insert(
          code: '5500',
          name: 'Depreciation Expense',
          type: 'expense',
          subtype: const Value('operating')),
      AccountsCompanion.insert(
          code: '5600',
          name: 'Other Expenses',
          type: 'expense',
          subtype: const Value('operating')),
    ];

    await batch((batch) {
      batch.insertAll(accounts, defaultAccounts);
    });

    // Seed default fiscal year
    await into(fiscalYears).insert(FiscalYearsCompanion.insert(
      name: '2081/82',
      bsStartYear: 2081,
      bsEndYear: 2082,
      adStartDate: DateTime(2024, 7, 16),
      adEndDate: DateTime(2025, 7, 15),
      isActive: const Value(true),
    ));

    // Seed default tax rates
    final defaultTaxRates = [
      TaxRatesCompanion.insert(
          name: 'VAT 13%',
          code: 'VAT13',
          rate: 13.0,
          isVat: const Value(true),
          isActive: const Value(true),
          description: const Value('Standard VAT rate for Nepal')),
      TaxRatesCompanion.insert(
          name: 'VAT 0%',
          code: 'VAT0',
          rate: 0.0,
          isVat: const Value(true),
          isActive: const Value(true),
          description: const Value('Zero-rated VAT')),
      TaxRatesCompanion.insert(
          name: 'Exempt',
          code: 'EXEMPT',
          rate: 0.0,
          isVat: const Value(false),
          isActive: const Value(true),
          description: const Value('VAT exempt items')),
    ];
    await batch((batch) {
      batch.insertAll(taxRates, defaultTaxRates);
    });

    // Seed default settings
    final defaultSettings = [
      SettingsCompanion.insert(
          key: 'default_vat_rate',
          value: const Value('13.0'),
          category: const Value('tax'),
          description: const Value('Default VAT rate percentage')),
      SettingsCompanion.insert(
          key: 'invoice_prefix',
          value: const Value('INV'),
          category: const Value('invoice'),
          description: const Value('Invoice number prefix')),
      SettingsCompanion.insert(
          key: 'auto_backup',
          value: const Value('true'),
          category: const Value('backup'),
          description: const Value('Enable automatic backup')),
      SettingsCompanion.insert(
          key: 'currency',
          value: const Value('NPR'),
          category: const Value('localization'),
          description: const Value('Default currency')),
      SettingsCompanion.insert(
          key: 'currency_symbol',
          value: const Value('रू'),
          category: const Value('localization'),
          description: const Value('Currency symbol')),
      SettingsCompanion.insert(
          key: 'bs_date_format',
          value: const Value('yyyy/MM/dd'),
          category: const Value('localization'),
          description: const Value('BS date format')),
      SettingsCompanion.insert(
          key: 'ad_date_format',
          value: const Value('yyyy-MM-dd'),
          category: const Value('localization'),
          description: const Value('AD date format')),
    ];
    await batch((batch) {
      batch.insertAll(settings, defaultSettings);
    });
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'nkount.db'));
      return NativeDatabase(file);
    });

/// Database instance provider
AppDatabase get appDatabase => AppDatabase();
