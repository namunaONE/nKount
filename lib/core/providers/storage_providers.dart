import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/repositories/contact_repository.dart';
import 'package:nkount/core/repositories/payment_repository.dart';
import 'package:nkount/core/repositories/product_repository.dart';
import 'package:nkount/core/repositories/transaction_repository.dart';
import 'package:nkount/core/services/local_storage_service.dart';

/// Local Storage Service Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService.instance;
});

/// Box Providers
final contactsBoxProvider = Provider<Box<ContactModel>>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox<ContactModel>(AppConstants.BOX_CONTACTS);
  if (box == null) {
    throw Exception('Contacts box not initialized');
  }
  return box;
});

final productsBoxProvider = Provider<Box<ProductModel>>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox<ProductModel>(AppConstants.BOX_PRODUCTS);
  if (box == null) {
    throw Exception('Products box not initialized');
  }
  return box;
});

final transactionsBoxProvider = Provider<Box<TransactionModel>>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox<TransactionModel>(AppConstants.BOX_TRANSACTIONS);
  if (box == null) {
    throw Exception('Transactions box not initialized');
  }
  return box;
});

final paymentsBoxProvider = Provider<Box<PaymentModel>>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox<PaymentModel>(AppConstants.BOX_PAYMENTS);
  if (box == null) {
    throw Exception('Payments box not initialized');
  }
  return box;
});

final companyBoxProvider = Provider<Box<CompanyModel>>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox<CompanyModel>(AppConstants.BOX_COMPANY);
  if (box == null) {
    throw Exception('Company box not initialized');
  }
  return box;
});

final settingsBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final box = storage.getBox(AppConstants.BOX_SETTINGS);
  if (box == null) {
    throw Exception('Settings box not initialized');
  }
  return box;
});

/// Repository Providers
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final box = ref.watch(contactsBoxProvider);
  return ContactRepository(box);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final box = ref.watch(productsBoxProvider);
  return ProductRepository(box);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionsBoxProvider);
  return TransactionRepository(box);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final box = ref.watch(paymentsBoxProvider);
  return PaymentRepository(box);
});

/// Data Providers
final contactsProvider = StateNotifierProvider<ContactsNotifier, List<ContactModel>>((ref) {
  final repo = ref.watch(contactRepositoryProvider);
  return ContactsNotifier(repo);
});

final productsProvider = StateNotifierProvider<ProductsNotifier, List<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repo);
});

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return TransactionsNotifier(repo);
});

final paymentsProvider = StateNotifierProvider<PaymentsNotifier, List<PaymentModel>>((ref) {
  final repo = ref.watch(paymentRepositoryProvider);
  return PaymentsNotifier(repo);
});

/// Notifier Classes
class ContactsNotifier extends StateNotifier<List<ContactModel>> {
  final ContactRepository _repository;
  
  ContactsNotifier(this._repository) : super(_repository.getAllContacts());
  
  Future<void> refresh() async {
    state = _repository.getAllContacts();
  }
  
  Future<void> addContact(ContactModel contact) async {
    await _repository.saveContact(contact);
    state = _repository.getAllContacts();
  }
  
  Future<void> updateContact(ContactModel contact) async {
    await _repository.updateContact(contact);
    state = _repository.getAllContacts();
  }
  
  Future<void> deleteContact(String id) async {
    await _repository.deleteContact(id);
    state = _repository.getAllContacts();
  }
  
  List<ContactModel> searchContacts(String query) {
    return _repository.searchContacts(query);
  }
}

class ProductsNotifier extends StateNotifier<List<ProductModel>> {
  final ProductRepository _repository;
  
  ProductsNotifier(this._repository) : super(_repository.getAllProducts());
  
  Future<void> refresh() async {
    state = _repository.getAllProducts();
  }
  
  Future<void> addProduct(ProductModel product) async {
    await _repository.saveProduct(product);
    state = _repository.getAllProducts();
  }
  
  Future<void> updateProduct(ProductModel product) async {
    await _repository.updateProduct(product);
    state = _repository.getAllProducts();
  }
  
  Future<void> deleteProduct(String id) async {
    await _repository.deleteProduct(id);
    state = _repository.getAllProducts();
  }
  
  List<ProductModel> searchProducts(String query) {
    return _repository.searchProducts(query);
  }
}

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepository _repository;
  
  TransactionsNotifier(this._repository) : super(_repository.getAllTransactions());
  
  Future<void> refresh() async {
    state = _repository.getAllTransactions();
  }
  
  Future<void> addTransaction(TransactionModel transaction) async {
    await _repository.saveTransaction(transaction);
    state = _repository.getAllTransactions();
  }
  
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.updateTransaction(transaction);
    state = _repository.getAllTransactions();
  }
  
  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getAllTransactions();
  }
  
  List<TransactionModel> getTransactionsByType(String type) {
    return _repository.getTransactionsByType(type);
  }
}

