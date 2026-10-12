// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncLogModel _$SyncLogModelFromJson(Map<String, dynamic> json) {
  return _SyncLogModel.fromJson(json);
}

/// @nodoc
mixin _$SyncLogModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get entityType => throw _privateConstructorUsedError;
  @HiveField(2)
  String get entityId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get action => throw _privateConstructorUsedError;
  @HiveField(4)
  String get status => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get requestId => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get responseId => throw _privateConstructorUsedError;
  @HiveField(7)
  int get retryCount => throw _privateConstructorUsedError;
  @HiveField(8)
  int get maxRetries => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get errorMessage => throw _privateConstructorUsedError;
  @HiveField(10)
  Map<String, dynamic>? get requestData => throw _privateConstructorUsedError;
  @HiveField(11)
  Map<String, dynamic>? get responseData => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isConflict => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get conflictResolution => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get conflictResolvedAt => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(16)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @HiveField(18)
  String? get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SyncLogModelCopyWith<SyncLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncLogModelCopyWith<$Res> {
  factory $SyncLogModelCopyWith(
          SyncLogModel value, $Res Function(SyncLogModel) then) =
      _$SyncLogModelCopyWithImpl<$Res, SyncLogModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String entityType,
      @HiveField(2) String entityId,
      @HiveField(3) String action,
      @HiveField(4) String status,
      @HiveField(5) String? requestId,
      @HiveField(6) String? responseId,
      @HiveField(7) int retryCount,
      @HiveField(8) int maxRetries,
      @HiveField(9) String? errorMessage,
      @HiveField(10) Map<String, dynamic>? requestData,
      @HiveField(11) Map<String, dynamic>? responseData,
      @HiveField(12) bool isConflict,
      @HiveField(13) String? conflictResolution,
      @HiveField(14) DateTime? conflictResolvedAt,
      @HiveField(15) DateTime? createdAt,
      @HiveField(16) DateTime? updatedAt,
      @HiveField(17) DateTime? completedAt,
      @HiveField(18) String? createdBy});
}

/// @nodoc
class _$SyncLogModelCopyWithImpl<$Res, $Val extends SyncLogModel>
    implements $SyncLogModelCopyWith<$Res> {
  _$SyncLogModelCopyWithImpl(this._value, this._then);

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
    Object? status = null,
    Object? requestId = freezed,
    Object? responseId = freezed,
    Object? retryCount = null,
    Object? maxRetries = null,
    Object? errorMessage = freezed,
    Object? requestData = freezed,
    Object? responseData = freezed,
    Object? isConflict = null,
    Object? conflictResolution = freezed,
    Object? conflictResolvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      responseId: freezed == responseId
          ? _value.responseId
          : responseId // ignore: cast_nullable_to_non_nullable
              as String?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      requestData: freezed == requestData
          ? _value.requestData
          : requestData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      responseData: freezed == responseData
          ? _value.responseData
          : responseData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isConflict: null == isConflict
          ? _value.isConflict
          : isConflict // ignore: cast_nullable_to_non_nullable
              as bool,
      conflictResolution: freezed == conflictResolution
          ? _value.conflictResolution
          : conflictResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      conflictResolvedAt: freezed == conflictResolvedAt
          ? _value.conflictResolvedAt
          : conflictResolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncLogModelImplCopyWith<$Res>
    implements $SyncLogModelCopyWith<$Res> {
  factory _$$SyncLogModelImplCopyWith(
          _$SyncLogModelImpl value, $Res Function(_$SyncLogModelImpl) then) =
      __$$SyncLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String entityType,
      @HiveField(2) String entityId,
      @HiveField(3) String action,
      @HiveField(4) String status,
      @HiveField(5) String? requestId,
      @HiveField(6) String? responseId,
      @HiveField(7) int retryCount,
      @HiveField(8) int maxRetries,
      @HiveField(9) String? errorMessage,
      @HiveField(10) Map<String, dynamic>? requestData,
      @HiveField(11) Map<String, dynamic>? responseData,
      @HiveField(12) bool isConflict,
      @HiveField(13) String? conflictResolution,
      @HiveField(14) DateTime? conflictResolvedAt,
      @HiveField(15) DateTime? createdAt,
      @HiveField(16) DateTime? updatedAt,
      @HiveField(17) DateTime? completedAt,
      @HiveField(18) String? createdBy});
}

