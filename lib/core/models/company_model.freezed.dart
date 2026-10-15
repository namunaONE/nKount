// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return _CompanyModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyModel {
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get address => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get city => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get district => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get mobile => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get website => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get vatNumber => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get panNumber => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get registrationNumber => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get logoPath => throw _privateConstructorUsedError;
  @HiveField(13)
  String get currency => throw _privateConstructorUsedError;
  @HiveField(14)
  String get locale => throw _privateConstructorUsedError;
  @HiveField(15)
  String get dateFormat => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get useNepaliDate => throw _privateConstructorUsedError;
  @HiveField(17)
  double get defaultVatRate => throw _privateConstructorUsedError;
  @HiveField(18)
  String get invoicePrefix => throw _privateConstructorUsedError;
  @HiveField(19)
  int get invoiceStartNumber => throw _privateConstructorUsedError;
  @HiveField(20)
  int get purchaseStartNumber => throw _privateConstructorUsedError;
  @HiveField(21)
  String? get footerText => throw _privateConstructorUsedError;
  @HiveField(22)
  bool get showTaxOnInvoice => throw _privateConstructorUsedError;
  @HiveField(23)
  bool get showVatNumber => throw _privateConstructorUsedError;
  @HiveField(24)
  bool get isIRDRegistered => throw _privateConstructorUsedError;
  @HiveField(25)
  DateTime? get financialYearStart => throw _privateConstructorUsedError;
  @HiveField(26)
  DateTime? get financialYearEnd => throw _privateConstructorUsedError;
  @HiveField(27)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(28)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(29)
  String? get ownerName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyModelCopyWith<CompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyModelCopyWith<$Res> {
  factory $CompanyModelCopyWith(
          CompanyModel value, $Res Function(CompanyModel) then) =
      _$CompanyModelCopyWithImpl<$Res, CompanyModel>;
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(0) String id,
      @HiveField(2) String? address,
      @HiveField(3) String? city,
      @HiveField(4) String? district,
      @HiveField(5) String? phone,
      @HiveField(6) String? mobile,
      @HiveField(7) String? email,
      @HiveField(8) String? website,
      @HiveField(9) String? vatNumber,
      @HiveField(10) String? panNumber,
      @HiveField(11) String? registrationNumber,
      @HiveField(12) String? logoPath,
      @HiveField(13) String currency,
      @HiveField(14) String locale,
      @HiveField(15) String dateFormat,
      @HiveField(16) bool useNepaliDate,
      @HiveField(17) double defaultVatRate,
      @HiveField(18) String invoicePrefix,
      @HiveField(19) int invoiceStartNumber,
      @HiveField(20) int purchaseStartNumber,
      @HiveField(21) String? footerText,
      @HiveField(22) bool showTaxOnInvoice,
      @HiveField(23) bool showVatNumber,
      @HiveField(24) bool isIRDRegistered,
      @HiveField(25) DateTime? financialYearStart,
      @HiveField(26) DateTime? financialYearEnd,
      @HiveField(27) DateTime? createdAt,
      @HiveField(28) DateTime? updatedAt,
      @HiveField(29) String? ownerName});
}

