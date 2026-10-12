// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  @HiveField(1)
  String get type => throw _privateConstructorUsedError;
  @HiveField(3)
  String get contactId => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @HiveField(4)
  List<TransactionItem>? get items => throw _privateConstructorUsedError;
  @HiveField(5)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(6)
  double get discount => throw _privateConstructorUsedError;
  @HiveField(7)
  double get tax => throw _privateConstructorUsedError;
  @HiveField(8)
  double get total => throw _privateConstructorUsedError;
  @HiveField(9)
  double get paidAmount => throw _privateConstructorUsedError;
  @HiveField(10)
  double get dueAmount => throw _privateConstructorUsedError;
  @HiveField(11)
  String get paymentStatus => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get paymentMethod => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get referenceNumber => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get date => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @HiveField(16)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(17)
  bool get isVatIncluded => throw _privateConstructorUsedError;
  @HiveField(18)
  double get vatRate => throw _privateConstructorUsedError;
  @HiveField(19)
  String? get createdBy => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(21)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(22)
  bool get isCancelled => throw _privateConstructorUsedError;
  @HiveField(23)
  String? get cancellationReason => throw _privateConstructorUsedError;
  @HiveField(24)
  bool get isSynced => throw _privateConstructorUsedError;
  @HiveField(25)
  String? get syncId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {@HiveField(1) String type,
      @HiveField(3) String contactId,
      @HiveField(0) String id,
      @HiveField(2) String? invoiceNumber,
      @HiveField(4) List<TransactionItem>? items,
      @HiveField(5) double subtotal,
      @HiveField(6) double discount,
      @HiveField(7) double tax,
      @HiveField(8) double total,
      @HiveField(9) double paidAmount,
      @HiveField(10) double dueAmount,
      @HiveField(11) String paymentStatus,
      @HiveField(12) String? paymentMethod,
      @HiveField(13) String? referenceNumber,
      @HiveField(14) DateTime? date,
      @HiveField(15) DateTime? dueDate,
      @HiveField(16) String? notes,
      @HiveField(17) bool isVatIncluded,
      @HiveField(18) double vatRate,
      @HiveField(19) String? createdBy,
      @HiveField(20) DateTime? createdAt,
      @HiveField(21) DateTime? updatedAt,
      @HiveField(22) bool isCancelled,
      @HiveField(23) String? cancellationReason,
      @HiveField(24) bool isSynced,
      @HiveField(25) String? syncId});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? contactId = null,
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? items = freezed,
    Object? subtotal = null,
    Object? discount = null,
    Object? tax = null,
    Object? total = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? referenceNumber = freezed,
    Object? date = freezed,
    Object? dueDate = freezed,
    Object? notes = freezed,
    Object? isVatIncluded = null,
    Object? vatRate = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isCancelled = null,
    Object? cancellationReason = freezed,
    Object? isSynced = null,
    Object? syncId = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransactionItem>?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      dueAmount: null == dueAmount
          ? _value.dueAmount
          : dueAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVatIncluded: null == isVatIncluded
          ? _value.isVatIncluded
          : isVatIncluded // ignore: cast_nullable_to_non_nullable
              as bool,
      vatRate: null == vatRate
          ? _value.vatRate
          : vatRate // ignore: cast_nullable_to_non_nullable
              as double,
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
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      syncId: freezed == syncId
          ? _value.syncId
          : syncId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String type,
      @HiveField(3) String contactId,
      @HiveField(0) String id,
      @HiveField(2) String? invoiceNumber,
      @HiveField(4) List<TransactionItem>? items,
      @HiveField(5) double subtotal,
      @HiveField(6) double discount,
      @HiveField(7) double tax,
      @HiveField(8) double total,
      @HiveField(9) double paidAmount,
      @HiveField(10) double dueAmount,
      @HiveField(11) String paymentStatus,
      @HiveField(12) String? paymentMethod,
      @HiveField(13) String? referenceNumber,
      @HiveField(14) DateTime? date,
      @HiveField(15) DateTime? dueDate,
      @HiveField(16) String? notes,
      @HiveField(17) bool isVatIncluded,
      @HiveField(18) double vatRate,
      @HiveField(19) String? createdBy,
      @HiveField(20) DateTime? createdAt,
      @HiveField(21) DateTime? updatedAt,
      @HiveField(22) bool isCancelled,
      @HiveField(23) String? cancellationReason,
      @HiveField(24) bool isSynced,
      @HiveField(25) String? syncId});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? contactId = null,
    Object? id = null,
    Object? invoiceNumber = freezed,
    Object? items = freezed,
    Object? subtotal = null,
    Object? discount = null,
    Object? tax = null,
    Object? total = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? paymentStatus = null,
    Object? paymentMethod = freezed,
    Object? referenceNumber = freezed,
    Object? date = freezed,
    Object? dueDate = freezed,
    Object? notes = freezed,
    Object? isVatIncluded = null,
    Object? vatRate = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isCancelled = null,
    Object? cancellationReason = freezed,
    Object? isSynced = null,
    Object? syncId = freezed,
  }) {
    return _then(_$TransactionModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransactionItem>?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      dueAmount: null == dueAmount
          ? _value.dueAmount
          : dueAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVatIncluded: null == isVatIncluded
          ? _value.isVatIncluded
          : isVatIncluded // ignore: cast_nullable_to_non_nullable
              as bool,
      vatRate: null == vatRate
          ? _value.vatRate
          : vatRate // ignore: cast_nullable_to_non_nullable
              as double,
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
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      syncId: freezed == syncId
          ? _value.syncId
          : syncId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl extends _TransactionModel {
  const _$TransactionModelImpl(
      {@HiveField(1) required this.type,
      @HiveField(3) required this.contactId,
      @HiveField(0) this.id = '',
      @HiveField(2) this.invoiceNumber,
      @HiveField(4) final List<TransactionItem>? items,
      @HiveField(5) this.subtotal = 0.0,
      @HiveField(6) this.discount = 0.0,
      @HiveField(7) this.tax = 0.0,
      @HiveField(8) this.total = 0.0,
      @HiveField(9) this.paidAmount = 0.0,
      @HiveField(10) this.dueAmount = 0.0,
      @HiveField(11) this.paymentStatus = AppConstants.PAYMENT_STATUS_PENDING,
      @HiveField(12) this.paymentMethod,
      @HiveField(13) this.referenceNumber,
      @HiveField(14) this.date,
      @HiveField(15) this.dueDate,
      @HiveField(16) this.notes,
      @HiveField(17) this.isVatIncluded = false,
      @HiveField(18) this.vatRate = 13.0,
      @HiveField(19) this.createdBy,
      @HiveField(20) this.createdAt,
      @HiveField(21) this.updatedAt,
      @HiveField(22) this.isCancelled = false,
      @HiveField(23) this.cancellationReason,
      @HiveField(24) this.isSynced = false,
      @HiveField(25) this.syncId})
      : _items = items,
        super._();

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  @HiveField(1)
  final String type;
  @override
  @HiveField(3)
  final String contactId;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final String? invoiceNumber;
  final List<TransactionItem>? _items;
  @override
  @HiveField(4)
  List<TransactionItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final double subtotal;
  @override
  @JsonKey()
  @HiveField(6)
  final double discount;
  @override
  @JsonKey()
  @HiveField(7)
  final double tax;
  @override
  @JsonKey()
  @HiveField(8)
  final double total;
  @override
  @JsonKey()
  @HiveField(9)
  final double paidAmount;
  @override
  @JsonKey()
  @HiveField(10)
  final double dueAmount;
  @override
  @JsonKey()
  @HiveField(11)
  final String paymentStatus;
  @override
  @HiveField(12)
  final String? paymentMethod;
  @override
  @HiveField(13)
  final String? referenceNumber;
  @override
  @HiveField(14)
  final DateTime? date;
  @override
  @HiveField(15)
  final DateTime? dueDate;
  @override
  @HiveField(16)
  final String? notes;
  @override
  @JsonKey()
  @HiveField(17)
  final bool isVatIncluded;
  @override
  @JsonKey()
  @HiveField(18)
  final double vatRate;
  @override
  @HiveField(19)
  final String? createdBy;
  @override
  @HiveField(20)
  final DateTime? createdAt;
  @override
  @HiveField(21)
  final DateTime? updatedAt;
  @override
  @JsonKey()
  @HiveField(22)
  final bool isCancelled;
  @override
  @HiveField(23)
  final String? cancellationReason;
  @override
  @JsonKey()
  @HiveField(24)
  final bool isSynced;
  @override
  @HiveField(25)
  final String? syncId;

  @override
  String toString() {
    return 'TransactionModel(type: $type, contactId: $contactId, id: $id, invoiceNumber: $invoiceNumber, items: $items, subtotal: $subtotal, discount: $discount, tax: $tax, total: $total, paidAmount: $paidAmount, dueAmount: $dueAmount, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, referenceNumber: $referenceNumber, date: $date, dueDate: $dueDate, notes: $notes, isVatIncluded: $isVatIncluded, vatRate: $vatRate, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, isCancelled: $isCancelled, cancellationReason: $cancellationReason, isSynced: $isSynced, syncId: $syncId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.dueAmount, dueAmount) ||
                other.dueAmount == dueAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isVatIncluded, isVatIncluded) ||
                other.isVatIncluded == isVatIncluded) &&
            (identical(other.vatRate, vatRate) || other.vatRate == vatRate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.syncId, syncId) || other.syncId == syncId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        type,
        contactId,
        id,
        invoiceNumber,
        const DeepCollectionEquality().hash(_items),
        subtotal,
        discount,
        tax,
        total,
        paidAmount,
        dueAmount,
        paymentStatus,
        paymentMethod,
        referenceNumber,
        date,
        dueDate,
        notes,
        isVatIncluded,
        vatRate,
        createdBy,
        createdAt,
        updatedAt,
        isCancelled,
        cancellationReason,
        isSynced,
        syncId
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel extends TransactionModel {
  const factory _TransactionModel(
      {@HiveField(1) required final String type,
      @HiveField(3) required final String contactId,
      @HiveField(0) final String id,
      @HiveField(2) final String? invoiceNumber,
      @HiveField(4) final List<TransactionItem>? items,
      @HiveField(5) final double subtotal,
      @HiveField(6) final double discount,
      @HiveField(7) final double tax,
      @HiveField(8) final double total,
      @HiveField(9) final double paidAmount,
      @HiveField(10) final double dueAmount,
      @HiveField(11) final String paymentStatus,
      @HiveField(12) final String? paymentMethod,
      @HiveField(13) final String? referenceNumber,
      @HiveField(14) final DateTime? date,
      @HiveField(15) final DateTime? dueDate,
      @HiveField(16) final String? notes,
      @HiveField(17) final bool isVatIncluded,
      @HiveField(18) final double vatRate,
      @HiveField(19) final String? createdBy,
      @HiveField(20) final DateTime? createdAt,
      @HiveField(21) final DateTime? updatedAt,
      @HiveField(22) final bool isCancelled,
      @HiveField(23) final String? cancellationReason,
      @HiveField(24) final bool isSynced,
      @HiveField(25) final String? syncId}) = _$TransactionModelImpl;
  const _TransactionModel._() : super._();

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  @HiveField(1)
  String get type;
  @override
  @HiveField(3)
  String get contactId;
  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  String? get invoiceNumber;
  @override
  @HiveField(4)
  List<TransactionItem>? get items;
  @override
  @HiveField(5)
  double get subtotal;
  @override
  @HiveField(6)
  double get discount;
  @override
  @HiveField(7)
  double get tax;
  @override
  @HiveField(8)
  double get total;
  @override
  @HiveField(9)
  double get paidAmount;
  @override
  @HiveField(10)
  double get dueAmount;
  @override
  @HiveField(11)
  String get paymentStatus;
  @override
  @HiveField(12)
  String? get paymentMethod;
  @override
  @HiveField(13)
  String? get referenceNumber;
  @override
  @HiveField(14)
  DateTime? get date;
  @override
  @HiveField(15)
  DateTime? get dueDate;
  @override
  @HiveField(16)
  String? get notes;
  @override
  @HiveField(17)
  bool get isVatIncluded;
  @override
  @HiveField(18)
  double get vatRate;
  @override
  @HiveField(19)
  String? get createdBy;
  @override
  @HiveField(20)
  DateTime? get createdAt;
  @override
  @HiveField(21)
  DateTime? get updatedAt;
  @override
  @HiveField(22)
  bool get isCancelled;
  @override
  @HiveField(23)
  String? get cancellationReason;
  @override
  @HiveField(24)
  bool get isSynced;
  @override
  @HiveField(25)
  String? get syncId;
  @override
  @JsonKey(ignore: true)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) {
  return _TransactionItem.fromJson(json);
}

/// @nodoc
mixin _$TransactionItem {
  @HiveField(1)
  String get productId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get productName => throw _privateConstructorUsedError;
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionItemCopyWith<TransactionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionItemCopyWith<$Res> {
  factory $TransactionItemCopyWith(
          TransactionItem value, $Res Function(TransactionItem) then) =
      _$TransactionItemCopyWithImpl<$Res, TransactionItem>;
  @useResult
  $Res call(
      {@HiveField(1) String productId,
      @HiveField(2) String productName,
      @HiveField(0) String id,
      @HiveField(3) double quantity,
      @HiveField(4) double unitPrice,
      @HiveField(5) double discount,
      @HiveField(6) double tax,
      @HiveField(7) double amount,
      @HiveField(8) String? unit,
      @HiveField(9) String? description});
}

/// @nodoc
class _$TransactionItemCopyWithImpl<$Res, $Val extends TransactionItem>
    implements $TransactionItemCopyWith<$Res> {
  _$TransactionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? id = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? tax = null,
    Object? amount = null,
    Object? unit = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionItemImplCopyWith<$Res>
    implements $TransactionItemCopyWith<$Res> {
  factory _$$TransactionItemImplCopyWith(_$TransactionItemImpl value,
          $Res Function(_$TransactionItemImpl) then) =
      __$$TransactionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(1) String productId,
      @HiveField(2) String productName,
      @HiveField(0) String id,
      @HiveField(3) double quantity,
      @HiveField(4) double unitPrice,
      @HiveField(5) double discount,
      @HiveField(6) double tax,
      @HiveField(7) double amount,
      @HiveField(8) String? unit,
      @HiveField(9) String? description});
}

/// @nodoc
class __$$TransactionItemImplCopyWithImpl<$Res>
    extends _$TransactionItemCopyWithImpl<$Res, _$TransactionItemImpl>
    implements _$$TransactionItemImplCopyWith<$Res> {
  __$$TransactionItemImplCopyWithImpl(
      _$TransactionItemImpl _value, $Res Function(_$TransactionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? id = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? tax = null,
    Object? amount = null,
    Object? unit = freezed,
    Object? description = freezed,
  }) {
    return _then(_$TransactionItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionItemImpl extends _TransactionItem {
  const _$TransactionItemImpl(
      {@HiveField(1) required this.productId,
      @HiveField(2) required this.productName,
      @HiveField(0) this.id = '',
      @HiveField(3) this.quantity = 0.0,
      @HiveField(4) this.unitPrice = 0.0,
      @HiveField(5) this.discount = 0.0,
      @HiveField(6) this.tax = 0.0,
      @HiveField(7) this.amount = 0.0,
      @HiveField(8) this.unit,
      @HiveField(9) this.description})
      : super._();

  factory _$TransactionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionItemImplFromJson(json);

  @override
  @HiveField(1)
  final String productId;
  @override
  @HiveField(2)
  final String productName;
  @override
  @JsonKey()
  @HiveField(0)
  final String id;
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
  String toString() {
    return 'TransactionItem(productId: $productId, productName: $productName, id: $id, quantity: $quantity, unitPrice: $unitPrice, discount: $discount, tax: $tax, amount: $amount, unit: $unit, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.id, id) || other.id == id) &&
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
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, id,
      quantity, unitPrice, discount, tax, amount, unit, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionItemImplCopyWith<_$TransactionItemImpl> get copyWith =>
      __$$TransactionItemImplCopyWithImpl<_$TransactionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionItemImplToJson(
      this,
    );
  }
}

abstract class _TransactionItem extends TransactionItem {
  const factory _TransactionItem(
      {@HiveField(1) required final String productId,
      @HiveField(2) required final String productName,
      @HiveField(0) final String id,
      @HiveField(3) final double quantity,
      @HiveField(4) final double unitPrice,
      @HiveField(5) final double discount,
      @HiveField(6) final double tax,
      @HiveField(7) final double amount,
      @HiveField(8) final String? unit,
      @HiveField(9) final String? description}) = _$TransactionItemImpl;
  const _TransactionItem._() : super._();

  factory _TransactionItem.fromJson(Map<String, dynamic> json) =
      _$TransactionItemImpl.fromJson;

  @override
  @HiveField(1)
  String get productId;
  @override
  @HiveField(2)
  String get productName;
  @override
  @HiveField(0)
  String get id;
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
  @JsonKey(ignore: true)
  _$$TransactionItemImplCopyWith<_$TransactionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
