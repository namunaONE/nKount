import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction_item_model.freezed.dart';
part 'transaction_item_model.g.dart';

/// Transaction Item Model for line items in transactions
@freezed
@HiveType(typeId: 3, adapterName: 'TransactionItemModelAdapter')
class TransactionItemModel with _$TransactionItemModel {
  const factory TransactionItemModel({
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
    @HiveField(10) DateTime? createdAt,
    @HiveField(11) DateTime? updatedAt,
  }) = _TransactionItemModel;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemModelFromJson(json);

  /// Create a new transaction item
  factory TransactionItemModel.create({
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

    return TransactionItemModel(
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
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get amount with tax
  double get amountWithTax => amount + tax;

  /// Get net amount (amount - discount)
  double get netAmount => amount - discount;

  /// Check if item has tax
  bool get hasTax => tax > 0;

  /// Check if item has discount
  bool get hasDiscount => discount > 0;
}
