// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncLogModelAdapter extends TypeAdapter<SyncLogModel> {
  @override
  final int typeId = 12;

  @override
  SyncLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncLogModel(
      entityType: fields[1] as String,
      entityId: fields[2] as String,
      action: fields[3] as String,
      id: fields[0] as String,
      status: fields[4] as String,
      requestId: fields[5] as String?,
      responseId: fields[6] as String?,
      retryCount: (fields[7] as num).toInt(),
      maxRetries: (fields[8] as num).toInt(),
      errorMessage: fields[9] as String?,
      requestData: (fields[10] as Map?)?.cast<String, dynamic>(),
      responseData: (fields[11] as Map?)?.cast<String, dynamic>(),
      isConflict: fields[12] as bool,
      conflictResolution: fields[13] as String?,
      conflictResolvedAt: fields[14] as DateTime?,
      createdAt: fields[15] as DateTime?,
      updatedAt: fields[16] as DateTime?,
      completedAt: fields[17] as DateTime?,
      createdBy: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncLogModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.entityType)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.requestId)
      ..writeByte(6)
      ..write(obj.responseId)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.maxRetries)
      ..writeByte(9)
      ..write(obj.errorMessage)
      ..writeByte(10)
      ..write(obj.requestData)
      ..writeByte(11)
      ..write(obj.responseData)
      ..writeByte(12)
      ..write(obj.isConflict)
      ..writeByte(13)
      ..write(obj.conflictResolution)
      ..writeByte(14)
      ..write(obj.conflictResolvedAt)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.completedAt)
      ..writeByte(18)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncLogModelImpl _$$SyncLogModelImplFromJson(Map<String, dynamic> json) =>
    _$SyncLogModelImpl(
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      action: json['action'] as String,
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      requestId: json['requestId'] as String?,
      responseId: json['responseId'] as String?,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
      errorMessage: json['errorMessage'] as String?,
      requestData: json['requestData'] as Map<String, dynamic>?,
      responseData: json['responseData'] as Map<String, dynamic>?,
      isConflict: json['isConflict'] as bool? ?? false,
      conflictResolution: json['conflictResolution'] as String?,
      conflictResolvedAt: json['conflictResolvedAt'] == null
          ? null
          : DateTime.parse(json['conflictResolvedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$SyncLogModelImplToJson(_$SyncLogModelImpl instance) =>
    <String, dynamic>{
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'action': instance.action,
      'id': instance.id,
      'status': instance.status,
      'requestId': instance.requestId,
      'responseId': instance.responseId,
      'retryCount': instance.retryCount,
      'maxRetries': instance.maxRetries,
      'errorMessage': instance.errorMessage,
      'requestData': instance.requestData,
      'responseData': instance.responseData,
      'isConflict': instance.isConflict,
      'conflictResolution': instance.conflictResolution,
      'conflictResolvedAt': instance.conflictResolvedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };
