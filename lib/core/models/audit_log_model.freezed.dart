// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) {
  return _AuditLogModel.fromJson(json);
}

/// @nodoc
mixin _$AuditLogModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get entityType => throw _privateConstructorUsedError;
  @HiveField(2)
  String get entityId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get action => throw _privateConstructorUsedError;
  @HiveField(4)
  Map<String, dynamic>? get oldValues => throw _privateConstructorUsedError;
  @HiveField(5)
  Map<String, dynamic>? get newValues => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get companyId => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get userId => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get userName => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get ipAddress => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get userAgent => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isSystemAction => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get isReversed => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get reversedBy => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get reversedAt => throw _privateConstructorUsedError;
  @HiveField(16)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditLogModelCopyWith<AuditLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogModelCopyWith<$Res> {
  factory $AuditLogModelCopyWith(
          AuditLogModel value, $Res Function(AuditLogModel) then) =
      _$AuditLogModelCopyWithImpl<$Res, AuditLogModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String entityType,
      @HiveField(2) String entityId,
      @HiveField(3) String action,
      @HiveField(4) Map<String, dynamic>? oldValues,
      @HiveField(5) Map<String, dynamic>? newValues,
      @HiveField(6) String? description,
      @HiveField(7) String? companyId,
      @HiveField(8) String? userId,
      @HiveField(9) String? userName,
      @HiveField(10) String? ipAddress,
      @HiveField(11) String? userAgent,
      @HiveField(12) bool isSystemAction,
      @HiveField(13) bool isReversed,
      @HiveField(14) String? reversedBy,
      @HiveField(15) DateTime? reversedAt,
      @HiveField(16) DateTime? createdAt,
      @HiveField(17) DateTime? updatedAt});
}

/// @nodoc
class _$AuditLogModelCopyWithImpl<$Res, $Val extends AuditLogModel>
    implements $AuditLogModelCopyWith<$Res> {
  _$AuditLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? description = freezed,
    Object? companyId = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? isSystemAction = null,
    Object? isReversed = null,
    Object? reversedBy = freezed,
    Object? reversedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      oldValues: freezed == oldValues
          ? _value.oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value.newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      isSystemAction: null == isSystemAction
          ? _value.isSystemAction
          : isSystemAction // ignore: cast_nullable_to_non_nullable
              as bool,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
      reversedBy: freezed == reversedBy
          ? _value.reversedBy
          : reversedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reversedAt: freezed == reversedAt
          ? _value.reversedAt
          : reversedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AuditLogModelImplCopyWith<$Res>
    implements $AuditLogModelCopyWith<$Res> {
  factory _$$AuditLogModelImplCopyWith(
          _$AuditLogModelImpl value, $Res Function(_$AuditLogModelImpl) then) =
      __$$AuditLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String entityType,
      @HiveField(2) String entityId,
      @HiveField(3) String action,
      @HiveField(4) Map<String, dynamic>? oldValues,
      @HiveField(5) Map<String, dynamic>? newValues,
      @HiveField(6) String? description,
      @HiveField(7) String? companyId,
      @HiveField(8) String? userId,
      @HiveField(9) String? userName,
      @HiveField(10) String? ipAddress,
      @HiveField(11) String? userAgent,
      @HiveField(12) bool isSystemAction,
      @HiveField(13) bool isReversed,
      @HiveField(14) String? reversedBy,
      @HiveField(15) DateTime? reversedAt,
      @HiveField(16) DateTime? createdAt,
      @HiveField(17) DateTime? updatedAt});
}

