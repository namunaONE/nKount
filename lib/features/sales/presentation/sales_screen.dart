import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/providers/storage_providers.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';

/// Sales Screen for managing sales transactions
class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final sales = transactions
        .where((t) => t.type == AppConstants.TRANSACTION_SALE)
        .toList();

    final filteredSales = _filterSales(sales);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
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
                hintText: 'Search sales...',
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
                    'Total Sales',
                    AppTheme.formatCurrency(
                      ref.read(transactionRepositoryProvider).getTotalSalesAmount()
                    ),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Paid',
                    AppTheme.formatCurrency(
                      sales
                          .where((s) => s.isFullyPaid)
                          .fold(0.0, (sum, s) => sum + s.total)
                    ),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Outstanding',
                    AppTheme.formatCurrency(
                      ref.read(transactionRepositoryProvider).getTotalOutstandingReceivables()
                    ),
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Sales List
          Expanded(
            child: filteredSales.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No sales found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create your first sale to get started',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredSales.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final sale = filteredSales[index];
                      return _buildSaleItem(sale);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddSaleDialog(),
      ),
    );
  }

  /// Filter sales based on search and status
  List<TransactionModel> _filterSales(List<TransactionModel> sales) {
    var filtered = sales;
    
    if (_selectedStatus != 'all') {
      filtered = filtered.where((s) {
        if (_selectedStatus == 'paid') return s.isFullyPaid;
        if (_selectedStatus == 'partial') return s.isPartiallyPaid;
        if (_selectedStatus == 'pending') return s.isPending;
        if (_selectedStatus == 'cancelled') return s.isCancelled;
        if (_selectedStatus == 'overdue') return s.isOverdue;
        return true;
      }).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((s) => 
            s.invoiceNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false ||
            (s.contactId.toLowerCase().contains(_searchQuery.toLowerCase())) ||
            s.items?.any((item) => 
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

  /// Build sale item
  Widget _buildSaleItem(TransactionModel sale) {
    final color = sale.isFullyPaid 
        ? Colors.green 
        : (sale.isPartiallyPaid ? Colors.orange : Colors.red);

    return Card(
      elevation: 2,
      color: sale.isCancelled ? Colors.grey[100] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            sale.isFullyPaid ? Icons.check_circle : 
            (sale.isPartiallyPaid ? Icons.remove_circle : Icons.pending),
            color: color,
          ),
        ),
        title: Text(
          'Invoice: ${sale.invoiceNumber ?? 'N/A'}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: sale.isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${sale.contactId}',
              style: const TextStyle(fontSize: 12),
            ),
            if (sale.items != null && sale.items!.isNotEmpty)
              Text(
                '${sale.items!.length} items',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppTheme.formatCurrency(sale.total),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: sale.isCancelled ? Colors.grey : color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sale.date != null 
                  ? '${sale.date!.day}/${sale.date!.month}/${sale.date!.year}'
                  : 'N/A',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showSaleDetails(sale),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Sales'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Sales'),
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

  /// Show add sale dialog
  void _showAddSaleDialog() {
    final contacts = ref.read(contactsProvider);
    final products = ref.read(productsProvider);
    
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a customer first')),
      );
      return;
    }
    
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products first')),
      );
      return;
    }

    // For simplicity, navigate to a full screen form
    // In production, use a proper form with validation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddSaleScreen(
          contacts: contacts,
          products: products,
        ),
      ),
    );
  }

  /// Show sale details
  void _showSaleDetails(TransactionModel sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invoice: ${sale.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Customer', sale.contactId),
              _buildDetailRow('Date', sale.date != null 
                  ? '${sale.date!.day}/${sale.date!.month}/${sale.date!.year}'
                  : 'N/A'),
              _buildDetailRow('Status', sale.paymentStatus),
              _buildDetailRow('Subtotal', AppTheme.formatCurrency(sale.subtotal)),
              _buildDetailRow('Discount', AppTheme.formatCurrency(sale.discount)),
              _buildDetailRow('Tax', AppTheme.formatCurrency(sale.tax)),
              _buildDetailRow('Total', AppTheme.formatCurrency(sale.total)),
              _buildDetailRow('Paid', AppTheme.formatCurrency(sale.paidAmount)),
              _buildDetailRow('Due', AppTheme.formatCurrency(sale.dueAmount)),
              
              if (sale.items != null && sale.items!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...sale.items!.map((item) => Padding(
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
              
              if (sale.notes != null && sale.notes!.isNotEmpty)
                _buildDetailRow('Notes', sale.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!sale.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRecordPaymentDialog(sale);
              },
              child: const Text('Record Payment'),
            ),
          if (!sale.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSaleActions(sale);
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

  /// Show sale actions
  void _showSaleActions(TransactionModel sale) {
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
                _showRecordPaymentDialog(sale);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Sale'),
              onTap: () {
                Navigator.pop(context);
                // Show edit sale dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Print Invoice'),
              onTap: () {
                Navigator.pop(context);
                // Print invoice
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Invoice'),
              onTap: () {
                Navigator.pop(context);
                // Share invoice
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Cancel Sale', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showCancelSaleConfirmation(sale);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show record payment dialog
  void _showRecordPaymentDialog(TransactionModel sale) {
    final amountController = TextEditingController();
    String selectedMethod = AppConstants.PAYMENT_CASH;
    final referenceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Payment for Invoice ${sale.invoiceNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Due Amount: ${AppTheme.formatCurrency(sale.dueAmount)}',
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
                onChanged: (value) => selectedMethod = value!,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              const SizedBox(height: 12),
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
              
              if (amount > sale.dueAmount) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment amount cannot exceed due amount')),
                );
                return;
              }
              
              // Create payment
              final payment = PaymentModel.create(
                type: 'receipt',
                transactionId: sale.id,
                invoiceNumber: sale.invoiceNumber,
                contactId: sale.contactId,
                amount: amount,
                method: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty 
                    ? null 
                    : referenceController.text.trim(),
                date: DateTime.now(),
              );
              
              await ref.read(paymentRepositoryProvider).savePayment(payment);
              
              // Update transaction
              final updatedSale = sale.copyWithPayment(
                amount: amount,
                paymentMethod: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty 
                    ? null 
                    : referenceController.text.trim(),
              );
              
              await ref.read(transactionRepositoryProvider).updateTransaction(updatedSale);
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

  /// Show cancel sale confirmation
  void _showCancelSaleConfirmation(TransactionModel sale) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Sale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this sale?'),
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
              final updatedSale = sale.copyWithCancellation(
                reasonController.text.trim().isEmpty 
                    ? 'Cancelled by user' 
                    : reasonController.text.trim(),
              );
              
              await ref.read(transactionRepositoryProvider).updateTransaction(updatedSale);
              await ref.read(transactionsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sale cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Sale', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Add Sale Screen (Full screen form)
class _AddSaleScreen extends StatefulWidget {
  final List<ContactModel> contacts;
  final List<ProductModel> products;

  const _AddSaleScreen({
    required this.contacts,
    required this.products,
  });

  @override
  State<_AddSaleScreen> createState() => __AddSaleScreenState();
}

class __AddSaleScreenState extends State<_AddSaleScreen> {
  ContactModel? _selectedCustomer;
  DateTime? _selectedDate = DateTime.now();
  final List<TransactionItem> _items = [];
  double _discount = 0;
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Sale'),
        actions: [
          TextButton(
            onPressed: _saveSale,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Customer Selection
            DropdownButtonFormField<ContactModel>(
              value: _selectedCustomer,
              items: widget.contacts
                  .where((c) => c.type == AppConstants.CONTACT_CUSTOMER || c.type == AppConstants.CONTACT_BOTH)
                  .map((contact) => DropdownMenuItem(
                    value: contact,
                    child: Text(contact.name),
                  ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCustomer = value),
              decoration: const InputDecoration(
                labelText: 'Customer *',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select customer'),
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
                    priceController.text = value.salePrice.toString();
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

  /// Save sale
  void _saveSale() {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
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
    
    final sale = TransactionModel.create(
      type: AppConstants.TRANSACTION_SALE,
      contactId: _selectedCustomer!.id,
      items: _items,
      subtotal: subtotal,
      discount: _discount,
      tax: tax,
      total: total,
      date: _selectedDate,
      notes: _notes.isEmpty ? null : _notes,
    );
    
    // Save to database
    ref.read(transactionRepositoryProvider).saveTransaction(sale);
    ref.read(transactionsProvider.notifier).refresh();
    
    // Update contact balance
    final updatedContact = _selectedCustomer!.copyWithTransaction(
      transactionType: AppConstants.TRANSACTION_SALE,
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
          -item.quantity,
        );
      }
    }
    ref.read(productsProvider.notifier).refresh();
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sale saved successfully')),
    );
  }
}
