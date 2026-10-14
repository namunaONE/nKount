import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/dates.dart';
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
            const ClayCommandSearch(),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(),
              SizedBox(height: 24),
              _KpiCards(),
              SizedBox(height: 24),
              ClayTwoColumn(
                main: _CashflowChart(),
                side: _QuickActions(),
              ),
              SizedBox(height: 24),
              ClayTwoColumn(
                main: _RecentTransactions(),
                side: _AlertsSection(),
              ),
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

/// Greeting header with BS long date + FY context.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final bsNow = NepaliDateTime.now();
    final startYear = bsNow.month >= 4 ? bsNow.year : bsNow.year - 1;
    final fy = '$startYear/${(startYear + 1).toString().substring(2)}';
    final bsLong =
        '${ClayBsDate.months[bsNow.month - 1]} ${bsNow.day}, ${bsNow.year} BS';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: ClayRadius.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: text.displaySmall
                ?.copyWith(color: scheme.onPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '$bsLong • FY $fy',
            style: text.bodyMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
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
        sum(transactions.where((t) => t.type == AppConstants.transactionSale));
    final expenses = sum(
        transactions.where((t) => t.type == AppConstants.transactionPurchase));
    final receivables = contacts
        .where((c) => c.balance > 0)
        .fold(0.0, (total, c) => total + c.balance);
    final payables = contacts
        .where((c) => c.balance < 0)
        .fold(0.0, (total, c) => total + c.balance.abs());

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

    final salesSpark = [
      for (final m in months) monthTotal(AppConstants.transactionSale, m)
    ];
    final purchasesSpark = [
      for (final m in months) monthTotal(AppConstants.transactionPurchase, m)
    ];

    final curMonth = DateTime(now.year, now.month);
    final prevMonth = DateTime(now.year, now.month - 1);
    final curRevenue = monthTotal(AppConstants.transactionSale, curMonth);
    final prevRevenue = monthTotal(AppConstants.transactionSale, prevMonth);
    final curExpenses = monthTotal(AppConstants.transactionPurchase, curMonth);
    final prevExpenses =
        monthTotal(AppConstants.transactionPurchase, prevMonth);

    double pct(double cur, double prev) =>
        prev == 0 ? (cur > 0 ? 100 : 0) : (cur - prev) / prev * 100;

    final revenuePct = pct(curRevenue, prevRevenue);
    final expensesPct = pct(curExpenses, prevExpenses);

    final cards = [
      _kpi(
        context,
        title: 'Revenue',
        value: formatCurrency(revenue),
        icon: ClayIcons.revenue,
        color: ClayColors.success,
        route: '/transactions',
        trend: ClayTrend(pct: revenuePct),
        spark: salesSpark,
      ),
      _kpi(
        context,
        title: 'Expenses',
        value: formatCurrency(expenses),
        icon: ClayIcons.expenses,
        color: ClayColors.error,
        route: '/transactions',
        trend: ClayTrend(pct: expensesPct, invert: true),
        spark: purchasesSpark,
      ),
      _kpi(
        context,
        title: 'Receivables',
        value: formatCurrency(receivables),
        icon: ClayIcons.receivables,
        color: ClayColors.info,
        route: '/contacts',
        subtitle: 'Outstanding',
      ),
      _kpi(
        context,
        title: 'Payables',
        value: formatCurrency(payables),
        icon: ClayIcons.payables,
        color: ClayColors.warning,
        route: '/contacts',
        subtitle: 'Outstanding',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < ClayBreakpoints.compactMax) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // v3: taller stat cards (trend chip + sparkline need ~190px
            // at ~160px cell width; 1.0 overflowed in Edge testing).
            childAspectRatio: 0.8,
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
    Widget? trend,
    List<double>? spark,
    String? subtitle,
  }) =>
      ClayStatCard(
        title: title,
        value: value,
        icon: icon,
        iconColor: color,
        onTap: () => context.push(route),
        trend: trend,
        spark: spark,
        subtitle: subtitle,
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
      for (final m in months) monthTotal(AppConstants.transactionSale, m)
    ];
    final purchases = [
      for (final m in months) monthTotal(AppConstants.transactionPurchase, m)
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

    final isEmpty = [...sales, ...purchases].every((v) => v == 0);

    if (isEmpty) {
      return ClayCard(
        title: const ClaySectionTitle('Cashflow — last 6 months'),
        child: ClayEmptyState(
          title: 'No data yet',
          subtitle: 'Record your first sale to see cashflow here.',
          icon: ClayIcons.transactions,
          action: ClayButton(
            onPressed: () => context.push('/sales'),
            child: const Text('New Sale'),
          ),
        ),
      );
    }

    final text = Theme.of(context).textTheme;
    final dark =
        Theme.of(context).brightness == Brightness.dark;
    final salesColor = dark ? ClayColors.chartUpDark : ClayColors.success;
    final purchColor = dark ? ClayColors.chartDownDark : ClayColors.error;

    return ClayCard(
      title: const ClaySectionTitle('Cashflow — last 6 months'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: salesColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('Sales', style: text.labelSmall),
                const SizedBox(width: 16),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: purchColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text('Purchases', style: text.labelSmall),
              ],
            ),
            const SizedBox(height: 12),
            RepaintBoundary(
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
                              color: salesColor,
                              width: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            BarChartRodData(
                              toY: purchases[i],
                              color: purchColor,
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
          ],
        ),
      ),
    );
  }
}

