// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 4;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel.fromJson(fields.cast<String, dynamic>());
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
  final int typeId = 5;

  @override
  PaymentSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentSummary.fromJson(fields.cast<String, dynamic>());
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
