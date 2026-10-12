import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../models/transaction_model.dart';

/// Repository for managing transactions
class TransactionRepository {
  TransactionRepository(this._transactionsBox);
  final Box<TransactionModel> _transactionsBox;

  /// Get all transactions
  List<TransactionModel> getAllTransactions() =>
      _transactionsBox.values.toList();

  /// Get transaction by ID
  TransactionModel? getTransactionById(String id) => _transactionsBox.get(id);

  /// Get transactions by type
  List<TransactionModel> getTransactionsByType(String type) =>
      _transactionsBox.values
          .where((transaction) => transaction.type == type)
          .toList();

  /// Get transactions by contact
  List<TransactionModel> getTransactionsByContact(String contactId) =>
      _transactionsBox.values
          .where((transaction) => transaction.contactId == contactId)
          .toList();

  /// Get transactions by date range
  List<TransactionModel> getTransactionsByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final transactions = _transactionsBox.values.toList();

    if (startDate != null && endDate != null) {
      return transactions
          .where((transaction) =>
              transaction.date != null &&
              transaction.date!
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              transaction.date!.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    } else if (startDate != null) {
      return transactions
          .where((transaction) =>
              transaction.date != null &&
              transaction.date!
                  .isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    } else if (endDate != null) {
      return transactions
          .where((transaction) =>
              transaction.date != null &&
              transaction.date!.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    return transactions;
  }

  /// Get transactions by payment status
  List<TransactionModel> getTransactionsByPaymentStatus(String status) =>
      _transactionsBox.values
          .where((transaction) => transaction.paymentStatus == status)
          .toList();

  /// Get overdue transactions
  List<TransactionModel> getOverdueTransactions() => _transactionsBox.values
      .where((transaction) => transaction.isOverdue)
      .toList();

  /// Save transaction
  Future<TransactionModel> saveTransaction(TransactionModel transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
    return transaction;
  }

  /// Update transaction
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
    return transaction;
  }

  /// Delete transaction
  Future<bool> deleteTransaction(String id) async {
    final transaction = _transactionsBox.get(id);
    if (transaction != null) {
      await _transactionsBox.delete(id);
      return true;
    }
    return false;
  }

  /// Delete all transactions
  Future<void> deleteAllTransactions() async {
    await _transactionsBox.clear();
  }

  /// Get transactions count
  int getTransactionsCount() => _transactionsBox.length;

  /// Get total sales amount
  double getTotalSalesAmount() => _transactionsBox.values
      .where((transaction) =>
          transaction.type == AppConstants.TRANSACTION_SALE &&
          !transaction.isCancelled)
      .fold(0.0, (sum, transaction) => sum + transaction.total);

  /// Get total purchase amount
  double getTotalPurchaseAmount() => _transactionsBox.values
      .where((transaction) =>
          transaction.type == AppConstants.TRANSACTION_PURCHASE &&
          !transaction.isCancelled)
      .fold(0.0, (sum, transaction) => sum + transaction.total);

  /// Get total outstanding amount (receivables)
  double getTotalOutstandingReceivables() => _transactionsBox.values
      .where((transaction) =>
          transaction.type == AppConstants.TRANSACTION_SALE &&
          !transaction.isCancelled &&
          transaction.dueAmount > 0)
      .fold(0.0, (sum, transaction) => sum + transaction.dueAmount);

  /// Get total outstanding amount (payables)
  double getTotalOutstandingPayables() => _transactionsBox.values
      .where((transaction) =>
          transaction.type == AppConstants.TRANSACTION_PURCHASE &&
          !transaction.isCancelled &&
          transaction.dueAmount > 0)
      .fold(0.0, (sum, transaction) => sum + transaction.dueAmount);

  /// Get today's transactions
  List<TransactionModel> getTodaysTransactions() {
    final today = DateTime.now();
    return _transactionsBox.values
        .where((transaction) =>
            transaction.date != null &&
            transaction.date!.year == today.year &&
            transaction.date!.month == today.month &&
            transaction.date!.day == today.day)
        .toList();
  }

  /// Get this month's transactions
  List<TransactionModel> getThisMonthTransactions() {
    final now = DateTime.now();
    return _transactionsBox.values
        .where((transaction) =>
            transaction.date != null &&
            transaction.date!.year == now.year &&
            transaction.date!.month == now.month)
        .toList();
  }

  /// Get this year's transactions
  List<TransactionModel> getThisYearTransactions() {
    final now = DateTime.now();
    return _transactionsBox.values
        .where((transaction) =>
            transaction.date != null && transaction.date!.year == now.year)
        .toList();
  }

  /// Export transactions to list
  List<Map<String, dynamic>> exportTransactions() => _transactionsBox.values
      .map((transaction) => transaction.toJson())
      .toList();

  /// Import transactions from list
  Future<int> importTransactions(
      List<Map<String, dynamic>> transactionsData) async {
    var count = 0;
    for (final data in transactionsData) {
      try {
        final transaction = TransactionModel.fromJson(data);
        await _transactionsBox.put(transaction.id, transaction);
        count++;
      } on Exception catch (_) {
        // Skip invalid transactions
        continue;
      }
    }
    return count;
  }
}