/// @nodoc
class _$CompanyModelCopyWithImpl<$Res, $Val extends CompanyModel>
    implements $CompanyModelCopyWith<$Res> {
  _$CompanyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? vatNumber = freezed,
    Object? panNumber = freezed,
    Object? registrationNumber = freezed,
    Object? logoPath = freezed,
    Object? currency = null,
    Object? locale = null,
    Object? dateFormat = null,
    Object? useNepaliDate = null,
    Object? defaultVatRate = null,
    Object? invoicePrefix = null,
    Object? invoiceStartNumber = null,
    Object? purchaseStartNumber = null,
    Object? footerText = freezed,
    Object? showTaxOnInvoice = null,
    Object? showVatNumber = null,
    Object? isIRDRegistered = null,
    Object? financialYearStart = freezed,
    Object? financialYearEnd = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ownerName = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      logoPath: freezed == logoPath
          ? _value.logoPath
          : logoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      dateFormat: null == dateFormat
          ? _value.dateFormat
          : dateFormat // ignore: cast_nullable_to_non_nullable
              as String,
      useNepaliDate: null == useNepaliDate
          ? _value.useNepaliDate
          : useNepaliDate // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultVatRate: null == defaultVatRate
          ? _value.defaultVatRate
          : defaultVatRate // ignore: cast_nullable_to_non_nullable
              as double,
      invoicePrefix: null == invoicePrefix
          ? _value.invoicePrefix
          : invoicePrefix // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceStartNumber: null == invoiceStartNumber
          ? _value.invoiceStartNumber
          : invoiceStartNumber // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseStartNumber: null == purchaseStartNumber
          ? _value.purchaseStartNumber
          : purchaseStartNumber // ignore: cast_nullable_to_non_nullable
              as int,
      footerText: freezed == footerText
          ? _value.footerText
          : footerText // ignore: cast_nullable_to_non_nullable
              as String?,
      showTaxOnInvoice: null == showTaxOnInvoice
          ? _value.showTaxOnInvoice
          : showTaxOnInvoice // ignore: cast_nullable_to_non_nullable
              as bool,
      showVatNumber: null == showVatNumber
          ? _value.showVatNumber
          : showVatNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isIRDRegistered: null == isIRDRegistered
          ? _value.isIRDRegistered
          : isIRDRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      financialYearStart: freezed == financialYearStart
          ? _value.financialYearStart
          : financialYearStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      financialYearEnd: freezed == financialYearEnd
          ? _value.financialYearEnd
          : financialYearEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyModelImplCopyWith<$Res>
    implements $CompanyModelCopyWith<$Res> {
  factory _$$CompanyModelImplCopyWith(
          _$CompanyModelImpl value, $Res Function(_$CompanyModelImpl) then) =
      __$$CompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(0) String id,
      @HiveField(2) String? address,
      @HiveField(3) String? city,
      @HiveField(4) String? district,
      @HiveField(5) String? phone,
      @HiveField(6) String? mobile,
      @HiveField(7) String? email,
      @HiveField(8) String? website,
      @HiveField(9) String? vatNumber,
      @HiveField(10) String? panNumber,
      @HiveField(11) String? registrationNumber,
      @HiveField(12) String? logoPath,
      @HiveField(13) String currency,
      @HiveField(14) String locale,
      @HiveField(15) String dateFormat,
      @HiveField(16) bool useNepaliDate,
      @HiveField(17) double defaultVatRate,
      @HiveField(18) String invoicePrefix,
      @HiveField(19) int invoiceStartNumber,
      @HiveField(20) int purchaseStartNumber,
      @HiveField(21) String? footerText,
      @HiveField(22) bool showTaxOnInvoice,
      @HiveField(23) bool showVatNumber,
      @HiveField(24) bool isIRDRegistered,
      @HiveField(25) DateTime? financialYearStart,
      @HiveField(26) DateTime? financialYearEnd,
      @HiveField(27) DateTime? createdAt,
      @HiveField(28) DateTime? updatedAt,
      @HiveField(29) String? ownerName});
}

