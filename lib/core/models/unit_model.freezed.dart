// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) {
  return _UnitModel.fromJson(json);
}

/// @nodoc
mixin _$UnitModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get code => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(4)
  double get baseUnitMultiplier => throw _privateConstructorUsedError;
  @HiveField(5)
  String get baseUnitId => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isBaseUnit => throw _privateConstructorUsedError;
  @HiveField(8)
  int get sortOrder => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnitModelCopyWith<UnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitModelCopyWith<$Res> {
  factory $UnitModelCopyWith(UnitModel value, $Res Function(UnitModel) then) =
      _$UnitModelCopyWithImpl<$Res, UnitModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String code,
      @HiveField(3) String? description,
      @HiveField(4) double baseUnitMultiplier,
      @HiveField(5) String baseUnitId,
      @HiveField(6) bool isActive,
      @HiveField(7) bool isBaseUnit,
      @HiveField(8) int sortOrder,
      @HiveField(9) DateTime? createdAt,
      @HiveField(10) DateTime? updatedAt});
}

/// @nodoc
class _$UnitModelCopyWithImpl<$Res, $Val extends UnitModel>
    implements $UnitModelCopyWith<$Res> {
  _$UnitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? baseUnitMultiplier = null,
    Object? baseUnitId = null,
    Object? isActive = null,
    Object? isBaseUnit = null,
    Object? sortOrder = null,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      baseUnitMultiplier: null == baseUnitMultiplier
          ? _value.baseUnitMultiplier
          : baseUnitMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      baseUnitId: null == baseUnitId
          ? _value.baseUnitId
          : baseUnitId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBaseUnit: null == isBaseUnit
          ? _value.isBaseUnit
          : isBaseUnit // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$UnitModelImplCopyWith<$Res>
    implements $UnitModelCopyWith<$Res> {
  factory _$$UnitModelImplCopyWith(
          _$UnitModelImpl value, $Res Function(_$UnitModelImpl) then) =
      __$$UnitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String code,
      @HiveField(3) String? description,
      @HiveField(4) double baseUnitMultiplier,
      @HiveField(5) String baseUnitId,
      @HiveField(6) bool isActive,
      @HiveField(7) bool isBaseUnit,
      @HiveField(8) int sortOrder,
      @HiveField(9) DateTime? createdAt,
      @HiveField(10) DateTime? updatedAt});
}

/// @nodoc
class __$$UnitModelImplCopyWithImpl<$Res>
    extends _$UnitModelCopyWithImpl<$Res, _$UnitModelImpl>
    implements _$$UnitModelImplCopyWith<$Res> {
  __$$UnitModelImplCopyWithImpl(
      _$UnitModelImpl _value, $Res Function(_$UnitModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? baseUnitMultiplier = null,
    Object? baseUnitId = null,
    Object? isActive = null,
    Object? isBaseUnit = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UnitModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      baseUnitMultiplier: null == baseUnitMultiplier
          ? _value.baseUnitMultiplier
          : baseUnitMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      baseUnitId: null == baseUnitId
          ? _value.baseUnitId
          : baseUnitId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBaseUnit: null == isBaseUnit
          ? _value.isBaseUnit
          : isBaseUnit // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$UnitModelImpl extends _UnitModel {
  const _$UnitModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.name,
      @HiveField(2) required this.code,
      @HiveField(3) this.description,
      @HiveField(4) this.baseUnitMultiplier = 1.0,
      @HiveField(5) this.baseUnitId = '',
      @HiveField(6) this.isActive = true,
      @HiveField(7) this.isBaseUnit = false,
      @HiveField(8) this.sortOrder = 0,
      @HiveField(9) this.createdAt,
      @HiveField(10) this.updatedAt})
      : super._();

  factory _$UnitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnitModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String code;
  @override
  @HiveField(3)
  final String? description;
  @override
  @JsonKey()
  @HiveField(4)
  final double baseUnitMultiplier;
  @override
  @JsonKey()
  @HiveField(5)
  final String baseUnitId;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isBaseUnit;
  @override
  @JsonKey()
  @HiveField(8)
  final int sortOrder;
  @override
  @HiveField(9)
  final DateTime? createdAt;
  @override
  @HiveField(10)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UnitModel(id: $id, name: $name, code: $code, description: $description, baseUnitMultiplier: $baseUnitMultiplier, baseUnitId: $baseUnitId, isActive: $isActive, isBaseUnit: $isBaseUnit, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.baseUnitMultiplier, baseUnitMultiplier) ||
                other.baseUnitMultiplier == baseUnitMultiplier) &&
            (identical(other.baseUnitId, baseUnitId) ||
                other.baseUnitId == baseUnitId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBaseUnit, isBaseUnit) ||
                other.isBaseUnit == isBaseUnit) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
      name,
      code,
      description,
      baseUnitMultiplier,
      baseUnitId,
      isActive,
      isBaseUnit,
      sortOrder,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      __$$UnitModelImplCopyWithImpl<_$UnitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnitModelImplToJson(
      this,
    );
  }
}

abstract class _UnitModel extends UnitModel {
  const factory _UnitModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String code,
      @HiveField(3) final String? description,
      @HiveField(4) final double baseUnitMultiplier,
      @HiveField(5) final String baseUnitId,
      @HiveField(6) final bool isActive,
      @HiveField(7) final bool isBaseUnit,
      @HiveField(8) final int sortOrder,
      @HiveField(9) final DateTime? createdAt,
      @HiveField(10) final DateTime? updatedAt}) = _$UnitModelImpl;
  const _UnitModel._() : super._();

  factory _UnitModel.fromJson(Map<String, dynamic> json) =
      _$UnitModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get code;
  @override
  @HiveField(3)
  String? get description;
  @override
  @HiveField(4)
  double get baseUnitMultiplier;
  @override
  @HiveField(5)
  String get baseUnitId;
  @override
  @HiveField(6)
  bool get isActive;
  @override
  @HiveField(7)
  bool get isBaseUnit;
  @override
  @HiveField(8)
  int get sortOrder;
  @override
  @HiveField(9)
  DateTime? get createdAt;
  @override
  @HiveField(10)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UnitModelImplCopyWith<_$UnitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