class PaymentsNotifier extends StateNotifier<List<PaymentModel>> {
  final PaymentRepository _repository;
  
  PaymentsNotifier(this._repository) : super(_repository.getAllPayments());
  
  Future<void> refresh() async {
    state = _repository.getAllPayments();
  }
  
  Future<void> addPayment(PaymentModel payment) async {
    await _repository.savePayment(payment);
    state = _repository.getAllPayments();
  }
  
  Future<void> updatePayment(PaymentModel payment) async {
    await _repository.updatePayment(payment);
    state = _repository.getAllPayments();
  }
  
  Future<void> deletePayment(String id) async {
    await _repository.deletePayment(id);
    state = _repository.getAllPayments();
  }
}

/// Company Provider
final companyProvider = StateNotifierProvider<CompanyNotifier, CompanyModel?>((ref) {
  final box = ref.watch(companyBoxProvider);
  return CompanyNotifier(box);
});

class CompanyNotifier extends StateNotifier<CompanyModel?> {
  final Box<CompanyModel> _box;
  
  CompanyNotifier(this._box) : super(_getCompany());
  
  static CompanyModel? _getCompany() {
    final box = Hive.box<CompanyModel>(AppConstants.BOX_COMPANY);
    return box.isNotEmpty ? box.getAt(0) : null;
  }
  
  Future<void> createCompany(CompanyModel company) async {
    if (_box.isNotEmpty) {
      await _box.deleteAt(0);
    }
    await _box.add(company);
    state = company;
  }
  
  Future<void> updateCompany(CompanyModel company) async {
    if (_box.isNotEmpty) {
      await _box.putAt(0, company);
    } else {
      await _box.add(company);
    }
    state = company;
  }
  
  Future<void> deleteCompany() async {
    if (_box.isNotEmpty) {
      await _box.deleteAt(0);
    }
    state = null;
  }
}

/// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, Map<String, dynamic>>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsNotifier(box);
});

class SettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  final Box _box;
  
  SettingsNotifier(this._box) : super(_box.toMap());
  
  Future<void> setSetting(String key, dynamic value) async {
    await _box.put(key, value);
    state = _box.toMap();
  }
  
  Future<void> removeSetting(String key) async {
    await _box.delete(key);
    state = _box.toMap();
  }
  
  Future<void> clearSettings() async {
    await _box.clear();
    state = {};
  }
}

/// Summary Providers
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final contacts = ref.watch(contactsProvider);
  final products = ref.watch(productsProvider);
  final transactions = ref.watch(transactionsProvider);
  final payments = ref.watch(paymentsProvider);
  
  return DashboardSummary(
    totalContacts: contacts.length,
    totalProducts: products.length,
    totalTransactions: transactions.length,
    totalPayments: payments.length,
    totalReceivables: ref.read(contactRepositoryProvider).getTotalReceivables(),
    totalPayables: ref.read(contactRepositoryProvider).getTotalPayables(),
    totalSales: ref.read(transactionRepositoryProvider).getTotalSalesAmount(),
    totalPurchases: ref.read(transactionRepositoryProvider).getTotalPurchaseAmount(),
    totalOutstanding: ref.read(transactionRepositoryProvider).getTotalOutstandingReceivables(),
    totalCash: ref.read(paymentRepositoryProvider).getCashPayments(),
    lowStockProducts: ref.read(productRepositoryProvider).getLowStockProducts().length,
    overdueTransactions: ref.read(transactionRepositoryProvider).getOverdueTransactions().length,
  );
});

class DashboardSummary {
  final int totalContacts;
  final int totalProducts;
  final int totalTransactions;
  final int totalPayments;
  final double totalReceivables;
  final double totalPayables;
  final double totalSales;
  final double totalPurchases;
  final double totalOutstanding;
  final double totalCash;
  final int lowStockProducts;
  final int overdueTransactions;
  
  DashboardSummary({
    required this.totalContacts,
    required this.totalProducts,
    required this.totalTransactions,
    required this.totalPayments,
    required this.totalReceivables,
    required this.totalPayables,
    required this.totalSales,
    required this.totalPurchases,
    required this.totalOutstanding,
    required this.totalCash,
    required this.lowStockProducts,
    required this.overdueTransactions,
  });
  
  double get profit => totalSales - totalPurchases;
  double get netBalance => totalReceivables - totalPayables;
}