/// Quick-action tiles in an adaptive grid.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('Quick Actions'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Max-extent delegate (not a breakpoint count): tiles keep a
          // fixed 150px height at ANY width, so side-column cells can
          // never overflow (see Edge RenderFlex overflow reports).
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 150,
            ),
            children: [
              ClayActionTile(
                icon: ClayIcons.contacts,
                title: 'New Contact',
                iconColor: ClayColors.info,
                onTap: () => context.push('/contacts'),
              ),
              ClayActionTile(
                icon: ClayIcons.products,
                title: 'New Product',
                iconColor: ClayColors.tertiary,
                onTap: () => context.push('/products'),
              ),
              ClayActionTile(
                icon: ClayIcons.sales,
                title: 'New Sale',
                iconColor: ClayColors.success,
                onTap: () => context.push('/sales'),
              ),
              ClayActionTile(
                icon: ClayIcons.purchases,
                title: 'New Purchase',
                iconColor: ClayColors.error,
                onTap: () => context.push('/purchases'),
              ),
              ClayActionTile(
                icon: ClayIcons.payments,
                title: 'New Payment',
                iconColor: ClayColors.primary,
                onTap: () => context.push('/payments'),
              ),
              ClayActionTile(
                icon: ClayIcons.reports,
                title: 'Reports',
                iconColor: ClayColors.warning,
                onTap: () => context.push('/reports'),
              ),
            ],
          ),
        ),
      );
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
              Icon(ClayIcons.check,
                  color: ClayColors.success, size: ClayIconSize.md),
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
              leading: const Icon(ClayIcons.alert,
                  color: ClayColors.error, size: ClayIconSize.md),
              title: Text('${overdue.length} overdue invoice(s)'),
              subtitle: Text(
                formatCurrency(
                    overdue.fold(0.0, (total, t) => total + t.dueAmount)),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/transactions'),
            ),
          if (lowStock.isNotEmpty)
            ListTile(
              leading: const Icon(ClayIcons.products,
                  color: ClayColors.warning, size: ClayIconSize.md),
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
                for (var i = 0; i < items.length; i++)
                  ClayEntrance(
                    delay: ClayMotion.stagger(i),
                    child: ListTile(
                      leading: Icon(
                        items[i].type == AppConstants.transactionSale
                            ? ClayIcons.receivables
                            : ClayIcons.payables,
                        color: items[i].type == AppConstants.transactionSale
                            ? ClayColors.success
                            : ClayColors.error,
                        size: ClayIconSize.md,
                      ),
                      title: Text(items[i].invoiceNumber ?? items[i].type),
                      subtitle: Text(
                        formatDate(items[i].date),
                      ),
                      trailing: Text(
                        formatCurrency(items[i].total),
                      ),
                      onTap: () => context.push('/transactions'),
                    ),
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
