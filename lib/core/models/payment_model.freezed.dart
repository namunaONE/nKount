// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  @HiveField(1)
  String get type => throw _privateConstructorUsedError; // payment or receipt
  @HiveField(2)
  String get transactionId => throw _privateConstructorUsedError;
  @HiveField(4)
  String get contactId => throw _privateConstructorUsedError;
  @HiveField(6)
  String get method => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @HiveField(5)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get referenceNumber => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get bankName => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get chequeNumber => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get chequeDate => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get date => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get isCleared => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get clearedDate => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get createdBy => throw _privateConstructorUsedError;
  @HiveField(16)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(18)
  bool get isCancelled => throw _privateConstructorUsedError;
  @HiveField(19)
  String? get cancellationReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {@HiveField(1) String type,
      @HiveField(2) String transactionId,
      @HiveField(4) String contactId,
      @HiveField(6) String method,
      @HiveField(0) String id,
      @HiveField(3) String? invoiceNumber,
      @HiveField(5) double amount,
      @HiveField(7) String? referenceNumber,
      @HiveField(8) String? bankName,
      @HiveField(9) String? chequeNumber,
      @HiveField(10) DateTime? chequeDate,
      @HiveField(11) DateTime? date,
      @HiveField(12) String? notes,
      @HiveField(13) bool isCleared,
      @HiveField(14) DateTime? clearedDate,
      @HiveField(15) String? createdBy,
      @HiveField(16) DateTime? createdAt,
      @HiveField(17) DateTime? updatedAt,
      @HiveField(18) bool isCancelled,
      @HiveField(19) String? cancellationReason});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? transactionId = null,
    Object? contactId = null,
    Object? method = null,
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? amount = null,
    Object? referenceNumber = freezed,
    Object? bankName = freezed,
    Object? chequeNumber = freezed,
    Object? chequeDate = freezed,
    Object? date = freezed,
    Object? notes = freezed,
    Object? isCleared = null,
    Object? clearedDate = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isCancelled = null,
    Object? cancellationReason = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      chequeNumber: freezed == chequeNumber
          ? _value.chequeNumber
          : chequeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chequeDate: freezed == chequeDate
          ? _value.chequeDate
          : chequeDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCleared: null == isCleared
          ? _value.isCleared
          : isCleared // ignore: cast_nullable_to_non_nullable
              as bool,
      clearedDate: freezed == clearedDate
          ? _value.clearedDate
          : clearedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String type,
      @HiveField(2) String transactionId,
      @HiveField(4) String contactId,
      @HiveField(6) String method,
      @HiveField(0) String id,
      @HiveField(3) String? invoiceNumber,
      @HiveField(5) double amount,
      @HiveField(7) String? referenceNumber,
      @HiveField(8) String? bankName,
      @HiveField(9) String? chequeNumber,
      @HiveField(10) DateTime? chequeDate,
      @HiveField(11) DateTime? date,
      @HiveField(12) String? notes,
      @HiveField(13) bool isCleared,
      @HiveField(14) DateTime? clearedDate,
      @HiveField(15) String? createdBy,
      @HiveField(16) DateTime? createdAt,
      @HiveField(17) DateTime? updatedAt,
      @HiveField(18) bool isCancelled,
      @HiveField(19) String? cancellationReason});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? transactionId = null,
    Object? contactId = null,
    Object? method = null,
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? amount = null,
    Object? referenceNumber = freezed,
    Object? bankName = freezed,
    Object? chequeNumber = freezed,
    Object? chequeDate = freezed,
    Object? date = freezed,
    Object? notes = freezed,
    Object? isCleared = null,
    Object? clearedDate = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isCancelled = null,
    Object? cancellationReason = freezed,
  }) {
    return _then(_$PaymentModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      chequeNumber: freezed == chequeNumber
          ? _value.chequeNumber
          : chequeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chequeDate: freezed == chequeDate
          ? _value.chequeDate
          : chequeDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCleared: null == isCleared
          ? _value.isCleared
          : isCleared // ignore: cast_nullable_to_non_nullable
              as bool,
      clearedDate: freezed == clearedDate
          ? _value.clearedDate
          : clearedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCancelled: null == isCancelled
          ? _value.isCancelled
          : isCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl extends _PaymentModel {
  const _$PaymentModelImpl(
      {@HiveField(1) required this.type,
      @HiveField(2) required this.transactionId,
      @HiveField(4) required this.contactId,
      @HiveField(6) required this.method,
      @HiveField(0) this.id = '',
      @HiveField(3) this.invoiceNumber,
      @HiveField(5) this.amount = 0.0,
      @HiveField(7) this.referenceNumber,
      @HiveField(8) this.bankName,
      @HiveField(9) this.chequeNumber,
      @HiveField(10) this.chequeDate,
      @HiveField(11) this.date,
      @HiveField(12) this.notes,
      @HiveField(13) this.isCleared = false,
      @HiveField(14) this.clearedDate,
      @HiveField(15) this.createdBy,
      @HiveField(16) this.createdAt,
      @HiveField(17) this.updatedAt,
      @HiveField(18) this.isCancelled = false,
      @HiveField(19) this.cancellationReason})
      : super._();

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  @HiveField(1)
  final String type;
// payment or receipt
  @override
  @HiveField(2)
  final String transactionId;
  @override
  @HiveField(4)
  final String contactId;
  @override
  @HiveField(6)
  final String method;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(3)
  final String? invoiceNumber;
  @override
  @JsonKey()
  @HiveField(5)
  final double amount;
  @override
  @HiveField(7)
  final String? referenceNumber;
  @override
  @HiveField(8)
  final String? bankName;
  @override
  @HiveField(9)
  final String? chequeNumber;
  @override
  @HiveField(10)
  final DateTime? chequeDate;
  @override
  @HiveField(11)
  final DateTime? date;
  @override
  @HiveField(12)
  final String? notes;
  @override
  @JsonKey()
  @HiveField(13)
  final bool isCleared;
  @override
  @HiveField(14)
  final DateTime? clearedDate;
  @override
  @HiveField(15)
  final String? createdBy;
  @override
  @HiveField(16)
  final DateTime? createdAt;
  @override
  @HiveField(17)
  final DateTime? updatedAt;
  @override
  @JsonKey()
  @HiveField(18)
  final bool isCancelled;
  @override
  @HiveField(19)
  final String? cancellationReason;

  @override
  String toString() {
    return 'PaymentModel(type: $type, transactionId: $transactionId, contactId: $contactId, method: $method, id: $id, invoiceNumber: $invoiceNumber, amount: $amount, referenceNumber: $referenceNumber, bankName: $bankName, chequeNumber: $chequeNumber, chequeDate: $chequeDate, date: $date, notes: $notes, isCleared: $isCleared, clearedDate: $clearedDate, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, isCancelled: $isCancelled, cancellationReason: $cancellationReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.chequeNumber, chequeNumber) ||
                other.chequeNumber == chequeNumber) &&
            (identical(other.chequeDate, chequeDate) ||
                other.chequeDate == chequeDate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isCleared, isCleared) ||
                other.isCleared == isCleared) &&
            (identical(other.clearedDate, clearedDate) ||
                other.clearedDate == clearedDate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        type,
        transactionId,
        contactId,
        method,
        id,
        invoiceNumber,
        amount,
        referenceNumber,
        bankName,
        chequeNumber,
        chequeDate,
        date,
        notes,
        isCleared,
        clearedDate,
        createdBy,
        createdAt,
        updatedAt,
        isCancelled,
        cancellationReason
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel extends PaymentModel {
  const factory _PaymentModel(
      {@HiveField(1) required final String type,
      @HiveField(2) required final String transactionId,
      @HiveField(4) required final String contactId,
      @HiveField(6) required final String method,
      @HiveField(0) final String id,
      @HiveField(3) final String? invoiceNumber,
      @HiveField(5) final double amount,
      @HiveField(7) final String? referenceNumber,
      @HiveField(8) final String? bankName,
      @HiveField(9) final String? chequeNumber,
      @HiveField(10) final DateTime? chequeDate,
      @HiveField(11) final DateTime? date,
      @HiveField(12) final String? notes,
      @HiveField(13) final bool isCleared,
      @HiveField(14) final DateTime? clearedDate,
      @HiveField(15) final String? createdBy,
      @HiveField(16) final DateTime? createdAt,
      @HiveField(17) final DateTime? updatedAt,
      @HiveField(18) final bool isCancelled,
      @HiveField(19) final String? cancellationReason}) = _$PaymentModelImpl;
  const _PaymentModel._() : super._();

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  @HiveField(1)
  String get type;
  @override // payment or receipt
  @HiveField(2)
  String get transactionId;
  @override
  @HiveField(4)
  String get contactId;
  @override
  @HiveField(6)
  String get method;
  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(3)
  String? get invoiceNumber;
  @override
  @HiveField(5)
  double get amount;
  @override
  @HiveField(7)
  String? get referenceNumber;
  @override
  @HiveField(8)
  String? get bankName;
  @override
  @HiveField(9)
  String? get chequeNumber;
  @override
  @HiveField(10)
  DateTime? get chequeDate;
  @override
  @HiveField(11)
  DateTime? get date;
  @override
  @HiveField(12)
  String? get notes;
  @override
  @HiveField(13)
  bool get isCleared;
  @override
  @HiveField(14)
  DateTime? get clearedDate;
  @override
  @HiveField(15)
  String? get createdBy;
  @override
  @HiveField(16)
  DateTime? get createdAt;
  @override
  @HiveField(17)
  DateTime? get updatedAt;
  @override
  @HiveField(18)
  bool get isCancelled;
  @override
  @HiveField(19)
  String? get cancellationReason;
  @override
  @JsonKey(ignore: true)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentSummary _$PaymentSummaryFromJson(Map<String, dynamic> json) {
  return _PaymentSummary.fromJson(json);
}

/// @nodoc
mixin _$PaymentSummary {
  @HiveField(0)
  String? get contactId => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get contactName => throw _privateConstructorUsedError;
  @HiveField(2)
  double get totalPaid => throw _privateConstructorUsedError;
  @HiveField(3)
  double get totalReceived => throw _privateConstructorUsedError;
  @HiveField(4)
  double get balance => throw _privateConstructorUsedError;
  @HiveField(5)
  int get paymentCount => throw _privateConstructorUsedError;
  @HiveField(6)
  int get receiptCount => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get lastTransactionDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentSummaryCopyWith<PaymentSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSummaryCopyWith<$Res> {
  factory $PaymentSummaryCopyWith(
          PaymentSummary value, $Res Function(PaymentSummary) then) =
      _$PaymentSummaryCopyWithImpl<$Res, PaymentSummary>;
  @useResult
  $Res call(
      {@HiveField(0) String? contactId,
      @HiveField(1) String? contactName,
      @HiveField(2) double totalPaid,
      @HiveField(3) double totalReceived,
      @HiveField(4) double balance,
      @HiveField(5) int paymentCount,
      @HiveField(6) int receiptCount,
      @HiveField(7) DateTime? lastTransactionDate});
}

/// @nodoc
class _$PaymentSummaryCopyWithImpl<$Res, $Val extends PaymentSummary>
    implements $PaymentSummaryCopyWith<$Res> {
  _$PaymentSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = freezed,
    Object? contactName = freezed,
    Object? totalPaid = null,
    Object? totalReceived = null,
    Object? balance = null,
    Object? paymentCount = null,
    Object? receiptCount = null,
    Object? lastTransactionDate = freezed,
  }) {
    return _then(_value.copyWith(
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPaid: null == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      paymentCount: null == paymentCount
          ? _value.paymentCount
          : paymentCount // ignore: cast_nullable_to_non_nullable
              as int,
      receiptCount: null == receiptCount
          ? _value.receiptCount
          : receiptCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentSummaryImplCopyWith<$Res>
    implements $PaymentSummaryCopyWith<$Res> {
  factory _$$PaymentSummaryImplCopyWith(_$PaymentSummaryImpl value,
          $Res Function(_$PaymentSummaryImpl) then) =
      __$$PaymentSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? contactId,
      @HiveField(1) String? contactName,
      @HiveField(2) double totalPaid,
      @HiveField(3) double totalReceived,
      @HiveField(4) double balance,
      @HiveField(5) int paymentCount,
      @HiveField(6) int receiptCount,
      @HiveField(7) DateTime? lastTransactionDate});
}

/// @nodoc
class __$$PaymentSummaryImplCopyWithImpl<$Res>
    extends _$PaymentSummaryCopyWithImpl<$Res, _$PaymentSummaryImpl>
    implements _$$PaymentSummaryImplCopyWith<$Res> {
  __$$PaymentSummaryImplCopyWithImpl(
      _$PaymentSummaryImpl _value, $Res Function(_$PaymentSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = freezed,
    Object? contactName = freezed,
    Object? totalPaid = null,
    Object? totalReceived = null,
    Object? balance = null,
    Object? paymentCount = null,
    Object? receiptCount = null,
    Object? lastTransactionDate = freezed,
  }) {
    return _then(_$PaymentSummaryImpl(
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPaid: null == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double,
      totalReceived: null == totalReceived
          ? _value.totalReceived
          : totalReceived // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      paymentCount: null == paymentCount
          ? _value.paymentCount
          : paymentCount // ignore: cast_nullable_to_non_nullable
              as int,
      receiptCount: null == receiptCount
          ? _value.receiptCount
          : receiptCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSummaryImpl extends _PaymentSummary {
  const _$PaymentSummaryImpl(
      {@HiveField(0) this.contactId,
      @HiveField(1) this.contactName,
      @HiveField(2) this.totalPaid = 0.0,
      @HiveField(3) this.totalReceived = 0.0,
      @HiveField(4) this.balance = 0.0,
      @HiveField(5) this.paymentCount = 0,
      @HiveField(6) this.receiptCount = 0,
      @HiveField(7) this.lastTransactionDate})
      : super._();

  factory _$PaymentSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSummaryImplFromJson(json);

  @override
  @HiveField(0)
  final String? contactId;
  @override
  @HiveField(1)
  final String? contactName;
  @override
  @JsonKey()
  @HiveField(2)
  final double totalPaid;
  @override
  @JsonKey()
  @HiveField(3)
  final double totalReceived;
  @override
  @JsonKey()
  @HiveField(4)
  final double balance;
  @override
  @JsonKey()
  @HiveField(5)
  final int paymentCount;
  @override
  @JsonKey()
  @HiveField(6)
  final int receiptCount;
  @override
  @HiveField(7)
  final DateTime? lastTransactionDate;

  @override
  String toString() {
    return 'PaymentSummary(contactId: $contactId, contactName: $contactName, totalPaid: $totalPaid, totalReceived: $totalReceived, balance: $balance, paymentCount: $paymentCount, receiptCount: $receiptCount, lastTransactionDate: $lastTransactionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSummaryImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.totalReceived, totalReceived) ||
                other.totalReceived == totalReceived) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.paymentCount, paymentCount) ||
                other.paymentCount == paymentCount) &&
            (identical(other.receiptCount, receiptCount) ||
                other.receiptCount == receiptCount) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contactId,
      contactName,
      totalPaid,
      totalReceived,
      balance,
      paymentCount,
      receiptCount,
      lastTransactionDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSummaryImplCopyWith<_$PaymentSummaryImpl> get copyWith =>
      __$$PaymentSummaryImplCopyWithImpl<_$PaymentSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSummaryImplToJson(
      this,
    );
  }
}

abstract class _PaymentSummary extends PaymentSummary {
  const factory _PaymentSummary(
          {@HiveField(0) final String? contactId,
          @HiveField(1) final String? contactName,
          @HiveField(2) final double totalPaid,
          @HiveField(3) final double totalReceived,
          @HiveField(4) final double balance,
          @HiveField(5) final int paymentCount,
          @HiveField(6) final int receiptCount,
          @HiveField(7) final DateTime? lastTransactionDate}) =
      _$PaymentSummaryImpl;
  const _PaymentSummary._() : super._();

  factory _PaymentSummary.fromJson(Map<String, dynamic> json) =
      _$PaymentSummaryImpl.fromJson;

  @override
  @HiveField(0)
  String? get contactId;
  @override
  @HiveField(1)
  String? get contactName;
  @override
  @HiveField(2)
  double get totalPaid;
  @override
  @HiveField(3)
  double get totalReceived;
  @override
  @HiveField(4)
  double get balance;
  @override
  @HiveField(5)
  int get paymentCount;
  @override
  @HiveField(6)
  int get receiptCount;
  @override
  @HiveField(7)
  DateTime? get lastTransactionDate;
  @override
  @JsonKey(ignore: true)
  _$$PaymentSummaryImplCopyWith<_$PaymentSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