/// @nodoc
class __$$SyncLogModelImplCopyWithImpl<$Res>
    extends _$SyncLogModelCopyWithImpl<$Res, _$SyncLogModelImpl>
    implements _$$SyncLogModelImplCopyWith<$Res> {
  __$$SyncLogModelImplCopyWithImpl(
      _$SyncLogModelImpl _value, $Res Function(_$SyncLogModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? status = null,
    Object? requestId = freezed,
    Object? responseId = freezed,
    Object? retryCount = null,
    Object? maxRetries = null,
    Object? errorMessage = freezed,
    Object? requestData = freezed,
    Object? responseData = freezed,
    Object? isConflict = null,
    Object? conflictResolution = freezed,
    Object? conflictResolvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$SyncLogModelImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      responseId: freezed == responseId
          ? _value.responseId
          : responseId // ignore: cast_nullable_to_non_nullable
              as String?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      requestData: freezed == requestData
          ? _value._requestData
          : requestData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      responseData: freezed == responseData
          ? _value._responseData
          : responseData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isConflict: null == isConflict
          ? _value.isConflict
          : isConflict // ignore: cast_nullable_to_non_nullable
              as bool,
      conflictResolution: freezed == conflictResolution
          ? _value.conflictResolution
          : conflictResolution // ignore: cast_nullable_to_non_nullable
              as String?,
      conflictResolvedAt: freezed == conflictResolvedAt
          ? _value.conflictResolvedAt
          : conflictResolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncLogModelImpl extends _SyncLogModel {
  const _$SyncLogModelImpl(
      {@HiveField(0) this.id = '',
      @HiveField(1) required this.entityType,
      @HiveField(2) required this.entityId,
      @HiveField(3) required this.action,
      @HiveField(4) this.status = 'pending',
      @HiveField(5) this.requestId,
      @HiveField(6) this.responseId,
      @HiveField(7) this.retryCount = 0,
      @HiveField(8) this.maxRetries = 3,
      @HiveField(9) this.errorMessage,
      @HiveField(10) final Map<String, dynamic>? requestData,
      @HiveField(11) final Map<String, dynamic>? responseData,
      @HiveField(12) this.isConflict = false,
      @HiveField(13) this.conflictResolution,
      @HiveField(14) this.conflictResolvedAt,
      @HiveField(15) this.createdAt,
      @HiveField(16) this.updatedAt,
      @HiveField(17) this.completedAt,
      @HiveField(18) this.createdBy})
      : _requestData = requestData,
        _responseData = responseData,
        super._();

  factory _$SyncLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncLogModelImplFromJson(json);

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
  @override
  @JsonKey()
  @HiveField(4)
  final String status;
  @override
  @HiveField(5)
  final String? requestId;
  @override
  @HiveField(6)
  final String? responseId;
  @override
  @JsonKey()
  @HiveField(7)
  final int retryCount;
  @override
  @JsonKey()
  @HiveField(8)
  final int maxRetries;
  @override
  @HiveField(9)
  final String? errorMessage;
  final Map<String, dynamic>? _requestData;
  @override
  @HiveField(10)
  Map<String, dynamic>? get requestData {
    final value = _requestData;
    if (value == null) return null;
    if (_requestData is EqualUnmodifiableMapView) return _requestData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _responseData;
  @override
  @HiveField(11)
  Map<String, dynamic>? get responseData {
    final value = _responseData;
    if (value == null) return null;
    if (_responseData is EqualUnmodifiableMapView) return _responseData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @HiveField(12)
  final bool isConflict;
  @override
  @HiveField(13)
  final String? conflictResolution;
  @override
  @HiveField(14)
  final DateTime? conflictResolvedAt;
  @override
  @HiveField(15)
  final DateTime? createdAt;
  @override
  @HiveField(16)
  final DateTime? updatedAt;
  @override
  @HiveField(17)
  final DateTime? completedAt;
  @override
  @HiveField(18)
  final String? createdBy;

  @override
  String toString() {
    return 'SyncLogModel(id: $id, entityType: $entityType, entityId: $entityId, action: $action, status: $status, requestId: $requestId, responseId: $responseId, retryCount: $retryCount, maxRetries: $maxRetries, errorMessage: $errorMessage, requestData: $requestData, responseData: $responseData, isConflict: $isConflict, conflictResolution: $conflictResolution, conflictResolvedAt: $conflictResolvedAt, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.responseId, responseId) ||
                other.responseId == responseId) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._requestData, _requestData) &&
            const DeepCollectionEquality()
                .equals(other._responseData, _responseData) &&
            (identical(other.isConflict, isConflict) ||
                other.isConflict == isConflict) &&
            (identical(other.conflictResolution, conflictResolution) ||
                other.conflictResolution == conflictResolution) &&
            (identical(other.conflictResolvedAt, conflictResolvedAt) ||
                other.conflictResolvedAt == conflictResolvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        entityType,
        entityId,
        action,
        status,
        requestId,
        responseId,
        retryCount,
        maxRetries,
        errorMessage,
        const DeepCollectionEquality().hash(_requestData),
        const DeepCollectionEquality().hash(_responseData),
        isConflict,
        conflictResolution,
        conflictResolvedAt,
        createdAt,
        updatedAt,
        completedAt,
        createdBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncLogModelImplCopyWith<_$SyncLogModelImpl> get copyWith =>
      __$$SyncLogModelImplCopyWithImpl<_$SyncLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncLogModelImplToJson(
      this,
    );
  }
}

abstract class _SyncLogModel extends SyncLogModel {
  const factory _SyncLogModel(
      {@HiveField(0) final String id,
      @HiveField(1) required final String entityType,
      @HiveField(2) required final String entityId,
      @HiveField(3) required final String action,
      @HiveField(4) final String status,
      @HiveField(5) final String? requestId,
      @HiveField(6) final String? responseId,
      @HiveField(7) final int retryCount,
      @HiveField(8) final int maxRetries,
      @HiveField(9) final String? errorMessage,
      @HiveField(10) final Map<String, dynamic>? requestData,
      @HiveField(11) final Map<String, dynamic>? responseData,
      @HiveField(12) final bool isConflict,
      @HiveField(13) final String? conflictResolution,
      @HiveField(14) final DateTime? conflictResolvedAt,
      @HiveField(15) final DateTime? createdAt,
      @HiveField(16) final DateTime? updatedAt,
      @HiveField(17) final DateTime? completedAt,
      @HiveField(18) final String? createdBy}) = _$SyncLogModelImpl;
  const _SyncLogModel._() : super._();

  factory _SyncLogModel.fromJson(Map<String, dynamic> json) =
      _$SyncLogModelImpl.fromJson;

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
  String get status;
  @override
  @HiveField(5)
  String? get requestId;
  @override
  @HiveField(6)
  String? get responseId;
  @override
  @HiveField(7)
  int get retryCount;
  @override
  @HiveField(8)
  int get maxRetries;
  @override
  @HiveField(9)
  String? get errorMessage;
  @override
  @HiveField(10)
  Map<String, dynamic>? get requestData;
  @override
  @HiveField(11)
  Map<String, dynamic>? get responseData;
  @override
  @HiveField(12)
  bool get isConflict;
  @override
  @HiveField(13)
  String? get conflictResolution;
  @override
  @HiveField(14)
  DateTime? get conflictResolvedAt;
  @override
  @HiveField(15)
  DateTime? get createdAt;
  @override
  @HiveField(16)
  DateTime? get updatedAt;
  @override
  @HiveField(17)
  DateTime? get completedAt;
  @override
  @HiveField(18)
  String? get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$SyncLogModelImplCopyWith<_$SyncLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
