import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/repositories/transaction_repository.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/dates.dart';
import '../../../packages/design-system/design_system.dart';

/// Detail rows shared by the desktop detail pane and the compact dialog.
List<Widget> _transactionDetailRows(TransactionModel t) => [
      ClayDetailRow(label: 'Invoice', value: t.invoiceNumber ?? 'N/A'),
      ClayDetailRow(
          label: 'Date', value: t.date == null ? 'N/A' : formatDate(t.date)),
      ClayDetailRow(label: 'Type', value: t.typeDisplayName),
      ClayDetailRow(label: 'Contact', value: t.contactId),
      ClayDetailRow(label: 'Subtotal', value: formatCurrency(t.subtotal)),
      ClayDetailRow(label: 'Discount', value: formatCurrency(t.discount)),
      ClayDetailRow(label: 'Tax (${t.vatRate}%)', value: formatCurrency(t.tax)),
      ClayDetailRow(
          label: 'Total', value: formatCurrency(t.total), isBold: true),
      ClayDetailRow(label: 'Paid', value: formatCurrency(t.paidAmount)),
      ClayDetailRow(
          label: 'Due',
          value: formatCurrency(t.dueAmount),
          isBold: t.dueAmount > 0),
      ClayDetailRow(label: 'Status', value: t.paymentStatus),
      if (t.notes != null && t.notes!.isNotEmpty)
        ClayDetailRow(label: 'Notes', value: t.notes!),
    ];

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
  String? _selectedId;
  int _rowsPerPage = 25;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  TransactionModel? _selectedTransaction(List<TransactionModel> sorted) {
    if (sorted.isEmpty) return null;
    final id = _selectedId;
    if (id != null) {
      for (final t in sorted) {
        if (t.id == id) return t;
      }
    }
    return sorted.first;
  }

  Widget _buildDetailPane(BuildContext context, TransactionModel? selected) {
    if (selected == null) {
      return const ClayCard(
        child: Center(
          child: ClayEmptyState(
            title: 'Select a transaction',
            icon: ClayIcons.transactions,
          ),
        ),
      );
    }
    final t = selected;
    return ClayCard(
      title: ClaySectionTitle(t.invoiceNumber ?? t.id),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._transactionDetailRows(t),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ClayButton(
                  onPressed: () => _printInvoice(context, t),
                  child: const Text('Print / PDF'),
                ),
                ClayButton.text(
                  onPressed: () => _showEditDialog(context, t),
                  child: const Text('Edit'),
                ),
                ClayButton.text(
                  onPressed: () => _confirmDelete(context, t, ref),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Transactions'),
        subtitle: const Text('View, filter, and manage transactions'),
        actions: [
          ClayIconButton(
            icon: ClayIcons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search (/)',
          ),
          ClayIconButton(
            icon: ClayIcons.filter,
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
        loading: () => const ClaySkeletonList(),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (transactionList) {
          final filtered = _filterTransactions(transactionList);
          final sorted = _sortTransactions(filtered);
          final selected = _selectedTransaction(sorted);

          return LayoutBuilder(
            builder: (context, constraints) {
              if (ClayBreakpoints.isCompact(constraints.maxWidth)) {
                return _MobileCardList(transactions: sorted);
              }
              // Non-compact: two-pane master-detail on wide windows,
              // table alone on medium windows.
              return LayoutBuilder(
                builder: (context, constraints) {
                  final tableCard = ClayTableCard(
                    title: 'Transactions',
                    tableTitle: 'All transactions',
                    searchHint: 'Search...',
                    onSearchChanged: (v) => setState(() => _searchQuery = v),
                    columns: [
                      DataColumn(
                        label: Text('Invoice',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 0;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Date',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 1;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Type',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 2;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Contact',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 3;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Total',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        numeric: true,
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 4;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Status',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 5;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Due',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        onSort: (col, asc) => setState(() {
                          _sortColumnIndex = 6;
                          _sortAscending = asc;
                        }),
                      ),
                      DataColumn(
                        label: Text('Actions',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    source: _TransactionDataSource(
                      transactions: sorted,
                      onView: (t) {
                        if (MediaQuery.sizeOf(context).width >=
                            ClayBreakpoints.twoColumnMin) {
                          setState(() => _selectedId = t.id);
                        } else {
                          _showDetailDialog(context, t);
                        }
                      },
                      onEdit: (t) => _showEditDialog(context, t),
                      onDelete: (t) => _confirmDelete(context, t, ref),
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (v) =>
                        setState(() => _rowsPerPage = v!),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                  );
                  if (constraints.maxWidth >= ClayBreakpoints.twoColumnMin) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: tableCard),
                        const SizedBox(width: 16),
                        Expanded(
                            flex: 1,
                            child: _buildDetailPane(context, selected)),
                      ],
                    );
                  }
                  return tableCard;
                },
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
    showClaySearchDialog(
      context,
      title: 'Search Transactions',
      hintText: 'Search by invoice number, contact, or amount',
      onChanged: (v) => setState(() => _searchQuery = v),
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
                      value: AppConstants.paymentStatusPaid,
                      child: Text('Paid')),
                  DropdownMenuItem(
                      value: AppConstants.paymentStatusPartial,
                      child: Text('Partial')),
                  DropdownMenuItem(
                      value: AppConstants.paymentStatusPending,
                      child: Text('Pending')),
                  DropdownMenuItem(
                      value: AppConstants.paymentStatusCancelled,
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
                      value: AppConstants.transactionSale, child: Text('Sale')),
                  DropdownMenuItem(
                      value: AppConstants.transactionPurchase,
                      child: Text('Purchase')),
                  DropdownMenuItem(
                      value: AppConstants.transactionExpense,
                      child: Text('Expense')),
                  DropdownMenuItem(
                      value: AppConstants.transactionIncome,
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

  void _showAddTransactionDialog(BuildContext context) =>
      _AddTransactionForm.show(context);

  void _showDetailDialog(BuildContext context, TransactionModel t) =>
      _showTransactionDetailDialog(context, t);

  void _showEditDialog(BuildContext context, TransactionModel t) {
    // TODO: Implement edit dialog
  }
}

/// Transaction detail dialog (top-level so both the screen and the
/// compact card can open it). Rows come from [_transactionDetailRows].
void _showTransactionDetailDialog(BuildContext context, TransactionModel t) {
  final scheme = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (c) => ClayDialog(
      title: Text('${t.typeDisplayName} - ${t.invoiceNumber ?? 'N/A'}'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _transactionDetailRows(t),
          ),
        ),
      ),
      actions: [
        ClayButton.text(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
        ClayButton(
          onPressed: () => _printInvoice(context, t),
          child: const Text('Print / PDF'),
        ),
      ],
    ),
  );
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
      showTax: companies.first.showTaxOnInvoice,
      showVatNumber: companies.first.showVatNumber,
    );
    await pdfService.sharePdf(
      pdfBytes,
      fileName: '${t.invoiceNumber ?? 'invoice'}.pdf',
    );
  } on Exception catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Print failed: $e')));
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  TransactionModel t,
  WidgetRef ref,
) async {
  if (await showClayConfirmDialog(
    context,
    title: 'Delete Transaction?',
    message: 'Delete ${t.invoiceNumber}? This cannot be undone.',
  )) {
    await hiveService.transactionsBox.delete(t.id);
    ref.invalidate(transactionsProvider);
  }
}

/// Compact transaction card for mobile.
class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isSale = transaction.type == AppConstants.transactionSale;
    return ClayCard(
      onTap: () => _showTransactionDetailDialog(context, transaction),
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
              isSale ? ClayIcons.receivables : ClayIcons.payables,
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatDate(transaction.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(transaction.total),
                style: ClayTypography.tabular(
                    Theme.of(context).textTheme.titleMedium),
              ),
              ClayStatusBadge(
                  label: _statusLabel(transaction.paymentStatus),
                  color: _statusColor(transaction.paymentStatus)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mobile card list (compact breakpoint)
class _MobileCardList extends ConsumerWidget {
  const _MobileCardList({required this.transactions});
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions.isEmpty) {
      return Center(
        child: ClayEmptyState(
          icon: ClayIcons.transactions,
          title: 'No Transactions Found',
          subtitle: 'Add your first transaction to get started',
          action: ClayButton(
            onPressed: () => _AddTransactionForm.show(context),
            child: const Text('Add Transaction'),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(transactionsProvider);
        await ref.read(transactionsProvider.future);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) => ClayEntrance(
          delay: ClayMotion.stagger(index),
          child: _TransactionCard(transaction: transactions[index]),
        ),
      ),
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
        DataCell(Text(t.date == null ? 'N/A' : formatDate(t.date))),
        DataCell(Chip(
            label: Text(t.typeDisplayName),
            backgroundColor: _getTypeColor(t.type).withValues(alpha: 0.1),
            labelStyle: TextStyle(color: _getTypeColor(t.type)))),
        DataCell(Text(t.contactId, overflow: TextOverflow.ellipsis)),
        DataCell(Text(formatCurrency(t.total),
            style: ClayTypography.tabular(
                const TextStyle(fontWeight: FontWeight.bold)))),
        DataCell(ClayStatusBadge(
            label: _statusLabel(t.paymentStatus),
            color: _statusColor(t.paymentStatus))),
        DataCell(Text(t.dueDate == null ? 'N/A' : formatDate(t.dueDate))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(ClayIcons.view, size: 18),
                onPressed: () => onView(transactions[index]),
                tooltip: 'View'),
            IconButton(
                icon: const Icon(ClayIcons.edit, size: 18),
                onPressed: () => onEdit(transactions[index]),
                tooltip: 'Edit'),
            IconButton(
                icon: const Icon(ClayIcons.delete, size: 18),
                color: ClayColors.error,
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
      case AppConstants.transactionSale:
        return ClayColors.success;
      case AppConstants.transactionPurchase:
        return ClayColors.info;
      case AppConstants.transactionExpense:
        return ClayColors.error;
      case AppConstants.transactionIncome:
        return ClayColors.secondary;
      default:
        return ClayColors.neutral;
    }
  }
}

/// Status → color mapping for payment badges (const-safe; neutral matches
/// M3 onSurfaceVariant per [ClayColors.neutral]).
Color _statusColor(String status) {
  switch (status) {
    case AppConstants.paymentStatusPaid:
      return ClayColors.success;
    case AppConstants.paymentStatusPartial:
      return ClayColors.warning;
    case AppConstants.paymentStatusPending:
      return ClayColors.error;
    case AppConstants.paymentStatusCancelled:
      return ClayColors.neutral;
    default:
      return ClayColors.neutral;
  }
}

/// Status → label mapping for payment badges.
String _statusLabel(String status) {
  switch (status) {
    case AppConstants.paymentStatusPaid:
      return 'Paid';
    case AppConstants.paymentStatusPartial:
      return 'Partial';
    case AppConstants.paymentStatusPending:
      return 'Pending';
    case AppConstants.paymentStatusCancelled:
      return 'Cancelled';
    default:
      return status;
  }
}

/// Transactions List
/// Add Transaction Form
class _AddTransactionForm extends ConsumerStatefulWidget {
  const _AddTransactionForm({super.key});

  /// Shows the add-transaction dialog. The form owns validation + saving
  /// and reports success; this pops the dialog and confirms on the caller's
  /// context (the screen underneath, which outlives the dialog).
  static Future<void> show(BuildContext context) {
    final key = GlobalKey<_AddTransactionFormState>();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(context);
        return ClayFormDialog(
          title: const Text('Add New Transaction'),
          onSave: () async {
            if (await key.currentState?.save() ?? false) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Transaction saved successfully')),
              );
            }
          },
          child: _AddTransactionForm(key: key),
        );
      },
    );
  }

  @override
  ConsumerState<_AddTransactionForm> createState() =>
      _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<_AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = AppConstants.transactionSale;
  String _invoiceNumber = '';
  String _contactId = '';
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _total = 0.0;
  double _paidAmount = 0.0;
  String _paymentStatus = AppConstants.paymentStatusPending;
  String _paymentMethod = AppConstants.paymentCash;
  String _referenceNumber = '';
  DateTime? _date;
  DateTime? _dueDate;
  String _notes = '';
  bool _isVatIncluded = true;
  double _vatRate = 13.0;

  Future<bool> save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    final hive = ref.read(hiveServiceProvider);
    await TransactionRepository(hive.transactionsBox).saveTransaction(
      TransactionModel.create(
        type: _type,
        contactId: _contactId.trim(),
        invoiceNumber:
            _invoiceNumber.trim().isEmpty ? null : _invoiceNumber.trim(),
        subtotal: _subtotal,
        discount: _discount,
        tax: _tax,
        total: _total,
        paidAmount: _paidAmount,
        paymentStatus: _paymentStatus,
        paymentMethod: _paymentMethod,
        referenceNumber:
            _referenceNumber.trim().isEmpty ? null : _referenceNumber.trim(),
        date: _date,
        dueDate: _dueDate,
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
        isVatIncluded: _isVatIncluded,
        vatRate: _vatRate,
      ),
    );
    ref.invalidate(transactionsProvider);
    return true;
  }

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
                      value: AppConstants.transactionSale, child: Text('Sale')),
                  DropdownMenuItem(
                      value: AppConstants.transactionPurchase,
                      child: Text('Purchase')),
                  DropdownMenuItem(
                      value: AppConstants.transactionExpense,
                      child: Text('Expense')),
                  DropdownMenuItem(
                      value: AppConstants.transactionIncome,
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
                      value: AppConstants.paymentStatusPending,
                      child: Text('Pending')),
                  DropdownMenuItem(
                      value: AppConstants.paymentStatusPaid,
                      child: Text('Paid')),
                  DropdownMenuItem(
                      value: AppConstants.paymentStatusPartial,
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
                      value: AppConstants.paymentCash, child: Text('Cash')),
                  DropdownMenuItem(
                      value: AppConstants.paymentBank, child: Text('Bank')),
                  DropdownMenuItem(
                      value: AppConstants.paymentCheque, child: Text('Cheque')),
                  DropdownMenuItem(
                      value: AppConstants.paymentOnline, child: Text('Online')),
                  DropdownMenuItem(
                      value: AppConstants.paymentCredit, child: Text('Credit')),
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
