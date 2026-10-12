// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 5;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      id: fields[0] as String,
      type: fields[1] as String,
      transactionId: fields[2] as String,
      invoiceNumber: fields[3] as String?,
      contactId: fields[4] as String,
      amount: fields[5] as double,
      method: fields[6] as String,
      referenceNumber: fields[7] as String?,
      bankName: fields[8] as String?,
      chequeNumber: fields[9] as String?,
      chequeDate: fields[10] as DateTime?,
      date: fields[11] as DateTime?,
      notes: fields[12] as String?,
      isCleared: fields[13] as bool,
      clearedDate: fields[14] as DateTime?,
      createdBy: fields[15] as String?,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
      isCancelled: fields[18] as bool,
      cancellationReason: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.transactionId)
      ..writeByte(3)
      ..write(obj.invoiceNumber)
      ..writeByte(4)
      ..write(obj.contactId)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.method)
      ..writeByte(7)
      ..write(obj.referenceNumber)
      ..writeByte(8)
      ..write(obj.bankName)
      ..writeByte(9)
      ..write(obj.chequeNumber)
      ..writeByte(10)
      ..write(obj.chequeDate)
      ..writeByte(11)
      ..write(obj.date)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.isCleared)
      ..writeByte(14)
      ..write(obj.clearedDate)
      ..writeByte(15)
      ..write(obj.createdBy)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.isCancelled)
      ..writeByte(19)
      ..write(obj.cancellationReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentSummaryAdapter extends TypeAdapter<PaymentSummary> {
  @override
  final int typeId = 6;

  @override
  PaymentSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentSummary(
      contactId: fields[0] as String?,
      contactName: fields[1] as String?,
      totalPaid: fields[2] as double,
      totalReceived: fields[3] as double,
      balance: fields[4] as double,
      paymentCount: fields[5] as int,
      receiptCount: fields[6] as int,
      lastTransactionDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentSummary obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.contactId)
      ..writeByte(1)
      ..write(obj.contactName)
      ..writeByte(2)
      ..write(obj.totalPaid)
      ..writeByte(3)
      ..write(obj.totalReceived)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.paymentCount)
      ..writeByte(6)
      ..write(obj.receiptCount)
      ..writeByte(7)
      ..write(obj.lastTransactionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String? ?? '',
      type: json['type'] as String,
      transactionId: json['transactionId'] as String,
      invoiceNumber: json['invoiceNumber'] as String?,
      contactId: json['contactId'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] as String,
      referenceNumber: json['referenceNumber'] as String?,
      bankName: json['bankName'] as String?,
      chequeNumber: json['chequeNumber'] as String?,
      chequeDate: json['chequeDate'] == null
          ? null
          : DateTime.parse(json['chequeDate'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      isCleared: json['isCleared'] as bool? ?? false,
      clearedDate: json['clearedDate'] == null
          ? null
          : DateTime.parse(json['clearedDate'] as String),
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isCancelled: json['isCancelled'] as bool? ?? false,
      cancellationReason: json['cancellationReason'] as String?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'transactionId': instance.transactionId,
      'invoiceNumber': instance.invoiceNumber,
      'contactId': instance.contactId,
      'amount': instance.amount,
      'method': instance.method,
      'referenceNumber': instance.referenceNumber,
      'bankName': instance.bankName,
      'chequeNumber': instance.chequeNumber,
      'chequeDate': instance.chequeDate?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'notes': instance.notes,
      'isCleared': instance.isCleared,
      'clearedDate': instance.clearedDate?.toIso8601String(),
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isCancelled': instance.isCancelled,
      'cancellationReason': instance.cancellationReason,
    };

_$PaymentSummaryImpl _$$PaymentSummaryImplFromJson(Map<String, dynamic> json) =>
    _$PaymentSummaryImpl(
      contactId: json['contactId'] as String?,
      contactName: json['contactName'] as String?,
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      totalReceived: (json['totalReceived'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      paymentCount: (json['paymentCount'] as num?)?.toInt() ?? 0,
      receiptCount: (json['receiptCount'] as num?)?.toInt() ?? 0,
      lastTransactionDate: json['lastTransactionDate'] == null
          ? null
          : DateTime.parse(json['lastTransactionDate'] as String),
    );

Map<String, dynamic> _$$PaymentSummaryImplToJson(
        _$PaymentSummaryImpl instance) =>
    <String, dynamic>{
      'contactId': instance.contactId,
      'contactName': instance.contactName,
      'totalPaid': instance.totalPaid,
      'totalReceived': instance.totalReceived,
      'balance': instance.balance,
      'paymentCount': instance.paymentCount,
      'receiptCount': instance.receiptCount,
      'lastTransactionDate': instance.lastTransactionDate?.toIso8601String(),
    };