/// @nodoc
class __$$CompanyModelImplCopyWithImpl<$Res>
    extends _$CompanyModelCopyWithImpl<$Res, _$CompanyModelImpl>
    implements _$$CompanyModelImplCopyWith<$Res> {
  __$$CompanyModelImplCopyWithImpl(
      _$CompanyModelImpl _value, $Res Function(_$CompanyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? vatNumber = freezed,
    Object? panNumber = freezed,
    Object? registrationNumber = freezed,
    Object? logoPath = freezed,
    Object? currency = null,
    Object? locale = null,
    Object? dateFormat = null,
    Object? useNepaliDate = null,
    Object? defaultVatRate = null,
    Object? invoicePrefix = null,
    Object? invoiceStartNumber = null,
    Object? purchaseStartNumber = null,
    Object? footerText = freezed,
    Object? showTaxOnInvoice = null,
    Object? showVatNumber = null,
    Object? isIRDRegistered = null,
    Object? financialYearStart = freezed,
    Object? financialYearEnd = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ownerName = freezed,
  }) {
    return _then(_$CompanyModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      logoPath: freezed == logoPath
          ? _value.logoPath
          : logoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      dateFormat: null == dateFormat
          ? _value.dateFormat
          : dateFormat // ignore: cast_nullable_to_non_nullable
              as String,
      useNepaliDate: null == useNepaliDate
          ? _value.useNepaliDate
          : useNepaliDate // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultVatRate: null == defaultVatRate
          ? _value.defaultVatRate
          : defaultVatRate // ignore: cast_nullable_to_non_nullable
              as double,
      invoicePrefix: null == invoicePrefix
          ? _value.invoicePrefix
          : invoicePrefix // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceStartNumber: null == invoiceStartNumber
          ? _value.invoiceStartNumber
          : invoiceStartNumber // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseStartNumber: null == purchaseStartNumber
          ? _value.purchaseStartNumber
          : purchaseStartNumber // ignore: cast_nullable_to_non_nullable
              as int,
      footerText: freezed == footerText
          ? _value.footerText
          : footerText // ignore: cast_nullable_to_non_nullable
              as String?,
      showTaxOnInvoice: null == showTaxOnInvoice
          ? _value.showTaxOnInvoice
          : showTaxOnInvoice // ignore: cast_nullable_to_non_nullable
              as bool,
      showVatNumber: null == showVatNumber
          ? _value.showVatNumber
          : showVatNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isIRDRegistered: null == isIRDRegistered
          ? _value.isIRDRegistered
          : isIRDRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      financialYearStart: freezed == financialYearStart
          ? _value.financialYearStart
          : financialYearStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      financialYearEnd: freezed == financialYearEnd
          ? _value.financialYearEnd
          : financialYearEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyModelImpl extends _CompanyModel {
  const _$CompanyModelImpl(
      {@HiveField(1) required this.name,
      @HiveField(0) this.id = '',
      @HiveField(2) this.address,
      @HiveField(3) this.city,
      @HiveField(4) this.district,
      @HiveField(5) this.phone,
      @HiveField(6) this.mobile,
      @HiveField(7) this.email,
      @HiveField(8) this.website,
      @HiveField(9) this.vatNumber,
      @HiveField(10) this.panNumber,
      @HiveField(11) this.registrationNumber,
      @HiveField(12) this.logoPath,
      @HiveField(13) this.currency = AppConstants.currency,
      @HiveField(14) this.locale = 'en_NP',
      @HiveField(15) this.dateFormat = 'yyyy-MM-dd',
      @HiveField(16) this.useNepaliDate = false,
      @HiveField(17) this.defaultVatRate = 13.0,
      @HiveField(18) this.invoicePrefix = 'INV',
      @HiveField(19) this.invoiceStartNumber = 1,
      @HiveField(20) this.purchaseStartNumber = 1,
      @HiveField(21) this.footerText,
      @HiveField(22) this.showTaxOnInvoice = true,
      @HiveField(23) this.showVatNumber = true,
      @HiveField(24) this.isIRDRegistered = false,
      @HiveField(25) this.financialYearStart,
      @HiveField(26) this.financialYearEnd,
      @HiveField(27) this.createdAt,
      @HiveField(28) this.updatedAt,
      @HiveField(29) this.ownerName})
      : super._();

  factory _$CompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyModelImplFromJson(json);

  @override
  @HiveField(1)
  final String name;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final String? address;
  @override
  @HiveField(3)
  final String? city;
  @override
  @HiveField(4)
  final String? district;
  @override
  @HiveField(5)
  final String? phone;
  @override
  @HiveField(6)
  final String? mobile;
  @override
  @HiveField(7)
  final String? email;
  @override
  @HiveField(8)
  final String? website;
  @override
  @HiveField(9)
  final String? vatNumber;
  @override
  @HiveField(10)
  final String? panNumber;
  @override
  @HiveField(11)
  final String? registrationNumber;
  @override
  @HiveField(12)
  final String? logoPath;
  @override
  @JsonKey()
  @HiveField(13)
  final String currency;
  @override
  @JsonKey()
  @HiveField(14)
  final String locale;
  @override
  @JsonKey()
  @HiveField(15)
  final String dateFormat;
  @override
  @JsonKey()
  @HiveField(16)
  final bool useNepaliDate;
  @override
  @JsonKey()
  @HiveField(17)
  final double defaultVatRate;
  @override
  @JsonKey()
  @HiveField(18)
  final String invoicePrefix;
  @override
  @JsonKey()
  @HiveField(19)
  final int invoiceStartNumber;
  @override
  @JsonKey()
  @HiveField(20)
  final int purchaseStartNumber;
  @override
  @HiveField(21)
  final String? footerText;
  @override
  @JsonKey()
  @HiveField(22)
  final bool showTaxOnInvoice;
  @override
  @JsonKey()
  @HiveField(23)
  final bool showVatNumber;
  @override
  @JsonKey()
  @HiveField(24)
  final bool isIRDRegistered;
  @override
  @HiveField(25)
  final DateTime? financialYearStart;
  @override
  @HiveField(26)
  final DateTime? financialYearEnd;
  @override
  @HiveField(27)
  final DateTime? createdAt;
  @override
  @HiveField(28)
  final DateTime? updatedAt;
  @override
  @HiveField(29)
  final String? ownerName;

  @override
  String toString() {
    return 'CompanyModel(name: $name, id: $id, address: $address, city: $city, district: $district, phone: $phone, mobile: $mobile, email: $email, website: $website, vatNumber: $vatNumber, panNumber: $panNumber, registrationNumber: $registrationNumber, logoPath: $logoPath, currency: $currency, locale: $locale, dateFormat: $dateFormat, useNepaliDate: $useNepaliDate, defaultVatRate: $defaultVatRate, invoicePrefix: $invoicePrefix, invoiceStartNumber: $invoiceStartNumber, purchaseStartNumber: $purchaseStartNumber, footerText: $footerText, showTaxOnInvoice: $showTaxOnInvoice, showVatNumber: $showVatNumber, isIRDRegistered: $isIRDRegistered, financialYearStart: $financialYearStart, financialYearEnd: $financialYearEnd, createdAt: $createdAt, updatedAt: $updatedAt, ownerName: $ownerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber) &&
            (identical(other.panNumber, panNumber) ||
                other.panNumber == panNumber) &&
            (identical(other.registrationNumber, registrationNumber) ||
                other.registrationNumber == registrationNumber) &&
            (identical(other.logoPath, logoPath) ||
                other.logoPath == logoPath) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.dateFormat, dateFormat) ||
                other.dateFormat == dateFormat) &&
            (identical(other.useNepaliDate, useNepaliDate) ||
                other.useNepaliDate == useNepaliDate) &&
            (identical(other.defaultVatRate, defaultVatRate) ||
                other.defaultVatRate == defaultVatRate) &&
            (identical(other.invoicePrefix, invoicePrefix) ||
                other.invoicePrefix == invoicePrefix) &&
            (identical(other.invoiceStartNumber, invoiceStartNumber) ||
                other.invoiceStartNumber == invoiceStartNumber) &&
            (identical(other.purchaseStartNumber, purchaseStartNumber) ||
                other.purchaseStartNumber == purchaseStartNumber) &&
            (identical(other.footerText, footerText) ||
                other.footerText == footerText) &&
            (identical(other.showTaxOnInvoice, showTaxOnInvoice) ||
                other.showTaxOnInvoice == showTaxOnInvoice) &&
            (identical(other.showVatNumber, showVatNumber) ||
                other.showVatNumber == showVatNumber) &&
            (identical(other.isIRDRegistered, isIRDRegistered) ||
                other.isIRDRegistered == isIRDRegistered) &&
            (identical(other.financialYearStart, financialYearStart) ||
                other.financialYearStart == financialYearStart) &&
            (identical(other.financialYearEnd, financialYearEnd) ||
                other.financialYearEnd == financialYearEnd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        id,
        address,
        city,
        district,
        phone,
        mobile,
        email,
        website,
        vatNumber,
        panNumber,
        registrationNumber,
        logoPath,
        currency,
        locale,
        dateFormat,
        useNepaliDate,
        defaultVatRate,
        invoicePrefix,
        invoiceStartNumber,
        purchaseStartNumber,
        footerText,
        showTaxOnInvoice,
        showVatNumber,
        isIRDRegistered,
        financialYearStart,
        financialYearEnd,
        createdAt,
        updatedAt,
        ownerName
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      __$$CompanyModelImplCopyWithImpl<_$CompanyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyModel extends CompanyModel {
  const factory _CompanyModel(
      {@HiveField(1) required final String name,
      @HiveField(0) final String id,
      @HiveField(2) final String? address,
      @HiveField(3) final String? city,
      @HiveField(4) final String? district,
      @HiveField(5) final String? phone,
      @HiveField(6) final String? mobile,
      @HiveField(7) final String? email,
      @HiveField(8) final String? website,
      @HiveField(9) final String? vatNumber,
      @HiveField(10) final String? panNumber,
      @HiveField(11) final String? registrationNumber,
      @HiveField(12) final String? logoPath,
      @HiveField(13) final String currency,
      @HiveField(14) final String locale,
      @HiveField(15) final String dateFormat,
      @HiveField(16) final bool useNepaliDate,
      @HiveField(17) final double defaultVatRate,
      @HiveField(18) final String invoicePrefix,
      @HiveField(19) final int invoiceStartNumber,
      @HiveField(20) final int purchaseStartNumber,
      @HiveField(21) final String? footerText,
      @HiveField(22) final bool showTaxOnInvoice,
      @HiveField(23) final bool showVatNumber,
      @HiveField(24) final bool isIRDRegistered,
      @HiveField(25) final DateTime? financialYearStart,
      @HiveField(26) final DateTime? financialYearEnd,
      @HiveField(27) final DateTime? createdAt,
      @HiveField(28) final DateTime? updatedAt,
      @HiveField(29) final String? ownerName}) = _$CompanyModelImpl;
  const _CompanyModel._() : super._();

  factory _CompanyModel.fromJson(Map<String, dynamic> json) =
      _$CompanyModelImpl.fromJson;

  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  String? get address;
  @override
  @HiveField(3)
  String? get city;
  @override
  @HiveField(4)
  String? get district;
  @override
  @HiveField(5)
  String? get phone;
  @override
  @HiveField(6)
  String? get mobile;
  @override
  @HiveField(7)
  String? get email;
  @override
  @HiveField(8)
  String? get website;
  @override
  @HiveField(9)
  String? get vatNumber;
  @override
  @HiveField(10)
  String? get panNumber;
  @override
  @HiveField(11)
  String? get registrationNumber;
  @override
  @HiveField(12)
  String? get logoPath;
  @override
  @HiveField(13)
  String get currency;
  @override
  @HiveField(14)
  String get locale;
  @override
  @HiveField(15)
  String get dateFormat;
  @override
  @HiveField(16)
  bool get useNepaliDate;
  @override
  @HiveField(17)
  double get defaultVatRate;
  @override
  @HiveField(18)
  String get invoicePrefix;
  @override
  @HiveField(19)
  int get invoiceStartNumber;
  @override
  @HiveField(20)
  int get purchaseStartNumber;
  @override
  @HiveField(21)
  String? get footerText;
  @override
  @HiveField(22)
  bool get showTaxOnInvoice;
  @override
  @HiveField(23)
  bool get showVatNumber;
  @override
  @HiveField(24)
  bool get isIRDRegistered;
  @override
  @HiveField(25)
  DateTime? get financialYearStart;
  @override
  @HiveField(26)
  DateTime? get financialYearEnd;
  @override
  @HiveField(27)
  DateTime? get createdAt;
  @override
  @HiveField(28)
  DateTime? get updatedAt;
  @override
  @HiveField(29)
  String? get ownerName;
  @override
  @JsonKey(ignore: true)
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
