// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) {
  return _ContactModel.fromJson(json);
}

/// @nodoc
mixin _$ContactModel {
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get mobile => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get address => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get city => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get district => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get vatNumber => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get panNumber => throw _privateConstructorUsedError;
  @HiveField(10)
  String get type => throw _privateConstructorUsedError;
  @HiveField(11)
  double? get openingBalance => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get remarks => throw _privateConstructorUsedError;
  @HiveField(14)
  double get totalPurchases => throw _privateConstructorUsedError;
  @HiveField(15)
  double get totalSales => throw _privateConstructorUsedError;
  @HiveField(16)
  double get totalPayments => throw _privateConstructorUsedError;
  @HiveField(17)
  double get totalReceipts => throw _privateConstructorUsedError;
  @HiveField(18)
  double get balance => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactModelCopyWith<ContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactModelCopyWith<$Res> {
  factory $ContactModelCopyWith(
          ContactModel value, $Res Function(ContactModel) then) =
      _$ContactModelCopyWithImpl<$Res, ContactModel>;
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(0) String id,
      @HiveField(2) String? phone,
      @HiveField(3) String? mobile,
      @HiveField(4) String? email,
      @HiveField(5) String? address,
      @HiveField(6) String? city,
      @HiveField(7) String? district,
      @HiveField(8) String? vatNumber,
      @HiveField(9) String? panNumber,
      @HiveField(10) String type,
      @HiveField(11) double? openingBalance,
      @HiveField(12) bool isActive,
      @HiveField(13) String? remarks,
      @HiveField(14) double totalPurchases,
      @HiveField(15) double totalSales,
      @HiveField(16) double totalPayments,
      @HiveField(17) double totalReceipts,
      @HiveField(18) double balance,
      @HiveField(19) DateTime? createdAt,
      @HiveField(20) DateTime? updatedAt});
}

/// @nodoc
class _$ContactModelCopyWithImpl<$Res, $Val extends ContactModel>
    implements $ContactModelCopyWith<$Res> {
  _$ContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? vatNumber = freezed,
    Object? panNumber = freezed,
    Object? type = null,
    Object? openingBalance = freezed,
    Object? isActive = null,
    Object? remarks = freezed,
    Object? totalPurchases = null,
    Object? totalSales = null,
    Object? totalPayments = null,
    Object? totalReceipts = null,
    Object? balance = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalance: freezed == openingBalance
          ? _value.openingBalance
          : openingBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPurchases: null == totalPurchases
          ? _value.totalPurchases
          : totalPurchases // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayments: null == totalPayments
          ? _value.totalPayments
          : totalPayments // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceipts: null == totalReceipts
          ? _value.totalReceipts
          : totalReceipts // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactModelImplCopyWith<$Res>
    implements $ContactModelCopyWith<$Res> {
  factory _$$ContactModelImplCopyWith(
          _$ContactModelImpl value, $Res Function(_$ContactModelImpl) then) =
      __$$ContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(0) String id,
      @HiveField(2) String? phone,
      @HiveField(3) String? mobile,
      @HiveField(4) String? email,
      @HiveField(5) String? address,
      @HiveField(6) String? city,
      @HiveField(7) String? district,
      @HiveField(8) String? vatNumber,
      @HiveField(9) String? panNumber,
      @HiveField(10) String type,
      @HiveField(11) double? openingBalance,
      @HiveField(12) bool isActive,
      @HiveField(13) String? remarks,
      @HiveField(14) double totalPurchases,
      @HiveField(15) double totalSales,
      @HiveField(16) double totalPayments,
      @HiveField(17) double totalReceipts,
      @HiveField(18) double balance,
      @HiveField(19) DateTime? createdAt,
      @HiveField(20) DateTime? updatedAt});
}

