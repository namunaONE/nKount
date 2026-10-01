import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Transactions Screen with Claymorphism Design
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Transactions'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Transactions',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddTransactionDialog(context),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
      body: transactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (transactionList) {
          if (transactionList.isEmpty) {
            return const _EmptyTransactionsState();
          }
          return _TransactionsList(transactions: transactionList);
        },
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 3,
        items: const [
          ClayBottomNavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/'),
          ClayBottomNavItem(icon: Icons.people, label: 'Contacts', route: '/contacts'),
          ClayBottomNavItem(icon: Icons.inventory, label: 'Products', route: '/products'),
          ClayBottomNavItem(icon: Icons.receipt, label: 'Transactions', route: '/transactions'),
          ClayBottomNavItem(icon: Icons.payment, label: 'Payments', route: '/payments'),
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Transactions'),
        content: const ClaySearchInput(hintText: 'Search by invoice number, contact, or amount'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayRadioListTile<String>(
              title: const Text('All'),
              value: 'all',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Sales'),
              value: AppConstants.TRANSACTION_SALE,
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Purchases'),
              value: AppConstants.TRANSACTION_PURCHASE,
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Today'),
              value: 'today',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Month'),
              value: 'this_month',
              groupValue: 'all',
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

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Transaction'),
        child: const _AddTransactionForm(),
      ),
    );
  }
}

/// Empty Transactions State
class _EmptyTransactionsState extends StatelessWidget {
  const _EmptyTransactionsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Transactions Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first transaction to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/transactions'),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}

/// Transactions List
class _TransactionsList extends ConsumerWidget {
  final List<TransactionModel> transactions;

  const _TransactionsList({required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _TransactionItem(transaction: transaction);
      },
    );
  }
}

