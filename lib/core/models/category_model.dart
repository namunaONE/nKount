import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Category Model for product categorization
@freezed
@HiveType(typeId: 7, adapterName: 'CategoryModelAdapter')
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) String? parentId,
    @HiveField(4) @Default(0) int level,
    @HiveField(5) @Default('') String path,
    @HiveField(6) @Default(0) int sortOrder,
    @HiveField(7) @Default(true) bool isActive,
    @HiveField(8) @Default(0) int productCount,
    @HiveField(9) DateTime? createdAt,
    @HiveField(10) DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Create a new category
  factory CategoryModel.create({
    required String name,
    String? description,
    String? parentId,
    int? level,
    String? path,
    int? sortOrder,
    bool isActive = true,
  }) {
    final parentCategory = parentId != null ? ' > ' : '';
    final calculatedLevel = level ?? (parentId != null ? 1 : 0);
    final calculatedPath = path ?? (parentId != null ? '$parentId/' : '');
    
    return CategoryModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      parentId: parentId,
      level: calculatedLevel,
      path: calculatedPath,
      sortOrder: sortOrder ?? 0,
      isActive: isActive,
      productCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update product count
  CategoryModel copyWithProductCount(int count) {
    return copyWith(
      productCount: count,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if category is root level
  bool get isRoot => parentId == null || parentId.isEmpty;

  /// Get full path display
  String get fullPath => isRoot ? name : '$name ($path)';

  /// Get display name with hierarchy
  String get displayName => isRoot ? name : '  ' * level + name;
}
