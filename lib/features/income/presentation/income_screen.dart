import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Income Screen with Claymorphism Design
class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomes = ref.watch(incomeProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Income'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Income',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddIncomeDialog(context),
            child: const Text('Add Income'),
          ),
        ],
      ),
      body: incomes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (incomeList) {
          if (incomeList.isEmpty) {
            return const _EmptyIncomeState();
          }
          return _IncomeList(incomes: incomeList);
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
        title: const Text('Search Income'),
        content: const ClaySearchInput(hintText: 'Search by description, source, or amount'),
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
        title: const Text('Filter Income'),
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

  void _showAddIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Income'),
        child: const _AddIncomeForm(),
      ),
    );
  }
}

/// Empty Income State
class _EmptyIncomeState extends StatelessWidget {
  const _EmptyIncomeState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Income Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first income to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/income'),
            child: const Text('Add Income'),
          ),
        ],
      ),
    );
  }
}

/// Income List
class _IncomeList extends ConsumerWidget {
  final List<TransactionModel> incomes;

  const _IncomeList({required this.incomes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final income = incomes[index];
        return _IncomeItem(income: income);
      },
    );
  }
}

/// Income Item
class _IncomeItem extends StatelessWidget {
  final TransactionModel income;

  const _IncomeItem({required this.income});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showIncomeDetailDialog(context, income),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClayColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monetization_on,
              color: ClayColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income.invoiceNumber ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  income.notes ?? 'No description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getSourceLabel(income),
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
                '${AppConstants.CURRENCY} ${income.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.success,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(income.date),
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

  String _getSourceLabel(TransactionModel income) {
    if (income.notes != null && income.notes!.isNotEmpty) {
      final lowerNotes = income.notes!.toLowerCase();
      if (lowerNotes.contains('sale') || lowerNotes.contains('revenue')) return 'Sales';
      if (lowerNotes.contains('service')) return 'Service';
      if (lowerNotes.contains('interest')) return 'Interest';
      if (lowerNotes.contains('rent') || lowerNotes.contains('lease')) return 'Rent';
      if (lowerNotes.contains('investment')) return 'Investment';
      if (lowerNotes.contains('commission')) return 'Commission';
      if (lowerNotes.contains('refund')) return 'Refund';
      if (lowerNotes.contains('discount')) return 'Discount Received';
      if (lowerNotes.contains('subsidy')) return 'Subsidy';
      if (lowerNotes.contains('grant')) return 'Grant';
      if (lowerNotes.contains('gift')) return 'Gift';
      if (lowerNotes.contains('other')) return 'Other Income';
    }
    return 'General';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showIncomeDetailDialog(BuildContext context, TransactionModel income) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text('Income - ${income.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IncomeDetailRow(
                icon: Icons.receipt,
                label: 'Income No',
                value: income.invoiceNumber ?? 'N/A',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: _formatDate(income.date),
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.people,
                label: 'Contact / Source',
                value: income.contactId,
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.money,
                label: 'Amount',
                value: '${AppConstants.CURRENCY} ${income.total.toStringAsFixed(2)}',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.percent,
                label: 'VAT Rate',
                value: '${income.vatRate}%',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.money,
                label: 'VAT Amount',
                value: '${AppConstants.CURRENCY} ${income.tax.toStringAsFixed(2)}',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.note,
                label: 'Description',
                value: income.notes ?? 'N/A',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.category,
                label: 'Source',
                value: _getSourceLabel(income),
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.payment,
                label: 'Payment Method',
                value: income.paymentMethod ?? 'N/A',
              ),
              const Divider(),
              _IncomeDetailRow(
                icon: Icons.info,
                label: 'Payment Status',
                value: income.paymentStatus,
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

/// Income Detail Row
class _IncomeDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _IncomeDetailRow({
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

/// Add Income Form
class _AddIncomeForm extends ConsumerStatefulWidget {
  const _AddIncomeForm();

  @override
  ConsumerState<_AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends ConsumerState<_AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  String _invoiceNumber = '';
  String _contactId = '';
  double _amount = 0.0;
  String _description = '';
  String _source = 'General';
  String _paymentMethod = AppConstants.PAYMENT_CASH;
  double _vatRate = 0.0; // Most income types don't have VAT in Nepal
  bool _isVatIncluded = false;
  DateTime? _date;
  String _referenceNumber = '';

  final List<String> _sources = [
    'General',
    'Sales',
    'Service',
    'Interest',
    'Rent',
    'Investment',
    'Commission',
    'Refund',
    'Discount Received',
    'Subsidy',
    'Grant',
    'Gift',
    'Other Income',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Income Number',
              hintText: 'Income reference number',
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
              label: 'Contact / Source (Optional)',
              hintText: 'Contact ID or source name',
              value: _contactId,
              onChanged: (value) => _contactId = value,
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Amount *',
              hintText: 'Income amount',
              value: _amount,
              onChanged: (value) => _amount = value,
              validator: (value) => value == null || value <= 0 ? 'Amount is required' : null,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Income Source *',
              value: _source,
              items: _sources.map((source) => DropdownMenuItem(
                value: source,
                child: Text(source),
              )).toList(),
              onChanged: (value) => setState(() => _source = value!),
              validator: (value) => value == null ? 'Source is required' : null,
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
                    hintText: 'VAT rate (if applicable)',
                    value: _vatRate.toString(),
                    onChanged: (value) => _vatRate = double.tryParse(value) ?? 0.0,
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
              hintText: 'Income description',
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

/// Provider for income
final incomeProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  final allTransactions = hiveService.transactionsBox.values.toList();
  return allTransactions
      .where((t) => t.type == AppConstants.TRANSACTION_INCOME)
      .toList();
});
