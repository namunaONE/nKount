import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

/// Audit Log Model for tracking changes to entities
@freezed
@HiveType(typeId: 13, adapterName: 'AuditLogModelAdapter')
class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String entityType,
    @HiveField(2) required String entityId,
    @HiveField(3) required String action,
    @HiveField(4) Map<String, dynamic>? oldValues,
    @HiveField(5) Map<String, dynamic>? newValues,
    @HiveField(6) String? description,
    @HiveField(7) String? companyId,
    @HiveField(8) String? userId,
    @HiveField(9) String? userName,
    @HiveField(10) String? ipAddress,
    @HiveField(11) String? userAgent,
    @HiveField(12) @Default(false) bool isSystemAction,
    @HiveField(13) @Default(false) bool isReversed,
    @HiveField(14) String? reversedBy,
    @HiveField(15) DateTime? reversedAt,
    @HiveField(16) DateTime? createdAt,
    @HiveField(17) DateTime? updatedAt,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  /// Create a new audit log
  factory AuditLogModel.create({
    required String entityType,
    required String entityId,
    required String action,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
    String? description,
    String? companyId,
    String? userId,
    String? userName,
    String? ipAddress,
    String? userAgent,
    bool isSystemAction = false,
  }) {
    return AuditLogModel(
      id: const Uuid().v4(),
      entityType: entityType,
      entityId: entityId,
      action: action,
      oldValues: oldValues,
      newValues: newValues,
      description: description,
      companyId: companyId,
      userId: userId,
      userName: userName,
      ipAddress: ipAddress,
      userAgent: userAgent,
      isSystemAction: isSystemAction,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Reverse an audit log (for undo operations)
  AuditLogModel copyWithReversal(String reversedBy) {
    return copyWith(
      isReversed: true,
      reversedBy: reversedBy,
      reversedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if audit log has changes
  bool get hasChanges => 
    (oldValues != null && oldValues!.isNotEmpty) ||
    (newValues != null && newValues!.isNotEmpty);

  /// Get changed fields
  List<String> get changedFields {
    if (oldValues == null || newValues == null) return [];
    
    final changes = <String>[];
    for (final key in newValues!.keys) {
      if (!oldValues!.containsKey(key) || oldValues![key] != newValues![key]) {
        changes.add(key);
      }
    }
    for (final key in oldValues!.keys) {
      if (!newValues!.containsKey(key)) {
        changes.add(key);
      }
    }
    return changes;
  }

  /// Get action display name
  String get actionDisplayName {
    switch (action) {
      case 'create':
        return 'Created';
      case 'update':
        return 'Updated';
      case 'delete':
        return 'Deleted';
      case 'restore':
        return 'Restored';
      default:
        return action;
    }
  }

  /// Get entity type display name
  String get entityTypeDisplayName {
    switch (entityType) {
      case 'company':
        return 'Company';
      case 'contact':
        return 'Contact';
      case 'product':
        return 'Product';
      case 'transaction':
        return 'Transaction';
      case 'payment':
        return 'Payment';
      case 'category':
        return 'Category';
      case 'brand':
        return 'Brand';
      case 'unit':
        return 'Unit';
      case 'tax_rate':
        return 'Tax Rate';
      case 'setting':
        return 'Setting';
      default:
        return entityType;
    }
  }

  /// Get description with details
  String get fullDescription {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    
    final buffer = StringBuffer();
    buffer.write('${entityTypeDisplayName} ${actionDisplayName.toLowerCase()}');
    
    if (changedFields.isNotEmpty) {
      buffer.write(' (${changedFields.join(', ')})');
    }
    
    return buffer.toString();
  }
}
