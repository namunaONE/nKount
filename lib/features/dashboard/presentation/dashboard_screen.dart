import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/utils/theme/app_theme.dart';
import '../../../packages/design-system/design_system.dart';

/// Dashboard Screen: answers "how is my business today" at a glance.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClayScaffold(
        appBar: ClayAppBar(
          title: const Text(AppConstants.appName),
          subtitle: const Text('Nepali Accounting Software'),
          actions: [
            const Center(child: _FiscalChip()),
            Consumer(builder: (context, ref, _) {
              final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
              return ClayIconButton(
                icon: dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                onPressed: () => ref.read(themeModeProvider.notifier).state =
                    dark ? ThemeMode.light : ThemeMode.dark,
                tooltip: 'Toggle dark mode',
              );
            }),
            ClayIconButton(
              icon: ClayIcons.search,
              onPressed: () => context.push('/transactions'),
              tooltip: 'Search transactions (/)',
            ),
            ClayIconButton(
              icon: ClayIcons.settings,
              onPressed: () => context.push('/settings'),
              tooltip: 'Settings',
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _KpiCards(),
              SizedBox(height: 24),
              _CashflowChart(),
              SizedBox(height: 24),
              _QuickActions(),
              SizedBox(height: 24),
              _AlertsSection(),
              SizedBox(height: 24),
              _RecentTransactions(),
              SizedBox(height: 24),
            ],
          ),
        ),
        bottomNavigationBar: mainNavBar(context, 0),
      );
}

/// Fiscal-year + BS date chip (Nepal FY starts Shrawan / month 4).
class _FiscalChip extends StatelessWidget {
  const _FiscalChip();

  @override
  Widget build(BuildContext context) {
    final now = NepaliDateTime.now();
    final startYear = now.month >= 4 ? now.year : now.year - 1;
    final fy = '$startYear/${(startYear + 1).toString().substring(2)}';
    final bs =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} BS';
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text('FY $fy • $bs'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// KPI cards: revenue, expenses, receivables, payables from live boxes.
class _KpiCards extends ConsumerWidget {
  const _KpiCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final transactions =
        hive.transactionsBox.values.where((t) => !t.isCancelled).toList();
    final contacts = hive.contactsBox.values.toList();

    double sum(Iterable<TransactionModel> list) =>
        list.fold(0, (total, t) => total + t.total);

    final revenue =
        sum(transactions.where((t) => t.type == AppConstants.TRANSACTION_SALE));
    final expenses = sum(
        transactions.where((t) => t.type == AppConstants.TRANSACTION_PURCHASE));
    final receivables = contacts
        .where((c) => c.balance > 0)
        .fold(0.0, (total, c) => total + c.balance);
    final payables = contacts
        .where((c) => c.balance < 0)
        .fold(0.0, (total, c) => total + c.balance.abs());

    final cards = [
      _kpi(
        context,
        title: 'Revenue',
        value: AppTheme.formatCurrency(revenue),
        icon: ClayIcons.revenue,
        color: ClayColors.success,
        route: '/transactions',
      ),
      _kpi(
        context,
        title: 'Expenses',
        value: AppTheme.formatCurrency(expenses),
        icon: ClayIcons.expenses,
        color: ClayColors.error,
        route: '/transactions',
      ),
      _kpi(
        context,
        title: 'Receivables',
        value: AppTheme.formatCurrency(receivables),
        icon: ClayIcons.receivables,
        color: ClayColors.info,
        route: '/contacts',
      ),
      _kpi(
        context,
        title: 'Payables',
        value: AppTheme.formatCurrency(payables),
        icon: ClayIcons.payables,
        color: ClayColors.warning,
        route: '/contacts',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // v2: roomier stat cards (icon container + tabular value).
            childAspectRatio: 1.35,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: cards,
          );
        }
        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }

  Widget _kpi(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String route,
  }) =>
      ClayStatCard(
        title: title,
        value: value,
        icon: icon,
        iconColor: color,
        onTap: () => context.push(route),
      );
}

/// Monthly sales-vs-purchases bar chart for the last 6 months.
class _CashflowChart extends ConsumerWidget {
  const _CashflowChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final now = DateTime.now();
    final months = List.generate(
      6,
      (i) => DateTime(now.year, now.month - 5 + i),
    );

    double monthTotal(String type, DateTime month) =>
        hive.transactionsBox.values
            .where((t) =>
                !t.isCancelled &&
                t.type == type &&
                t.date != null &&
                t.date!.year == month.year &&
                t.date!.month == month.month)
            .fold(0.0, (total, t) => total + t.total);

