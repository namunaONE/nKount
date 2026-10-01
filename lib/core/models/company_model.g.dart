// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return CompanyModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String,
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
    currency: json['currency'] as String? ?? 'NPR',
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
  );
}

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
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
    };
