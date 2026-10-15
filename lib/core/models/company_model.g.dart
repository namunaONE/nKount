// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 0;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel(
      name: fields[1] as String,
      id: fields[0] as String,
      address: fields[2] as String?,
      city: fields[3] as String?,
      district: fields[4] as String?,
      phone: fields[5] as String?,
      mobile: fields[6] as String?,
      email: fields[7] as String?,
      website: fields[8] as String?,
      vatNumber: fields[9] as String?,
      panNumber: fields[10] as String?,
      registrationNumber: fields[11] as String?,
      logoPath: fields[12] as String?,
      currency: fields[13] as String,
      locale: fields[14] as String,
      dateFormat: fields[15] as String,
      useNepaliDate: fields[16] as bool,
      defaultVatRate: (fields[17] as num).toDouble(),
      invoicePrefix: fields[18] as String,
      invoiceStartNumber: (fields[19] as num).toInt(),
      purchaseStartNumber: (fields[20] as num).toInt(),
      footerText: fields[21] as String?,
      showTaxOnInvoice: fields[22] as bool,
      showVatNumber: fields[23] as bool,
      isIRDRegistered: fields[24] as bool,
      financialYearStart: fields[25] as DateTime?,
      financialYearEnd: fields[26] as DateTime?,
      createdAt: fields[27] as DateTime?,
      updatedAt: fields[28] as DateTime?,
      ownerName: fields[29] as String?,
      province: fields[30] as String?,
      palika: fields[31] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(32)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.id)
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
      ..write(obj.updatedAt)
      ..writeByte(29)
      ..write(obj.ownerName)
      ..writeByte(30)
      ..write(obj.province)
      ..writeByte(31)
      ..write(obj.palika);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      name: json['name'] as String,
      id: json['id'] as String? ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      vatNumber: json['vatNumber'] as String?,
      panNumber: json['panNumber'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      logoPath: json['logoPath'] as String?,
      currency: json['currency'] as String? ?? AppConstants.currency,
      locale: json['locale'] as String? ?? 'en_NP',
      dateFormat: json['dateFormat'] as String? ?? 'yyyy-MM-dd',
      useNepaliDate: json['useNepaliDate'] as bool? ?? false,
      defaultVatRate: (json['defaultVatRate'] as num?)?.toDouble() ?? 13.0,
      invoicePrefix: json['invoicePrefix'] as String? ?? 'INV',
      invoiceStartNumber: (json['invoiceStartNumber'] as num?)?.toInt() ?? 1,
      purchaseStartNumber: (json['purchaseStartNumber'] as num?)?.toInt() ?? 1,
      footerText: json['footerText'] as String?,
      showTaxOnInvoice: json['showTaxOnInvoice'] as bool? ?? true,
      showVatNumber: json['showVatNumber'] as bool? ?? true,
      isIRDRegistered: json['isIRDRegistered'] as bool? ?? false,
      financialYearStart: json['financialYearStart'] == null
          ? null
          : DateTime.parse(json['financialYearStart'] as String),
      financialYearEnd: json['financialYearEnd'] == null
          ? null
          : DateTime.parse(json['financialYearEnd'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      ownerName: json['ownerName'] as String?,
      province: json['province'] as String?,
      palika: json['palika'] as String?,
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'email': instance.email,
      'website': instance.website,
      'vatNumber': instance.vatNumber,
      'panNumber': instance.panNumber,
      'registrationNumber': instance.registrationNumber,
      'logoPath': instance.logoPath,
      'currency': instance.currency,
      'locale': instance.locale,
      'dateFormat': instance.dateFormat,
      'useNepaliDate': instance.useNepaliDate,
      'defaultVatRate': instance.defaultVatRate,
      'invoicePrefix': instance.invoicePrefix,
      'invoiceStartNumber': instance.invoiceStartNumber,
      'purchaseStartNumber': instance.purchaseStartNumber,
      'footerText': instance.footerText,
      'showTaxOnInvoice': instance.showTaxOnInvoice,
      'showVatNumber': instance.showVatNumber,
      'isIRDRegistered': instance.isIRDRegistered,
      'financialYearStart': instance.financialYearStart?.toIso8601String(),
      'financialYearEnd': instance.financialYearEnd?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'ownerName': instance.ownerName,
      'province': instance.province,
      'palika': instance.palika,
    };