/// @nodoc
class __$$ContactModelImplCopyWithImpl<$Res>
    extends _$ContactModelCopyWithImpl<$Res, _$ContactModelImpl>
    implements _$$ContactModelImplCopyWith<$Res> {
  __$$ContactModelImplCopyWithImpl(
      _$ContactModelImpl _value, $Res Function(_$ContactModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? vatNumber = freezed,
    Object? panNumber = freezed,
    Object? type = null,
    Object? openingBalance = freezed,
    Object? isActive = null,
    Object? remarks = freezed,
    Object? totalPurchases = null,
    Object? totalSales = null,
    Object? totalPayments = null,
    Object? totalReceipts = null,
    Object? balance = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ContactModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      vatNumber: freezed == vatNumber
          ? _value.vatNumber
          : vatNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalance: freezed == openingBalance
          ? _value.openingBalance
          : openingBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPurchases: null == totalPurchases
          ? _value.totalPurchases
          : totalPurchases // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayments: null == totalPayments
          ? _value.totalPayments
          : totalPayments // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceipts: null == totalReceipts
          ? _value.totalReceipts
          : totalReceipts // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactModelImpl extends _ContactModel {
  const _$ContactModelImpl(
      {@HiveField(1) required this.name,
      @HiveField(0) this.id = '',
      @HiveField(2) this.phone,
      @HiveField(3) this.mobile,
      @HiveField(4) this.email,
      @HiveField(5) this.address,
      @HiveField(6) this.city,
      @HiveField(7) this.district,
      @HiveField(8) this.vatNumber,
      @HiveField(9) this.panNumber,
      @HiveField(10) this.type = AppConstants.contactCustomer,
      @HiveField(11) this.openingBalance,
      @HiveField(12) this.isActive = true,
      @HiveField(13) this.remarks,
      @HiveField(14) this.totalPurchases = 0,
      @HiveField(15) this.totalSales = 0,
      @HiveField(16) this.totalPayments = 0,
      @HiveField(17) this.totalReceipts = 0,
      @HiveField(18) this.balance = 0,
      @HiveField(19) this.createdAt,
      @HiveField(20) this.updatedAt})
      : super._();

  factory _$ContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactModelImplFromJson(json);

  @override
  @HiveField(1)
  final String name;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final String? phone;
  @override
  @HiveField(3)
  final String? mobile;
  @override
  @HiveField(4)
  final String? email;
  @override
  @HiveField(5)
  final String? address;
  @override
  @HiveField(6)
  final String? city;
  @override
  @HiveField(7)
  final String? district;
  @override
  @HiveField(8)
  final String? vatNumber;
  @override
  @HiveField(9)
  final String? panNumber;
  @override
  @JsonKey()
  @HiveField(10)
  final String type;
  @override
  @HiveField(11)
  final double? openingBalance;
  @override
  @JsonKey()
  @HiveField(12)
  final bool isActive;
  @override
  @HiveField(13)
  final String? remarks;
  @override
  @JsonKey()
  @HiveField(14)
  final double totalPurchases;
  @override
  @JsonKey()
  @HiveField(15)
  final double totalSales;
  @override
  @JsonKey()
  @HiveField(16)
  final double totalPayments;
  @override
  @JsonKey()
  @HiveField(17)
  final double totalReceipts;
  @override
  @JsonKey()
  @HiveField(18)
  final double balance;
  @override
  @HiveField(19)
  final DateTime? createdAt;
  @override
  @HiveField(20)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ContactModel(name: $name, id: $id, phone: $phone, mobile: $mobile, email: $email, address: $address, city: $city, district: $district, vatNumber: $vatNumber, panNumber: $panNumber, type: $type, openingBalance: $openingBalance, isActive: $isActive, remarks: $remarks, totalPurchases: $totalPurchases, totalSales: $totalSales, totalPayments: $totalPayments, totalReceipts: $totalReceipts, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber) &&
            (identical(other.panNumber, panNumber) ||
                other.panNumber == panNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.totalPurchases, totalPurchases) ||
                other.totalPurchases == totalPurchases) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalPayments, totalPayments) ||
                other.totalPayments == totalPayments) &&
            (identical(other.totalReceipts, totalReceipts) ||
                other.totalReceipts == totalReceipts) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        id,
        phone,
        mobile,
        email,
        address,
        city,
        district,
        vatNumber,
        panNumber,
        type,
        openingBalance,
        isActive,
        remarks,
        totalPurchases,
        totalSales,
        totalPayments,
        totalReceipts,
        balance,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactModelImplCopyWith<_$ContactModelImpl> get copyWith =>
      __$$ContactModelImplCopyWithImpl<_$ContactModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactModelImplToJson(
      this,
    );
  }
}

abstract class _ContactModel extends ContactModel {
  const factory _ContactModel(
      {@HiveField(1) required final String name,
      @HiveField(0) final String id,
      @HiveField(2) final String? phone,
      @HiveField(3) final String? mobile,
      @HiveField(4) final String? email,
      @HiveField(5) final String? address,
      @HiveField(6) final String? city,
      @HiveField(7) final String? district,
      @HiveField(8) final String? vatNumber,
      @HiveField(9) final String? panNumber,
      @HiveField(10) final String type,
      @HiveField(11) final double? openingBalance,
      @HiveField(12) final bool isActive,
      @HiveField(13) final String? remarks,
      @HiveField(14) final double totalPurchases,
      @HiveField(15) final double totalSales,
      @HiveField(16) final double totalPayments,
      @HiveField(17) final double totalReceipts,
      @HiveField(18) final double balance,
      @HiveField(19) final DateTime? createdAt,
      @HiveField(20) final DateTime? updatedAt}) = _$ContactModelImpl;
  const _ContactModel._() : super._();

  factory _ContactModel.fromJson(Map<String, dynamic> json) =
      _$ContactModelImpl.fromJson;

  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  String? get phone;
  @override
  @HiveField(3)
  String? get mobile;
  @override
  @HiveField(4)
  String? get email;
  @override
  @HiveField(5)
  String? get address;
  @override
  @HiveField(6)
  String? get city;
  @override
  @HiveField(7)
  String? get district;
  @override
  @HiveField(8)
  String? get vatNumber;
  @override
  @HiveField(9)
  String? get panNumber;
  @override
  @HiveField(10)
  String get type;
  @override
  @HiveField(11)
  double? get openingBalance;
  @override
  @HiveField(12)
  bool get isActive;
  @override
  @HiveField(13)
  String? get remarks;
  @override
  @HiveField(14)
  double get totalPurchases;
  @override
  @HiveField(15)
  double get totalSales;
  @override
  @HiveField(16)
  double get totalPayments;
  @override
  @HiveField(17)
  double get totalReceipts;
  @override
  @HiveField(18)
  double get balance;
  @override
  @HiveField(19)
  DateTime? get createdAt;
  @override
  @HiveField(20)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ContactModelImplCopyWith<_$ContactModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
