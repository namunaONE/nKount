import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/providers/storage_providers.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';

/// Purchases Screen for managing purchase transactions
class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});

  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final purchases = transactions
        .where((t) => t.type == AppConstants.TRANSACTION_PURCHASE)
        .toList();

    final filteredPurchases = _filterPurchases(purchases);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
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
                hintText: 'Search purchases...',
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
                    'Total Purchases',
                    AppTheme.formatCurrency(
                      ref.read(transactionRepositoryProvider).getTotalPurchaseAmount()
                    ),
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Paid',
                    AppTheme.formatCurrency(
                      purchases
                          .where((p) => p.isFullyPaid)
                          .fold(0.0, (sum, p) => sum + p.total)
                    ),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Outstanding',
                    AppTheme.formatCurrency(
                      ref.read(transactionRepositoryProvider).getTotalOutstandingPayables()
                    ),
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Purchases List
          Expanded(
            child: filteredPurchases.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No purchases found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create your first purchase to get started',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPurchases.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final purchase = filteredPurchases[index];
                      return _buildPurchaseItem(purchase);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddPurchaseDialog(),
      ),
    );
  }

  /// Filter purchases based on search and status
  List<TransactionModel> _filterPurchases(List<TransactionModel> purchases) {
    var filtered = purchases;
    
    if (_selectedStatus != 'all') {
      filtered = filtered.where((p) {
        if (_selectedStatus == 'paid') return p.isFullyPaid;
        if (_selectedStatus == 'partial') return p.isPartiallyPaid;
        if (_selectedStatus == 'pending') return p.isPending;
        if (_selectedStatus == 'cancelled') return p.isCancelled;
        if (_selectedStatus == 'overdue') return p.isOverdue;
        return true;
      }).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) => 
            p.invoiceNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false ||
            (p.contactId.toLowerCase().contains(_searchQuery.toLowerCase())) ||
            p.items?.any((item) => 
              item.productName.toLowerCase().contains(_searchQuery.toLowerCase())
            ) ?? false
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

  /// Build purchase item
  Widget _buildPurchaseItem(TransactionModel purchase) {
    final color = purchase.isFullyPaid 
        ? Colors.green 
        : (purchase.isPartiallyPaid ? Colors.orange : Colors.red);

    return Card(
      elevation: 2,
      color: purchase.isCancelled ? Colors.grey[100] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            purchase.isFullyPaid ? Icons.check_circle : 
            (purchase.isPartiallyPaid ? Icons.remove_circle : Icons.pending),
            color: color,
          ),
        ),
        title: Text(
          'Invoice: ${purchase.invoiceNumber ?? 'N/A'}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: purchase.isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supplier: ${purchase.contactId}',
              style: const TextStyle(fontSize: 12),
            ),
            if (purchase.items != null && purchase.items!.isNotEmpty)
              Text(
                '${purchase.items!.length} items',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppTheme.formatCurrency(purchase.total),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: purchase.isCancelled ? Colors.grey : color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              purchase.date != null 
                  ? '${purchase.date!.day}/${purchase.date!.month}/${purchase.date!.year}'
                  : 'N/A',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showPurchaseDetails(purchase),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Purchases'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Purchases'),
              value: 'all',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Paid'),
              value: 'paid',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Partially Paid'),
              value: 'partial',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Pending'),
              value: 'pending',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Overdue'),
              value: 'overdue',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Cancelled'),
              value: 'cancelled',
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show add purchase dialog
  void _showAddPurchaseDialog() {
    final contacts = ref.read(contactsProvider);
    final products = ref.read(productsProvider);
    
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a supplier first')),
      );
      return;
    }
    
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products first')),
      );
      return;
    }

    // Navigate to full screen form
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddPurchaseScreen(
          contacts: contacts,
          products: products,
        ),
      ),
    );
  }

  /// Show purchase details
  void _showPurchaseDetails(TransactionModel purchase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase: ${purchase.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Supplier', purchase.contactId),
              _buildDetailRow('Date', purchase.date != null 
                  ? '${purchase.date!.day}/${purchase.date!.month}/${purchase.date!.year}'
                  : 'N/A'),
              _buildDetailRow('Status', purchase.paymentStatus),
              _buildDetailRow('Subtotal', AppTheme.formatCurrency(purchase.subtotal)),
              _buildDetailRow('Discount', AppTheme.formatCurrency(purchase.discount)),
              _buildDetailRow('Tax', AppTheme.formatCurrency(purchase.tax)),
              _buildDetailRow('Total', AppTheme.formatCurrency(purchase.total)),
              _buildDetailRow('Paid', AppTheme.formatCurrency(purchase.paidAmount)),
              _buildDetailRow('Due', AppTheme.formatCurrency(purchase.dueAmount)),
              
              if (purchase.items != null && purchase.items!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...purchase.items!.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${item.quantity} x ${AppTheme.formatCurrency(item.unitPrice)}'),
                      const SizedBox(width: 8),
                      Text(AppTheme.formatCurrency(item.amount)),
                    ],
                  ),
                )),
              ],
              
              if (purchase.notes != null && purchase.notes!.isNotEmpty)
                _buildDetailRow('Notes', purchase.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!purchase.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRecordPaymentDialog(purchase);
              },
              child: const Text('Record Payment'),
            ),
          if (!purchase.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPurchaseActions(purchase);
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
            width: 100,
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

  /// Show purchase actions
  void _showPurchaseActions(TransactionModel purchase) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Record Payment'),
              onTap: () {
                Navigator.pop(context);
                _showRecordPaymentDialog(purchase);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Purchase'),
              onTap: () {
                Navigator.pop(context);
                // Show edit purchase dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Print Purchase'),
              onTap: () {
                Navigator.pop(context);
                // Print purchase
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Cancel Purchase', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showCancelPurchaseConfirmation(purchase);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show record payment dialog
  void _showRecordPaymentDialog(TransactionModel purchase) {
    final amountController = TextEditingController();
    String selectedMethod = AppConstants.PAYMENT_CASH;
    final referenceController = TextEditingController();
    final bankController = TextEditingController();
    final chequeNumberController = TextEditingController();
    DateTime? chequeDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Payment for Purchase ${purchase.invoiceNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Due Amount: ${AppTheme.formatCurrency(purchase.dueAmount)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount *',
                  hintText: 'Enter payment amount',
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
                  labelText: 'Payment Method',
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
              final amount = double.tryParse(amountController.text) ?? 0;
              
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }
              
              if (amount > purchase.dueAmount) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment amount cannot exceed due amount')),
                );
                return;
              }
              
              // Create payment
              final payment = PaymentModel.create(
                type: 'payment',
                transactionId: purchase.id,
                invoiceNumber: purchase.invoiceNumber,
                contactId: purchase.contactId,
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
                date: DateTime.now(),
              );
              
              await ref.read(paymentRepositoryProvider).savePayment(payment);
              
              // Update transaction
              final updatedPurchase = purchase.copyWithPayment(
                amount: amount,
                paymentMethod: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty 
                    ? null 
                    : referenceController.text.trim(),
              );
              
              await ref.read(transactionRepositoryProvider).updateTransaction(updatedPurchase);
              await ref.read(transactionsProvider.notifier).refresh();
              await ref.read(paymentsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded successfully')),
              );
            },
            child: const Text('Record Payment'),
          ),
        ],
      ),
    );
  }

  /// Show cancel purchase confirmation
  void _showCancelPurchaseConfirmation(TransactionModel purchase) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this purchase?'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for cancellation',
                hintText: 'Enter reason (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedPurchase = purchase.copyWithCancellation(
                reasonController.text.trim().isEmpty 
                    ? 'Cancelled by user' 
                    : reasonController.text.trim(),
              );
              
              await ref.read(transactionRepositoryProvider).updateTransaction(updatedPurchase);
              await ref.read(transactionsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Purchase cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Purchase', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Add Purchase Screen (Full screen form)
class _AddPurchaseScreen extends StatefulWidget {
  final List<ContactModel> contacts;
  final List<ProductModel> products;

  const _AddPurchaseScreen({
    required this.contacts,
    required this.products,
  });

  @override
  State<_AddPurchaseScreen> createState() => __AddPurchaseScreenState();
}

class __AddPurchaseScreenState extends State<_AddPurchaseScreen> {
  ContactModel? _selectedSupplier;
  DateTime? _selectedDate = DateTime.now();
  DateTime? _dueDate;
  final List<TransactionItem> _items = [];
  double _discount = 0;
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Purchase'),
        actions: [
          TextButton(
            onPressed: _savePurchase,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Supplier Selection
            DropdownButtonFormField<ContactModel>(
              value: _selectedSupplier,
              items: widget.contacts
                  .where((c) => c.type == AppConstants.CONTACT_SUPPLIER || c.type == AppConstants.CONTACT_BOTH)
                  .map((contact) => DropdownMenuItem(
                    value: contact,
                    child: Text(contact.name),
                  ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedSupplier = value),
              decoration: const InputDecoration(
                labelText: 'Supplier *',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select supplier'),
            ),
            const SizedBox(height: 16),
            
            // Date Selection
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate != null 
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Date *',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _dueDate != null 
                          ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDueDate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _discount.toString()),
                    decoration: const InputDecoration(
                      labelText: 'Discount',
                      border: OutlineInputBorder(),
                      prefixText: 'रू ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _discount = double.tryParse(value) ?? 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Items Section
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Add Item Button
            OutlinedButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
            const SizedBox(height: 8),
            
            // Items List
            if (_items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No items added yet',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: _items.map((item) => _buildItemRow(item)).toList(),
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Notes
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              onChanged: (value) => _notes = value,
            ),
            const SizedBox(height: 16),
            
            // Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Subtotal', _calculateSubtotal()),
                    _buildSummaryRow('Discount', AppTheme.formatCurrency(_discount)),
                    _buildSummaryRow('Tax (13%)', AppTheme.formatCurrency(_calculateTax())),
                    const Divider(),
                    _buildSummaryRow(
                      'Total',
                      AppTheme.formatCurrency(_calculateTotal()),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build item row
  Widget _buildItemRow(TransactionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(item.productName),
          ),
          Expanded(
            child: Text(item.quantity.toString()),
          ),
          Expanded(
            child: Text(AppTheme.formatCurrency(item.unitPrice)),
          ),
          Expanded(
            child: Text(AppTheme.formatCurrency(item.amount)),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(item),
          ),
        ],
      ),
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate subtotal
  String _calculateSubtotal() {
    return AppTheme.formatCurrency(
      _items.fold(0.0, (sum, item) => sum + item.amount)
    );
  }

  /// Calculate tax
  double _calculateTax() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    return (subtotal - _discount) * 0.13; // 13% VAT
  }

  /// Calculate total
  String _calculateTotal() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    final tax = _calculateTax();
    return AppTheme.formatCurrency(subtotal - _discount + tax);
  }

  /// Select date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Select due date
  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? (_selectedDate ?? DateTime.now()).add(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() => _dueDate = picked);
    }
  }

  /// Show add item dialog
  void _showAddItemDialog() {
    final productController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController();
    final discountController = TextEditingController(text: '0');

    ProductModel? selectedProduct;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ProductModel>(
                value: selectedProduct,
                items: widget.products
                    .where((p) => p.isActive)
                    .map((product) => DropdownMenuItem(
                      value: product,
                      child: Text(product.name),
                    ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedProduct = value);
                  if (value != null) {
                    priceController.text = value.purchasePrice.toString();
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Product *',
                ),
                hint: const Text('Select product'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        hintText: '1',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Price *',
                        prefixText: 'रू ',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: discountController,
                decoration: const InputDecoration(
                  labelText: 'Discount',
                  prefixText: 'रू ',
                ),
                keyboardType: TextInputType.number,
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
            onPressed: () {
              if (selectedProduct == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a product')),
                );
                return;
              }
              
              final quantity = double.tryParse(quantityController.text) ?? 0;
              final price = double.tryParse(priceController.text) ?? 0;
              final discount = double.tryParse(discountController.text) ?? 0;
              
              if (quantity <= 0 || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid quantity and price')),
                );
                return;
              }
              
              final amount = (quantity * price) - discount;
              
              setState(() {
                _items.add(TransactionItem.create(
                  productId: selectedProduct!.id,
                  productName: selectedProduct!.name,
                  quantity: quantity,
                  unitPrice: price,
                  discount: discount,
                  unit: selectedProduct!.unit,
                ));
              });
              
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Remove item
  void _removeItem(TransactionItem item) {
    setState(() => _items.remove(item));
  }

  /// Save purchase
  void _savePurchase() {
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a supplier')),
      );
      return;
    }
    
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }
    
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    final tax = _calculateTax();
    final total = subtotal - _discount + tax;
    
    final purchase = TransactionModel.create(
      type: AppConstants.TRANSACTION_PURCHASE,
      contactId: _selectedSupplier!.id,
      items: _items,
      subtotal: subtotal,
      discount: _discount,
      tax: tax,
      total: total,
      date: _selectedDate,
      dueDate: _dueDate,
      notes: _notes.isEmpty ? null : _notes,
    );
    
    // Save to database
    ref.read(transactionRepositoryProvider).saveTransaction(purchase);
    ref.read(transactionsProvider.notifier).refresh();
    
    // Update contact balance
    final updatedContact = _selectedSupplier!.copyWithTransaction(
      transactionType: AppConstants.TRANSACTION_PURCHASE,
      amount: total,
    );
    ref.read(contactRepositoryProvider).updateContact(updatedContact);
    ref.read(contactsProvider.notifier).refresh();
    
    // Update product quantities
    for (final item in _items) {
      final product = widget.products.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => null,
      );
      if (product != null) {
        ref.read(productRepositoryProvider).updateProductQuantity(
          product.id,
          item.quantity,
        );
      }
    }
    ref.read(productsProvider.notifier).refresh();
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Purchase saved successfully')),
    );
  }
}
