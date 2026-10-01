import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Expenses Screen with Claymorphism Design
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Expenses'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Expenses',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddExpenseDialog(context),
            child: const Text('Add Expense'),
          ),
        ],
      ),
      body: expenses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (expenseList) {
          if (expenseList.isEmpty) {
            return const _EmptyExpensesState();
          }
          return _ExpensesList(expenses: expenseList);
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
        title: const Text('Search Expenses'),
        content: const ClaySearchInput(hintText: 'Search by description, category, or amount'),
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
        title: const Text('Filter Expenses'),
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
              title: const Text('Today'),
              value: 'today',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Week'),
              value: 'this_week',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Month'),
              value: 'this_month',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('This Year'),
              value: 'this_year',
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

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Expense'),
        child: const _AddExpenseForm(),
      ),
    );
  }
}

/// Empty Expenses State
class _EmptyExpensesState extends StatelessWidget {
  const _EmptyExpensesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.money_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Expenses Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first expense to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/expenses'),
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}

/// Expenses List
class _ExpensesList extends ConsumerWidget {
  final List<TransactionModel> expenses;

  const _ExpensesList({required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return _ExpenseItem(expense: expense);
      },
    );
  }
}

/// Expense Item
class _ExpenseItem extends StatelessWidget {
  final TransactionModel expense;

  const _ExpenseItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showExpenseDetailDialog(context, expense),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClayColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.money_off,
              color: ClayColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.invoiceNumber ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense.notes ?? 'No description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getCategoryLabel(expense),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppConstants.CURRENCY} ${expense.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.error,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(expense.date),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(TransactionModel expense) {
    // Extract category from notes or items
    if (expense.notes != null && expense.notes!.isNotEmpty) {
      final lowerNotes = expense.notes!.toLowerCase();
      if (lowerNotes.contains('rent')) return 'Rent';
      if (lowerNotes.contains('salary')) return 'Salary';
      if (lowerNotes.contains('electricity') || lowerNotes.contains('electric')) return 'Electricity';
      if (lowerNotes.contains('water')) return 'Water';
      if (lowerNotes.contains('internet') || lowerNotes.contains('wifi')) return 'Internet';
      if (lowerNotes.contains('phone') || lowerNotes.contains('mobile')) return 'Phone';
      if (lowerNotes.contains('transport') || lowerNotes.contains('fuel')) return 'Transport';
      if (lowerNotes.contains('food') || lowerNotes.contains('meal')) return 'Food';
      if (lowerNotes.contains('stationery') || lowerNotes.contains('office')) return 'Office';
      if (lowerNotes.contains('travel')) return 'Travel';
      if (lowerNotes.contains('maintenance')) return 'Maintenance';
      if (lowerNotes.contains('insurance')) return 'Insurance';
      if (lowerNotes.contains('tax')) return 'Tax';
      if (lowerNotes.contains('bank') || lowerNotes.contains('interest')) return 'Bank Charges';
      if (lowerNotes.contains('advertising') || lowerNotes.contains('marketing')) return 'Marketing';
    }
    return 'General';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showExpenseDetailDialog(BuildContext context, TransactionModel expense) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text('Expense - ${expense.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExpenseDetailRow(
                icon: Icons.receipt,
                label: 'Expense No',
                value: expense.invoiceNumber ?? 'N/A',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: _formatDate(expense.date),
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.people,
                label: 'Contact',
                value: expense.contactId,
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.money,
                label: 'Amount',
                value: '${AppConstants.CURRENCY} ${expense.total.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.percent,
                label: 'VAT Rate',
                value: '${expense.vatRate}%',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.money,
                label: 'VAT Amount',
                value: '${AppConstants.CURRENCY} ${expense.tax.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.note,
                label: 'Description',
                value: expense.notes ?? 'N/A',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.category,
                label: 'Category',
                value: _getCategoryLabel(expense),
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.payment,
                label: 'Payment Method',
                value: expense.paymentMethod ?? 'N/A',
              ),
              const Divider(),
              _ExpenseDetailRow(
                icon: Icons.info,
                label: 'Payment Status',
                value: expense.paymentStatus,
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
          ClayButton(
            onPressed: () {},
            style: ClayButtonStyle(
              backgroundColor: ClayColors.error.withOpacity(0.1),
              foregroundColor: ClayColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Expense Detail Row
class _ExpenseDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ExpenseDetailRow({
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

/// Add Expense Form
class _AddExpenseForm extends ConsumerStatefulWidget {
  const _AddExpenseForm();

  @override
  ConsumerState<_AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<_AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _invoiceNumber = '';
  String _contactId = '';
  double _amount = 0.0;
  String _description = '';
  String _category = 'General';
  String _paymentMethod = AppConstants.PAYMENT_CASH;
  double _vatRate = 13.0;
  bool _isVatIncluded = true;
  DateTime? _date;
  String _referenceNumber = '';

  final List<String> _categories = [
    'General',
    'Rent',
    'Salary',
    'Electricity',
    'Water',
    'Internet',
    'Phone',
    'Transport',
    'Food',
    'Office Supplies',
    'Travel',
    'Maintenance',
    'Insurance',
    'Tax',
    'Bank Charges',
    'Marketing',
    'Professional Fees',
    'Miscellaneous',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Expense Number',
              hintText: 'Expense reference number',
              value: _invoiceNumber,
              onChanged: (value) => _invoiceNumber = value,
            ),
            const SizedBox(height: 16),
            ClayDateInput(
              label: 'Date',
              value: _date,
              onChanged: (value) => _date = value,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Contact / Vendor (Optional)',
              hintText: 'Contact ID or name',
              value: _contactId,
              onChanged: (value) => _contactId = value,
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Amount *',
              hintText: 'Expense amount',
              value: _amount,
              onChanged: (value) => _amount = value,
              validator: (value) => value == null || value <= 0 ? 'Amount is required' : null,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Category *',
              value: _category,
              items: _categories.map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              )).toList(),
              onChanged: (value) => setState(() => _category = value!),
              validator: (value) => value == null ? 'Category is required' : null,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Payment Method',
              value: _paymentMethod,
              items: const [
                DropdownMenuItem(value: AppConstants.PAYMENT_CASH, child: Text('Cash')),
                DropdownMenuItem(value: AppConstants.PAYMENT_BANK, child: Text('Bank Transfer')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CHEQUE, child: Text('Cheque')),
                DropdownMenuItem(value: AppConstants.PAYMENT_ONLINE, child: Text('Online Payment')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CREDIT, child: Text('Credit Card')),
              ],
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'VAT Rate %',
                    hintText: 'VAT rate',
                    value: _vatRate.toString(),
                    onChanged: (value) => _vatRate = double.tryParse(value) ?? 13.0,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClaySwitchInput(
                    label: 'VAT Included',
                    value: _isVatIncluded,
                    onChanged: (value) => setState(() => _isVatIncluded = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Reference Number',
              hintText: 'Cheque number, transaction ID, etc.',
              value: _referenceNumber,
              onChanged: (value) => _referenceNumber = value,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Description',
              hintText: 'Expense description',
              value: _description,
              onChanged: (value) => _description = value,
              maxLines: 3,
              validator: (value) => value?.isEmpty == true ? 'Description is recommended' : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for expenses
final expensesProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  final allTransactions = hiveService.transactionsBox.values.toList();
  return allTransactions
      .where((t) => t.type == AppConstants.TRANSACTION_EXPENSE)
      .toList();
});

/// Provider for HiveService
final hiveServiceProvider = Provider<HiveService>((ref) {
  return hiveService;
});
