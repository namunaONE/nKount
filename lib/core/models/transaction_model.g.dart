// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 3;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      type: fields[1] as String,
      contactId: fields[3] as String,
      id: fields[0] as String,
      invoiceNumber: fields[2] as String?,
      items: (fields[4] as List?)?.cast<TransactionItem>(),
      subtotal: (fields[5] as num).toDouble(),
      discount: (fields[6] as num).toDouble(),
      tax: (fields[7] as num).toDouble(),
      total: (fields[8] as num).toDouble(),
      paidAmount: (fields[9] as num).toDouble(),
      dueAmount: (fields[10] as num).toDouble(),
      paymentStatus: fields[11] as String,
      paymentMethod: fields[12] as String?,
      referenceNumber: fields[13] as String?,
      date: fields[14] as DateTime?,
      dueDate: fields[15] as DateTime?,
      notes: fields[16] as String?,
      isVatIncluded: fields[17] as bool,
      vatRate: (fields[18] as num).toDouble(),
      createdBy: fields[19] as String?,
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
      isCancelled: fields[22] as bool,
      cancellationReason: fields[23] as String?,
      isSynced: fields[24] as bool,
      syncId: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.contactId)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.invoiceNumber)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.subtotal)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.tax)
      ..writeByte(8)
      ..write(obj.total)
      ..writeByte(9)
      ..write(obj.paidAmount)
      ..writeByte(10)
      ..write(obj.dueAmount)
      ..writeByte(11)
      ..write(obj.paymentStatus)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.referenceNumber)
      ..writeByte(14)
      ..write(obj.date)
      ..writeByte(15)
      ..write(obj.dueDate)
      ..writeByte(16)
      ..write(obj.notes)
      ..writeByte(17)
      ..write(obj.isVatIncluded)
      ..writeByte(18)
      ..write(obj.vatRate)
      ..writeByte(19)
      ..write(obj.createdBy)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(22)
      ..write(obj.isCancelled)
      ..writeByte(23)
      ..write(obj.cancellationReason)
      ..writeByte(24)
      ..write(obj.isSynced)
      ..writeByte(25)
      ..write(obj.syncId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionItemAdapter extends TypeAdapter<TransactionItem> {
  @override
  final int typeId = 4;

  @override
  TransactionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionItem(
      productId: fields[1] as String,
      productName: fields[2] as String,
      id: fields[0] as String,
      quantity: (fields[3] as num).toDouble(),
      unitPrice: (fields[4] as num).toDouble(),
      discount: (fields[5] as num).toDouble(),
      tax: (fields[6] as num).toDouble(),
      amount: (fields[7] as num).toDouble(),
      unit: fields[8] as String?,
      description: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unitPrice)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.tax)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.unit)
      ..writeByte(9)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      type: json['type'] as String,
      contactId: json['contactId'] as String,
      id: json['id'] as String? ?? '',
      invoiceNumber: json['invoiceNumber'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String? ??
          AppConstants.PAYMENT_STATUS_PENDING,
      paymentMethod: json['paymentMethod'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      notes: json['notes'] as String?,
      isVatIncluded: json['isVatIncluded'] as bool? ?? false,
      vatRate: (json['vatRate'] as num?)?.toDouble() ?? 13.0,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isCancelled: json['isCancelled'] as bool? ?? false,
      cancellationReason: json['cancellationReason'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      syncId: json['syncId'] as String?,
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'contactId': instance.contactId,
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'tax': instance.tax,
      'total': instance.total,
      'paidAmount': instance.paidAmount,
      'dueAmount': instance.dueAmount,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'referenceNumber': instance.referenceNumber,
      'date': instance.date?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'notes': instance.notes,
      'isVatIncluded': instance.isVatIncluded,
      'vatRate': instance.vatRate,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isCancelled': instance.isCancelled,
      'cancellationReason': instance.cancellationReason,
      'isSynced': instance.isSynced,
      'syncId': instance.syncId,
    };

_$TransactionItemImpl _$$TransactionItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionItemImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      id: json['id'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TransactionItemImplToJson(
        _$TransactionItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'id': instance.id,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'tax': instance.tax,
      'amount': instance.amount,
      'unit': instance.unit,
      'description': instance.description,
    };
