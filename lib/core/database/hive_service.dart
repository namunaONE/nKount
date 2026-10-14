import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logger/logger.dart';
import '../models/company_model.dart';
import '../models/contact_model.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_item_model.dart';
import '../models/payment_model.dart';
import '../models/category_model.dart';
import '../models/brand_model.dart';
import '../models/unit_model.dart';
import '../models/tax_rate_model.dart';
import '../models/setting_model.dart';
import '../models/sync_log_model.dart';

/// Hive Database Service for nKount
/// Provides persistent storage for Flutter web using IndexedDB
class HiveService {
  // Factory constructor
  factory HiveService() => _instance;

  // Private constructor
  HiveService._internal();
  static final HiveService _instance = HiveService._internal();
  static final Logger _logger = Logger();

  // Box names
  static const String boxCompanies = 'nkount_companies';
  static const String boxContacts = 'nkount_contacts';
  static const String boxProducts = 'nkount_products';
  static const String boxTransactions = 'nkount_transactions';
  static const String boxTransactionItems = 'nkount_transaction_items';
  static const String boxPayments = 'nkount_payments';
  static const String boxCategories = 'nkount_categories';
  static const String boxBrands = 'nkount_brands';
  static const String boxUnits = 'nkount_units';
  static const String boxTaxRates = 'nkount_tax_rates';
  static const String boxSettings = 'nkount_settings';
  static const String boxSyncLogs = 'nkount_sync_logs';

  // Box instances
  late final Box<CompanyModel> companiesBox;
  late final Box<ContactModel> contactsBox;
  late final Box<ProductModel> productsBox;
  late final Box<TransactionModel> transactionsBox;
  late final Box<TransactionItemModel> transactionItemsBox;
  late final Box<PaymentModel> paymentsBox;
  late final Box<CategoryModel> categoriesBox;
  late final Box<BrandModel> brandsBox;
  late final Box<UnitModel> unitsBox;
  late final Box<TaxRateModel> taxRatesBox;
  late final Box<SettingModel> settingsBox;
  late final Box<SyncLogModel> syncLogsBox;

  // Initialization flag
  bool _isInitialized = false;

  /// Initialize Hive database.
  ///
  /// [testPath] is test-only: when given, Hive opens [testPath] on disk
  /// instead of `Hive.initFlutter()` (path_provider has no test binding).
  /// Production callers must omit it.
  Future<void> initialize({String? testPath}) async {
    if (_isInitialized) {
      _logger.i('Hive database already initialized');
      return;
    }

    try {
      _logger.i('Initializing Hive database...');

      // Initialize Hive for Flutter (or a scratch dir in tests).
      if (testPath == null) {
        await Hive.initFlutter();
      } else {
        Hive.init(testPath);
      }

      // Register adapters
      _registerAdapters();

      // Open boxes
      await _openBoxes();

      _isInitialized = true;
      _logger.i('Hive database initialized successfully');
    } catch (e) {
      _logger.e('Error initializing Hive database: $e');
      rethrow;
    }
  }

  /// Register Hive adapters
  void _registerAdapters() {
    // Type ID 0
    Hive.registerAdapter(CompanyModelAdapter());
    // Type ID 1
    Hive.registerAdapter(ContactModelAdapter());
    // Type ID 2
    Hive.registerAdapter(ProductModelAdapter());
    // Type ID 3
    Hive.registerAdapter(TransactionModelAdapter());
    // Type ID 4 (embedded items inside TransactionModel)
    Hive.registerAdapter(TransactionItemAdapter());
    // Type ID 14 (separate transaction_items box)
    Hive.registerAdapter(TransactionItemModelAdapter());
    // Type ID 5
    Hive.registerAdapter(PaymentModelAdapter());
    // Type ID 6
    Hive.registerAdapter(PaymentSummaryAdapter());
    // Type ID 7
    Hive.registerAdapter(CategoryModelAdapter());
    // Type ID 8
    Hive.registerAdapter(BrandModelAdapter());
    // Type ID 9
    Hive.registerAdapter(UnitModelAdapter());
    // Type ID 10
    Hive.registerAdapter(TaxRateModelAdapter());
    // Type ID 11
    Hive.registerAdapter(SettingModelAdapter());
    // Type ID 12
    Hive.registerAdapter(SyncLogModelAdapter());

    _logger.i('All Hive adapters registered');
  }

