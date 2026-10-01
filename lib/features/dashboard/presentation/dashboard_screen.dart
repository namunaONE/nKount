import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/providers/storage_providers.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';
import 'package:nkount/features/contacts/presentation/contacts_screen.dart';
import 'package:nkount/features/purchases/presentation/purchases_screen.dart';
import 'package:nkount/features/sales/presentation/sales_screen.dart';
import 'package:nkount/features/payments/presentation/payments_screen.dart';

/// Dashboard Screen - Main screen of the application
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final contacts = ref.watch(contactsProvider);
    final products = ref.watch(productsProvider);
    final transactions = ref.watch(transactionsProvider);
    final payments = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Cards
            _buildSummaryCards(summary),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(context, transactions, payments),
            const SizedBox(height: 24),
            
            // Statistics
            _buildStatistics(summary),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddMenu(context, ref);
        },
      ),
    );
  }

  /// Build summary cards
  Widget _buildSummaryCards(DashboardSummary summary) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildSummaryCard(
                  'Total Sales',
                  AppTheme.formatCurrency(summary.totalSales),
                  Icons.trending_up,
                  Colors.green,
                ),
                _buildSummaryCard(
                  'Total Purchases',
                  AppTheme.formatCurrency(summary.totalPurchases),
                  Icons.trending_down,
                  Colors.orange,
                ),
                _buildSummaryCard(
                  'Receivables',
                  AppTheme.formatCurrency(summary.totalReceivables),
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
                _buildSummaryCard(
                  'Payables',
                  AppTheme.formatCurrency(summary.totalPayables),
                  Icons.money_off,
                  Colors.red,
                ),
                _buildSummaryCard(
                  'Cash Balance',
                  AppTheme.formatCurrency(summary.totalCash),
                  Icons.account_balance,
                  Colors.purple,
                ),
                _buildSummaryCard(
                  'Profit',
                  AppTheme.formatCurrency(summary.profit),
                  Icons.monetization_on,
                  Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary card
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick actions
  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildQuickActionButton(
                  context,
                  'New Sale',
                  Icons.add_shopping_cart,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesScreen(),
                    ),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'New Purchase',
                  Icons.shopping_basket,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchasesScreen(),
                    ),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'Add Contact',
                  Icons.person_add,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsScreen(),
                    ),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'Record Payment',
                  Icons.payment,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentsScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick action button
  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build recent activity
  Widget _buildRecentActivity(
    BuildContext context,
    List<TransactionModel> transactions,
    List<PaymentModel> payments,
  ) {
    // Combine and sort by date
    final recentTransactions = transactions
        .where((t) => !t.isCancelled)
        .toList()
        ..sort((a, b) => b.date?.compareTo(a.date ?? DateTime.now()) ?? 0)
        .take(5)
        .toList();

    final recentPayments = payments
        .where((p) => !p.isCancelled)
        .toList()
        ..sort((a, b) => b.date?.compareTo(a.date ?? DateTime.now()) ?? 0)
        .take(5)
        .toList();

    final allRecent = [...recentTransactions, ...recentPayments]
        ..sort((a, b) => b.date?.compareTo(a.date ?? DateTime.now()) ?? 0)
        .take(10)
        .toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (allRecent.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allRecent.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = allRecent[index];
                  if (item is TransactionModel) {
                    return _buildTransactionItem(item);
                  } else if (item is PaymentModel) {
                    return _buildPaymentItem(item);
                  }
                  return const SizedBox();
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Build transaction item
  Widget _buildTransactionItem(TransactionModel transaction) {
    final color = transaction.type == AppConstants.TRANSACTION_SALE 
        ? Colors.green 
        : Colors.blue;
    final icon = transaction.type == AppConstants.TRANSACTION_SALE 
        ? Icons.arrow_upward 
        : Icons.arrow_downward;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        '${transaction.typeDisplayName} - ${transaction.invoiceNumber ?? 'N/A'}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Contact: ${transaction.contactId}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppTheme.formatCurrency(transaction.total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.isFullyPaid ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            transaction.date != null 
                ? '${transaction.date!.day}/${transaction.date!.month}/${transaction.date!.year}'
                : 'N/A',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Build payment item
  Widget _buildPaymentItem(PaymentModel payment) {
    final color = payment.type == 'receipt' ? Colors.green : Colors.red;
    final icon = payment.type == 'receipt' ? Icons.call_received : Icons.call_made;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        '${payment.typeDisplayName} - ${payment.referenceDisplay}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Method: ${payment.methodDisplayName}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppTheme.formatCurrency(payment.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            payment.date != null 
                ? '${payment.date!.day}/${payment.date!.month}/${payment.date!.year}'
                : 'N/A',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Build statistics
  Widget _buildStatistics(DashboardSummary summary) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Contacts',
                    summary.totalContacts.toString(),
                    Icons.contacts,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Products',
                    summary.totalProducts.toString(),
                    Icons.inventory,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Transactions',
                    summary.totalTransactions.toString(),
                    Icons.receipt,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Low Stock',
                    summary.lowStockProducts.toString(),
                    Icons.warning,
                    warning: summary.lowStockProducts > 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build stat item
  Widget _buildStatItem(String title, String value, IconData icon, {bool warning = false}) {
    return Card(
      elevation: warning ? 2 : 0,
      color: warning ? Colors.amber[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: warning ? Colors.amber : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: warning ? Colors.amber : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build drawer
  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    final company = ref.watch(companyProvider);
    
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_balance, size: 30, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(
                  company?.name ?? AppConstants.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (company != null)
                  Text(
                    company.fullAddress,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  'Dashboard',
                  Icons.dashboard,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  'Contacts',
                  Icons.contacts,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  'Products',
                  Icons.inventory,
                  () {
                    // Navigator.push for products
                  },
                ),
                _buildDrawerItem(
                  context,
                  'Sales',
                  Icons.shopping_cart,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  'Purchases',
                  Icons.shopping_basket,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchasesScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  'Payments',
                  Icons.payment,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentsScreen(),
                    ),
                  ),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  'Reports',
                  Icons.assessment,
                  () {
                    // Navigator.push for reports
                  },
                ),
                _buildDrawerItem(
                  context,
                  'Settings',
                  Icons.settings,
                  () {
                    // Navigator.push for settings
                  },
                ),
              ],
            ),
          ),
          
          // Drawer Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'v${AppConstants.appVersion}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'IRD Compliant',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build drawer item
  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  /// Show add menu
  void _showAddMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.purple),
                title: const Text('New Contact'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_shopping_cart, color: Colors.green),
                title: const Text('New Sale'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_basket, color: Colors.blue),
                title: const Text('New Purchase'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchasesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.orange),
                title: const Text('Record Payment'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
