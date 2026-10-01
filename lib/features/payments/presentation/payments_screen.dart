import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/providers/storage_providers.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';

/// Payments Screen for managing payments and receipts
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  String _searchQuery = '';
  String _selectedType = 'all';
  String _selectedMethod = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentsProvider);
    final filteredPayments = _filterPayments(payments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search payments...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          // Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Received',
                    AppTheme.formatCurrency(
                      ref.read(paymentRepositoryProvider).getTotalPaymentsReceived()
                    ),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Paid',
                    AppTheme.formatCurrency(
                      ref.read(paymentRepositoryProvider).getTotalPaymentsMade()
                    ),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Cash',
                    AppTheme.formatCurrency(
                      ref.read(paymentRepositoryProvider).getCashPayments()
                    ),
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Date Range Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _startDate != null 
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Start Date',
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectStartDate,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _endDate != null 
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'End Date',
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectEndDate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Payments List
          Expanded(
            child: filteredPayments.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No payments found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Record your first payment to get started',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPayments.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final payment = filteredPayments[index];
                      return _buildPaymentItem(payment);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddPaymentDialog(),
      ),
    );
  }

  /// Filter payments based on search, type, method, and date range
  List<PaymentModel> _filterPayments(List<PaymentModel> payments) {
    var filtered = payments;
    
    if (_selectedType != 'all') {
      filtered = filtered.where((p) => p.type == _selectedType).toList();
    }
    
    if (_selectedMethod != 'all') {
      filtered = filtered.where((p) => p.method == _selectedMethod).toList();
    }
    
    if (_startDate != null || _endDate != null) {
      filtered = filtered.where((p) {
        if (_startDate != null && p.date != null) {
          if (p.date!.isBefore(_startDate!)) return false;
        }
        if (_endDate != null && p.date != null) {
          if (p.date!.isAfter(_endDate!)) return false;
        }
        return true;
      }).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) => 
            p.invoiceNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false ||
            (p.contactId.toLowerCase().contains(_searchQuery.toLowerCase())) ||
            (p.referenceNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            (p.bankName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
          )
          .toList();
    }
    
    return filtered;
  }

  /// Build summary card
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build payment item
  Widget _buildPaymentItem(PaymentModel payment) {
    final color = payment.type == 'receipt' ? Colors.green : Colors.red;
    final icon = payment.type == 'receipt' ? Icons.call_received : Icons.call_made;

    return Card(
      elevation: 2,
      color: payment.isCancelled ? Colors.grey[100] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          '${payment.typeDisplayName} - ${payment.referenceDisplay}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: payment.isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact: ${payment.contactId}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Method: ${payment.methodDisplayName}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppTheme.formatCurrency(payment.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: payment.isCancelled ? Colors.grey : color,
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
        onTap: () => _showPaymentDetails(payment),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Payments'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('All'),
                value: 'all',
                groupValue: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              RadioListTile<String>(
                title: const Text('Receipts'),
                value: 'receipt',
                groupValue: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              RadioListTile<String>(
                title: const Text('Payments'),
                value: 'payment',
                groupValue: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const Divider(),
              const Text('Method', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('All'),
                value: 'all',
                groupValue: _selectedMethod,
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Cash'),
                value: AppConstants.PAYMENT_CASH,
                groupValue: _selectedMethod,
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Bank'),
                value: AppConstants.PAYMENT_BANK,
                groupValue: _selectedMethod,
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Cheque'),
                value: AppConstants.PAYMENT_CHEQUE,
                groupValue: _selectedMethod,
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Online'),
                value: AppConstants.PAYMENT_ONLINE,
                groupValue: _selectedMethod,
                onChanged: (value) => setState(() => _selectedMethod = value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = 'all';
                _selectedMethod = 'all';
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// Select start date
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  /// Select end date
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  /// Show add payment dialog
  void _showAddPaymentDialog() {
    final contacts = ref.read(contactsProvider);
    final transactions = ref.read(transactionsProvider);
    
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add contacts first')),
      );
      return;
    }

    String selectedType = 'receipt';
    String? selectedContactId;
    String? selectedTransactionId;
    final amountController = TextEditingController();
    String selectedMethod = AppConstants.PAYMENT_CASH;
    final referenceController = TextEditingController();
    final bankController = TextEditingController();
    final chequeNumberController = TextEditingController();
    DateTime? chequeDate;
    DateTime? paymentDate = DateTime.now();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record New Payment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: 'receipt',
                    child: const Text('Receipt (Money Received)'),
                  ),
                  DropdownMenuItem(
                    value: 'payment',
                    child: const Text('Payment (Money Paid)'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedType = value!),
                decoration: const InputDecoration(
                  labelText: 'Payment Type *',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedContactId,
                items: contacts.map((contact) => DropdownMenuItem(
                  value: contact.id,
                  child: Text(contact.name),
                )).toList(),
                onChanged: (value) => setState(() => selectedContactId = value),
                decoration: const InputDecoration(
                  labelText: 'Contact *',
                ),
                hint: const Text('Select contact'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTransactionId,
                items: transactions
                    .where((t) => 
                      (selectedType == 'receipt' && t.type == AppConstants.TRANSACTION_SALE) ||
                      (selectedType == 'payment' && t.type == AppConstants.TRANSACTION_PURCHASE)
                    )
                    .where((t) => !t.isFullyPaid)
                    .map((transaction) => DropdownMenuItem(
                      value: transaction.id,
                      child: Text('${transaction.invoiceNumber ?? 'N/A'} - ${AppTheme.formatCurrency(transaction.dueAmount)}'),
                    ))
                    .toList(),
                onChanged: (value) => setState(() => selectedTransactionId = value),
                decoration: InputDecoration(
                  labelText: selectedType == 'receipt' ? 'Sale Invoice' : 'Purchase Invoice',
                ),
                hint: const Text('Select invoice'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  prefixText: 'रू ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: [
                  DropdownMenuItem(
                    value: AppConstants.PAYMENT_CASH,
                    child: const Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.PAYMENT_BANK,
                    child: const Text('Bank Transfer'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.PAYMENT_CHEQUE,
                    child: const Text('Cheque'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.PAYMENT_ONLINE,
                    child: const Text('Online Payment'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedMethod = value!),
                decoration: const InputDecoration(
                  labelText: 'Payment Method *',
                ),
              ),
              const SizedBox(height: 12),
              if (selectedMethod == AppConstants.PAYMENT_BANK) ...[
                TextField(
                  controller: bankController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name',
                    hintText: 'Enter bank name',
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (selectedMethod == AppConstants.PAYMENT_CHEQUE) ...[
                TextField(
                  controller: chequeNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Cheque Number',
                    hintText: 'Enter cheque number',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: chequeDate != null 
                        ? '${chequeDate!.day}/${chequeDate!.month}/${chequeDate!.year}'
                        : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Cheque Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: chequeDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => chequeDate = picked);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: selectedMethod == AppConstants.PAYMENT_CHEQUE 
                      ? 'Cheque Number' 
                      : 'Reference Number',
                  hintText: 'Enter reference',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: paymentDate != null 
                      ? '${paymentDate!.day}/${paymentDate!.month}/${paymentDate!.year}'
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Payment Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: paymentDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => paymentDate = picked);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedContactId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a contact')),
                );
                return;
              }
              
              final amount = double.tryParse(amountController.text) ?? 0;
              
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }
              
              // Get invoice number if transaction is selected
              String? invoiceNumber;
              if (selectedTransactionId != null) {
                final transaction = transactions.firstWhere(
                  (t) => t.id == selectedTransactionId,
                  orElse: () => null,
                );
                invoiceNumber = transaction?.invoiceNumber;
              }
              
              final payment = PaymentModel.create(
                type: selectedType,
                transactionId: selectedTransactionId ?? '',
                invoiceNumber: invoiceNumber,
                contactId: selectedContactId,
                amount: amount,
                method: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty 
                    ? null 
                    : referenceController.text.trim(),
                bankName: selectedMethod == AppConstants.PAYMENT_BANK 
                    ? bankController.text.trim().isEmpty 
                        ? null 
                        : bankController.text.trim()
                    : null,
                chequeNumber: selectedMethod == AppConstants.PAYMENT_CHEQUE 
                    ? chequeNumberController.text.trim().isEmpty 
                        ? null 
                        : chequeNumberController.text.trim()
                    : null,
                chequeDate: chequeDate,
                date: paymentDate,
                notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              );
              
              await ref.read(paymentRepositoryProvider).savePayment(payment);
              await ref.read(paymentsProvider.notifier).refresh();
              
              // Update transaction if linked
              if (selectedTransactionId != null) {
                final transaction = transactions.firstWhere(
                  (t) => t.id == selectedTransactionId,
                  orElse: () => null,
                );
                if (transaction != null) {
                  final updatedTransaction = transaction.copyWithPayment(
                    amount: amount,
                    paymentMethod: selectedMethod,
                    referenceNumber: referenceController.text.trim().isEmpty 
                        ? null 
                        : referenceController.text.trim(),
                  );
                  await ref.read(transactionRepositoryProvider).updateTransaction(updatedTransaction);
                  await ref.read(transactionsProvider.notifier).refresh();
                }
              }
              
              // Update contact balance
              final contact = contacts.firstWhere(
                (c) => c.id == selectedContactId,
                orElse: () => null,
              );
              if (contact != null) {
                final transactionType = selectedType == 'receipt' 
                    ? 'receipt' 
                    : 'payment';
                final updatedContact = contact.copyWithTransaction(
                  transactionType: transactionType,
                  amount: amount,
                );
                await ref.read(contactRepositoryProvider).updateContact(updatedContact);
                await ref.read(contactsProvider.notifier).refresh();
              }
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show payment details
  void _showPaymentDetails(PaymentModel payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${payment.typeDisplayName}: ${payment.referenceDisplay}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Contact', payment.contactId),
              _buildDetailRow('Transaction ID', payment.transactionId),
              _buildDetailRow('Invoice Number', payment.invoiceNumber ?? 'N/A'),
              _buildDetailRow('Amount', AppTheme.formatCurrency(payment.amount)),
              _buildDetailRow('Method', payment.methodDisplayName),
              _buildDetailRow('Reference', payment.referenceDisplay),
              if (payment.bankName != null)
                _buildDetailRow('Bank', payment.bankName!),
              if (payment.chequeNumber != null)
                _buildDetailRow('Cheque Number', payment.chequeNumber!),
              if (payment.chequeDate != null)
                _buildDetailRow(
                  'Cheque Date',
                  '${payment.chequeDate!.day}/${payment.chequeDate!.month}/${payment.chequeDate!.year}',
                ),
              _buildDetailRow(
                'Date',
                payment.date != null 
                    ? '${payment.date!.day}/${payment.date!.month}/${payment.date!.year}'
                    : 'N/A',
              ),
              _buildDetailRow('Status', payment.isClearedPayment ? 'Cleared' : 'Pending'),
              if (payment.notes != null && payment.notes!.isNotEmpty)
                _buildDetailRow('Notes', payment.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!payment.isClearedPayment && payment.method == AppConstants.PAYMENT_CHEQUE)
            ElevatedButton(
              onPressed: () async {
                final clearedPayment = payment.copyWithCleared();
                await ref.read(paymentRepositoryProvider).updatePayment(clearedPayment);
                await ref.read(paymentsProvider.notifier).refresh();
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cheque marked as cleared')),
                );
              },
              child: const Text('Mark as Cleared'),
            ),
          if (!payment.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPaymentActions(payment);
              },
              child: const Text('Actions'),
            ),
        ],
      ),
    );
  }

  /// Build detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Show payment actions
  void _showPaymentActions(PaymentModel payment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!payment.isClearedPayment && payment.method == AppConstants.PAYMENT_CHEQUE)
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Mark as Cleared'),
                onTap: () async {
                  Navigator.pop(context);
                  final clearedPayment = payment.copyWithCleared();
                  await ref.read(paymentRepositoryProvider).updatePayment(clearedPayment);
                  await ref.read(paymentsProvider.notifier).refresh();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cheque marked as cleared')),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Payment'),
              onTap: () {
                Navigator.pop(context);
                // Show edit payment dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Print Receipt'),
              onTap: () {
                Navigator.pop(context);
                // Print receipt
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Payment', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(payment);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show delete confirmation
  void _showDeleteConfirmation(PaymentModel payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment'),
        content: Text('Are you sure you want to delete this payment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(paymentRepositoryProvider).deletePayment(payment.id);
              await ref.read(paymentsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
