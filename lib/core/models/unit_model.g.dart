// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitModelAdapter extends TypeAdapter<UnitModel> {
  @override
  final int typeId = 9;

  @override
  UnitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitModel(
      name: fields[1] as String,
      code: fields[2] as String,
      id: fields[0] as String,
      description: fields[3] as String?,
      baseUnitMultiplier: (fields[4] as num).toDouble(),
      baseUnitId: fields[5] as String,
      isActive: fields[6] as bool,
      isBaseUnit: fields[7] as bool,
      sortOrder: (fields[8] as num).toInt(),
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.baseUnitMultiplier)
      ..writeByte(5)
      ..write(obj.baseUnitId)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.isBaseUnit)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitModelImpl _$$UnitModelImplFromJson(Map<String, dynamic> json) =>
    _$UnitModelImpl(
      name: json['name'] as String,
      code: json['code'] as String,
      id: json['id'] as String? ?? '',
      description: json['description'] as String?,
      baseUnitMultiplier:
          (json['baseUnitMultiplier'] as num?)?.toDouble() ?? 1.0,
      baseUnitId: json['baseUnitId'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      isBaseUnit: json['isBaseUnit'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UnitModelImplToJson(_$UnitModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'id': instance.id,
      'description': instance.description,
      'baseUnitMultiplier': instance.baseUnitMultiplier,
      'baseUnitId': instance.baseUnitId,
      'isActive': instance.isActive,
      'isBaseUnit': instance.isBaseUnit,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
