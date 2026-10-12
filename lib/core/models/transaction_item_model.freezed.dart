// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionItemModel _$TransactionItemModelFromJson(Map<String, dynamic> json) {
  return _TransactionItemModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionItemModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get productId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get productName => throw _privateConstructorUsedError;
  @HiveField(3)
  double get quantity => throw _privateConstructorUsedError;
  @HiveField(4)
  double get unitPrice => throw _privateConstructorUsedError;
  @HiveField(5)
  double get discount => throw _privateConstructorUsedError;
  @HiveField(6)
  double get tax => throw _privateConstructorUsedError;
  @HiveField(7)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get unit => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionItemModelCopyWith<TransactionItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionItemModelCopyWith<$Res> {
  factory $TransactionItemModelCopyWith(TransactionItemModel value,
          $Res Function(TransactionItemModel) then) =
      _$TransactionItemModelCopyWithImpl<$Res, TransactionItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String productId,
      @HiveField(2) String productName,
      @HiveField(3) double quantity,
      @HiveField(4) double unitPrice,
      @HiveField(5) double discount,
      @HiveField(6) double tax,
      @HiveField(7) double amount,
      @HiveField(8) String? unit,
      @HiveField(9) String? description,
      @HiveField(10) DateTime? createdAt,
      @HiveField(11) DateTime? updatedAt});
}

/// @nodoc
class _$TransactionItemModelCopyWithImpl<$Res,
        $Val extends TransactionItemModel>
    implements $TransactionItemModelCopyWith<$Res> {
  _$TransactionItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? tax = null,
    Object? amount = null,
    Object? unit = freezed,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$TransactionItemModelImplCopyWith<$Res>
    implements $TransactionItemModelCopyWith<$Res> {
  factory _$$TransactionItemModelImplCopyWith(_$TransactionItemModelImpl value,
          $Res Function(_$TransactionItemModelImpl) then) =
      __$$TransactionItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String productId,
      @HiveField(2) String productName,
      @HiveField(3) double quantity,
      @HiveField(4) double unitPrice,
      @HiveField(5) double discount,
      @HiveField(6) double tax,
      @HiveField(7) double amount,
      @HiveField(8) String? unit,
      @HiveField(9) String? description,
      @HiveField(10) DateTime? createdAt,
      @HiveField(11) DateTime? updatedAt});
}

/// @nodoc
class __$$TransactionItemModelImplCopyWithImpl<$Res>
    extends _$TransactionItemModelCopyWithImpl<$Res, _$TransactionItemModelImpl>
    implements _$$TransactionItemModelImplCopyWith<$Res> {
  __$$TransactionItemModelImplCopyWithImpl(_$TransactionItemModelImpl _value,
      $Res Function(_$TransactionItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? tax = null,
    Object? amount = null,
    Object? unit = freezed,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TransactionItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$TransactionItemModelImpl extends _TransactionItemModel {
  const _$TransactionItemModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.productId,
      @HiveField(2) required this.productName,
      @HiveField(3) this.quantity = 0.0,
      @HiveField(4) this.unitPrice = 0.0,
      @HiveField(5) this.discount = 0.0,
      @HiveField(6) this.tax = 0.0,
      @HiveField(7) this.amount = 0.0,
      @HiveField(8) this.unit,
      @HiveField(9) this.description,
      @HiveField(10) this.createdAt,
      @HiveField(11) this.updatedAt})
      : super._();

  factory _$TransactionItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionItemModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String productId;
  @override
  @HiveField(2)
  final String productName;
  @override
  @JsonKey()
  @HiveField(3)
  final double quantity;
  @override
  @JsonKey()
  @HiveField(4)
  final double unitPrice;
  @override
  @JsonKey()
  @HiveField(5)
  final double discount;
  @override
  @JsonKey()
  @HiveField(6)
  final double tax;
  @override
  @JsonKey()
  @HiveField(7)
  final double amount;
  @override
  @HiveField(8)
  final String? unit;
  @override
  @HiveField(9)
  final String? description;
  @override
  @HiveField(10)
  final DateTime? createdAt;
  @override
  @HiveField(11)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TransactionItemModel(id: $id, productId: $productId, productName: $productName, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, tax: $tax, amount: $amount, unit: $unit, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      quantity,
      unitPrice,
      discount,
      tax,
      amount,
      unit,
      description,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionItemModelImplCopyWith<_$TransactionItemModelImpl>
      get copyWith =>
          __$$TransactionItemModelImplCopyWithImpl<_$TransactionItemModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionItemModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionItemModel extends TransactionItemModel {
  const factory _TransactionItemModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String productId,
      @HiveField(2) required final String productName,
      @HiveField(3) final double quantity,
      @HiveField(4) final double unitPrice,
      @HiveField(5) final double discount,
      @HiveField(6) final double tax,
      @HiveField(7) final double amount,
      @HiveField(8) final String? unit,
      @HiveField(9) final String? description,
      @HiveField(10) final DateTime? createdAt,
      @HiveField(11) final DateTime? updatedAt}) = _$TransactionItemModelImpl;
  const _TransactionItemModel._() : super._();

  factory _TransactionItemModel.fromJson(Map<String, dynamic> json) =
      _$TransactionItemModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get productId;
  @override
  @HiveField(2)
  String get productName;
  @override
  @HiveField(3)
  double get quantity;
  @override
  @HiveField(4)
  double get unitPrice;
  @override
  @HiveField(5)
  double get discount;
  @override
  @HiveField(6)
  double get tax;
  @override
  @HiveField(7)
  double get amount;
  @override
  @HiveField(8)
  String? get unit;
  @override
  @HiveField(9)
  String? get description;
  @override
  @HiveField(10)
  DateTime? get createdAt;
  @override
  @HiveField(11)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionItemModelImplCopyWith<_$TransactionItemModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
