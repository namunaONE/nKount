// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return TransactionModel(
    id: json['id'] as String? ?? '',
    type: json['type'] as String,
    invoiceNumber: json['invoiceNumber'] as String?,
    contactId: json['contactId'] as String,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
    total: (json['total'] as num?)?.toDouble() ?? 0.0,
    paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
    dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
    paymentStatus: json['paymentStatus'] as String? ?? 'pending',
    paymentMethod: json['paymentMethod'] as String?,
    referenceNumber: json['referenceNumber'] as String?,
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
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
}

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'invoiceNumber': instance.invoiceNumber,
      'contactId': instance.contactId,
      'items': instance.items?.map((e) => e.toJson()).toList(),
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

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) {
  return TransactionItem(
    id: json['id'] as String? ?? '',
    productId: json['productId'] as String,
    productName: json['productName'] as String,
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    unit: json['unit'] as String?,
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'tax': instance.tax,
      'amount': instance.amount,
      'unit': instance.unit,
      'description': instance.description,
    };
