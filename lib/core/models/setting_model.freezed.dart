// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) {
  return _SettingModel.fromJson(json);
}

/// @nodoc
mixin _$SettingModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get key => throw _privateConstructorUsedError;
  @HiveField(2)
  dynamic get value => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(4)
  String get category => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isSystemSetting => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isEditable => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get companyId => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingModelCopyWith<SettingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingModelCopyWith<$Res> {
  factory $SettingModelCopyWith(
          SettingModel value, $Res Function(SettingModel) then) =
      _$SettingModelCopyWithImpl<$Res, SettingModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String key,
      @HiveField(2) dynamic value,
      @HiveField(3) String? description,
      @HiveField(4) String category,
      @HiveField(5) bool isSystemSetting,
      @HiveField(6) bool isEditable,
      @HiveField(7) String? companyId,
      @HiveField(8) DateTime? createdAt,
      @HiveField(9) DateTime? updatedAt});
}

/// @nodoc
class _$SettingModelCopyWithImpl<$Res, $Val extends SettingModel>
    implements $SettingModelCopyWith<$Res> {
  _$SettingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = freezed,
    Object? description = freezed,
    Object? category = null,
    Object? isSystemSetting = null,
    Object? isEditable = null,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSystemSetting: null == isSystemSetting
          ? _value.isSystemSetting
          : isSystemSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SettingModelImplCopyWith<$Res>
    implements $SettingModelCopyWith<$Res> {
  factory _$$SettingModelImplCopyWith(
          _$SettingModelImpl value, $Res Function(_$SettingModelImpl) then) =
      __$$SettingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String key,
      @HiveField(2) dynamic value,
      @HiveField(3) String? description,
      @HiveField(4) String category,
      @HiveField(5) bool isSystemSetting,
      @HiveField(6) bool isEditable,
      @HiveField(7) String? companyId,
      @HiveField(8) DateTime? createdAt,
      @HiveField(9) DateTime? updatedAt});
}

/// @nodoc
class __$$SettingModelImplCopyWithImpl<$Res>
    extends _$SettingModelCopyWithImpl<$Res, _$SettingModelImpl>
    implements _$$SettingModelImplCopyWith<$Res> {
  __$$SettingModelImplCopyWithImpl(
      _$SettingModelImpl _value, $Res Function(_$SettingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? value = freezed,
    Object? description = freezed,
    Object? category = null,
    Object? isSystemSetting = null,
    Object? isEditable = null,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SettingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSystemSetting: null == isSystemSetting
          ? _value.isSystemSetting
          : isSystemSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
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
class _$SettingModelImpl extends _SettingModel {
  const _$SettingModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.key,
      @HiveField(2) required this.value,
      @HiveField(3) this.description,
      @HiveField(4) this.category = 'app',
      @HiveField(5) this.isSystemSetting = false,
      @HiveField(6) this.isEditable = true,
      @HiveField(7) this.companyId,
      @HiveField(8) this.createdAt,
      @HiveField(9) this.updatedAt})
      : super._();

  factory _$SettingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String key;
  @override
  @HiveField(2)
  final dynamic value;
  @override
  @HiveField(3)
  final String? description;
  @override
  @JsonKey()
  @HiveField(4)
  final String category;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isSystemSetting;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isEditable;
  @override
  @HiveField(7)
  final String? companyId;
  @override
  @HiveField(8)
  final DateTime? createdAt;
  @override
  @HiveField(9)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SettingModel(id: $id, key: $key, value: $value, description: $description, category: $category, isSystemSetting: $isSystemSetting, isEditable: $isEditable, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSystemSetting, isSystemSetting) ||
                other.isSystemSetting == isSystemSetting) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
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
      key,
      const DeepCollectionEquality().hash(value),
      description,
      category,
      isSystemSetting,
      isEditable,
      companyId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingModelImplCopyWith<_$SettingModelImpl> get copyWith =>
      __$$SettingModelImplCopyWithImpl<_$SettingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingModelImplToJson(
      this,
    );
  }
}

abstract class _SettingModel extends SettingModel {
  const factory _SettingModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String key,
      @HiveField(2) required final dynamic value,
      @HiveField(3) final String? description,
      @HiveField(4) final String category,
      @HiveField(5) final bool isSystemSetting,
      @HiveField(6) final bool isEditable,
      @HiveField(7) final String? companyId,
      @HiveField(8) final DateTime? createdAt,
      @HiveField(9) final DateTime? updatedAt}) = _$SettingModelImpl;
  const _SettingModel._() : super._();

  factory _SettingModel.fromJson(Map<String, dynamic> json) =
      _$SettingModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get key;
  @override
  @HiveField(2)
  dynamic get value;
  @override
  @HiveField(3)
  String? get description;
  @override
  @HiveField(4)
  String get category;
  @override
  @HiveField(5)
  bool get isSystemSetting;
  @override
  @HiveField(6)
  bool get isEditable;
  @override
  @HiveField(7)
  String? get companyId;
  @override
  @HiveField(8)
  DateTime? get createdAt;
  @override
  @HiveField(9)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SettingModelImplCopyWith<_$SettingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
