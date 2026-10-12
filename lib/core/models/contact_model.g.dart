// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactModelAdapter extends TypeAdapter<ContactModel> {
  @override
  final int typeId = 1;

  @override
  ContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactModel(
      name: fields[1] as String,
      id: fields[0] as String,
      phone: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
      address: fields[5] as String?,
      city: fields[6] as String?,
      district: fields[7] as String?,
      vatNumber: fields[8] as String?,
      panNumber: fields[9] as String?,
      type: fields[10] as String,
      openingBalance: (fields[11] as num?)?.toDouble(),
      isActive: fields[12] as bool,
      remarks: fields[13] as String?,
      totalPurchases: (fields[14] as num).toDouble(),
      totalSales: (fields[15] as num).toDouble(),
      totalPayments: (fields[16] as num).toDouble(),
      totalReceipts: (fields[17] as num).toDouble(),
      balance: (fields[18] as num).toDouble(),
      createdAt: fields[19] as DateTime?,
      updatedAt: fields[20] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.district)
      ..writeByte(8)
      ..write(obj.vatNumber)
      ..writeByte(9)
      ..write(obj.panNumber)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.openingBalance)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.remarks)
      ..writeByte(14)
      ..write(obj.totalPurchases)
      ..writeByte(15)
      ..write(obj.totalSales)
      ..writeByte(16)
      ..write(obj.totalPayments)
      ..writeByte(17)
      ..write(obj.totalReceipts)
      ..writeByte(18)
      ..write(obj.balance)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactModelImpl _$$ContactModelImplFromJson(Map<String, dynamic> json) =>
    _$ContactModelImpl(
      name: json['name'] as String,
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      vatNumber: json['vatNumber'] as String?,
      panNumber: json['panNumber'] as String?,
      type: json['type'] as String? ?? AppConstants.CONTACT_CUSTOMER,
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      remarks: json['remarks'] as String?,
      totalPurchases: (json['totalPurchases'] as num?)?.toDouble() ?? 0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalPayments: (json['totalPayments'] as num?)?.toDouble() ?? 0,
      totalReceipts: (json['totalReceipts'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ContactModelImplToJson(_$ContactModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
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
