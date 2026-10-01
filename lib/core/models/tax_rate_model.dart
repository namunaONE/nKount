import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'tax_rate_model.freezed.dart';
part 'tax_rate_model.g.dart';

/// Tax Rate Model for different tax types
@freezed
@HiveType(typeId: 10, adapterName: 'TaxRateModelAdapter')
class TaxRateModel with _$TaxRateModel {
  const factory TaxRateModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) required String code,
    @HiveField(3) @Default(0.0) double rate,
    @HiveField(4) String? description,
    @HiveField(5) @Default('percentage') String type,
    @HiveField(6) @Default(true) bool isActive,
    @HiveField(7) @Default(false) bool isDefault,
    @HiveField(8) @Default(false) bool isVat,
    @HiveField(9) @Default(false) bool isCompound,
    @HiveField(10) DateTime? effectiveFrom,
    @HiveField(11) DateTime? effectiveTo,
    @HiveField(12) DateTime? createdAt,
    @HiveField(13) DateTime? updatedAt,
  }) = _TaxRateModel;

  factory TaxRateModel.fromJson(Map<String, dynamic> json) =>
      _$TaxRateModelFromJson(json);

  /// Create a new tax rate
  factory TaxRateModel.create({
    required String name,
    required String code,
    required double rate,
    String? description,
    String type = 'percentage',
    bool isActive = true,
    bool isDefault = false,
    bool isVat = false,
    bool isCompound = false,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
  }) {
    return TaxRateModel(
      id: const Uuid().v4(),
      name: name,
      code: code.toUpperCase(),
      rate: rate,
      description: description,
      type: type,
      isActive: isActive,
      isDefault: isDefault,
      isVat: isVat,
      isCompound: isCompound,
      effectiveFrom: effectiveFrom ?? DateTime.now(),
      effectiveTo: effectiveTo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create default VAT rate for Nepal (13%)
  factory TaxRateModel.createVatRate() {
    return TaxRateModel(
      id: const Uuid().v4(),
      name: 'VAT (13%)',
      code: 'VAT',
      rate: 13.0,
      description: 'Value Added Tax - Nepal Standard Rate',
      type: 'percentage',
      isActive: true,
      isDefault: true,
      isVat: true,
      isCompound: false,
      effectiveFrom: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Calculate tax amount
  double calculateTax(double amount) {
    return type == 'percentage' ? amount * rate / 100 : rate;
  }

  /// Get display name with rate
  String get displayName => isVat ? '$name (${rate}%)' : name;

  /// Check if tax rate is currently effective
  bool get isEffective {
    final now = DateTime.now();
    if (effectiveFrom != null && effectiveFrom!.isAfter(now)) return false;
    if (effectiveTo != null && effectiveTo!.isBefore(now)) return false;
    return isActive;
  }

  /// Get tax type display name
  String get typeDisplayName {
    switch (type) {
      case 'percentage':
        return 'Percentage';
      case 'fixed':
        return 'Fixed Amount';
      case 'compound':
        return 'Compound';
      default:
        return 'Unknown';
    }
  }
}
