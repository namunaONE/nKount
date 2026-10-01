// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
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
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
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
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
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

PaymentSummary _$PaymentSummaryFromJson(Map<String, dynamic> json) {
  return PaymentSummary(
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
}

Map<String, dynamic> _$PaymentSummaryToJson(PaymentSummary instance) =>
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
