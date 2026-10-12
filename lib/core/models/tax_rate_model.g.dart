// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_rate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxRateModelAdapter extends TypeAdapter<TaxRateModel> {
  @override
  final int typeId = 10;

  @override
  TaxRateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaxRateModel(
      name: fields[1] as String,
      code: fields[2] as String,
      id: fields[0] as String,
      rate: (fields[3] as num).toDouble(),
      description: fields[4] as String?,
      type: fields[5] as String,
      isActive: fields[6] as bool,
      isDefault: fields[7] as bool,
      isVat: fields[8] as bool,
      isCompound: fields[9] as bool,
      effectiveFrom: fields[10] as DateTime?,
      effectiveTo: fields[11] as DateTime?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaxRateModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.rate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.isDefault)
      ..writeByte(8)
      ..write(obj.isVat)
      ..writeByte(9)
      ..write(obj.isCompound)
      ..writeByte(10)
      ..write(obj.effectiveFrom)
      ..writeByte(11)
      ..write(obj.effectiveTo)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxRateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxRateModelImpl _$$TaxRateModelImplFromJson(Map<String, dynamic> json) =>
    _$TaxRateModelImpl(
      name: json['name'] as String,
      code: json['code'] as String,
      id: json['id'] as String? ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'percentage',
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      isVat: json['isVat'] as bool? ?? false,
      isCompound: json['isCompound'] as bool? ?? false,
      effectiveFrom: json['effectiveFrom'] == null
          ? null
          : DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] == null
          ? null
          : DateTime.parse(json['effectiveTo'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaxRateModelImplToJson(_$TaxRateModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'id': instance.id,
      'rate': instance.rate,
      'description': instance.description,
      'type': instance.type,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'isVat': instance.isVat,
      'isCompound': instance.isCompound,
      'effectiveFrom': instance.effectiveFrom?.toIso8601String(),
      'effectiveTo': instance.effectiveTo?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
