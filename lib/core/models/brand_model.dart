import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

/// Brand Model for product brands/manufacturers
@freezed
@HiveType(typeId: 8, adapterName: 'BrandModelAdapter')
class BrandModel with _$BrandModel {
  const factory BrandModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) String? logoPath,
    @HiveField(4) String? website,
    @HiveField(5) String? contactPhone,
    @HiveField(6) String? contactEmail,
    @HiveField(7) @Default(true) bool isActive,
    @HiveField(8) @Default(0) int productCount,
    @HiveField(9) DateTime? createdAt,
    @HiveField(10) DateTime? updatedAt,
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  /// Create a new brand
  factory BrandModel.create({
    required String name,
    String? description,
    String? logoPath,
    String? website,
    String? contactPhone,
    String? contactEmail,
    bool isActive = true,
  }) {
    return BrandModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      logoPath: logoPath,
      website: website,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      isActive: isActive,
      productCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update product count
  BrandModel copyWithProductCount(int count) {
    return copyWith(
      productCount: count,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if brand has contact information
  bool get hasContactInfo => 
    contactPhone != null && contactPhone!.isNotEmpty ||
    contactEmail != null && contactEmail!.isNotEmpty;

  /// Get display name with product count
  String get displayNameWithCount => productCount > 0 ? '$name ($productCount)' : name;
}
