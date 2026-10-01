import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Product Model for Inventory
@freezed
@HiveType(typeId: 2, adapterName: 'ProductModelAdapter')
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) String? code,
    @HiveField(3) String? barcode,
    @HiveField(4) String? category,
    @HiveField(5) String? brand,
    @HiveField(6) String? unit,
    @HiveField(7) @Default(0.0) double purchasePrice,
    @HiveField(8) @Default(0.0) double salePrice,
    @HiveField(9) @Default(0.0) double costPrice,
    @HiveField(10) @Default(0.0) double quantity,
    @HiveField(11) @Default(0.0) double minQuantity,
    @HiveField(12) @Default(false) bool isTaxable,
    @HiveField(13) @Default(13.0) double taxRate,
    @HiveField(14) String? description,
    @HiveField(15) String? supplierId,
    @HiveField(16) @Default(true) bool isActive,
    @HiveField(17) String? imageUrl,
    @HiveField(18) @Default(0.0) double totalPurchased,
    @HiveField(19) @Default(0.0) double totalSold,
    @HiveField(20) DateTime? createdAt,
    @HiveField(21) DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Create a new product with auto-generated ID
  factory ProductModel.create({
    required String name,
    String? code,
    String? barcode,
    String? category,
    String? brand,
    String? unit,
    required double purchasePrice,
    required double salePrice,
    double? costPrice,
    double? quantity,
    double? minQuantity,
    bool isTaxable = true,
    double taxRate = 13.0,
    String? description,
    String? supplierId,
    bool isActive = true,
    String? imageUrl,
  }) {
    return ProductModel(
      id: const Uuid().v4(),
      name: name,
      code: code ?? _generateProductCode(name),
      barcode: barcode,
      category: category,
      brand: brand,
      unit: unit ?? 'Unit',
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      costPrice: costPrice ?? purchasePrice,
      quantity: quantity ?? 0.0,
      minQuantity: minQuantity ?? 0.0,
      isTaxable: isTaxable,
      taxRate: taxRate,
      description: description,
      supplierId: supplierId,
      isActive: isActive,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generate product code from name
  static String _generateProductCode(String name) {
    return name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase()
        .substring(0, 4);
  }

  /// Update product quantity
  ProductModel copyWithQuantity(double newQuantity) {
    return copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    );
  }

  /// Update product with purchase
  ProductModel copyWithPurchase(double quantity, double price) {
    return copyWith(
      quantity: this.quantity + quantity,
      purchasePrice: price,
      totalPurchased: totalPurchased + (quantity * price),
      updatedAt: DateTime.now(),
    );
  }

  /// Update product with sale
  ProductModel copyWithSale(double quantity, double price) {
    return copyWith(
      quantity: this.quantity - quantity,
      salePrice: price,
      totalSold: totalSold + (quantity * price),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if product is in stock
  bool get inStock => quantity > 0;

  /// Check if product is below minimum quantity
  bool get belowMinimum => quantity < minQuantity;

  /// Get tax amount for sale
  double get taxAmount => isTaxable ? (salePrice * taxRate / 100) : 0;

  /// Get sale price with tax
  double get salePriceWithTax => salePrice + taxAmount;

  /// Get profit per unit
  double get profitPerUnit => salePrice - costPrice;

  /// Get profit margin percentage
  double get profitMargin => costPrice > 0 ? ((salePrice - costPrice) / costPrice * 100) : 0;
}
