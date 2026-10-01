import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Transaction Model for Purchases, Sales, and other transactions
@freezed
@HiveType(typeId: 3, adapterName: 'TransactionModelAdapter')
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String type,
    @HiveField(2) String? invoiceNumber,
    @HiveField(3) required String contactId,
    @HiveField(4) List<TransactionItem>? items,
    @HiveField(5) @Default(0.0) double subtotal,
    @HiveField(6) @Default(0.0) double discount,
    @HiveField(7) @Default(0.0) double tax,
    @HiveField(8) @Default(0.0) double total,
    @HiveField(9) @Default(0.0) double paidAmount,
    @HiveField(10) @Default(0.0) double dueAmount,
    @HiveField(11) @Default(AppConstants.PAYMENT_STATUS_PENDING) String paymentStatus,
    @HiveField(12) String? paymentMethod,
    @HiveField(13) String? referenceNumber,
    @HiveField(14) DateTime? date,
    @HiveField(15) DateTime? dueDate,
    @HiveField(16) String? notes,
    @HiveField(17) @Default(false) bool isVatIncluded,
    @HiveField(18) @Default(13.0) double vatRate,
    @HiveField(19) String? createdBy,
    @HiveField(20) DateTime? createdAt,
    @HiveField(21) DateTime? updatedAt,
    @HiveField(22) @Default(false) bool isCancelled,
    @HiveField(23) String? cancellationReason,
    @HiveField(24) @Default(false) bool isSynced,
    @HiveField(25) String? syncId,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Create a new transaction
  factory TransactionModel.create({
    required String type,
    String? invoiceNumber,
    required String contactId,
    List<TransactionItem>? items,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    double? paidAmount,
    String paymentStatus = AppConstants.PAYMENT_STATUS_PENDING,
    String? paymentMethod,
    String? referenceNumber,
    DateTime? date,
    DateTime? dueDate,
    String? notes,
    bool isVatIncluded = true,
    double vatRate = 13.0,
    String? createdBy,
  }) {
    final now = DateTime.now();
    final calculatedItems = items ?? [];
    final calculatedSubtotal = subtotal ?? calculatedItems.fold(0.0, (sum, item) => sum + item.amount);
    final calculatedDiscount = discount ?? 0.0;
    final calculatedTax = tax ?? (isVatIncluded ? (calculatedSubtotal - calculatedDiscount) * vatRate / 100 : 0.0);
    final calculatedTotal = total ?? (calculatedSubtotal - calculatedDiscount + calculatedTax);
    final calculatedPaid = paidAmount ?? 0.0;
    final calculatedDue = calculatedTotal - calculatedPaid;

    return TransactionModel(
      id: const Uuid().v4(),
      type: type,
      invoiceNumber: invoiceNumber ?? _generateInvoiceNumber(type),
      contactId: contactId,
      items: calculatedItems,
      subtotal: calculatedSubtotal,
      discount: calculatedDiscount,
      tax: calculatedTax,
      total: calculatedTotal,
      paidAmount: calculatedPaid,
      dueAmount: calculatedDue,
      paymentStatus: calculatedDue <= 0 ? AppConstants.PAYMENT_STATUS_PAID : paymentStatus,
      paymentMethod: paymentMethod,
      referenceNumber: referenceNumber,
      date: date ?? now,
      dueDate: dueDate,
      notes: notes,
      isVatIncluded: isVatIncluded,
      vatRate: vatRate,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Generate invoice number
  static String _generateInvoiceNumber(String type) {
    final prefix = type == AppConstants.TRANSACTION_PURCHASE ? 'PUR' : 'INV';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(4);
    return '$prefix-$timestamp';
  }

  /// Update payment status
  TransactionModel copyWithPayment({
    required double amount,
    required String paymentMethod,
    String? referenceNumber,
  }) {
    final newPaid = paidAmount + amount;
    final newDue = total - newPaid;
    final newStatus = newDue <= 0 
        ? AppConstants.PAYMENT_STATUS_PAID
        : (newDue < total 
            ? AppConstants.PAYMENT_STATUS_PARTIAL
            : AppConstants.PAYMENT_STATUS_PENDING);

    return copyWith(
      paidAmount: newPaid,
      dueAmount: newDue,
      paymentStatus: newStatus,
      paymentMethod: paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      updatedAt: DateTime.now(),
    );
  }

  /// Cancel transaction
  TransactionModel copyWithCancellation(String reason) {
    return copyWith(
      isCancelled: true,
      cancellationReason: reason,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if transaction is overdue
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && dueAmount > 0;

  /// Check if transaction is fully paid
  bool get isFullyPaid => paymentStatus == AppConstants.PAYMENT_STATUS_PAID;

  /// Check if transaction is partially paid
  bool get isPartiallyPaid => paymentStatus == AppConstants.PAYMENT_STATUS_PARTIAL;

  /// Check if transaction is pending
  bool get isPending => paymentStatus == AppConstants.PAYMENT_STATUS_PENDING;

  /// Get transaction type display name
  String get typeDisplayName {
    switch (type) {
      case AppConstants.TRANSACTION_PURCHASE:
        return 'Purchase';
      case AppConstants.TRANSACTION_SALE:
        return 'Sale';
      case AppConstants.TRANSACTION_EXPENSE:
        return 'Expense';
      case AppConstants.TRANSACTION_INCOME:
        return 'Income';
      default:
        return 'Unknown';
    }
  }
}

/// Transaction Item Model
@freezed
@HiveType(typeId: 4, adapterName: 'TransactionItemAdapter')
class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String productId,
    @HiveField(2) required String productName,
    @HiveField(3) @Default(0.0) double quantity,
    @HiveField(4) @Default(0.0) double unitPrice,
    @HiveField(5) @Default(0.0) double discount,
    @HiveField(6) @Default(0.0) double tax,
    @HiveField(7) @Default(0.0) double amount,
    @HiveField(8) String? unit,
    @HiveField(9) String? description,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  /// Create a new transaction item
  factory TransactionItem.create({
    required String productId,
    required String productName,
    required double quantity,
    required double unitPrice,
    double? discount,
    double? tax,
    String? unit,
    String? description,
  }) {
    final calculatedDiscount = discount ?? 0.0;
    final calculatedTax = tax ?? 0.0;
    final calculatedAmount = (unitPrice * quantity) - calculatedDiscount + calculatedTax;

    return TransactionItem(
      id: const Uuid().v4(),
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      discount: calculatedDiscount,
      tax: calculatedTax,
      amount: calculatedAmount,
      unit: unit,
      description: description,
    );
  }

  /// Get amount with tax
  double get amountWithTax => amount + tax;
}
