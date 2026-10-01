import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Payments Screen with Claymorphism Design
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Payments'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Payments',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddPaymentDialog(context),
            child: const Text('Add Payment'),
          ),
        ],
      ),
      body: payments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (paymentList) {
          if (paymentList.isEmpty) {
            return const _EmptyPaymentsState();
          }
          return _PaymentsList(payments: paymentList);
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
        title: const Text('Search Payments'),
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
        title: const Text('Filter Payments'),
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
              title: const Text('Payments'),
              value: 'payment',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Receipts'),
              value: 'receipt',
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

  void _showAddPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Payment'),
        child: const _AddPaymentForm(),
      ),
    );
  }
}

/// Empty Payments State
class _EmptyPaymentsState extends StatelessWidget {
  const _EmptyPaymentsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Payments Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first payment to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/payments'),
            child: const Text('Add Payment'),
          ),
        ],
      ),
    );
  }
}

/// Payments List
class _PaymentsList extends ConsumerWidget {
  final List<PaymentModel> payments;

  const _PaymentsList({required this.payments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _PaymentItem(payment: payment);
      },
    );
  }
}

/// Payment Item
class _PaymentItem extends StatelessWidget {
  final PaymentModel payment;

  const _PaymentItem({required this.payment});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showPaymentDetailDialog(context, payment),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getPaymentTypeColor(payment.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getPaymentTypeIcon(payment.type),
              color: _getPaymentTypeColor(payment.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.invoiceNumber ?? payment.referenceDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.typeDisplayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getPaymentTypeColor(payment.type),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.methodDisplayName,
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
                'NPR ${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              _PaymentStatusBadge(status: payment.isClearedPayment ? 'Cleared' : 'Pending'),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPaymentTypeColor(String type) {
    switch (type) {
      case 'payment':
        return ClayColors.error;
      case 'receipt':
        return ClayColors.success;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentTypeIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.arrow_downward;
      case 'receipt':
        return Icons.arrow_upward;
      default:
        return Icons.payment;
    }
  }

  void _showPaymentDetailDialog(BuildContext context, PaymentModel payment) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text('${payment.typeDisplayName} - ${payment.referenceDisplay}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PaymentDetailRow(
                icon: Icons.receipt,
                label: 'Invoice Number',
                value: payment.invoiceNumber ?? 'N/A',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: payment.date?.toString().substring(0, 10) ?? 'N/A',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.people,
                label: 'Contact ID',
                value: payment.contactId,
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.people,
                label: 'Transaction ID',
                value: payment.transactionId,
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.money,
                label: 'Amount',
                value: 'NPR ${payment.amount.toStringAsFixed(2)}',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.payment,
                label: 'Method',
                value: payment.methodDisplayName,
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.numbers,
                label: 'Reference',
                value: payment.referenceDisplay,
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.account_balance,
                label: 'Bank',
                value: payment.bankName ?? 'N/A',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.description,
                label: 'Cheque Number',
                value: payment.chequeNumber ?? 'N/A',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.note,
                label: 'Notes',
                value: payment.notes ?? 'N/A',
              ),
              const Divider(),
              _PaymentDetailRow(
                icon: Icons.info,
                label: 'Status',
                value: payment.isClearedPayment ? 'Cleared' : 'Pending',
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

/// Payment Detail Row
class _PaymentDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PaymentDetailRow({
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

/// Add Payment Form
class _AddPaymentForm extends ConsumerStatefulWidget {
  const _AddPaymentForm();

  @override
  ConsumerState<_AddPaymentForm> createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends ConsumerState<_AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'payment';
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
            ClayDropdownInput<String>(
              label: 'Payment Type *',
              value: _type,
              items: const [
                DropdownMenuItem(value: 'payment', child: Text('Payment')),
                DropdownMenuItem(value: 'receipt', child: Text('Receipt')),
              ],
              onChanged: (value) => setState(() => _type = value!),
              validator: (value) => value == null ? 'Type is required' : null,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Transaction ID *',
              hintText: 'Transaction ID',
              value: _transactionId,
              onChanged: (value) => _transactionId = value,
              validator: (value) => value?.isEmpty == true ? 'Transaction ID is required' : null,
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
            ClayCurrencyInput(
              label: 'Amount *',
              hintText: 'Amount',
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
                DropdownMenuItem(value: AppConstants.PAYMENT_CREDIT, child: Text('Credit')),
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
              label: 'Payment Date',
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

/// Provider for payments
final paymentsProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.paymentsBox.values.toList();
});