/// Transaction Item
class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showTransactionDetailDialog(context, transaction),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTransactionTypeColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionTypeIcon(transaction.type),
              color: _getTransactionTypeColor(transaction.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.invoiceNumber ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.typeDisplayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTransactionTypeColor(transaction.type),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Items: ${transaction.items?.length ?? 0}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'NPR ${transaction.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              _PaymentStatusBadge(status: transaction.paymentStatus),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTransactionTypeColor(String type) {
    switch (type) {
      case AppConstants.TRANSACTION_SALE:
        return ClayColors.success;
      case AppConstants.TRANSACTION_PURCHASE:
        return ClayColors.secondary;
      case AppConstants.TRANSACTION_EXPENSE:
        return ClayColors.error;
      case AppConstants.TRANSACTION_INCOME:
        return ClayColors.info;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionTypeIcon(String type) {
    switch (type) {
      case AppConstants.TRANSACTION_SALE:
        return Icons.arrow_upward;
      case AppConstants.TRANSACTION_PURCHASE:
        return Icons.arrow_downward;
      case AppConstants.TRANSACTION_EXPENSE:
        return Icons.money_off;
      case AppConstants.TRANSACTION_INCOME:
        return Icons.money;
      default:
        return Icons.receipt;
    }
  }

  void _showTransactionDetailDialog(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text('${transaction.typeDisplayName} - ${transaction.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TransactionDetailRow(
                icon: Icons.receipt,
                label: 'Invoice Number',
                value: transaction.invoiceNumber ?? 'N/A',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: transaction.date?.toString().substring(0, 10) ?? 'N/A',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.people,
                label: 'Contact ID',
                value: transaction.contactId,
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.money,
                label: 'Subtotal',
                value: 'NPR ${transaction.subtotal.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.discount,
                label: 'Discount',
                value: 'NPR ${transaction.discount.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.percent,
                label: 'VAT Rate',
                value: '${transaction.vatRate}%',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.money,
                label: 'Tax Amount',
                value: 'NPR ${transaction.tax.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.money,
                label: 'Total',
                value: 'NPR ${transaction.total.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.payment,
                label: 'Paid Amount',
                value: 'NPR ${transaction.paidAmount.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.money_off,
                label: 'Due Amount',
                value: 'NPR ${transaction.dueAmount.toStringAsFixed(2)}',
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.info,
                label: 'Payment Status',
                value: transaction.paymentStatus,
              ),
              const Divider(),
              _TransactionDetailRow(
                icon: Icons.note,
                label: 'Notes',
                value: transaction.notes ?? 'N/A',
              ),
            ],
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ClayButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

/// Transaction Detail Row
class _TransactionDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TransactionDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment Status Badge
class _PaymentStatusBadge extends StatelessWidget {
  final String status;

  const _PaymentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    
    switch (status) {
      case AppConstants.PAYMENT_STATUS_PAID:
        color = ClayColors.success;
        label = 'Paid';
        break;
      case AppConstants.PAYMENT_STATUS_PARTIAL:
        color = ClayColors.warning;
        label = 'Partial';
        break;
      case AppConstants.PAYMENT_STATUS_PENDING:
        color = ClayColors.error;
        label = 'Pending';
        break;
      case AppConstants.PAYMENT_STATUS_CANCELLED:
        color = Colors.grey;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

/// Add Transaction Form
class _AddTransactionForm extends ConsumerStatefulWidget {
  const _AddTransactionForm();

  @override
  ConsumerState<_AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<_AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = AppConstants.TRANSACTION_SALE;
  String _invoiceNumber = '';
  String _contactId = '';
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _total = 0.0;
  double _paidAmount = 0.0;
  String _paymentStatus = AppConstants.PAYMENT_STATUS_PENDING;
  String _paymentMethod = AppConstants.PAYMENT_CASH;
  String _referenceNumber = '';
  DateTime? _date;
  DateTime? _dueDate;
  String _notes = '';
  bool _isVatIncluded = true;
  double _vatRate = 13.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayDropdownInput<String>(
              label: 'Transaction Type *',
              value: _type,
              items: const [
                DropdownMenuItem(value: AppConstants.TRANSACTION_SALE, child: Text('Sale')),
                DropdownMenuItem(value: AppConstants.TRANSACTION_PURCHASE, child: Text('Purchase')),
                DropdownMenuItem(value: AppConstants.TRANSACTION_EXPENSE, child: Text('Expense')),
                DropdownMenuItem(value: AppConstants.TRANSACTION_INCOME, child: Text('Income')),
              ],
              onChanged: (value) => setState(() => _type = value!),
              validator: (value) => value == null ? 'Type is required' : null,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Invoice Number',
              hintText: 'Invoice number',
              value: _invoiceNumber,
              onChanged: (value) => _invoiceNumber = value,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Contact ID *',
              hintText: 'Contact ID',
              value: _contactId,
              onChanged: (value) => _contactId = value,
              validator: (value) => value?.isEmpty == true ? 'Contact ID is required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayDateInput(
                    label: 'Date',
                    value: _date,
                    onChanged: (value) => _date = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayDateInput(
                    label: 'Due Date',
                    value: _dueDate,
                    onChanged: (value) => _dueDate = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Subtotal',
                    hintText: 'Subtotal',
                    value: _subtotal,
                    onChanged: (value) => _subtotal = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Discount',
                    hintText: 'Discount',
                    value: _discount,
                    onChanged: (value) => _discount = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Tax',
                    hintText: 'Tax',
                    value: _tax,
                    onChanged: (value) => _tax = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Total',
                    hintText: 'Total',
                    value: _total,
                    onChanged: (value) => _total = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Paid Amount',
              hintText: 'Paid amount',
              value: _paidAmount,
              onChanged: (value) => _paidAmount = value,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Payment Status',
              value: _paymentStatus,
              items: const [
                DropdownMenuItem(value: AppConstants.PAYMENT_STATUS_PENDING, child: Text('Pending')),
                DropdownMenuItem(value: AppConstants.PAYMENT_STATUS_PAID, child: Text('Paid')),
                DropdownMenuItem(value: AppConstants.PAYMENT_STATUS_PARTIAL, child: Text('Partial')),
              ],
              onChanged: (value) => setState(() => _paymentStatus = value!),
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Payment Method',
              value: _paymentMethod,
              items: const [
                DropdownMenuItem(value: AppConstants.PAYMENT_CASH, child: Text('Cash')),
                DropdownMenuItem(value: AppConstants.PAYMENT_BANK, child: Text('Bank')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CHEQUE, child: Text('Cheque')),
                DropdownMenuItem(value: AppConstants.PAYMENT_ONLINE, child: Text('Online')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CREDIT, child: Text('Credit')),
              ],
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Reference Number',
              hintText: 'Reference number',
              value: _referenceNumber,
              onChanged: (value) => _referenceNumber = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClaySwitchInput(
                    label: 'VAT Included',
                    value: _isVatIncluded,
                    onChanged: (value) => setState(() => _isVatIncluded = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'VAT Rate %',
                    hintText: 'VAT rate',
                    value: _vatRate.toString(),
                    onChanged: (value) => _vatRate = double.tryParse(value) ?? 13.0,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Notes',
              hintText: 'Additional notes',
              value: _notes,
              onChanged: (value) => _notes = value,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for transactions
final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.transactionsBox.values.toList();
});
