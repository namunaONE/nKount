import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/utils/money.dart';
import '../../../packages/design-system/design_system.dart';

/// Reports Screen: live summaries computed from Hive boxes.
/// Summary cards cover the current calendar month; detail sections and
/// the balance sheet cover all time. Empty database ⇒ honest zeros.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClayScaffold(
        appBar: ClayAppBar(
          title: const Text('Reports'),
          actions: [
            ClayIconButton(
              icon: ClayIcons.date,
              onPressed: () => _showDateRangeDialog(context),
              tooltip: 'Select Date Range',
            ),
            ClayIconButton(
              icon: ClayIcons.print,
              onPressed: () => _showPrintDialog(context),
              tooltip: 'Print Report',
            ),
            ClayIconButton(
              icon: ClayIcons.download,
              onPressed: () => _showExportDialog(context),
              tooltip: 'Export',
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Cards
              _SummaryCards(),
              SizedBox(height: 24),

              // Report Sections
              _SalesReportSection(),
              SizedBox(height: 24),
              _PurchaseReportSection(),
              SizedBox(height: 24),
              _PaymentReportSection(),
              SizedBox(height: 24),
              _BalanceSheetSection(),
            ],
          ),
        ),
        bottomNavigationBar: mainNavBar(context, 0),
      );

  void _showDateRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Select Date Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayRadioListTile<String>(
              title: const Text('Today'),
              value: 'today',
              groupValue: 'today',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Week'),
              value: 'this_week',
              groupValue: 'today',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Month'),
              value: 'this_month',
              groupValue: 'today',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Year'),
              value: 'this_year',
              groupValue: 'today',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Custom Range'),
              value: 'custom',
              groupValue: 'today',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Print Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayRadioListTile<String>(
              title: const Text('Current View'),
              value: 'current',
              groupValue: 'current',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Summary Report'),
              value: 'summary',
              groupValue: 'current',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Detailed Report'),
              value: 'detailed',
              groupValue: 'current',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Export Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayRadioListTile<String>(
              title: const Text('PDF'),
              value: 'pdf',
              groupValue: 'pdf',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Excel'),
              value: 'excel',
              groupValue: 'pdf',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('CSV'),
              value: 'csv',
              groupValue: 'pdf',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}

/// Summary Cards: this calendar month, from live transactions.
class _SummaryCards extends ConsumerWidget {
  const _SummaryCards();

  static bool _thisMonth(DateTime? date) {
    final now = DateTime.now();
    return date != null && date.year == now.year && date.month == now.month;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final monthly = hive.transactionsBox.values
        .where((t) => !t.isCancelled && _thisMonth(t.date));
    final sales = monthly
        .where((t) => t.type == AppConstants.transactionSale)
        .fold(0.0, (sum, t) => sum + t.total);
    final purchases = monthly
        .where((t) => t.type == AppConstants.transactionPurchase)
        .fold(0.0, (sum, t) => sum + t.total);
    return Row(
      children: [
        Expanded(
          child: ClayStatCard(
            title: 'Total Sales',
            value: formatCurrency(sales),
            icon: ClayIcons.receivables,
            iconColor: ClayColors.success,
            subtitle: 'This Month',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayStatCard(
            title: 'Total Purchases',
            value: formatCurrency(purchases),
            icon: ClayIcons.payables,
            iconColor: ClayColors.error,
            subtitle: 'This Month',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayStatCard(
            title: 'Net Profit',
            value: formatCurrency(sales - purchases),
            icon: ClayIcons.profit,
            iconColor: ClayColors.info,
            subtitle: 'This Month',
          ),
        ),
      ],
    );
  }
}

/// Whole-or-one-decimal count formatting for item quantities.
String _count(double v) =>
    v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);

/// Sales Report Section: all-time, non-cancelled sales.
class _SalesReportSection extends ConsumerWidget {
  const _SalesReportSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final sales = hive.transactionsBox.values
        .where((t) => !t.isCancelled && t.type == AppConstants.transactionSale)
        .toList();
    final total = sales.fold(0.0, (sum, t) => sum + t.total);
    final items = sales
        .expand((t) => t.items ?? const [])
        .fold(0.0, (sum, i) => sum + i.quantity);
    final highest =
        sales.fold(0.0, (high, t) => t.total > high ? t.total : high);
    return ClayCard(
      title: const ClaySectionTitle('Sales Report', subtitle: 'All time'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ReportRow(
              label: 'Total Sales',
              value: formatCurrency(total),
              color: ClayColors.success,
            ),
            const Divider(),
            _ReportRow(
              label: 'Total Items Sold',
              value: _count(items),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Divider(),
            _ReportRow(
              label: 'Average Sale',
              value: formatCurrency(sales.isEmpty ? 0 : total / sales.length),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Divider(),
            _ReportRow(
              label: 'Highest Sale',
              value: formatCurrency(highest),
              color: ClayColors.success,
            ),
            const SizedBox(height: 12),
            ClayButton.text(
              onPressed: () => context.push('/transactions'),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purchase Report Section: all-time, non-cancelled purchases.
class _PurchaseReportSection extends ConsumerWidget {
  const _PurchaseReportSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final purchases = hive.transactionsBox.values
        .where(
            (t) => !t.isCancelled && t.type == AppConstants.transactionPurchase)
        .toList();
    final total = purchases.fold(0.0, (sum, t) => sum + t.total);
    final items = purchases
        .expand((t) => t.items ?? const [])
        .fold(0.0, (sum, i) => sum + i.quantity);
    final highest =
        purchases.fold(0.0, (high, t) => t.total > high ? t.total : high);
    return ClayCard(
      title: const ClaySectionTitle('Purchase Report', subtitle: 'All time'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ReportRow(
              label: 'Total Purchases',
              value: formatCurrency(total),
              color: ClayColors.error,
            ),
            const Divider(),
            _ReportRow(
              label: 'Total Items Purchased',
              value: _count(items),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Divider(),
            _ReportRow(
              label: 'Average Purchase',
              value: formatCurrency(
                  purchases.isEmpty ? 0 : total / purchases.length),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Divider(),
            _ReportRow(
              label: 'Highest Purchase',
              value: formatCurrency(highest),
              color: ClayColors.error,
            ),
            const SizedBox(height: 12),
            ClayButton.text(
              onPressed: () => context.push('/transactions'),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Payment Report Section: all-time, non-cancelled payments.
class _PaymentReportSection extends ConsumerWidget {
  const _PaymentReportSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final payments = hive.paymentsBox.values.where((p) => !p.isCancelled);
    final made = payments
        .where((p) => p.type == 'payment')
        .fold(0.0, (sum, p) => sum + p.amount);
    final received = payments
        .where((p) => p.type == 'receipt')
        .fold(0.0, (sum, p) => sum + p.amount);
    final pending = payments
        .where((p) => !p.isCleared && !p.isCancelled)
        .fold(0.0, (sum, p) => sum + p.amount);
    return ClayCard(
      title: const ClaySectionTitle('Payment Report', subtitle: 'All time'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ReportRow(
              label: 'Total Payments',
              value: formatCurrency(made),
              color: ClayColors.error,
            ),
            const Divider(),
            _ReportRow(
              label: 'Total Receipts',
              value: formatCurrency(received),
              color: ClayColors.success,
            ),
            const Divider(),
            _ReportRow(
              label: 'Net Cash Flow',
              value: formatCurrency(received - made),
              color: ClayColors.info,
            ),
            const Divider(),
            _ReportRow(
              label: 'Pending Payments',
              value: formatCurrency(pending),
              color: ClayColors.warning,
            ),
            const SizedBox(height: 12),
            ClayButton.text(
              onPressed: () => context.push('/payments'),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Balance Sheet Section, derived live:
/// cash = receipts − payments; receivables/payables from contact
/// balances; inventory at cost; equity = assets − payables.
class _BalanceSheetSection extends ConsumerWidget {
  const _BalanceSheetSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final payments = hive.paymentsBox.values.where((p) => !p.isCancelled);
    final cash = payments
            .where((p) => p.type == 'receipt')
            .fold(0.0, (sum, p) => sum + p.amount) -
        payments
            .where((p) => p.type == 'payment')
            .fold(0.0, (sum, p) => sum + p.amount);
    final receivables = hive.contactsBox.values
        .where((c) => c.balance > 0)
        .fold(0.0, (sum, c) => sum + c.balance);
    final inventory = hive.productsBox.values
        .where((p) => p.isActive)
        .fold(0.0, (sum, p) => sum + p.quantity * p.costPrice);
    final payables = hive.contactsBox.values
        .where((c) => c.balance < 0)
        .fold(0.0, (sum, c) => sum + c.balance.abs());
    final equity = cash + receivables + inventory - payables;
    return ClayCard(
      title: const ClaySectionTitle('Balance Sheet'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _BalanceSubhead('Assets'),
            const SizedBox(height: 8),
            _ReportRow(
              label: 'Cash',
              value: formatCurrency(cash),
              color: ClayColors.success,
            ),
            const Divider(),
            _ReportRow(
              label: 'Accounts Receivable',
              value: formatCurrency(receivables),
              color: ClayColors.info,
            ),
            const Divider(),
            _ReportRow(
              label: 'Inventory',
              value: formatCurrency(inventory),
              color: ClayColors.warning,
            ),
            const SizedBox(height: 12),
            const _BalanceSubhead('Liabilities'),
            const SizedBox(height: 8),
            _ReportRow(
              label: 'Accounts Payable',
              value: formatCurrency(payables),
              color: ClayColors.error,
            ),
            const Divider(),
            _ReportRow(
              label: 'Total Equity',
              value: formatCurrency(equity),
              color: ClayColors.primary,
            ),
            const SizedBox(height: 16),
            const Divider(height: 2),
            _ReportRow(
              label: 'Net Worth',
              value: formatCurrency(equity),
              color: ClayColors.primary,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Balance-sheet subhead (`titleMedium`, no hard-coded size).
class _BalanceSubhead extends StatelessWidget {
  const _BalanceSubhead(this.label);
  final String label;

  @override
  Widget build(BuildContext context) =>
      Text(label, style: Theme.of(context).textTheme.titleMedium);
}

/// Report Row
class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: (isBold
                      ? text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
                      : text.bodyMedium)
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Text(
            value,
            style: ClayTypography.tabular(
              (isBold
                      ? text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
                      : text.bodyMedium?.copyWith(fontWeight: FontWeight.w500))
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
