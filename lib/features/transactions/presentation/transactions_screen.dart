import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/utils/theme/app_theme.dart';
import '../../../packages/design-system/design_system.dart';

/// Transactions Screen: dense, sortable, filterable table (desktop) + cards (mobile)
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  int _rowsPerPage = 25;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Transactions'),
        subtitle: const Text('View, filter, and manage transactions'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search (/)',
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
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (transactionList) {
          final filtered = _filterTransactions(transactionList);
          final sorted = _sortTransactions(filtered);

          return LayoutBuilder(
            builder: (context, constraints) {
              if (ClayBreakpoints.isCompact(constraints.maxWidth)) {
                return _MobileCardList(transactions: sorted);
              }
              // Desktop: dense paginated table fills available height.
              return SizedBox(
                height: constraints.maxHeight,
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 280,
                              child: ClaySearchInput(
                                hintText: 'Search...',
                                onChanged: (v) =>
                                    setState(() => _searchQuery = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            header: const Text(
                              'All transactions',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            rowsPerPage: _rowsPerPage,
                            availableRowsPerPage: const [10, 25, 50, 100],
                            onRowsPerPageChanged: (v) =>
                                setState(() => _rowsPerPage = v!),
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(
                                label: const Text('Invoice',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 0;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 1;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Type',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 2;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Contact',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 3;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                numeric: true,
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 4;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 5;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Due',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 6;
                                  _sortAscending = asc;
                                }),
                              ),
                              const DataColumn(
                                label: Text('Actions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                            source: _TransactionDataSource(
                              transactions: sorted,
                              onView: (t) => _showDetailDialog(context, t),
                              onEdit: (t) => _showEditDialog(context, t),
                              onDelete: (t) => _confirmDelete(context, t),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: mainNavBar(context, 3),
    );
  }

  List<TransactionModel> _filterTransactions(List<TransactionModel> list) =>
      list.where((t) {
        if (t.isCancelled) return false;
        if (_selectedStatus != 'all' && t.paymentStatus != _selectedStatus) {
          return false;
        }
        if (_selectedType != 'all' && t.type != _selectedType) return false;
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          if (!(t.invoiceNumber?.toLowerCase().contains(q) ?? false) &&
              !t.contactId.toLowerCase().contains(q) &&
              !(t.items?.any(
                      (item) => item.productName.toLowerCase().contains(q)) ??
                  false)) {
            return false;
          }
        }
        return true;
      }).toList();

  List<TransactionModel> _sortTransactions(List<TransactionModel> list) {
    list.sort((a, b) {
      var cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = (a.invoiceNumber ?? '').compareTo(b.invoiceNumber ?? '');
          break;
        case 1:
          cmp = (a.date ?? DateTime(1970)).compareTo(b.date ?? DateTime(1970));
          break;
        case 2:
          cmp = a.typeDisplayName.compareTo(b.typeDisplayName);
          break;
        case 3:
          cmp = a.contactId.compareTo(b.contactId);
          break;
        case 4:
          cmp = a.total.compareTo(b.total);
          break;
        case 5:
          cmp = a.paymentStatus.compareTo(b.paymentStatus);
          break;
        case 6:
          cmp = (a.dueDate ?? DateTime(2099))
              .compareTo(b.dueDate ?? DateTime(2099));
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });
    return list;
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Transactions'),
        content: ClaySearchInput(
          hintText: 'Search by invoice number, contact, or amount',
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClayDropdownInput<String>(
                label: 'Status',
                value: _selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PAID,
                      child: Text('Paid')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PARTIAL,
                      child: Text('Partial')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PENDING,
                      child: Text('Pending')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_CANCELLED,
                      child: Text('Cancelled')),
                ],
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: 'Type',
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_SALE,
                      child: Text('Sale')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_PURCHASE,
                      child: Text('Purchase')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_EXPENSE,
                      child: Text('Expense')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_INCOME,
                      child: Text('Income')),
                ],
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
            ],
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ClayFormDialog(
        title: Text('Add New Transaction'),
        child: _AddTransactionForm(),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, TransactionModel t) =>
      showDialog(
          context: context,
          builder: (c) => ClayDialog(
                title:
                    Text('${t.typeDisplayName} - ${t.invoiceNumber ?? 'N/A'}'),
                content: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      _detailRow('Invoice', t.invoiceNumber ?? 'N/A'),
                      _detailRow(
                          'Date', t.date?.toString().split(' ').first ?? 'N/A'),
                      _detailRow('Type', t.typeDisplayName),
                      _detailRow('Contact', t.contactId),
                      _detailRow(
                          'Subtotal', AppTheme.formatCurrency(t.subtotal)),
                      _detailRow(
                          'Discount', AppTheme.formatCurrency(t.discount)),
                      _detailRow('Tax (${t.vatRate}%)',
                          AppTheme.formatCurrency(t.tax)),
                      _detailRow('Total', AppTheme.formatCurrency(t.total),
                          bold: true),
                      _detailRow('Paid', AppTheme.formatCurrency(t.paidAmount)),
                      _detailRow('Due', AppTheme.formatCurrency(t.dueAmount),
                          bold: t.dueAmount > 0),
                      _detailRow('Status', t.paymentStatus),
                      if (t.notes != null && t.notes!.isNotEmpty)
                        _detailRow('Notes', t.notes!),
                    ]))),
                actions: [
                  ClayButton.text(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                  ClayButton(
                    onPressed: () => _printInvoice(context, t),
                    child: const Text('Print / PDF'),
                  ),
                ],
              ));

  void _showEditDialog(BuildContext context, TransactionModel t) {
    // TODO: Implement edit dialog
  }

  /// Generates the invoice PDF and opens the platform print/share sheet.
  Future<void> _printInvoice(BuildContext context, TransactionModel t) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final companies = hiveService.companiesBox.values.toList();
      if (companies.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text('Add your company profile in Settings first')),
        );
        return;
      }
      final contact = hiveService.contactsBox.get(t.contactId) ??
          ContactModel.create(name: 'Walk-in Customer');
      final productsById = {
        for (final p in hiveService.productsBox.values) p.id: p,
      };
      final products = [
        for (final item in t.items ?? <TransactionItem>[])
          if (productsById.containsKey(item.productId))
            productsById[item.productId]!,
      ];
      final pdfBytes = await pdfService.generateInvoicePdf(
        transaction: t,
        company: companies.first,
        contact: contact,
        products: products,
      );
      await pdfService.sharePdf(
        pdfBytes,
        fileName: '${t.invoiceNumber ?? 'invoice'}.pdf',
      );
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Print failed: $e')));
    }
  }

  void _confirmDelete(BuildContext context, TransactionModel t) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('Delete Transaction?'),
              content:
                  Text('Delete ${t.invoiceNumber}? This cannot be undone.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await hiveService.transactionsBox.delete(t.id);
                    ref.invalidate(transactionsProvider);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ));
  }

  Widget _detailRow(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ]),
      );
}

