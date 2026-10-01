import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/payment_model.dart';

/// Repository for managing payments
class PaymentRepository {
  final Box<PaymentModel> _paymentsBox;

  PaymentRepository(this._paymentsBox);

  /// Get all payments
  List<PaymentModel> getAllPayments() {
    return _paymentsBox.values.toList();
  }

  /// Get payment by ID
  PaymentModel? getPaymentById(String id) {
    return _paymentsBox.get(id);
  }

  /// Get payments by transaction
  List<PaymentModel> getPaymentsByTransaction(String transactionId) {
    return _paymentsBox.values
        .where((payment) => payment.transactionId == transactionId)
        .toList();
  }

  /// Get payments by contact
  List<PaymentModel> getPaymentsByContact(String contactId) {
    return _paymentsBox.values
        .where((payment) => payment.contactId == contactId)
        .toList();
  }

  /// Get payments by type
  List<PaymentModel> getPaymentsByType(String type) {
    return _paymentsBox.values
        .where((payment) => payment.type == type)
        .toList();
  }

  /// Get payments by method
  List<PaymentModel> getPaymentsByMethod(String method) {
    return _paymentsBox.values
        .where((payment) => payment.method == method)
        .toList();
  }

  /// Get payments by date range
  List<PaymentModel> getPaymentsByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final payments = _paymentsBox.values.toList();
    
    if (startDate != null && endDate != null) {
      return payments
          .where((payment) => 
            payment.date != null &&
            payment.date!.isAfter(startDate.subtract(const Duration(days: 1))) &&
            payment.date!.isBefore(endDate.add(const Duration(days: 1)))
          )
          .toList();
    } else if (startDate != null) {
      return payments
          .where((payment) => 
            payment.date != null &&
            payment.date!.isAfter(startDate.subtract(const Duration(days: 1)))
          )
          .toList();
    } else if (endDate != null) {
      return payments
          .where((payment) => 
            payment.date != null &&
            payment.date!.isBefore(endDate.add(const Duration(days: 1)))
          )
          .toList();
    }
    
    return payments;
  }

  /// Get uncleared payments (cheques)
  List<PaymentModel> getUnclearedPayments() {
    return _paymentsBox.values
        .where((payment) => payment.isPendingClearance)
        .toList();
  }

  /// Save payment
  Future<PaymentModel> savePayment(PaymentModel payment) async {
    await _paymentsBox.put(payment.id, payment);
    return payment;
  }

  /// Update payment
  Future<PaymentModel> updatePayment(PaymentModel payment) async {
    await _paymentsBox.put(payment.id, payment);
    return payment;
  }

  /// Delete payment
  Future<bool> deletePayment(String id) async {
    final payment = _paymentsBox.get(id);
    if (payment != null) {
      await _paymentsBox.delete(id);
      return true;
    }
    return false;
  }

  /// Delete all payments
  Future<void> deleteAllPayments() async {
    await _paymentsBox.clear();
  }

  /// Get payments count
  int getPaymentsCount() {
    return _paymentsBox.length;
  }

  /// Get total payments received
  double getTotalPaymentsReceived() {
    return _paymentsBox.values
        .where((payment) => 
          payment.type == 'receipt' &&
          !payment.isCancelled &&
          payment.isClearedPayment
        )
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get total payments made
  double getTotalPaymentsMade() {
    return _paymentsBox.values
        .where((payment) => 
          payment.type == 'payment' &&
          !payment.isCancelled &&
          payment.isClearedPayment
        )
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get cash payments
  double getCashPayments() {
    return _paymentsBox.values
        .where((payment) => 
          payment.method == AppConstants.PAYMENT_CASH &&
          !payment.isCancelled &&
          payment.isClearedPayment
        )
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get bank payments
  double getBankPayments() {
    return _paymentsBox.values
        .where((payment) => 
          payment.method == AppConstants.PAYMENT_BANK &&
          !payment.isCancelled &&
          payment.isClearedPayment
        )
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get today's payments
  List<PaymentModel> getTodaysPayments() {
    final today = DateTime.now();
    return _paymentsBox.values
        .where((payment) => 
          payment.date != null &&
          payment.date!.year == today.year &&
          payment.date!.month == today.month &&
          payment.date!.day == today.day
        )
        .toList();
  }

  /// Export payments to list
  List<Map<String, dynamic>> exportPayments() {
    return _paymentsBox.values
        .map((payment) => payment.toJson())
        .toList();
  }

  /// Import payments from list
  Future<int> importPayments(List<Map<String, dynamic>> paymentsData) async {
    int count = 0;
    for (final data in paymentsData) {
      try {
        final payment = PaymentModel.fromJson(data);
        await _paymentsBox.put(payment.id, payment);
        count++;
      } catch (e) {
        // Skip invalid payments
        continue;
      }
    }
    return count;
  }
}
