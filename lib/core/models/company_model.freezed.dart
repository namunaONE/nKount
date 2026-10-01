// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 6;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel.fromJson(fields.cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.district)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.mobile)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.website)
      ..writeByte(9)
      ..write(obj.vatNumber)
      ..writeByte(10)
      ..write(obj.panNumber)
      ..writeByte(11)
      ..write(obj.registrationNumber)
      ..writeByte(12)
      ..write(obj.logoPath)
      ..writeByte(13)
      ..write(obj.currency)
      ..writeByte(14)
      ..write(obj.locale)
      ..writeByte(15)
      ..write(obj.dateFormat)
      ..writeByte(16)
      ..write(obj.useNepaliDate)
      ..writeByte(17)
      ..write(obj.defaultVatRate)
      ..writeByte(18)
      ..write(obj.invoicePrefix)
      ..writeByte(19)
      ..write(obj.invoiceStartNumber)
      ..writeByte(20)
      ..write(obj.purchaseStartNumber)
      ..writeByte(21)
      ..write(obj.footerText)
      ..writeByte(22)
      ..write(obj.showTaxOnInvoice)
      ..writeByte(23)
      ..write(obj.showVatNumber)
      ..writeByte(24)
      ..write(obj.isIRDRegistered)
      ..writeByte(25)
      ..write(obj.financialYearStart)
      ..writeByte(26)
      ..write(obj.financialYearEnd)
      ..writeByte(27)
      ..write(obj.createdAt)
      ..writeByte(28)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
