/// Nepali currency formatting (extracted from the deleted `AppTheme`).
///
/// Single source of truth for money text across sales, purchases,
/// transactions, and dashboard. Keeps the `रू` symbol and 2-decimal
/// default in one place so the design system stays consistent.
String formatCurrency(
  double amount, {
  String symbol = 'रू',
  int decimalPlaces = 2,
}) =>
    '$symbol ${amount.toStringAsFixed(decimalPlaces)}';
