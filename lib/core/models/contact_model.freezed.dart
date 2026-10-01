// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactModelAdapter extends TypeAdapter<ContactModel> {
  @override
  final int typeId = 0;

  @override
  ContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactModel.fromJson(fields.cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, ContactModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
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
