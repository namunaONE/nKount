import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

/// Company Model for business information
@freezed
@HiveType(typeId: 0, adapterName: 'CompanyModelAdapter')
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String name,
    @HiveField(2) String? address,
    @HiveField(3) String? city,
    @HiveField(4) String? district,
    @HiveField(5) String? phone,
    @HiveField(6) String? mobile,
    @HiveField(7) String? email,
    @HiveField(8) String? website,
    @HiveField(9) String? vatNumber,
    @HiveField(10) String? panNumber,
    @HiveField(11) String? registrationNumber,
    @HiveField(12) String? logoPath,
    @HiveField(13) @Default(AppConstants.CURRENCY) String currency,
    @HiveField(14) @Default('en_NP') String locale,
    @HiveField(15) @Default('yyyy-MM-dd') String dateFormat,
    @HiveField(16) @Default(false) bool useNepaliDate,
    @HiveField(17) @Default(13.0) double defaultVatRate,
    @HiveField(18) @Default('INV') String invoicePrefix,
    @HiveField(19) @Default(1) int invoiceStartNumber,
    @HiveField(20) @Default(1) int purchaseStartNumber,
    @HiveField(21) String? footerText,
    @HiveField(22) @Default(true) bool showTaxOnInvoice,
    @HiveField(23) @Default(true) bool showVatNumber,
    @HiveField(24) @Default(false) bool isIRDRegistered,
    @HiveField(25) DateTime? financialYearStart,
    @HiveField(26) DateTime? financialYearEnd,
    @HiveField(27) DateTime? createdAt,
    @HiveField(28) DateTime? updatedAt,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  /// Create a new company profile
  factory CompanyModel.create({
    required String name,
    String? address,
    String? city,
    String? district,
    String? phone,
    String? mobile,
    String? email,
    String? website,
    String? vatNumber,
    String? panNumber,
    String? registrationNumber,
    String? logoPath,
    String currency = AppConstants.CURRENCY,
    String locale = 'en_NP',
    String dateFormat = 'yyyy-MM-dd',
    bool useNepaliDate = false,
    double defaultVatRate = 13.0,
    String invoicePrefix = 'INV',
    int invoiceStartNumber = 1,
    int purchaseStartNumber = 1,
    String? footerText,
    bool showTaxOnInvoice = true,
    bool showVatNumber = true,
    bool isIRDRegistered = false,
    DateTime? financialYearStart,
    DateTime? financialYearEnd,
  }) {
    return CompanyModel(
      id: const Uuid().v4(),
      name: name,
      address: address,
      city: city,
      district: district,
      phone: phone,
      mobile: mobile,
      email: email,
      website: website,
      vatNumber: vatNumber,
      panNumber: panNumber,
      registrationNumber: registrationNumber,
      logoPath: logoPath,
      currency: currency,
      locale: locale,
      dateFormat: dateFormat,
      useNepaliDate: useNepaliDate,
      defaultVatRate: defaultVatRate,
      invoicePrefix: invoicePrefix,
      invoiceStartNumber: invoiceStartNumber,
      purchaseStartNumber: purchaseStartNumber,
      footerText: footerText ?? 'Thank you for your business!',
      showTaxOnInvoice: showTaxOnInvoice,
      showVatNumber: showVatNumber,
      isIRDRegistered: isIRDRegistered,
      financialYearStart: financialYearStart,
      financialYearEnd: financialYearEnd,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update invoice number
  CompanyModel copyWithNextInvoiceNumber() {
    return copyWith(
      invoiceStartNumber: invoiceStartNumber + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Update purchase number
  CompanyModel copyWithNextPurchaseNumber() {
    return copyWith(
      purchaseStartNumber: purchaseStartNumber + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Get full address
  String get fullAddress {
    final parts = [
      address,
      city,
      district,
      AppConstants.COUNTRY,
    ].where((element) => element != null && element.isNotEmpty);
    return parts.join(', ');
  }

  /// Get next invoice number
  String get nextInvoiceNumber => '${invoicePrefix}-${invoiceStartNumber.toString().padLeft(6, '0')}';

  /// Get next purchase number
  String get nextPurchaseNumber => 'PUR-${purchaseStartNumber.toString().padLeft(6, '0')}';

  /// Check if company is IRD compliant
  bool get isCompliant => isIRDRegistered && vatNumber != null && vatNumber!.isNotEmpty;
}