  /// Open all Hive boxes
  Future<void> _openBoxes() async {
    companiesBox = await Hive.openBox<CompanyModel>(boxCompanies);
    contactsBox = await Hive.openBox<ContactModel>(boxContacts);
    productsBox = await Hive.openBox<ProductModel>(boxProducts);
    transactionsBox = await Hive.openBox<TransactionModel>(boxTransactions);
    transactionItemsBox =
        await Hive.openBox<TransactionItemModel>(boxTransactionItems);
    paymentsBox = await Hive.openBox<PaymentModel>(boxPayments);
    categoriesBox = await Hive.openBox<CategoryModel>(boxCategories);
    brandsBox = await Hive.openBox<BrandModel>(boxBrands);
    unitsBox = await Hive.openBox<UnitModel>(boxUnits);
    taxRatesBox = await Hive.openBox<TaxRateModel>(boxTaxRates);
    settingsBox = await Hive.openBox<SettingModel>(boxSettings);
    syncLogsBox = await Hive.openBox<SyncLogModel>(boxSyncLogs);

    _logger.i('All Hive boxes opened successfully');
  }

  /// Check if Hive is initialized
  bool get isInitialized => _isInitialized;

  /// Close all boxes
  Future<void> close() async {
    try {
      await companiesBox.close();
      await contactsBox.close();
      await productsBox.close();
      await transactionsBox.close();
      await transactionItemsBox.close();
      await paymentsBox.close();
      await categoriesBox.close();
      await brandsBox.close();
      await unitsBox.close();
      await taxRatesBox.close();
      await settingsBox.close();
      await syncLogsBox.close();

      _isInitialized = false;
      _logger.i('All Hive boxes closed');
    } catch (e) {
      _logger.e('Error closing Hive boxes: $e');
      rethrow;
    }
  }

  /// Delete all data from all boxes
  Future<void> clearAllData() async {
    try {
      await companiesBox.clear();
      await contactsBox.clear();
      await productsBox.clear();
      await transactionsBox.clear();
      await transactionItemsBox.clear();
      await paymentsBox.clear();
      await categoriesBox.clear();
      await brandsBox.clear();
      await unitsBox.clear();
      await taxRatesBox.clear();
      await settingsBox.clear();
      await syncLogsBox.clear();

      _logger.i('All Hive data cleared');
    } catch (e) {
      _logger.e('Error clearing Hive data: $e');
      rethrow;
    }
  }

  /// Delete a specific box
  Future<void> clearBox(String boxName) async {
    try {
      switch (boxName) {
        case boxCompanies:
          await companiesBox.clear();
          break;
        case boxContacts:
          await contactsBox.clear();
          break;
        case boxProducts:
          await productsBox.clear();
          break;
        case boxTransactions:
          await transactionsBox.clear();
          break;
        case boxTransactionItems:
          await transactionItemsBox.clear();
          break;
        case boxPayments:
          await paymentsBox.clear();
          break;
        case boxCategories:
          await categoriesBox.clear();
          break;
        case boxBrands:
          await brandsBox.clear();
          break;
        case boxUnits:
          await unitsBox.clear();
          break;
        case boxTaxRates:
          await taxRatesBox.clear();
          break;
        case boxSettings:
          await settingsBox.clear();
          break;
        case boxSyncLogs:
          await syncLogsBox.clear();
          break;
        default:
          throw Exception('Unknown box: $boxName');
      }

      _logger.i('Hive box $boxName cleared');
    } catch (e) {
      _logger.e('Error clearing Hive box $boxName: $e');
      rethrow;
    }
  }

