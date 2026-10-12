import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import '../constants/app_constants.dart';
import 'package:uuid/uuid.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

/// Contact Model for Customers and Suppliers
@freezed
@HiveType(typeId: 1, adapterName: 'ContactModelAdapter')
class ContactModel with _$ContactModel {
  const factory ContactModel({
    @HiveField(1) required String name,
    @HiveField(0) @Default('') String id,
    @HiveField(2) String? phone,
    @HiveField(3) String? mobile,
    @HiveField(4) String? email,
    @HiveField(5) String? address,
    @HiveField(6) String? city,
    @HiveField(7) String? district,
    @HiveField(8) String? vatNumber,
    @HiveField(9) String? panNumber,
    @HiveField(10) @Default(AppConstants.CONTACT_CUSTOMER) String type,
    @HiveField(11) double? openingBalance,
    @HiveField(12) @Default(true) bool isActive,
    @HiveField(13) String? remarks,
    @HiveField(14) @Default(0) double totalPurchases,
    @HiveField(15) @Default(0) double totalSales,
    @HiveField(16) @Default(0) double totalPayments,
    @HiveField(17) @Default(0) double totalReceipts,
    @HiveField(18) @Default(0) double balance,
    @HiveField(19) DateTime? createdAt,
    @HiveField(20) DateTime? updatedAt,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  const ContactModel._();

  /// Create a new contact with auto-generated ID
  factory ContactModel.create({
    required String name,
    String? phone,
    String? mobile,
    String? email,
    String? address,
    String? city,
    String? district,
    String? vatNumber,
    String? panNumber,
    String type = AppConstants.CONTACT_CUSTOMER,
    double? openingBalance,
    bool isActive = true,
    String? remarks,
  }) =>
      ContactModel(
        id: const Uuid().v4(),
        name: name,
        phone: phone,
        mobile: mobile,
        email: email,
        address: address,
        city: city,
        district: district,
        vatNumber: vatNumber,
        panNumber: panNumber,
        type: type,
        openingBalance: openingBalance,
        isActive: isActive,
        remarks: remarks,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Update contact balance
  ContactModel copyWithUpdatedBalance(double newBalance) => copyWith(
        balance: newBalance,
        updatedAt: DateTime.now(),
      );

  /// Update contact with new transaction
  ContactModel copyWithTransaction({
    required String transactionType,
    required double amount,
  }) {
    var newBalance = balance;
    var newTotalPurchases = totalPurchases;
    var newTotalSales = totalSales;
    var newTotalPayments = totalPayments;
    var newTotalReceipts = totalReceipts;

    if (transactionType == AppConstants.TRANSACTION_PURCHASE) {
      newTotalPurchases += amount;
      newBalance += amount;
    } else if (transactionType == AppConstants.TRANSACTION_SALE) {
      newTotalSales += amount;
      newBalance -= amount;
    } else if (transactionType == 'payment') {
      newTotalPayments += amount;
      newBalance -= amount;
    } else if (transactionType == 'receipt') {
      newTotalReceipts += amount;
      newBalance += amount;
    }

    return copyWith(
      totalPurchases: newTotalPurchases,
      totalSales: newTotalSales,
      totalPayments: newTotalPayments,
      totalReceipts: newTotalReceipts,
      balance: newBalance,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if contact has VAT registration
  bool get hasVat => vatNumber != null && vatNumber!.isNotEmpty;

  /// Get contact type display name
  String get typeDisplayName {
    switch (type) {
      case AppConstants.CONTACT_CUSTOMER:
        return 'Customer';
      case AppConstants.CONTACT_SUPPLIER:
        return 'Supplier';
      case AppConstants.CONTACT_BOTH:
        return 'Customer & Supplier';
      default:
        return 'Unknown';
    }
  }

  /// Get primary contact number
  String? get primaryPhone => mobile?.isNotEmpty ?? false ? mobile : phone;

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
}
