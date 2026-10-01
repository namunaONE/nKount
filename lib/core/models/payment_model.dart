import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment Model for tracking payments and receipts
@freezed
@HiveType(typeId: 5, adapterName: 'PaymentModelAdapter')
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String type, // payment or receipt
    @HiveField(2) required String transactionId,
    @HiveField(3) String? invoiceNumber,
    @HiveField(4) required String contactId,
    @HiveField(5) @Default(0.0) double amount,
    @HiveField(6) required String method,
    @HiveField(7) String? referenceNumber,
    @HiveField(8) String? bankName,
    @HiveField(9) String? chequeNumber,
    @HiveField(10) DateTime? chequeDate,
    @HiveField(11) DateTime? date,
    @HiveField(12) String? notes,
    @HiveField(13) @Default(false) bool isCleared,
    @HiveField(14) DateTime? clearedDate,
    @HiveField(15) String? createdBy,
    @HiveField(16) DateTime? createdAt,
    @HiveField(17) DateTime? updatedAt,
    @HiveField(18) @Default(false) bool isCancelled,
    @HiveField(19) String? cancellationReason,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  /// Create a new payment
  factory PaymentModel.create({
    required String type,
    required String transactionId,
    String? invoiceNumber,
    required String contactId,
    required double amount,
    required String method,
    String? referenceNumber,
    String? bankName,
    String? chequeNumber,
    DateTime? chequeDate,
    DateTime? date,
    String? notes,
    String? createdBy,
  }) {
    return PaymentModel(
      id: const Uuid().v4(),
      type: type,
      transactionId: transactionId,
      invoiceNumber: invoiceNumber,
      contactId: contactId,
      amount: amount,
      method: method,
      referenceNumber: referenceNumber,
      bankName: bankName,
      chequeNumber: chequeNumber,
      chequeDate: chequeDate,
      date: date ?? DateTime.now(),
      notes: notes,
      isCleared: method != AppConstants.PAYMENT_CHEQUE,
      clearedDate: method != AppConstants.PAYMENT_CHEQUE ? DateTime.now() : null,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Clear payment (for cheque clearance)
  PaymentModel copyWithCleared() {
    return copyWith(
      isCleared: true,
      clearedDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Cancel payment
  PaymentModel copyWithCancellation(String reason) {
    return copyWith(
      isCancelled: true,
      cancellationReason: reason,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if payment is cleared
  bool get isClearedPayment => isCleared && !isCancelled;

  /// Check if payment is pending clearance
  bool get isPendingClearance => method == AppConstants.PAYMENT_CHEQUE && !isCleared && !isCancelled;

  /// Get payment type display name
  String get typeDisplayName {
    switch (type) {
      case 'payment':
        return 'Payment';
      case 'receipt':
        return 'Receipt';
      default:
        return 'Unknown';
    }
  }

  /// Get payment method display name
  String get methodDisplayName {
    switch (method) {
      case AppConstants.PAYMENT_CASH:
        return 'Cash';
      case AppConstants.PAYMENT_BANK:
        return 'Bank Transfer';
      case AppConstants.PAYMENT_CHEQUE:
        return 'Cheque';
      case AppConstants.PAYMENT_ONLINE:
        return 'Online Payment';
      case AppConstants.PAYMENT_CREDIT:
        return 'Credit';
      default:
        return 'Unknown';
    }
  }

  /// Get reference display
  String get referenceDisplay {
    if (method == AppConstants.PAYMENT_CHEQUE && chequeNumber != null) {
      return 'Cheque #$chequeNumber';
    } else if (referenceNumber != null && referenceNumber!.isNotEmpty) {
      return referenceNumber!;
    } else if (bankName != null && bankName!.isNotEmpty) {
      return bankName!;
    }
    return 'N/A';
  }
}

/// Payment Summary Model for reporting
@freezed
@HiveType(typeId: 6, adapterName: 'PaymentSummaryAdapter')
class PaymentSummary with _$PaymentSummary {
  const factory PaymentSummary({
    @HiveField(0) String? contactId,
    @HiveField(1) String? contactName,
    @HiveField(2) @Default(0.0) double totalPaid,
    @HiveField(3) @Default(0.0) double totalReceived,
    @HiveField(4) @Default(0.0) double balance,
    @HiveField(5) @Default(0) int paymentCount,
    @HiveField(6) @Default(0) int receiptCount,
    @HiveField(7) DateTime? lastTransactionDate,
  }) = _PaymentSummary;

  factory PaymentSummary.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryFromJson(json);
}
