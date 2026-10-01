// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) {
  return ContactModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String,
    phone: json['phone'] as String?,
    mobile: json['mobile'] as String?,
    email: json['email'] as String?,
    address: json['address'] as String?,
    city: json['city'] as String?,
    district: json['district'] as String?,
    vatNumber: json['vatNumber'] as String?,
    panNumber: json['panNumber'] as String?,
    type: json['type'] as String? ?? 'customer',
    openingBalance: (json['openingBalance'] as num?)?.toDouble(),
    isActive: json['isActive'] as bool? ?? true,
    remarks: json['remarks'] as String?,
    totalPurchases: (json['totalPurchases'] as num?)?.toDouble() ?? 0.0,
    totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
    totalPayments: (json['totalPayments'] as num?)?.toDouble() ?? 0.0,
    totalReceipts: (json['totalReceipts'] as num?)?.toDouble() ?? 0.0,
    balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'email': instance.email,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district,
      'vatNumber': instance.vatNumber,
      'panNumber': instance.panNumber,
      'type': instance.type,
      'openingBalance': instance.openingBalance,
      'isActive': instance.isActive,
      'remarks': instance.remarks,
      'totalPurchases': instance.totalPurchases,
      'totalSales': instance.totalSales,
      'totalPayments': instance.totalPayments,
      'totalReceipts': instance.totalReceipts,
      'balance': instance.balance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
