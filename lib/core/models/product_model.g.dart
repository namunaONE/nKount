// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      name: fields[1] as String,
      id: fields[0] as String,
      code: fields[2] as String?,
      barcode: fields[3] as String?,
      category: fields[4] as String?,
      brand: fields[5] as String?,
      unit: fields[6] as String?,
      purchasePrice: (fields[7] as num).toDouble(),
      salePrice: (fields[8] as num).toDouble(),
      costPrice: (fields[9] as num).toDouble(),
      quantity: (fields[10] as num).toDouble(),
      minQuantity: (fields[11] as num).toDouble(),
      isTaxable: fields[12] as bool,
      taxRate: (fields[13] as num).toDouble(),
      description: fields[14] as String?,
      supplierId: fields[15] as String?,
      isActive: fields[16] as bool,
      imageUrl: fields[17] as String?,
      totalPurchased: (fields[18] as num).toDouble(),
      totalSold: (fields[19] as num).toDouble(),
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.purchasePrice)
      ..writeByte(8)
      ..write(obj.salePrice)
      ..writeByte(9)
      ..write(obj.costPrice)
      ..writeByte(10)
      ..write(obj.quantity)
      ..writeByte(11)
      ..write(obj.minQuantity)
      ..writeByte(12)
      ..write(obj.isTaxable)
      ..writeByte(13)
      ..write(obj.taxRate)
      ..writeByte(14)
      ..write(obj.description)
      ..writeByte(15)
      ..write(obj.supplierId)
      ..writeByte(16)
      ..write(obj.isActive)
      ..writeByte(17)
      ..write(obj.imageUrl)
      ..writeByte(18)
      ..write(obj.totalPurchased)
      ..writeByte(19)
      ..write(obj.totalSold)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      name: json['name'] as String,
      id: json['id'] as String? ?? '',
      code: json['code'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      unit: json['unit'] as String?,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      minQuantity: (json['minQuantity'] as num?)?.toDouble() ?? 0.0,
      isTaxable: json['isTaxable'] as bool? ?? false,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 13.0,
      description: json['description'] as String?,
      supplierId: json['supplierId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
      totalPurchased: (json['totalPurchased'] as num?)?.toDouble() ?? 0.0,
      totalSold: (json['totalSold'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'code': instance.code,
      'barcode': instance.barcode,
      'category': instance.category,
      'brand': instance.brand,
      'unit': instance.unit,
      'purchasePrice': instance.purchasePrice,
      'salePrice': instance.salePrice,
      'costPrice': instance.costPrice,
      'quantity': instance.quantity,
      'minQuantity': instance.minQuantity,
      'isTaxable': instance.isTaxable,
      'taxRate': instance.taxRate,
      'description': instance.description,
      'supplierId': instance.supplierId,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'totalPurchased': instance.totalPurchased,
      'totalSold': instance.totalSold,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
