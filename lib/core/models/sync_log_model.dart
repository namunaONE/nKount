import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

part 'sync_log_model.freezed.dart';
part 'sync_log_model.g.dart';

/// Sync Log Model for tracking synchronization operations
@freezed
@HiveType(typeId: 12, adapterName: 'SyncLogModelAdapter')
class SyncLogModel with _$SyncLogModel {
  const factory SyncLogModel({
    @HiveField(1) required String entityType,
    @HiveField(2) required String entityId,
    @HiveField(3) required String action,
    @HiveField(0) @Default('') String id,
    @HiveField(4) @Default('pending') String status,
    @HiveField(5) String? requestId,
    @HiveField(6) String? responseId,
    @HiveField(7) @Default(0) int retryCount,
    @HiveField(8) @Default(3) int maxRetries,
    @HiveField(9) String? errorMessage,
    @HiveField(10) Map<String, dynamic>? requestData,
    @HiveField(11) Map<String, dynamic>? responseData,
    @HiveField(12) @Default(false) bool isConflict,
    @HiveField(13) String? conflictResolution,
    @HiveField(14) DateTime? conflictResolvedAt,
    @HiveField(15) DateTime? createdAt,
    @HiveField(16) DateTime? updatedAt,
    @HiveField(17) DateTime? completedAt,
    @HiveField(18) String? createdBy,
  }) = _SyncLogModel;

  factory SyncLogModel.fromJson(Map<String, dynamic> json) =>
      _$SyncLogModelFromJson(json);

  const SyncLogModel._();

  /// Create a new sync log
  factory SyncLogModel.create({
    required String entityType,
    required String entityId,
    required String action,
    String? requestId,
    Map<String, dynamic>? requestData,
    String? createdBy,
  }) =>
      SyncLogModel(
        id: const Uuid().v4(),
        entityType: entityType,
        entityId: entityId,
        action: action,
        status: 'pending',
        requestId: requestId,
        requestData: requestData,
        retryCount: 0,
        maxRetries: 3,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Check if sync is pending
  bool get isPending => status == 'pending';

  /// Check if sync has failed
  bool get isFailed => status == 'failed';

  /// Check if sync has conflict
  bool get hasConflict => isConflict;

  /// Get sync action display name
  String get actionDisplayName {
    switch (action) {
      case 'create':
        return 'Create';
      case 'update':
        return 'Update';
      case 'delete':
        return 'Delete';
      case 'pull':
        return 'Pull';
      case 'push':
        return 'Push';
      default:
        return action;
    }
  }
}
