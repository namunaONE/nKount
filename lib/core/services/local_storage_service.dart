import 'package:logger/logger.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../models/company_model.dart';
import '../models/contact_model.dart';
import '../models/payment_model.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// Service for managing local storage with Hive
class LocalStorageService {
  factory LocalStorageService() => _instance;

  LocalStorageService._internal();
  static final LocalStorageService _instance = LocalStorageService._internal();

  static LocalStorageService get instance => _instance;

  static final Logger _logger = Logger();

  bool _isInitialized = false;

  /// Initialize Hive boxes
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Register adapters
      _registerAdapters();

      // Initialize Hive
      if (!kIsWeb) {
        final appDocumentDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDir.path);
      } else {
        // For web, Hive uses IndexedDB
        Hive.init('nkount_db');
      }

      // Open boxes
      await _openBoxes();

      _isInitialized = true;
      _logger.i('✅ LocalStorageService initialized');
    } on Exception catch (e) {
      _logger.i('❌ Error initializing LocalStorageService: $e');
      rethrow;
    }
  }

  /// Register Hive adapters
  void _registerAdapters() {
    // Register all model adapters
    Hive.registerAdapter(ContactModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(TransactionItemAdapter());
    Hive.registerAdapter(PaymentModelAdapter());
    Hive.registerAdapter(PaymentSummaryAdapter());
    Hive.registerAdapter(CompanyModelAdapter());
  }

  /// Open all Hive boxes
  Future<void> _openBoxes() async {
    // Open boxes with error handling
    try {
      await Hive.openBox<ContactModel>(AppConstants.BOX_CONTACTS);
      await Hive.openBox<ProductModel>(AppConstants.BOX_PRODUCTS);
      await Hive.openBox<TransactionModel>(AppConstants.BOX_TRANSACTIONS);
      await Hive.openBox<PaymentModel>(AppConstants.BOX_PAYMENTS);
      await Hive.openBox<CompanyModel>(AppConstants.BOX_COMPANY);
      await Hive.openBox(AppConstants.BOX_SETTINGS);

      _logger.i('✅ All Hive boxes opened successfully');
    } on Exception catch (e) {
      _logger.i('❌ Error opening Hive boxes: $e');
      // Try to open boxes individually
      await _openBoxSafely<ContactModel>(AppConstants.BOX_CONTACTS);
      await _openBoxSafely<ProductModel>(AppConstants.BOX_PRODUCTS);
      await _openBoxSafely<TransactionModel>(AppConstants.BOX_TRANSACTIONS);
      await _openBoxSafely<PaymentModel>(AppConstants.BOX_PAYMENTS);
      await _openBoxSafely<CompanyModel>(AppConstants.BOX_COMPANY);
      await _openBoxSafely(AppConstants.BOX_SETTINGS);
    }
  }

  /// Open a box safely with error handling
  Future<void> _openBoxSafely<T>(String boxName) async {
    try {
      await Hive.openBox<T>(boxName);
      _logger.i('✅ Box $boxName opened');
    } on Exception catch (e) {
      _logger.i('❌ Error opening box $boxName: $e');
    }
  }

  /// Get box by name
  Box<T>? getBox<T>(String boxName) {
    if (!_isInitialized) {
      throw Exception(
          'LocalStorageService not initialized. Call initialize() first.');
    }

    try {
      return Hive.box<T>(boxName);
    } on Exception catch (e) {
      _logger.i('❌ Error getting box $boxName: $e');
      return null;
    }
  }

  /// Check if storage is initialized
  bool get isInitialized => _isInitialized;

  /// Close all boxes
  Future<void> close() async {
    if (!_isInitialized) return;

    try {
      await Hive.close();
      _isInitialized = false;
      _logger.i('✅ LocalStorageService closed');
    } on Exception catch (e) {
      _logger.i('❌ Error closing LocalStorageService: $e');
    }
  }

  /// Delete all data (for testing or reset)
  Future<void> deleteAllData() async {
    if (!_isInitialized) return;

    try {
      await Hive.deleteBoxFromDisk(AppConstants.BOX_CONTACTS);
      await Hive.deleteBoxFromDisk(AppConstants.BOX_PRODUCTS);
      await Hive.deleteBoxFromDisk(AppConstants.BOX_TRANSACTIONS);
      await Hive.deleteBoxFromDisk(AppConstants.BOX_PAYMENTS);
      await Hive.deleteBoxFromDisk(AppConstants.BOX_COMPANY);
      await Hive.deleteBoxFromDisk(AppConstants.BOX_SETTINGS);

      // Re-open boxes
      await _openBoxes();

      _logger.i('✅ All data deleted');
    } on Exception catch (e) {
      _logger.i('❌ Error deleting all data: $e');
      rethrow;
    }
  }

  /// Export all data to JSON
  Future<Map<String, dynamic>> exportAllData() async {
    if (!_isInitialized) {
      throw Exception('LocalStorageService not initialized');
    }

    final data = <String, dynamic>{};

    try {
      final contactsBox = Hive.box<ContactModel>(AppConstants.BOX_CONTACTS);
      data['contacts'] = contactsBox.values.map((c) => c.toJson()).toList();

      final productsBox = Hive.box<ProductModel>(AppConstants.BOX_PRODUCTS);
      data['products'] = productsBox.values.map((p) => p.toJson()).toList();

      final transactionsBox =
          Hive.box<TransactionModel>(AppConstants.BOX_TRANSACTIONS);
      data['transactions'] =
          transactionsBox.values.map((t) => t.toJson()).toList();

      final paymentsBox = Hive.box<PaymentModel>(AppConstants.BOX_PAYMENTS);
      data['payments'] = paymentsBox.values.map((p) => p.toJson()).toList();

      final companyBox = Hive.box<CompanyModel>(AppConstants.BOX_COMPANY);
      if (companyBox.isNotEmpty) {
        data['company'] = companyBox.getAt(0)?.toJson();
      }

      final settingsBox = Hive.box(AppConstants.BOX_SETTINGS);
      data['settings'] = settingsBox.toMap();

      return data;
    } on Exception catch (e) {
      _logger.i('❌ Error exporting all data: $e');
      rethrow;
    }
  }

  /// Import all data from JSON
  Future<void> importAllData(Map<String, dynamic> data) async {
    if (!_isInitialized) {
      throw Exception('LocalStorageService not initialized');
    }

    try {
      // Clear existing data
      await deleteAllData();

      // Import contacts
      if (data['contacts'] != null) {
        final contactsBox = Hive.box<ContactModel>(AppConstants.BOX_CONTACTS);
        for (final contactData in data['contacts'] as List) {
          final contact = ContactModel.fromJson(contactData);
          await contactsBox.add(contact);
        }
      }

      // Import products
      if (data['products'] != null) {
        final productsBox = Hive.box<ProductModel>(AppConstants.BOX_PRODUCTS);
        for (final productData in data['products'] as List) {
          final product = ProductModel.fromJson(productData);
          await productsBox.add(product);
        }
      }

      // Import transactions
      if (data['transactions'] != null) {
        final transactionsBox =
            Hive.box<TransactionModel>(AppConstants.BOX_TRANSACTIONS);
        for (final transactionData in data['transactions'] as List) {
          final transaction = TransactionModel.fromJson(transactionData);
          await transactionsBox.add(transaction);
        }
      }

      // Import payments
      if (data['payments'] != null) {
        final paymentsBox = Hive.box<PaymentModel>(AppConstants.BOX_PAYMENTS);
        for (final paymentData in data['payments'] as List) {
          final payment = PaymentModel.fromJson(paymentData);
          await paymentsBox.add(payment);
        }
      }

      // Import company
      if (data['company'] != null) {
        final companyBox = Hive.box<CompanyModel>(AppConstants.BOX_COMPANY);
        final company = CompanyModel.fromJson(data['company']);
        await companyBox.add(company);
      }

      // Import settings
      if (data['settings'] != null) {
        final settingsBox = Hive.box(AppConstants.BOX_SETTINGS);
        await settingsBox.putAll(data['settings']);
      }

      _logger.i('✅ All data imported successfully');
    } on Exception catch (e) {
      _logger.i('❌ Error importing all data: $e');
      rethrow;
    }
  }
}
