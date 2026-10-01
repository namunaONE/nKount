import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Dashboard Screen with Claymorphism Design
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbStats = ref.watch(dashboardStatsProvider);
    final theme = Theme.of(context);
    
    return ClayScaffold(
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
          ClayIconButton(
            icon: Icons.settings,
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Cards Row
            const _StatsCards(),
            const SizedBox(height: 24),
            
            // Quick Actions Section
            _QuickActionsSection(dbStats: dbStats),
            const SizedBox(height: 24),
            
            // Recent Activity Section
            const _RecentActivitySection(),
            const SizedBox(height: 24),
            
            // Summary Cards
            const _SummaryCards(),
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
          final routes = ['/', '/contacts', '/products', '/transactions', '/payments'];
          if (index < routes.length) {
            context.go(routes[index]);
          }
        },
      ),
    );
  }
}

/// Stats Cards Widget
class _StatsCards extends ConsumerWidget {
  const _StatsCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    
    return Row(
      children: [
        Expanded(
          child: ClayStatCard(
            title: 'Total Contacts',
            value: stats['contacts'].toString(),
            icon: Icons.people,
            iconColor: ClayColors.primary,
            onTap: () => context.push('/contacts'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayStatCard(
            title: 'Products',
            value: stats['products'].toString(),
            icon: Icons.inventory,
            iconColor: ClayColors.secondary,
            onTap: () => context.push('/products'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayStatCard(
            title: 'Transactions',
            value: stats['transactions'].toString(),
            icon: Icons.receipt,
            iconColor: ClayColors.tertiary,
            onTap: () => context.push('/transactions'),
          ),
        ),
      ],
    );
  }
}

/// Quick Actions Section
class _QuickActionsSection extends StatelessWidget {
  final Map<String, dynamic> dbStats;
  
  const _QuickActionsSection({required this.dbStats});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'Quick Actions',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _QuickActionButton(
              icon: Icons.add,
              label: 'New Contact',
              color: ClayColors.primary,
              onTap: () => context.push('/contacts'),
            ),
            _QuickActionButton(
              icon: Icons.add_shopping_cart,
              label: 'New Product',
              color: ClayColors.secondary,
              onTap: () => context.push('/products'),
            ),
            _QuickActionButton(
              icon: Icons.receipt_long,
              label: 'New Sale',
              color: ClayColors.tertiary,
              onTap: () => context.push('/transactions'),
            ),
            _QuickActionButton(
              icon: Icons.shopping_bag,
              label: 'New Purchase',
              color: ClayColors.success,
              onTap: () => context.push('/transactions'),
            ),
            _QuickActionButton(
              icon: Icons.payment,
              label: 'New Payment',
              color: ClayColors.warning,
              onTap: () => context.push('/payments'),
            ),
            _QuickActionButton(
              icon: Icons.analytics,
              label: 'View Reports',
              color: ClayColors.info,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick Action Button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClayButton(
      onPressed: onTap,
      style: ClayButtonStyle(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        borderRadius: ClayRadius.medium,
        padding: const EdgeInsets.all(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Recent Activity Section
class _RecentActivitySection extends ConsumerWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClayCard(
      title: const Text(
        'Recent Activity',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ActivityItem(
              icon: Icons.people,
              title: 'New Contact Added',
              subtitle: 'John Doe - Customer',
              time: '2 minutes ago',
              color: ClayColors.primary,
            ),
            const Divider(height: 16),
            _ActivityItem(
              icon: Icons.inventory,
              title: 'Product Updated',
              subtitle: 'Laptop - Price updated',
              time: '5 minutes ago',
              color: ClayColors.secondary,
            ),
            const Divider(height: 16),
            _ActivityItem(
              icon: Icons.receipt,
              title: 'New Sale',
              subtitle: 'INV-001 - NPR 15,000',
              time: '10 minutes ago',
              color: ClayColors.tertiary,
            ),
            const SizedBox(height: 8),
            ClayButton.text(
              onPressed: () => context.push('/transactions'),
              child: const Text('View All Activity'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Activity Item
class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

/// Summary Cards
class _SummaryCards extends ConsumerWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ClayCard(
            title: const Text(
              'Revenue Today',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'NPR 0.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.success,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayCard(
            title: const Text(
              'Expenses Today',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'NPR 0.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.error,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayCard(
            title: const Text(
              'Net Balance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'NPR 0.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Provider for dashboard statistics
final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.getBoxStats();
});

/// Provider for HiveService
final hiveServiceProvider = Provider<HiveService>((ref) {
  return hiveService;
});
