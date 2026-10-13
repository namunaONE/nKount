import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/utils/theme/app_theme.dart';
import '../../../packages/design-system/design_system.dart';

/// Dashboard Screen: answers "how is my business today" at a glance.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClayScaffold(
        appBar: ClayAppBar(
          title: const Text(
            AppConstants.appName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          subtitle: const Text(
            'Nepali Accounting Software',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          actions: [
            const Center(child: _FiscalChip()),
            ClayIconButton(
              icon: Icons.search,
              onPressed: () => context.push('/transactions'),
              tooltip: 'Search transactions (/)',
            ),
            ClayIconButton(
              icon: Icons.settings,
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
        bottomNavigationBar: ClayBottomNavigation(
          currentIndex: 0,
          items: const [
            ClayBottomNavItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              route: '/',
            ),
            ClayBottomNavItem(
              icon: Icons.people,
              label: 'Contacts',
              route: '/contacts',
            ),
            ClayBottomNavItem(
              icon: Icons.inventory,
              label: 'Products',
              route: '/products',
            ),
            ClayBottomNavItem(
              icon: Icons.receipt,
              label: 'Transactions',
              route: '/transactions',
            ),
            ClayBottomNavItem(
              icon: Icons.payment,
              label: 'Payments',
              route: '/payments',
            ),
          ],
          onTap: (index) {
            final routes = [
              '/',
              '/contacts',
              '/products',
              '/transactions',
              '/payments'
            ];
            if (index < routes.length) {
              context.go(routes[index]);
            }
          },
        ),
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
        label: Text('FY $fy • $bs', style: const TextStyle(fontSize: 12)),
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
        icon: Icons.trending_up,
        color: ClayColors.success,
        route: '/transactions',
      ),
      _kpi(
        context,
        title: 'Expenses',
        value: AppTheme.formatCurrency(expenses),
        icon: Icons.trending_down,
        color: ClayColors.error,
        route: '/transactions',
      ),
      _kpi(
        context,
        title: 'Receivables',
        value: AppTheme.formatCurrency(receivables),
        icon: Icons.call_received,
        color: ClayColors.info,
        route: '/contacts',
      ),
      _kpi(
        context,
        title: 'Payables',
        value: AppTheme.formatCurrency(payables),
        icon: Icons.call_made,
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
            childAspectRatio: 1.6,
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
      title: const Text(
        'Cashflow — last 6 months',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
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
                        style: const TextStyle(fontSize: 11),
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
      (Icons.person_add, 'New Contact', '/contacts'),
      (Icons.add_box, 'New Product', '/products'),
      (Icons.point_of_sale, 'New Sale', '/sales'),
      (Icons.shopping_bag, 'New Purchase', '/purchases'),
      (Icons.payments, 'New Payment', '/payments'),
      (Icons.assessment, 'Reports', '/reports'),
    ];
    return ClayCard(
      title: const Text(
        'Quick Actions',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final action in actions)
              ActionChip(
                avatar: Icon(action.$1, size: 18),
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
              Icon(Icons.check_circle, color: ClayColors.success),
              SizedBox(width: 12),
              Text('All clear — nothing overdue, stock is healthy.'),
            ],
          ),
        ),
      );
    }

    return ClayCard(
      title: const Text(
        'Needs attention',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      child: Column(
        children: [
          if (overdue.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.warning, color: ClayColors.error),
              title: Text('${overdue.length} overdue invoice(s)'),
              subtitle: Text(
                AppTheme.formatCurrency(
                    overdue.fold(0.0, (total, t) => total + t.dueAmount)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/transactions'),
            ),
          if (lowStock.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.inventory_2, color: ClayColors.warning),
              title: Text('${lowStock.length} product(s) low on stock'),
              subtitle: Text(lowStock.take(3).map((p) => p.name).join(', ')),
              trailing: const Icon(Icons.chevron_right),
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
      title: const Text(
        'Recent transactions',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
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
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
