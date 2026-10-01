// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String,
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
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
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
