import 'package:hive_ce/hive.dart';
import '../constants/app_constants.dart';
import '../models/tax_rate_model.dart';

/// Default VAT rate lookup: single source of truth for the effective rate.
///
/// Prefers the active default VAT record, then any default VAT record,
/// then the first active VAT record, then the 13% Nepal standard.
/// Takes the box (rather than the singleton) for unit-test coverage.
double defaultVatRate(Box<TaxRateModel> taxRatesBox) {
  final rates = taxRatesBox.values.toList();
  for (final fallback in [
    rates.where((r) => r.isVat && r.isDefault && r.isActive),
    rates.where((r) => r.isVat && r.isDefault),
    rates.where((r) => r.isVat && r.isActive),
  ]) {
    if (fallback.isNotEmpty) return fallback.first.rate;
  }
  return AppConstants.defaultVatRate;
}

/// Formats a percentage without a trailing `.0` (`13.0` → `13%`).
String pct(double rate) => rate % 1 == 0 ? '${rate.toInt()}%' : '$rate%';
