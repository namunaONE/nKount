// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_rate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaxRateModel _$TaxRateModelFromJson(Map<String, dynamic> json) {
  return _TaxRateModel.fromJson(json);
}

/// @nodoc
mixin _$TaxRateModel {
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get code => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(3)
  double get rate => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(5)
  String get type => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isDefault => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isVat => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isCompound => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get effectiveFrom => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get effectiveTo => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaxRateModelCopyWith<TaxRateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxRateModelCopyWith<$Res> {
  factory $TaxRateModelCopyWith(
          TaxRateModel value, $Res Function(TaxRateModel) then) =
      _$TaxRateModelCopyWithImpl<$Res, TaxRateModel>;
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(2) String code,
      @HiveField(0) String id,
      @HiveField(3) double rate,
      @HiveField(4) String? description,
      @HiveField(5) String type,
      @HiveField(6) bool isActive,
      @HiveField(7) bool isDefault,
      @HiveField(8) bool isVat,
      @HiveField(9) bool isCompound,
      @HiveField(10) DateTime? effectiveFrom,
      @HiveField(11) DateTime? effectiveTo,
      @HiveField(12) DateTime? createdAt,
      @HiveField(13) DateTime? updatedAt});
}

/// @nodoc
class _$TaxRateModelCopyWithImpl<$Res, $Val extends TaxRateModel>
    implements $TaxRateModelCopyWith<$Res> {
  _$TaxRateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? code = null,
    Object? id = null,
    Object? rate = null,
    Object? description = freezed,
    Object? type = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? isVat = null,
    Object? isCompound = null,
    Object? effectiveFrom = freezed,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isVat: null == isVat
          ? _value.isVat
          : isVat // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompound: null == isCompound
          ? _value.isCompound
          : isCompound // ignore: cast_nullable_to_non_nullable
              as bool,
      effectiveFrom: freezed == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$TaxRateModelImplCopyWith<$Res>
    implements $TaxRateModelCopyWith<$Res> {
  factory _$$TaxRateModelImplCopyWith(
          _$TaxRateModelImpl value, $Res Function(_$TaxRateModelImpl) then) =
      __$$TaxRateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String name,
      @HiveField(2) String code,
      @HiveField(0) String id,
      @HiveField(3) double rate,
      @HiveField(4) String? description,
      @HiveField(5) String type,
      @HiveField(6) bool isActive,
      @HiveField(7) bool isDefault,
      @HiveField(8) bool isVat,
      @HiveField(9) bool isCompound,
      @HiveField(10) DateTime? effectiveFrom,
      @HiveField(11) DateTime? effectiveTo,
      @HiveField(12) DateTime? createdAt,
      @HiveField(13) DateTime? updatedAt});
}

/// @nodoc
class __$$TaxRateModelImplCopyWithImpl<$Res>
    extends _$TaxRateModelCopyWithImpl<$Res, _$TaxRateModelImpl>
    implements _$$TaxRateModelImplCopyWith<$Res> {
  __$$TaxRateModelImplCopyWithImpl(
      _$TaxRateModelImpl _value, $Res Function(_$TaxRateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? code = null,
    Object? id = null,
    Object? rate = null,
    Object? description = freezed,
    Object? type = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? isVat = null,
    Object? isCompound = null,
    Object? effectiveFrom = freezed,
    Object? effectiveTo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TaxRateModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isVat: null == isVat
          ? _value.isVat
          : isVat // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompound: null == isCompound
          ? _value.isCompound
          : isCompound // ignore: cast_nullable_to_non_nullable
              as bool,
      effectiveFrom: freezed == effectiveFrom
          ? _value.effectiveFrom
          : effectiveFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      effectiveTo: freezed == effectiveTo
          ? _value.effectiveTo
          : effectiveTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$TaxRateModelImpl extends _TaxRateModel {
  const _$TaxRateModelImpl(
      {@HiveField(1) required this.name,
      @HiveField(2) required this.code,
      @HiveField(0) this.id = '',
      @HiveField(3) this.rate = 0.0,
      @HiveField(4) this.description,
      @HiveField(5) this.type = 'percentage',
      @HiveField(6) this.isActive = true,
      @HiveField(7) this.isDefault = false,
      @HiveField(8) this.isVat = false,
      @HiveField(9) this.isCompound = false,
      @HiveField(10) this.effectiveFrom,
      @HiveField(11) this.effectiveTo,
      @HiveField(12) this.createdAt,
      @HiveField(13) this.updatedAt})
      : super._();

  factory _$TaxRateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxRateModelImplFromJson(json);

  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String code;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @JsonKey()
  @HiveField(3)
  final double rate;
  @override
  @HiveField(4)
  final String? description;
  @override
  @JsonKey()
  @HiveField(5)
  final String type;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isDefault;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isVat;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isCompound;
  @override
  @HiveField(10)
  final DateTime? effectiveFrom;
  @override
  @HiveField(11)
  final DateTime? effectiveTo;
  @override
  @HiveField(12)
  final DateTime? createdAt;
  @override
  @HiveField(13)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TaxRateModel(name: $name, code: $code, id: $id, rate: $rate, description: $description, type: $type, isActive: $isActive, isDefault: $isDefault, isVat: $isVat, isCompound: $isCompound, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxRateModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isVat, isVat) || other.isVat == isVat) &&
            (identical(other.isCompound, isCompound) ||
                other.isCompound == isCompound) &&
            (identical(other.effectiveFrom, effectiveFrom) ||
                other.effectiveFrom == effectiveFrom) &&
            (identical(other.effectiveTo, effectiveTo) ||
                other.effectiveTo == effectiveTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      code,
      id,
      rate,
      description,
      type,
      isActive,
      isDefault,
      isVat,
      isCompound,
      effectiveFrom,
      effectiveTo,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxRateModelImplCopyWith<_$TaxRateModelImpl> get copyWith =>
      __$$TaxRateModelImplCopyWithImpl<_$TaxRateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxRateModelImplToJson(
      this,
    );
  }
}

abstract class _TaxRateModel extends TaxRateModel {
  const factory _TaxRateModel(
      {@HiveField(1) required final String name,
      @HiveField(2) required final String code,
      @HiveField(0) final String id,
      @HiveField(3) final double rate,
      @HiveField(4) final String? description,
      @HiveField(5) final String type,
      @HiveField(6) final bool isActive,
      @HiveField(7) final bool isDefault,
      @HiveField(8) final bool isVat,
      @HiveField(9) final bool isCompound,
      @HiveField(10) final DateTime? effectiveFrom,
      @HiveField(11) final DateTime? effectiveTo,
      @HiveField(12) final DateTime? createdAt,
      @HiveField(13) final DateTime? updatedAt}) = _$TaxRateModelImpl;
  const _TaxRateModel._() : super._();

  factory _TaxRateModel.fromJson(Map<String, dynamic> json) =
      _$TaxRateModelImpl.fromJson;

  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get code;
  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(3)
  double get rate;
  @override
  @HiveField(4)
  String? get description;
  @override
  @HiveField(5)
  String get type;
  @override
  @HiveField(6)
  bool get isActive;
  @override
  @HiveField(7)
  bool get isDefault;
  @override
  @HiveField(8)
  bool get isVat;
  @override
  @HiveField(9)
  bool get isCompound;
  @override
  @HiveField(10)
  DateTime? get effectiveFrom;
  @override
  @HiveField(11)
  DateTime? get effectiveTo;
  @override
  @HiveField(12)
  DateTime? get createdAt;
  @override
  @HiveField(13)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TaxRateModelImplCopyWith<_$TaxRateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
