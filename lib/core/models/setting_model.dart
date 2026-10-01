import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

/// Setting Model for application settings
@freezed
@HiveType(typeId: 11, adapterName: 'SettingModelAdapter')
class SettingModel with _$SettingModel {
  const factory SettingModel({
    @HiveField(0) @Default('') String id,
    @HiveField(1) required String key,
    @HiveField(2) required dynamic value,
    @HiveField(3) String? description,
    @HiveField(4) @Default('app') String category,
    @HiveField(5) @Default(false) bool isSystemSetting,
    @HiveField(6) @Default(true) bool isEditable,
    @HiveField(7) String? companyId,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) DateTime? updatedAt,
  }) = _SettingModel;

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);

  /// Create a new setting
  factory SettingModel.create({
    required String key,
    required dynamic value,
    String? description,
    String category = 'app',
    bool isSystemSetting = false,
    bool isEditable = true,
    String? companyId,
  }) {
    return SettingModel(
      id: const Uuid().v4(),
      key: key,
      value: value,
      description: description,
      category: category,
      isSystemSetting: isSystemSetting,
      isEditable: isEditable,
      companyId: companyId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create default settings
  static List<SettingModel> createDefaultSettings({String? companyId}) {
    return [
      SettingModel.create(
        key: 'currency',
        value: AppConstants.CURRENCY,
        description: 'Default currency for the application',
        category: 'general',
        isSystemSetting: true,
        isEditable: false,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'currency_symbol',
        value: AppConstants.CURRENCY_SYMBOL,
        description: 'Currency symbol for display',
        category: 'general',
        isSystemSetting: true,
        isEditable: false,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'default_vat_rate',
        value: AppConstants.DEFAULT_VAT_RATE,
        description: 'Default VAT rate percentage',
        category: 'tax',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'date_format',
        value: AppConstants.DATE_FORMAT_AD,
        description: 'Date format for display',
        category: 'general',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'use_nepali_date',
        value: false,
        description: 'Use Bikram Sambat (Nepali) date',
        category: 'general',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'fiscal_year_start',
        value: '2081-04-01',
        description: 'Fiscal year start date (B.S.)',
        category: 'financial',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'fiscal_year_end',
        value: '2082-03-31',
        description: 'Fiscal year end date (B.S.)',
        category: 'financial',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'invoice_prefix',
        value: 'INV',
        description: 'Prefix for invoice numbers',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'purchase_prefix',
        value: 'PUR',
        description: 'Prefix for purchase numbers',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'invoice_start_number',
        value: 1,
        description: 'Starting invoice number',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'purchase_start_number',
        value: 1,
        description: 'Starting purchase number',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'show_tax_on_invoice',
        value: true,
        description: 'Show tax breakdown on invoices',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'show_vat_number',
        value: true,
        description: 'Show VAT number on invoices',
        category: 'invoicing',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
      SettingModel.create(
        key: 'items_per_page',
        value: AppConstants.ITEMS_PER_PAGE,
        description: 'Number of items per page in lists',
        category: 'ui',
        isSystemSetting: false,
        isEditable: true,
        companyId: companyId,
      ),
    ];
  }

  /// Get value as specific type
  T? getValueAs<T>() {
    try {
      return value as T?;
    } catch (e) {
      return null;
    }
  }

  /// Update value
  SettingModel copyWithNewValue(dynamic newValue) {
    return copyWith(
      value: newValue,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if setting is for a specific company
  bool get isCompanySetting => companyId != null && companyId!.isNotEmpty;
}
