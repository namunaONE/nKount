import 'package:hive_ce/hive.dart';
import 'package:nkount/core/models/brand_model.dart';
import 'package:nkount/core/models/category_model.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/setting_model.dart';
import 'package:nkount/core/models/sync_log_model.dart';
import 'package:nkount/core/models/tax_rate_model.dart';
import 'package:nkount/core/models/transaction_item_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/models/unit_model.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(BrandModelAdapter());
    registerAdapter(CategoryModelAdapter());
    registerAdapter(CompanyModelAdapter());
    registerAdapter(ContactModelAdapter());
    registerAdapter(PaymentModelAdapter());
    registerAdapter(PaymentSummaryAdapter());
    registerAdapter(ProductModelAdapter());
    registerAdapter(SettingModelAdapter());
    registerAdapter(SyncLogModelAdapter());
    registerAdapter(TaxRateModelAdapter());
    registerAdapter(TransactionItemModelAdapter());
    registerAdapter(TransactionModelAdapter());
    registerAdapter(TransactionItemAdapter());
    registerAdapter(UnitModelAdapter());
  }
}