/// Compact transaction card for mobile.
class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isSale = transaction.type == AppConstants.TRANSACTION_SALE;
    return ClayCard(
      onTap: () => context.push('/transactions'),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isSale ? ClayColors.success : ClayColors.info)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSale ? Icons.arrow_upward : Icons.arrow_downward,
              color: isSale ? ClayColors.success : ClayColors.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.invoiceNumber ?? transaction.typeDisplayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  transaction.date?.toString().split(' ').first ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppTheme.formatCurrency(transaction.total),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _PaymentStatusChip(status: transaction.paymentStatus),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mobile card list (compact breakpoint)
class _MobileCardList extends StatelessWidget {
  const _MobileCardList({required this.transactions});
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const _EmptyTransactionsState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) =>
          _TransactionCard(transaction: transactions[index]),
    );
  }
}

/// Desktop data table with sorting, pagination, row actions
class _TransactionDataSource extends DataTableSource {
  _TransactionDataSource({
    required this.transactions,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });
  final List<TransactionModel> transactions;
  final void Function(TransactionModel) onView;
  final void Function(TransactionModel) onEdit;
  final void Function(TransactionModel) onDelete;

  @override
  DataRow? getRow(int index) {
    final t = transactions[index];
    return DataRow(
      onSelectChanged: (_) => onView(t),
      cells: [
        DataCell(Text(t.invoiceNumber ?? 'N/A')),
        DataCell(Text(t.date?.toString().split(' ').first ?? 'N/A')),
        DataCell(Chip(
            label: Text(t.typeDisplayName),
            backgroundColor: _getTypeColor(t.type).withValues(alpha: 0.1),
            labelStyle: TextStyle(color: _getTypeColor(t.type)))),
        DataCell(Text(t.contactId, overflow: TextOverflow.ellipsis)),
        DataCell(Text('NPR ${t.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(_PaymentStatusChip(status: t.paymentStatus)),
        DataCell(Text(t.dueDate?.toString().split(' ').first ?? 'N/A')),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () => onView(transactions[index]),
                tooltip: 'View'),
            IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => onEdit(transactions[index]),
                tooltip: 'Edit'),
            IconButton(
                icon: const Icon(Icons.delete, size: 18),
                color: Colors.red,
                onPressed: () => onDelete(transactions[index]),
                tooltip: 'Delete'),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => transactions.length;
  @override
  int get selectedRowCount => 0;

  Color _getTypeColor(String type) {
    switch (type) {
      case AppConstants.TRANSACTION_SALE:
        return Colors.green;
      case AppConstants.TRANSACTION_PURCHASE:
        return Colors.blue;
      case AppConstants.TRANSACTION_EXPENSE:
        return Colors.red;
      case AppConstants.TRANSACTION_INCOME:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _PaymentStatusChip extends StatelessWidget {
  const _PaymentStatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case AppConstants.PAYMENT_STATUS_PAID:
        color = Colors.green;
        label = 'Paid';
        break;
      case AppConstants.PAYMENT_STATUS_PARTIAL:
        color = Colors.orange;
        label = 'Partial';
        break;
      case AppConstants.PAYMENT_STATUS_PENDING:
        color = Colors.red;
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
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color, width: 1),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Empty Transactions State
class _EmptyTransactionsState extends StatelessWidget {
  const _EmptyTransactionsState();

  @override
  Widget build(BuildContext context) => Center(
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

/// Transactions List
/// Add Transaction Form
class _AddTransactionForm extends ConsumerStatefulWidget {
  const _AddTransactionForm();

  @override
  ConsumerState<_AddTransactionForm> createState() =>
      _AddTransactionFormState();
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
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClayDropdownInput<String>(
                label: 'Transaction Type *',
                value: _type,
                items: const [
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_SALE,
                      child: Text('Sale')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_PURCHASE,
                      child: Text('Purchase')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_EXPENSE,
                      child: Text('Expense')),
                  DropdownMenuItem(
                      value: AppConstants.TRANSACTION_INCOME,
                      child: Text('Income')),
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
                validator: (value) =>
                    value?.isEmpty ?? false ? 'Contact ID is required' : null,
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
                      onChanged: (value) => _subtotal = value ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayCurrencyInput(
                      label: 'Discount',
                      hintText: 'Discount',
                      value: _discount,
                      onChanged: (value) => _discount = value ?? 0,
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
                      onChanged: (value) => _tax = value ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayCurrencyInput(
                      label: 'Total',
                      hintText: 'Total',
                      value: _total,
                      onChanged: (value) => _total = value ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClayCurrencyInput(
                label: 'Paid Amount',
                hintText: 'Paid amount',
                value: _paidAmount,
                onChanged: (value) => _paidAmount = value ?? 0,
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: 'Payment Status',
                value: _paymentStatus,
                items: const [
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PENDING,
                      child: Text('Pending')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PAID,
                      child: Text('Paid')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_STATUS_PARTIAL,
                      child: Text('Partial')),
                ],
                onChanged: (value) => setState(() => _paymentStatus = value!),
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: 'Payment Method',
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_CASH, child: Text('Cash')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_BANK, child: Text('Bank')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_CHEQUE,
                      child: Text('Cheque')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_ONLINE,
                      child: Text('Online')),
                  DropdownMenuItem(
                      value: AppConstants.PAYMENT_CREDIT,
                      child: Text('Credit')),
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
                      onChanged: (value) =>
                          setState(() => _isVatIncluded = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'VAT Rate %',
                      hintText: 'VAT rate',
                      value: _vatRate.toString(),
                      onChanged: (value) =>
                          _vatRate = double.tryParse(value) ?? 13.0,
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

/// Provider for transactions
final transactionsProvider =
    FutureProvider<List<TransactionModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.transactionsBox.values.toList();
});
