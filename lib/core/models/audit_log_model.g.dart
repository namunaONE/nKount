// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuditLogModelAdapter extends TypeAdapter<AuditLogModel> {
  @override
  final int typeId = 13;

  @override
  AuditLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditLogModel(
      entityType: fields[1] as String,
      entityId: fields[2] as String,
      action: fields[3] as String,
      id: fields[0] as String,
      oldValues: (fields[4] as Map?)?.cast<String, dynamic>(),
      newValues: (fields[5] as Map?)?.cast<String, dynamic>(),
      description: fields[6] as String?,
      companyId: fields[7] as String?,
      userId: fields[8] as String?,
      userName: fields[9] as String?,
      ipAddress: fields[10] as String?,
      userAgent: fields[11] as String?,
      isSystemAction: fields[12] as bool,
      isReversed: fields[13] as bool,
      reversedBy: fields[14] as String?,
      reversedAt: fields[15] as DateTime?,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AuditLogModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(1)
      ..write(obj.entityType)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.oldValues)
      ..writeByte(5)
      ..write(obj.newValues)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.companyId)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.userName)
      ..writeByte(10)
      ..write(obj.ipAddress)
      ..writeByte(11)
      ..write(obj.userAgent)
      ..writeByte(12)
      ..write(obj.isSystemAction)
      ..writeByte(13)
      ..write(obj.isReversed)
      ..writeByte(14)
      ..write(obj.reversedBy)
      ..writeByte(15)
      ..write(obj.reversedAt)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogModelImpl _$$AuditLogModelImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogModelImpl(
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      action: json['action'] as String,
      id: json['id'] as String? ?? '',
      oldValues: json['oldValues'] as Map<String, dynamic>?,
      newValues: json['newValues'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      companyId: json['companyId'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      isSystemAction: json['isSystemAction'] as bool? ?? false,
      isReversed: json['isReversed'] as bool? ?? false,
      reversedBy: json['reversedBy'] as String?,
      reversedAt: json['reversedAt'] == null
          ? null
          : DateTime.parse(json['reversedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AuditLogModelImplToJson(_$AuditLogModelImpl instance) =>
    <String, dynamic>{
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'action': instance.action,
      'id': instance.id,
      'oldValues': instance.oldValues,
      'newValues': instance.newValues,
      'description': instance.description,
      'companyId': instance.companyId,
      'userId': instance.userId,
      'userName': instance.userName,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'isSystemAction': instance.isSystemAction,
      'isReversed': instance.isReversed,
      'reversedBy': instance.reversedBy,
      'reversedAt': instance.reversedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
