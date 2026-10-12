// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get code => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get barcode => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get category => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get unit => throw _privateConstructorUsedError;
  @HiveField(7)
  double get purchasePrice => throw _privateConstructorUsedError;
  @HiveField(8)
  double get salePrice => throw _privateConstructorUsedError;
  @HiveField(9)
  double get costPrice => throw _privateConstructorUsedError;
  @HiveField(10)
  double get quantity => throw _privateConstructorUsedError;
  @HiveField(11)
  double get minQuantity => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isTaxable => throw _privateConstructorUsedError;
  @HiveField(13)
  double get taxRate => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get supplierId => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(17)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(18)
  double get totalPurchased => throw _privateConstructorUsedError;
  @HiveField(19)
  double get totalSold => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(21)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? code,
      @HiveField(3) String? barcode,
      @HiveField(4) String? category,
      @HiveField(5) String? brand,
      @HiveField(6) String? unit,
      @HiveField(7) double purchasePrice,
      @HiveField(8) double salePrice,
      @HiveField(9) double costPrice,
      @HiveField(10) double quantity,
      @HiveField(11) double minQuantity,
      @HiveField(12) bool isTaxable,
      @HiveField(13) double taxRate,
      @HiveField(14) String? description,
      @HiveField(15) String? supplierId,
      @HiveField(16) bool isActive,
      @HiveField(17) String? imageUrl,
      @HiveField(18) double totalPurchased,
      @HiveField(19) double totalSold,
      @HiveField(20) DateTime? createdAt,
      @HiveField(21) DateTime? updatedAt});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? barcode = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? costPrice = null,
    Object? quantity = null,
    Object? minQuantity = null,
    Object? isTaxable = null,
    Object? taxRate = null,
    Object? description = freezed,
    Object? supplierId = freezed,
    Object? isActive = null,
    Object? imageUrl = freezed,
    Object? totalPurchased = null,
    Object? totalSold = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      minQuantity: null == minQuantity
          ? _value.minQuantity
          : minQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      isTaxable: null == isTaxable
          ? _value.isTaxable
          : isTaxable // ignore: cast_nullable_to_non_nullable
              as bool,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPurchased: null == totalPurchased
          ? _value.totalPurchased
          : totalPurchased // ignore: cast_nullable_to_non_nullable
              as double,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? code,
      @HiveField(3) String? barcode,
      @HiveField(4) String? category,
      @HiveField(5) String? brand,
      @HiveField(6) String? unit,
      @HiveField(7) double purchasePrice,
      @HiveField(8) double salePrice,
      @HiveField(9) double costPrice,
      @HiveField(10) double quantity,
      @HiveField(11) double minQuantity,
      @HiveField(12) bool isTaxable,
      @HiveField(13) double taxRate,
      @HiveField(14) String? description,
      @HiveField(15) String? supplierId,
      @HiveField(16) bool isActive,
      @HiveField(17) String? imageUrl,
      @HiveField(18) double totalPurchased,
      @HiveField(19) double totalSold,
      @HiveField(20) DateTime? createdAt,
      @HiveField(21) DateTime? updatedAt});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? barcode = freezed,
    Object? category = freezed,
    Object? brand = freezed,
    Object? unit = freezed,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? costPrice = null,
    Object? quantity = null,
    Object? minQuantity = null,
    Object? isTaxable = null,
    Object? taxRate = null,
    Object? description = freezed,
    Object? supplierId = freezed,
    Object? isActive = null,
    Object? imageUrl = freezed,
    Object? totalPurchased = null,
    Object? totalSold = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
      costPrice: null == costPrice
          ? _value.costPrice
          : costPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      minQuantity: null == minQuantity
          ? _value.minQuantity
          : minQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      isTaxable: null == isTaxable
          ? _value.isTaxable
          : isTaxable // ignore: cast_nullable_to_non_nullable
              as bool,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPurchased: null == totalPurchased
          ? _value.totalPurchased
          : totalPurchased // ignore: cast_nullable_to_non_nullable
              as double,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
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
class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.name,
      @HiveField(2) this.code,
      @HiveField(3) this.barcode,
      @HiveField(4) this.category,
      @HiveField(5) this.brand,
      @HiveField(6) this.unit,
      @HiveField(7) this.purchasePrice = 0.0,
      @HiveField(8) this.salePrice = 0.0,
      @HiveField(9) this.costPrice = 0.0,
      @HiveField(10) this.quantity = 0.0,
      @HiveField(11) this.minQuantity = 0.0,
      @HiveField(12) this.isTaxable = false,
      @HiveField(13) this.taxRate = 13.0,
      @HiveField(14) this.description,
      @HiveField(15) this.supplierId,
      @HiveField(16) this.isActive = true,
      @HiveField(17) this.imageUrl,
      @HiveField(18) this.totalPurchased = 0.0,
      @HiveField(19) this.totalSold = 0.0,
      @HiveField(20) this.createdAt,
      @HiveField(21) this.updatedAt})
      : super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String? code;
  @override
  @HiveField(3)
  final String? barcode;
  @override
  @HiveField(4)
  final String? category;
  @override
  @HiveField(5)
  final String? brand;
  @override
  @HiveField(6)
  final String? unit;
  @override
  @JsonKey()
  @HiveField(7)
  final double purchasePrice;
  @override
  @JsonKey()
  @HiveField(8)
  final double salePrice;
  @override
  @JsonKey()
  @HiveField(9)
  final double costPrice;
  @override
  @JsonKey()
  @HiveField(10)
  final double quantity;
  @override
  @JsonKey()
  @HiveField(11)
  final double minQuantity;
  @override
  @JsonKey()
  @HiveField(12)
  final bool isTaxable;
  @override
  @JsonKey()
  @HiveField(13)
  final double taxRate;
  @override
  @HiveField(14)
  final String? description;
  @override
  @HiveField(15)
  final String? supplierId;
  @override
  @JsonKey()
  @HiveField(16)
  final bool isActive;
  @override
  @HiveField(17)
  final String? imageUrl;
  @override
  @JsonKey()
  @HiveField(18)
  final double totalPurchased;
  @override
  @JsonKey()
  @HiveField(19)
  final double totalSold;
  @override
  @HiveField(20)
  final DateTime? createdAt;
  @override
  @HiveField(21)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, code: $code, barcode: $barcode, category: $category, brand: $brand, unit: $unit, purchasePrice: $purchasePrice, salePrice: $salePrice, costPrice: $costPrice, quantity: $quantity, minQuantity: $minQuantity, isTaxable: $isTaxable, taxRate: $taxRate, description: $description, supplierId: $supplierId, isActive: $isActive, imageUrl: $imageUrl, totalPurchased: $totalPurchased, totalSold: $totalSold, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.costPrice, costPrice) ||
                other.costPrice == costPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.minQuantity, minQuantity) ||
                other.minQuantity == minQuantity) &&
            (identical(other.isTaxable, isTaxable) ||
                other.isTaxable == isTaxable) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.totalPurchased, totalPurchased) ||
                other.totalPurchased == totalPurchased) &&
            (identical(other.totalSold, totalSold) ||
                other.totalSold == totalSold) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        code,
        barcode,
        category,
        brand,
        unit,
        purchasePrice,
        salePrice,
        costPrice,
        quantity,
        minQuantity,
        isTaxable,
        taxRate,
        description,
        supplierId,
        isActive,
        imageUrl,
        totalPurchased,
        totalSold,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String name,
      @HiveField(2) final String? code,
      @HiveField(3) final String? barcode,
      @HiveField(4) final String? category,
      @HiveField(5) final String? brand,
      @HiveField(6) final String? unit,
      @HiveField(7) final double purchasePrice,
      @HiveField(8) final double salePrice,
      @HiveField(9) final double costPrice,
      @HiveField(10) final double quantity,
      @HiveField(11) final double minQuantity,
      @HiveField(12) final bool isTaxable,
      @HiveField(13) final double taxRate,
      @HiveField(14) final String? description,
      @HiveField(15) final String? supplierId,
      @HiveField(16) final bool isActive,
      @HiveField(17) final String? imageUrl,
      @HiveField(18) final double totalPurchased,
      @HiveField(19) final double totalSold,
      @HiveField(20) final DateTime? createdAt,
      @HiveField(21) final DateTime? updatedAt}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String? get code;
  @override
  @HiveField(3)
  String? get barcode;
  @override
  @HiveField(4)
  String? get category;
  @override
  @HiveField(5)
  String? get brand;
  @override
  @HiveField(6)
  String? get unit;
  @override
  @HiveField(7)
  double get purchasePrice;
  @override
  @HiveField(8)
  double get salePrice;
  @override
  @HiveField(9)
  double get costPrice;
  @override
  @HiveField(10)
  double get quantity;
  @override
  @HiveField(11)
  double get minQuantity;
  @override
  @HiveField(12)
  bool get isTaxable;
  @override
  @HiveField(13)
  double get taxRate;
  @override
  @HiveField(14)
  String? get description;
  @override
  @HiveField(15)
  String? get supplierId;
  @override
  @HiveField(16)
  bool get isActive;
  @override
  @HiveField(17)
  String? get imageUrl;
  @override
  @HiveField(18)
  double get totalPurchased;
  @override
  @HiveField(19)
  double get totalSold;
  @override
  @HiveField(20)
  DateTime? get createdAt;
  @override
  @HiveField(21)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
