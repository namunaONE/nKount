import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

/// Unit Model for units of measurement
@freezed
@HiveType(typeId: 9, adapterName: 'UnitModelAdapter')
class UnitModel with _$UnitModel {
  const factory UnitModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) required String code,
    @HiveField(3) String? description,
    @HiveField(4) @Default(1.0) double baseUnitMultiplier,
    @HiveField(5) @Default('') String baseUnitId,
    @HiveField(6) @Default(true) bool isActive,
    @HiveField(7) @Default(false) bool isBaseUnit,
    @HiveField(8) @Default(0) int sortOrder,
    @HiveField(9) DateTime? createdAt,
    @HiveField(10) DateTime? updatedAt,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  /// Create a new unit
  factory UnitModel.create({
    required String name,
    required String code,
    String? description,
    double baseUnitMultiplier = 1.0,
    String? baseUnitId,
    bool isActive = true,
    bool isBaseUnit = false,
    int? sortOrder,
  }) {
    return UnitModel(
      id: const Uuid().v4(),
      name: name,
      code: code.toUpperCase(),
      description: description,
      baseUnitMultiplier: baseUnitMultiplier,
      baseUnitId: baseUnitId,
      isActive: isActive,
      isBaseUnit: isBaseUnit,
      sortOrder: sortOrder ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create base unit
  factory UnitModel.createBaseUnit({
    required String name,
    required String code,
    String? description,
  }) {
    return UnitModel(
      id: const Uuid().v4(),
      name: name,
      code: code.toUpperCase(),
      description: description,
      baseUnitMultiplier: 1.0,
      baseUnitId: '',
      isActive: true,
      isBaseUnit: true,
      sortOrder: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if unit can be converted to another unit
  bool canConvertTo(UnitModel other) {
    if (!isActive || !other.isActive) return false;
    if (isBaseUnit && other.isBaseUnit) return id == other.id;
    if (isBaseUnit) return baseUnitId == other.id;
    if (other.isBaseUnit) return id == other.baseUnitId;
    return baseUnitId == other.baseUnitId;
  }

  /// Get display name with code
  String get displayName => '$name ($code)';

  /// Get full display name
  String get fullDisplayName => 
    isBaseUnit ? displayName : '$displayName = ${baseUnitMultiplier}x $baseUnitId';
}
