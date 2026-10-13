/// Application constants for nKount
class AppConstants {
  // App Info
  static const String appName = 'nKount';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Simple Nepali Accounting Software';

  // Company Info
  static const String companyName = 'namunaONE';
  static const String companyWebsite = 'https://namunaone.com.np';
  static const String maintainedBy = 'Maintained by namunaONE';
  static const String maintainerTeam = 'HyaMuji & Taire Bhai';

  // Transaction Types
  static const String transactionPurchase = 'purchase';
  static const String transactionSale = 'sale';
  static const String transactionExpense = 'expense';
  static const String transactionIncome = 'income';

  // Payment Types
  static const String paymentCash = 'cash';
  static const String paymentBank = 'bank';
  static const String paymentCheque = 'cheque';
  static const String paymentOnline = 'online';
  static const String paymentCredit = 'credit';

  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusPartial = 'partial';
  static const String paymentStatusCancelled = 'cancelled';

  // Contact Types
  static const String contactCustomer = 'customer';
  static const String contactSupplier = 'supplier';
  static const String contactBoth = 'both';

  // Nepali Specific
  static const String currency = 'NPR';
  static const String currencySymbol = 'रू';
  static const String country = 'Nepal';

  // Date Formats
  static const String dateFormatAd = 'yyyy-MM-dd';

  // Default Values
  static const double defaultVatRate = 13.0; // 13% VAT in Nepal

  // Pagination
  static const int itemsPerPage = 50;
}