  /// Get box statistics
  Map<String, int> getBoxStats() => {
        'companies': companiesBox.length,
        'contacts': contactsBox.length,
        'products': productsBox.length,
        'transactions': transactionsBox.length,
        'transaction_items': transactionItemsBox.length,
        'payments': paymentsBox.length,
        'categories': categoriesBox.length,
        'brands': brandsBox.length,
        'units': unitsBox.length,
        'tax_rates': taxRatesBox.length,
        'settings': settingsBox.length,
        'sync_logs': syncLogsBox.length,
      };

  /// Export all data as JSON
  Future<Map<String, dynamic>> exportAllData() async {
    try {
      final data = <String, dynamic>{};

      data['companies'] = companiesBox.values.map((c) => c.toJson()).toList();
      data['contacts'] = contactsBox.values.map((c) => c.toJson()).toList();
      data['products'] = productsBox.values.map((p) => p.toJson()).toList();
      data['transactions'] =
          transactionsBox.values.map((t) => t.toJson()).toList();
      data['transaction_items'] =
          transactionItemsBox.values.map((ti) => ti.toJson()).toList();
      data['payments'] = paymentsBox.values.map((p) => p.toJson()).toList();
      data['categories'] = categoriesBox.values.map((c) => c.toJson()).toList();
      data['brands'] = brandsBox.values.map((b) => b.toJson()).toList();
      data['units'] = unitsBox.values.map((u) => u.toJson()).toList();
      data['tax_rates'] = taxRatesBox.values.map((tr) => tr.toJson()).toList();
      data['settings'] = settingsBox.values.map((s) => s.toJson()).toList();
      data['sync_logs'] = syncLogsBox.values.map((sl) => sl.toJson()).toList();

      _logger.i('Hive data exported');
      return data;
    } catch (e) {
      _logger.e('Error exporting Hive data: $e');
      rethrow;
    }
  }

  /// Import one box, preserving record ids as box keys.
  ///
  /// The app reads, updates, and deletes by id (`box.put(id, ...)`), so a
  /// restore must restore keys too — plain `add()` would orphan every
  /// delete/update issued after a restore. Records without an id fall
  /// back to `add()`, matching previous behavior.
  Future<void> _importBox<T>(
    Box<T> box,
    Object? list,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (list == null) return;
    for (final json in list as List) {
      final map = json as Map<String, dynamic>;
      final model = fromJson(map);
      final id = map['id'];
      if (id is String && id.isNotEmpty) {
        await box.put(id, model);
      } else {
        await box.add(model);
      }
    }
  }

  /// Import data from JSON
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      // Clear existing data
      await clearAllData();

      await _importBox(companiesBox, data['companies'], CompanyModel.fromJson);
      await _importBox(contactsBox, data['contacts'], ContactModel.fromJson);
      await _importBox(productsBox, data['products'], ProductModel.fromJson);
      await _importBox(
          transactionsBox, data['transactions'], TransactionModel.fromJson);
      await _importBox(transactionItemsBox, data['transaction_items'],
          TransactionItemModel.fromJson);
      await _importBox(paymentsBox, data['payments'], PaymentModel.fromJson);
      await _importBox(
          categoriesBox, data['categories'], CategoryModel.fromJson);
      await _importBox(brandsBox, data['brands'], BrandModel.fromJson);
      await _importBox(unitsBox, data['units'], UnitModel.fromJson);
      await _importBox(taxRatesBox, data['tax_rates'], TaxRateModel.fromJson);
      await _importBox(settingsBox, data['settings'], SettingModel.fromJson);
      await _importBox(syncLogsBox, data['sync_logs'], SyncLogModel.fromJson);

      _logger.i('Hive data imported');
    } catch (e) {
      _logger.e('Error importing Hive data: $e');
      rethrow;
    }
  }
}

// Singleton instance
final hiveService = HiveService();

/// Shared provider for the Hive singleton (single definition of truth;
/// screens must import this instead of redeclaring it).
final hiveServiceProvider = Provider<HiveService>((ref) => hiveService);
