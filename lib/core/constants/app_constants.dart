// ignore_for_file: constant_identifier_names

/// Application constants for nKount
class AppConstants {
  // App Info
  static const String appName = 'nKount';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Simple Nepali Accounting Software';
  
  // Company Info
  static const String companyName = 'namunaONE';
  static const String companyWebsite = 'https://namunaone.com.np';
  
  // Storage Keys
  static const String STORAGE_KEY_COMPANY = 'nkount_company';
  static const String STORAGE_KEY_CONTACTS = 'nkount_contacts';
  static const String STORAGE_KEY_PRODUCTS = 'nkount_products';
  static const String STORAGE_KEY_TRANSACTIONS = 'nkount_transactions';
  static const String STORAGE_KEY_PAYMENTS = 'nkount_payments';
  static const String STORAGE_KEY_SETTINGS = 'nkount_settings';
  static const String STORAGE_KEY_LAST_SYNC = 'nkount_last_sync';
  
  // Box Names for Hive
  static const String BOX_COMPANY = 'company_box';
  static const String BOX_CONTACTS = 'contacts_box';
  static const String BOX_PRODUCTS = 'products_box';
  static const String BOX_TRANSACTIONS = 'transactions_box';
  static const String BOX_PAYMENTS = 'payments_box';
  static const String BOX_SETTINGS = 'settings_box';
  
  // Transaction Types
  static const String TRANSACTION_PURCHASE = 'purchase';
  static const String TRANSACTION_SALE = 'sale';
  static const String TRANSACTION_EXPENSE = 'expense';
  static const String TRANSACTION_INCOME = 'income';
  
  // Payment Types
  static const String PAYMENT_CASH = 'cash';
  static const String PAYMENT_BANK = 'bank';
  static const String PAYMENT_CHEQUE = 'cheque';
  static const String PAYMENT_ONLINE = 'online';
  static const String PAYMENT_CREDIT = 'credit';
  
  // Payment Status
  static const String PAYMENT_STATUS_PENDING = 'pending';
  static const String PAYMENT_STATUS_PAID = 'paid';
  static const String PAYMENT_STATUS_PARTIAL = 'partial';
  static const String PAYMENT_STATUS_CANCELLED = 'cancelled';
  
  // Contact Types
  static const String CONTACT_CUSTOMER = 'customer';
  static const String CONTACT_SUPPLIER = 'supplier';
  static const String CONTACT_BOTH = 'both';
  
  // Nepali Specific
  static const String CURRENCY = 'NPR';
  static const String CURRENCY_SYMBOL = 'रू';
  static const String COUNTRY = 'Nepal';
  
  // IRD Compliance
  static const String IRD_VERSION = '2081/82';
  static const bool IRD_COMPLIANT = true;
  
  // Date Formats
  static const String DATE_FORMAT_AD = 'yyyy-MM-dd';
  static const String DATE_FORMAT_BS = 'yyyy/MM/dd';
  
  // Default Values
  static const double DEFAULT_VAT_RATE = 13.0; // 13% VAT in Nepal
  static const double DEFAULT_SERVICE_CHARGE = 0.0;
  static const int DEFAULT_INVOICE_EXPIRY_DAYS = 30;
  
  // Limits
  static const int MAX_CONTACTS = 10000;
  static const int MAX_PRODUCTS = 50000;
  static const int MAX_TRANSACTIONS = 100000;
  
  // Pagination
  static const int ITEMS_PER_PAGE = 50;
  
  // Error Messages
  static const String ERROR_INVALID_AMOUNT = 'Invalid amount';
  static const String ERROR_INVALID_DATE = 'Invalid date';
  static const String ERROR_DUPLICATE_ENTRY = 'Duplicate entry';
  static const String ERROR_NOT_FOUND = 'Not found';
  
  // Success Messages
  static const String SUCCESS_SAVED = 'Saved successfully';
  static const String SUCCESS_DELETED = 'Deleted successfully';
  static const String SUCCESS_UPDATED = 'Updated successfully';
}

/// Nepali specific constants
class NepaliConstants {
  static const List<String> nepaliMonths = [
    'बैशाख', 'जेष्ठ', 'असार', 'श्रावण', 'भदौ', 'असोज',
    'कात्तिक', 'मंसिर', 'पुष', 'माघ', 'फाल्गुण', 'चैत्र'
  ];
  
  static const List<String> englishMonths = [
    'Baisakh', 'Jestha', 'Asar', 'Srawan', 'Bhadra', 'Asoj',
    'Kartik', 'Mangsir', 'Push', 'Magh', 'Falgun', 'Chaitra'
  ];
  
  static const Map<String, String> nepaliNumbers = {
    '0': '०', '1': '१', '2': '२', '3': '३', '4': '४',
    '5': '५', '6': '६', '7': '७', '8': '८', '9': '९'
  };
  
  static String convertToNepaliNumbers(String input) {
    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => nepaliNumbers[match.group(0)] ?? match.group(0)!
    );
  }
}
