import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Receipts Screen with Claymorphism Design
/// This screen shows all receipts (payments received from customers)
class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Receipts'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Receipts',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddReceiptDialog(context),
            child: const Text('Add Receipt'),
          ),
        ],
      ),
      body: receipts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (receiptList) {
          if (receiptList.isEmpty) {
            return const _EmptyReceiptsState();
          }
          return _ReceiptsList(receipts: receiptList);
        },
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 4,
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
        title: const Text('Search Receipts'),
        content: const ClaySearchInput(hintText: 'Search by reference, contact, or amount'),
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
        title: const Text('Filter Receipts'),
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
              title: const Text('Cleared Only'),
              value: 'cleared',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Pending Only'),
              value: 'pending',
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

  void _showAddReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Receipt'),
        child: const _AddReceiptForm(),
      ),
    );
  }
}

/// Empty Receipts State
class _EmptyReceiptsState extends StatelessWidget {
  const _EmptyReceiptsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Receipts Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first receipt to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/receipts'),
            child: const Text('Add Receipt'),
          ),
        ],
      ),
    );
  }
}

/// Receipts List
class _ReceiptsList extends ConsumerWidget {
  final List<PaymentModel> receipts;

  const _ReceiptsList({required this.receipts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        return _ReceiptItem(receipt: receipt);
      },
    );
  }
}

/// Receipt Item
class _ReceiptItem extends StatelessWidget {
  final PaymentModel receipt;

  const _ReceiptItem({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showReceiptDetailDialog(context, receipt),
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
              Icons.receipt_long,
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
                  receipt.invoiceNumber ?? receipt.referenceDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'From: ${receipt.contactId}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  receipt.methodDisplayName,
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
                '${AppConstants.CURRENCY} ${receipt.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.success,
                ),
              ),
              const SizedBox(height: 4),
              _ReceiptStatusBadge(status: receipt.isClearedPayment ? 'Cleared' : 'Pending'),
              const SizedBox(height: 4),
              Text(
                _formatDate(receipt.date),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showReceiptDetailDialog(BuildContext context, PaymentModel receipt) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text('Receipt - ${receipt.referenceDisplay}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReceiptDetailRow(
                icon: Icons.receipt,
                label: 'Receipt Number',
                value: receipt.invoiceNumber ?? receipt.referenceDisplay,
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: _formatDate(receipt.date),
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.people,
                label: 'From Contact',
                value: receipt.contactId,
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.article,
                label: 'Transaction ID',
                value: receipt.transactionId,
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.money,
                label: 'Amount',
                value: '${AppConstants.CURRENCY} ${receipt.amount.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.payment,
                label: 'Payment Method',
                value: receipt.methodDisplayName,
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.numbers,
                label: 'Reference',
                value: receipt.referenceDisplay,
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.account_balance,
                label: 'Bank',
                value: receipt.bankName ?? 'N/A',
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.description,
                label: 'Cheque Number',
                value: receipt.chequeNumber ?? 'N/A',
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.note,
                label: 'Notes',
                value: receipt.notes ?? 'N/A',
              ),
              const Divider(),
              _ReceiptDetailRow(
                icon: Icons.info,
                label: 'Status',
                value: receipt.isClearedPayment ? 'Cleared' : 'Pending',
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
          ClayButton(
            onPressed: () => _showPrintOptions(context, receipt),
            icon: Icons.print,
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  void _showPrintOptions(BuildContext context, PaymentModel receipt) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Print Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement print
              },
              child: const Text('Print Receipt'),
            ),
            const SizedBox(height: 8),
            ClayButton.outlined(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement PDF
              },
              child: const Text('Save as PDF'),
            ),
            const SizedBox(height: 8),
            ClayButton.outlined(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement share
              },
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Receipt Status Badge
class _ReceiptStatusBadge extends StatelessWidget {
  final String status;

  const _ReceiptStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    
    switch (status) {
      case 'Cleared':
        color = ClayColors.success;
        break;
      case 'Pending':
        color = ClayColors.warning;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

/// Receipt Detail Row
class _ReceiptDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReceiptDetailRow({
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

/// Add Receipt Form
class _AddReceiptForm extends ConsumerStatefulWidget {
  const _AddReceiptForm();

  @override
  ConsumerState<_AddReceiptForm> createState() => _AddReceiptFormState();
}

class _AddReceiptFormState extends ConsumerState<_AddReceiptForm> {
  final _formKey = GlobalKey<FormState>();
  String _transactionId = '';
  String _invoiceNumber = '';
  String _contactId = '';
  double _amount = 0.0;
  String _method = AppConstants.PAYMENT_CASH;
  String _referenceNumber = '';
  String _bankName = '';
  String _chequeNumber = '';
  DateTime? _chequeDate;
  DateTime? _date;
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Transaction ID *',
              hintText: 'Related transaction ID',
              value: _transactionId,
              onChanged: (value) => _transactionId = value,
              validator: (value) => value?.isEmpty == true ? 'Transaction ID is required' : null,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Invoice Number',
              hintText: 'Invoice number (optional)',
              value: _invoiceNumber,
              onChanged: (value) => _invoiceNumber = value,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Contact ID *',
              hintText: 'Customer ID',
              value: _contactId,
              onChanged: (value) => _contactId = value,
              validator: (value) => value?.isEmpty == true ? 'Contact ID is required' : null,
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Amount *',
              hintText: 'Receipt amount',
              value: _amount,
              onChanged: (value) => _amount = value,
              validator: (value) => value == null || value <= 0 ? 'Amount is required' : null,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Payment Method *',
              value: _method,
              items: const [
                DropdownMenuItem(value: AppConstants.PAYMENT_CASH, child: Text('Cash')),
                DropdownMenuItem(value: AppConstants.PAYMENT_BANK, child: Text('Bank Transfer')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CHEQUE, child: Text('Cheque')),
                DropdownMenuItem(value: AppConstants.PAYMENT_ONLINE, child: Text('Online Payment')),
                DropdownMenuItem(value: AppConstants.PAYMENT_CREDIT, child: Text('Credit Card')),
              ],
              onChanged: (value) => setState(() => _method = value!),
              validator: (value) => value == null ? 'Method is required' : null,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Reference Number',
              hintText: 'Reference number',
              value: _referenceNumber,
              onChanged: (value) => _referenceNumber = value,
            ),
            const SizedBox(height: 16),
            if (_method == AppConstants.PAYMENT_BANK || _method == AppConstants.PAYMENT_CHEQUE) ...[
              ClayInputWithLabel(
                label: 'Bank Name',
                hintText: 'Bank name',
                value: _bankName,
                onChanged: (value) => _bankName = value,
              ),
              const SizedBox(height: 16),
            ],
            if (_method == AppConstants.PAYMENT_CHEQUE) ...[
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'Cheque Number',
                      hintText: 'Cheque number',
                      value: _chequeNumber,
                      onChanged: (value) => _chequeNumber = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayDateInput(
                      label: 'Cheque Date',
                      value: _chequeDate,
                      onChanged: (value) => _chequeDate = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            ClayDateInput(
              label: 'Receipt Date',
              value: _date,
              onChanged: (value) => _date = value,
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

/// Provider for receipts
final receiptsProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  final allPayments = hiveService.paymentsBox.values.toList();
  return allPayments
      .where((p) => p.type == 'receipt')
      .toList();
});
