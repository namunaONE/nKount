import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../packages/design-system/design_system.dart';

/// Reports Screen with Claymorphism Design
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClayScaffold(
        appBar: ClayAppBar(
          title: const Text('Reports'),
          actions: [
            ClayIconButton(
              icon: Icons.date_range,
              onPressed: () => _showDateRangeDialog(context),
              tooltip: 'Select Date Range',
            ),
            ClayIconButton(
              icon: Icons.print,
              onPressed: () => _showPrintDialog(context),
              tooltip: 'Print Report',
            ),
            ClayIconButton(
              icon: Icons.download,
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

/// Summary Cards
class _SummaryCards extends ConsumerWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Row(
        children: [
          Expanded(
            child: ClayStatCard(
              title: 'Total Sales',
              value: 'NPR 0.00',
              icon: Icons.arrow_upward,
              iconColor: ClayColors.success,
              subtitle: 'This Month',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ClayStatCard(
              title: 'Total Purchases',
              value: 'NPR 0.00',
              icon: Icons.arrow_downward,
              iconColor: ClayColors.error,
              subtitle: 'This Month',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ClayStatCard(
              title: 'Net Profit',
              value: 'NPR 0.00',
              icon: Icons.trending_up,
              iconColor: ClayColors.info,
              subtitle: 'This Month',
            ),
          ),
        ],
      );
}

/// Sales Report Section
class _SalesReportSection extends StatelessWidget {
  const _SalesReportSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const Text(
          'Sales Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const _ReportRow(
                label: 'Total Sales',
                value: 'NPR 0.00',
                color: ClayColors.success,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Total Items Sold',
                value: '0',
                color: Colors.grey,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Average Sale',
                value: 'NPR 0.00',
                color: Colors.grey,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Highest Sale',
                value: 'NPR 0.00',
                color: ClayColors.success,
              ),
              const SizedBox(height: 12),
              ClayButton.text(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      );
}

/// Purchase Report Section
class _PurchaseReportSection extends StatelessWidget {
  const _PurchaseReportSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const Text(
          'Purchase Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const _ReportRow(
                label: 'Total Purchases',
                value: 'NPR 0.00',
                color: ClayColors.error,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Total Items Purchased',
                value: '0',
                color: Colors.grey,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Average Purchase',
                value: 'NPR 0.00',
                color: Colors.grey,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Highest Purchase',
                value: 'NPR 0.00',
                color: ClayColors.error,
              ),
              const SizedBox(height: 12),
              ClayButton.text(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      );
}

/// Payment Report Section
class _PaymentReportSection extends StatelessWidget {
  const _PaymentReportSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const Text(
          'Payment Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const _ReportRow(
                label: 'Total Payments',
                value: 'NPR 0.00',
                color: ClayColors.error,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Total Receipts',
                value: 'NPR 0.00',
                color: ClayColors.success,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Net Cash Flow',
                value: 'NPR 0.00',
                color: ClayColors.info,
              ),
              const Divider(),
              const _ReportRow(
                label: 'Pending Payments',
                value: 'NPR 0.00',
                color: ClayColors.warning,
              ),
              const SizedBox(height: 12),
              ClayButton.text(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      );
}

/// Balance Sheet Section
class _BalanceSheetSection extends StatelessWidget {
  const _BalanceSheetSection();

  @override
  Widget build(BuildContext context) => const ClayCard(
        title: Text(
          'Balance Sheet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Assets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              _ReportRow(
                label: 'Cash',
                value: 'NPR 0.00',
                color: ClayColors.success,
              ),
              Divider(),
              _ReportRow(
                label: 'Accounts Receivable',
                value: 'NPR 0.00',
                color: ClayColors.info,
              ),
              Divider(),
              _ReportRow(
                label: 'Inventory',
                value: 'NPR 0.00',
                color: ClayColors.warning,
              ),
              SizedBox(height: 12),
              Text(
                'Liabilities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              _ReportRow(
                label: 'Accounts Payable',
                value: 'NPR 0.00',
                color: ClayColors.error,
              ),
              Divider(),
              _ReportRow(
                label: 'Total Equity',
                value: 'NPR 0.00',
                color: ClayColors.primary,
              ),
              SizedBox(height: 16),
              Divider(height: 2),
              _ReportRow(
                label: 'Net Worth',
                value: 'NPR 0.00',
                color: ClayColors.primary,
                isBold: true,
              ),
            ],
          ),
        ),
      );
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      );
}