    final sales = [
      for (final m in months) monthTotal(AppConstants.TRANSACTION_SALE, m)
    ];
    final purchases = [
      for (final m in months) monthTotal(AppConstants.TRANSACTION_PURCHASE, m)
    ];
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return ClayCard(
      title: const ClaySectionTitle('Cashflow — last 6 months'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: [...sales, ...purchases, 100]
                      .reduce((a, b) => a > b ? a : b) *
                  1.2,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        monthNames[months[value.toInt()].month - 1],
                      ),
                    ),
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < 6; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: sales[i],
                        color: ClayColors.success,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: purchases[i],
                        color: ClayColors.error,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact quick actions (wrap, not giant tiles).
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    const actions = [
      (ClayIcons.contacts, 'New Contact', '/contacts'),
      (ClayIcons.products, 'New Product', '/products'),
      (ClayIcons.sales, 'New Sale', '/sales'),
      (ClayIcons.purchases, 'New Purchase', '/purchases'),
      (ClayIcons.payments, 'New Payment', '/payments'),
      (ClayIcons.reports, 'Reports', '/reports'),
    ];
    return ClayCard(
      title: const ClaySectionTitle('Quick Actions'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final action in actions)
              ActionChip(
                avatar: Icon(action.$1, size: ClayIconSize.dense),
                label: Text(action.$2),
                onPressed: () => context.push(action.$3),
              ),
          ],
        ),
      ),
    );
  }
}

/// Alerts: overdue invoices + low stock.
class _AlertsSection extends ConsumerWidget {
  const _AlertsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final now = DateTime.now();
    final overdue = hive.transactionsBox.values
        .where((t) =>
            !t.isCancelled &&
            t.dueAmount > 0 &&
            t.dueDate != null &&
            t.dueDate!.isBefore(now))
        .toList();
    final lowStock = hive.productsBox.values
        .where((p) => p.isActive && p.quantity <= p.minQuantity)
        .toList();

    if (overdue.isEmpty && lowStock.isEmpty) {
      return const ClayCard(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(ClayIcons.check, color: ClayColors.success),
              SizedBox(width: 12),
              Expanded(
                  child:
                      Text('All clear — nothing overdue, stock is healthy.')),
            ],
          ),
        ),
      );
    }

    return ClayCard(
      title: const ClaySectionTitle('Needs attention'),
      child: Column(
        children: [
          if (overdue.isNotEmpty)
            ListTile(
              leading: const Icon(ClayIcons.alert, color: ClayColors.error),
              title: Text('${overdue.length} overdue invoice(s)'),
              subtitle: Text(
                AppTheme.formatCurrency(
                    overdue.fold(0.0, (total, t) => total + t.dueAmount)),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/transactions'),
            ),
          if (lowStock.isNotEmpty)
            ListTile(
              leading:
                  const Icon(ClayIcons.products, color: ClayColors.warning),
              title: Text('${lowStock.length} product(s) low on stock'),
              subtitle: Text(lowStock.take(3).map((p) => p.name).join(', ')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/products'),
            ),
        ],
      ),
    );
  }
}

/// Latest 5 transactions, or an empty-state CTA.
class _RecentTransactions extends ConsumerWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final recent = hive.transactionsBox.values.toList()
      ..sort((a, b) =>
          (b.date ?? DateTime(2000)).compareTo(a.date ?? DateTime(2000)));
    final items = recent.take(5).toList();

    return ClayCard(
      title: const ClaySectionTitle('Recent transactions'),
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                      'No transactions yet. Record your first sale to see it here.'),
                  const SizedBox(height: 12),
                  ClayButton(
                    onPressed: () => context.push('/sales'),
                    child: const Text('New Sale'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                for (final t in items)
                  ListTile(
                    leading: Icon(
                      t.type == AppConstants.TRANSACTION_SALE
                          ? ClayIcons.receivables
                          : ClayIcons.payables,
                      color: t.type == AppConstants.TRANSACTION_SALE
                          ? ClayColors.success
                          : ClayColors.error,
                    ),
                    title: Text(t.invoiceNumber ?? t.type),
                    subtitle: Text(
                      t.date == null
                          ? ''
                          : '${t.date!.day}/${t.date!.month}/${t.date!.year}',
                    ),
                    trailing: Text(
                      AppTheme.formatCurrency(t.total),
                    ),
                    onTap: () => context.push('/transactions'),
                  ),
                ClayButton.text(
                  onPressed: () => context.push('/transactions'),
                  child: const Text('View all'),
                ),
              ],
            ),
    );
  }
}

/// Provider for dashboard statistics
final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.getBoxStats();
});