/// @nodoc
class __$$AuditLogModelImplCopyWithImpl<$Res>
    extends _$AuditLogModelCopyWithImpl<$Res, _$AuditLogModelImpl>
    implements _$$AuditLogModelImplCopyWith<$Res> {
  __$$AuditLogModelImplCopyWithImpl(
      _$AuditLogModelImpl _value, $Res Function(_$AuditLogModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? description = freezed,
    Object? companyId = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? isSystemAction = null,
    Object? isReversed = null,
    Object? reversedBy = freezed,
    Object? reversedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AuditLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      oldValues: freezed == oldValues
          ? _value._oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value._newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      isSystemAction: null == isSystemAction
          ? _value.isSystemAction
          : isSystemAction // ignore: cast_nullable_to_non_nullable
              as bool,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
      reversedBy: freezed == reversedBy
          ? _value.reversedBy
          : reversedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reversedAt: freezed == reversedAt
          ? _value.reversedAt
          : reversedAt // ignore: cast_nullable_to_non_nullable
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
class _$AuditLogModelImpl extends _AuditLogModel {
  const _$AuditLogModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.entityType,
      @HiveField(2) required this.entityId,
      @HiveField(3) required this.action,
      @HiveField(4) final Map<String, dynamic>? oldValues,
      @HiveField(5) final Map<String, dynamic>? newValues,
      @HiveField(6) this.description,
      @HiveField(7) this.companyId,
      @HiveField(8) this.userId,
      @HiveField(9) this.userName,
      @HiveField(10) this.ipAddress,
      @HiveField(11) this.userAgent,
      @HiveField(12) this.isSystemAction = false,
      @HiveField(13) this.isReversed = false,
      @HiveField(14) this.reversedBy,
      @HiveField(15) this.reversedAt,
      @HiveField(16) this.createdAt,
      @HiveField(17) this.updatedAt})
      : _oldValues = oldValues,
        _newValues = newValues,
        super._();

  factory _$AuditLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String entityType;
  @override
  @HiveField(2)
  final String entityId;
  @override
  @HiveField(3)
  final String action;
  final Map<String, dynamic>? _oldValues;
  @override
  @HiveField(4)
  Map<String, dynamic>? get oldValues {
    final value = _oldValues;
    if (value == null) return null;
    if (_oldValues is EqualUnmodifiableMapView) return _oldValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newValues;
  @override
  @HiveField(5)
  Map<String, dynamic>? get newValues {
    final value = _newValues;
    if (value == null) return null;
    if (_newValues is EqualUnmodifiableMapView) return _newValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(6)
  final String? description;
  @override
  @HiveField(7)
  final String? companyId;
  @override
  @HiveField(8)
  final String? userId;
  @override
  @HiveField(9)
  final String? userName;
  @override
  @HiveField(10)
  final String? ipAddress;
  @override
  @HiveField(11)
  final String? userAgent;
  @override
  @JsonKey()
  @HiveField(12)
  final bool isSystemAction;
  @override
  @JsonKey()
  @HiveField(13)
  final bool isReversed;
  @override
  @HiveField(14)
  final String? reversedBy;
  @override
  @HiveField(15)
  final DateTime? reversedAt;
  @override
  @HiveField(16)
  final DateTime? createdAt;
  @override
  @HiveField(17)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AuditLogModel(id: $id, entityType: $entityType, entityId: $entityId, action: $action, oldValues: $oldValues, newValues: $newValues, description: $description, companyId: $companyId, userId: $userId, userName: $userName, ipAddress: $ipAddress, userAgent: $userAgent, isSystemAction: $isSystemAction, isReversed: $isReversed, reversedBy: $reversedBy, reversedAt: $reversedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality()
                .equals(other._oldValues, _oldValues) &&
            const DeepCollectionEquality()
                .equals(other._newValues, _newValues) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.isSystemAction, isSystemAction) ||
                other.isSystemAction == isSystemAction) &&
            (identical(other.isReversed, isReversed) ||
                other.isReversed == isReversed) &&
            (identical(other.reversedBy, reversedBy) ||
                other.reversedBy == reversedBy) &&
            (identical(other.reversedAt, reversedAt) ||
                other.reversedAt == reversedAt) &&
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
      entityType,
      entityId,
      action,
      const DeepCollectionEquality().hash(_oldValues),
      const DeepCollectionEquality().hash(_newValues),
      description,
      companyId,
      userId,
      userName,
      ipAddress,
      userAgent,
      isSystemAction,
      isReversed,
      reversedBy,
      reversedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      __$$AuditLogModelImplCopyWithImpl<_$AuditLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogModelImplToJson(
      this,
    );
  }
}

abstract class _AuditLogModel extends AuditLogModel {
  const factory _AuditLogModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String entityType,
      @HiveField(2) required final String entityId,
      @HiveField(3) required final String action,
      @HiveField(4) final Map<String, dynamic>? oldValues,
      @HiveField(5) final Map<String, dynamic>? newValues,
      @HiveField(6) final String? description,
      @HiveField(7) final String? companyId,
      @HiveField(8) final String? userId,
      @HiveField(9) final String? userName,
      @HiveField(10) final String? ipAddress,
      @HiveField(11) final String? userAgent,
      @HiveField(12) final bool isSystemAction,
      @HiveField(13) final bool isReversed,
      @HiveField(14) final String? reversedBy,
      @HiveField(15) final DateTime? reversedAt,
      @HiveField(16) final DateTime? createdAt,
      @HiveField(17) final DateTime? updatedAt}) = _$AuditLogModelImpl;
  const _AuditLogModel._() : super._();

  factory _AuditLogModel.fromJson(Map<String, dynamic> json) =
      _$AuditLogModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get entityType;
  @override
  @HiveField(2)
  String get entityId;
  @override
  @HiveField(3)
  String get action;
  @override
  @HiveField(4)
  Map<String, dynamic>? get oldValues;
  @override
  @HiveField(5)
  Map<String, dynamic>? get newValues;
  @override
  @HiveField(6)
  String? get description;
  @override
  @HiveField(7)
  String? get companyId;
  @override
  @HiveField(8)
  String? get userId;
  @override
  @HiveField(9)
  String? get userName;
  @override
  @HiveField(10)
  String? get ipAddress;
  @override
  @HiveField(11)
  String? get userAgent;
  @override
  @HiveField(12)
  bool get isSystemAction;
  @override
  @HiveField(13)
  bool get isReversed;
  @override
  @HiveField(14)
  String? get reversedBy;
  @override
  @HiveField(15)
  DateTime? get reversedAt;
  @override
  @HiveField(16)
  DateTime? get createdAt;
  @override
  @HiveField(17)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
