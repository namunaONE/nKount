import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/contact_model.dart';
import '../../core/models/payment_model.dart';
import '../../core/models/product_model.dart';
import '../../core/models/transaction_model.dart';
import '../../core/database/hive_service.dart';
import '../../core/repositories/contact_repository.dart';
import '../../core/repositories/payment_repository.dart';
import '../../core/repositories/product_repository.dart';
import '../../core/repositories/transaction_repository.dart';
import '../../core/utils/money.dart';
import '../../core/utils/dates.dart';
import '../../packages/design-system/design_system.dart';

/// Which outstanding aggregate the summary row shows.
enum OutstandingAgg { receivables, payables }

/// Default unit-price source for sales (kept as top-level functions so
/// [TransactionFlowConfig] can stay const).
double salePriceOf(ProductModel product) => product.salePrice;

/// Default unit-price source for purchases (kept as top-level functions so
/// [TransactionFlowConfig] can stay const).
double purchasePriceOf(ProductModel product) => product.purchasePrice;

/// Parameterizes every behavioral/visual difference between the former
/// sales and purchases twin screens. Everything else is shared verbatim.
class TransactionFlowConfig {
  const TransactionFlowConfig({
    required this.type,
    required this.title,
    required this.searchHint,
    required this.clearIcon,
    required this.contactType,
    required this.contactLabel,
    required this.contactEmptyHint,
    required this.contactRequiredHint,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyHint,
    required this.summaryTotalLabel,
    required this.summaryTotalColor,
    required this.summaryOutstandingColor,
    required this.detailTitlePrefix,
    required this.editLabel,
    required this.printLabel,
    required this.cancelTitle,
    required this.cancelConfirmText,
    required this.cancelSuccessText,
    required this.savedText,
    required this.editorTitle,
    required this.paymentRecordType,
    required this.stockSign,
    required this.priceOf,
    required this.outstandingAgg,
    required this.hasShareAction,
    required this.hasDueDate,
    required this.hasExtendedPaymentFields,
    required this.partialIcon,
    required this.pendingIcon,
  });

  /// Transaction type filter (AppConstants.transactionSale/PURCHASE).
  final String type;

  /// App bar title ('Sales'/'Purchases').
  final String title;

  /// Search field hint ('Search sales...'/'Search purchases...').
  final String searchHint;

  /// Search clear icon (Icons.clear_rounded sale / Icons.clear purchase).
  final IconData clearIcon;

  /// Which contact type is selectable besides contactBoth
  /// (contactCustomer/contactSupplier).
  final String contactType;

  /// Contact noun ('Customer'/'Supplier').
  final String contactLabel;

  /// Empty-contacts guard ('Please add a customer/supplier first').
  final String contactEmptyHint;

  /// Editor contact-required guard ('Please select a customer/supplier').
  final String contactRequiredHint;

  /// Empty-list icon (ClayIcons.empty sale / ClayIcons.purchases purchase).
  final IconData emptyIcon;

  /// Empty-list title ('No sales/purchases found').
  final String emptyTitle;

  /// Empty-list hint ('Create your first sale/purchase to get started').
  final String emptyHint;

  /// First summary card label ('Total Sales'/'Total Purchases').
  final String summaryTotalLabel;

  /// First summary card color (success sale / warning purchase).
  final Color summaryTotalColor;

  /// Outstanding summary card color (warning sale / error purchase).
  final Color summaryOutstandingColor;

  /// Detail/record-payment title noun ('Invoice' sale / 'Purchase' purchase).
  final String detailTitlePrefix;

  /// Actions-sheet edit label ('Edit Sale'/'Edit Purchase').
  final String editLabel;

  /// Actions-sheet print label ('Print Invoice'/'Print Purchase').
  final String printLabel;

  /// Cancel dialog title + actions-sheet cancel tile
  /// ('Cancel Sale'/'Cancel Purchase').
  final String cancelTitle;

  /// Cancel confirm text ('Are you sure you want to cancel this
  /// sale/purchase?').
  final String cancelConfirmText;

  /// Cancel success snackbar ('Sale/Purchase cancelled successfully').
  final String cancelSuccessText;

  /// Editor save snackbar ('Sale/Purchase saved successfully').
  final String savedText;

  /// Editor app bar title ('Add New Sale'/'Add New Purchase').
  final String editorTitle;

  /// Created payment record type ('receipt' sale / 'payment' purchase).
  final String paymentRecordType;

  /// Stock quantity multiplier (-1.0 sale / +1.0 purchase).
  final double stockSign;

  /// Default unit-price source (salePrice sale / purchasePrice purchase).
  final double Function(ProductModel) priceOf;

  /// Which outstanding aggregate the summary shows.
  final OutstandingAgg outstandingAgg;

  /// Whether the actions sheet has the Share tile (sales only).
  final bool hasShareAction;

  /// Whether the editor has a due-date picker (purchases only).
  final bool hasDueDate;

  /// Whether the record-payment dialog has bank/cheque fields
  /// (purchases only).
  final bool hasExtendedPaymentFields;

  /// Partially-paid tile icon (rounded sale / plain purchase).
  final IconData partialIcon;

  /// Pending tile icon (rounded sale / plain purchase).
  final IconData pendingIcon;

  static const sale = TransactionFlowConfig(
    type: AppConstants.transactionSale,
    title: 'Sales',
    searchHint: 'Search sales...',
    clearIcon: Icons.clear_rounded,
    contactType: AppConstants.contactCustomer,
    contactLabel: 'Customer',
    contactEmptyHint: 'Please add a customer first',
    contactRequiredHint: 'Please select a customer',
    emptyIcon: ClayIcons.empty,
    emptyTitle: 'No sales found',
    emptyHint: 'Create your first sale to get started',
    summaryTotalLabel: 'Total Sales',
    summaryTotalColor: ClayColors.success,
    summaryOutstandingColor: ClayColors.warning,
    detailTitlePrefix: 'Invoice',
    editLabel: 'Edit Sale',
    printLabel: 'Print Invoice',
    cancelTitle: 'Cancel Sale',
    cancelConfirmText: 'Are you sure you want to cancel this sale?',
    cancelSuccessText: 'Sale cancelled successfully',
    savedText: 'Sale saved successfully',
    editorTitle: 'Add New Sale',
    paymentRecordType: 'receipt',
    stockSign: -1.0,
    priceOf: salePriceOf,
    outstandingAgg: OutstandingAgg.receivables,
    hasShareAction: true,
    hasDueDate: false,
    hasExtendedPaymentFields: false,
    partialIcon: Icons.remove_circle_rounded,
    pendingIcon: Icons.pending_rounded,
  );

  static const purchase = TransactionFlowConfig(
    type: AppConstants.transactionPurchase,
    title: 'Purchases',
    searchHint: 'Search purchases...',
    clearIcon: Icons.clear,
    contactType: AppConstants.contactSupplier,
    contactLabel: 'Supplier',
    contactEmptyHint: 'Please add a supplier first',
    contactRequiredHint: 'Please select a supplier',
    emptyIcon: ClayIcons.purchases,
    emptyTitle: 'No purchases found',
    emptyHint: 'Create your first purchase to get started',
    summaryTotalLabel: 'Total Purchases',
    summaryTotalColor: ClayColors.warning,
    summaryOutstandingColor: ClayColors.error,
    detailTitlePrefix: 'Purchase',
    editLabel: 'Edit Purchase',
    printLabel: 'Print Purchase',
    cancelTitle: 'Cancel Purchase',
    cancelConfirmText: 'Are you sure you want to cancel this purchase?',
    cancelSuccessText: 'Purchase cancelled successfully',
    savedText: 'Purchase saved successfully',
    editorTitle: 'Add New Purchase',
    paymentRecordType: 'payment',
    stockSign: 1.0,
    priceOf: purchasePriceOf,
    outstandingAgg: OutstandingAgg.payables,
    hasShareAction: false,
    hasDueDate: true,
    hasExtendedPaymentFields: true,
    partialIcon: Icons.remove_circle,
    pendingIcon: Icons.pending,
  );
}

/// Shared list screen behind SalesScreen and PurchasesScreen.
class TransactionFlowScreen extends ConsumerStatefulWidget {
  const TransactionFlowScreen({required this.config, super.key});

  final TransactionFlowConfig config;

  @override
  ConsumerState<TransactionFlowScreen> createState() =>
      TransactionFlowScreenState();
}

class TransactionFlowScreenState extends ConsumerState<TransactionFlowScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';

  TransactionFlowConfig get _config => widget.config;

  @override
  Widget build(BuildContext context) {
    final hive = ref.watch(hiveServiceProvider);
    final transactions = hive.transactionsBox.values.toList();
    final flowTransactions =
        transactions.where((t) => t.type == _config.type).toList();

    final filteredTransactions = _filterTransactions(flowTransactions);
    final transactionRepo = TransactionRepository(hive.transactionsBox);
    final totalAmount = _config.type == AppConstants.transactionSale
        ? transactionRepo.getTotalSalesAmount()
        : transactionRepo.getTotalPurchaseAmount();
    final outstandingAmount =
        _config.outstandingAgg == OutstandingAgg.receivables
            ? transactionRepo.getTotalOutstandingReceivables()
            : transactionRepo.getTotalOutstandingPayables();

    return Scaffold(
      appBar: AppBar(
        title: Text(_config.title),
        actions: [
          IconButton(
            icon: const Icon(ClayIcons.filter),
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
                hintText: _config.searchHint,
                prefixIcon: const Icon(ClayIcons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(_config.clearIcon),
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
                    _config.summaryTotalLabel,
                    formatCurrency(totalAmount),
                    _config.summaryTotalColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Paid',
                    formatCurrency(flowTransactions
                        .where((t) => t.isFullyPaid)
                        .fold(0.0, (sum, t) => sum + t.total)),
                    ClayColors.info,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Outstanding',
                    formatCurrency(outstandingAmount),
                    _config.summaryOutstandingColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Transactions List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _config.emptyIcon,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _config.emptyTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _config.emptyHint,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTransactions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return _buildTransactionItem(transaction);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(ClayIcons.add),
      ),
    );
  }

  /// Filter transactions based on search and status
  List<TransactionModel> _filterTransactions(
    List<TransactionModel> transactions,
  ) {
    var filtered = transactions;

    if (_selectedStatus != 'all') {
      filtered = filtered.where((t) {
        if (_selectedStatus == 'paid') return t.isFullyPaid;
        if (_selectedStatus == 'partial') return t.isPartiallyPaid;
        if (_selectedStatus == 'pending') return t.isPending;
        if (_selectedStatus == 'cancelled') return t.isCancelled;
        if (_selectedStatus == 'overdue') return t.isOverdue;
        return true;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (t) =>
                (t.invoiceNumber
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ??
                    false) ||
                (t.contactId
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())) ||
                (t.items?.any(
                      (item) => item.productName
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()),
                    ) ??
                    false),
          )
          .toList();
    }

    return filtered;
  }

  /// Build summary card
  Widget _buildSummaryCard(String title, String value, Color color) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: ClayTypography.tabular(
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  /// Build transaction item.
  ///
  /// The sales twin used titleSmall for the title and bodyMedium for the
  /// trailing amount; the purchases twin used bodyLarge (w500) and bodyLarge.
  /// Each side's style is preserved behind the type branch below.
  Widget _buildTransactionItem(TransactionModel transaction) {
    final color = transaction.isFullyPaid
        ? ClayColors.success
        : (transaction.isPartiallyPaid ? ClayColors.warning : ClayColors.error);
    final isSale = _config.type == AppConstants.transactionSale;

    return Card(
      elevation: 2,
      color: transaction.isCancelled
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(
            transaction.isFullyPaid
                ? ClayIcons.check
                : (transaction.isPartiallyPaid
                    ? _config.partialIcon
                    : _config.pendingIcon),
            color: color,
          ),
        ),
        title: Text(
          'Invoice: ${transaction.invoiceNumber ?? 'N/A'}',
          style: isSale
              ? Theme.of(context).textTheme.titleSmall?.copyWith(
                    decoration: transaction.isCancelled
                        ? TextDecoration.lineThrough
                        : null,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration: transaction.isCancelled
                        ? TextDecoration.lineThrough
                        : null,
                  ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_config.contactLabel}: ${transaction.contactId}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (transaction.items != null && transaction.items!.isNotEmpty)
              Text(
                '${transaction.items!.length} items',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatCurrency(transaction.total),
              style: ClayTypography.tabular(
                (isSale
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.bodyLarge)
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.isCancelled
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction.date != null ? formatDate(transaction.date) : 'N/A',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        onTap: () => _showDetails(transaction),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter ${_config.title}'),
        content: RadioGroup<String>(
          groupValue: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value!);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('All ${_config.title}'),
                value: 'all',
              ),
              const RadioListTile<String>(
                title: Text('Paid'),
                value: 'paid',
              ),
              const RadioListTile<String>(
                title: Text('Partially Paid'),
                value: 'partial',
              ),
              const RadioListTile<String>(
                title: Text('Pending'),
                value: 'pending',
              ),
              const RadioListTile<String>(
                title: Text('Overdue'),
                value: 'overdue',
              ),
              const RadioListTile<String>(
                title: Text('Cancelled'),
                value: 'cancelled',
              ),
            ],
          ),
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

  /// Show add dialog
  void _showAddDialog() {
    final hive = ref.read(hiveServiceProvider);
    final contacts = hive.contactsBox.values.toList();
    final products = hive.productsBox.values.toList();

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_config.contactEmptyHint)));
      return;
    }

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products first')),
      );
      return;
    }

    // Navigate to a full screen form
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFlowEditor(
          contacts: contacts,
          products: products,
          config: _config,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  /// Show transaction details
  void _showDetails(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${_config.detailTitlePrefix}: ${transaction.invoiceNumber ?? 'N/A'}',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClayDetailRow(
                label: _config.contactLabel,
                value: transaction.contactId,
              ),
              ClayDetailRow(
                label: 'Date',
                value: transaction.date != null
                    ? formatDate(transaction.date)
                    : 'N/A',
              ),
              ClayDetailRow(
                label: 'Status',
                value: transaction.paymentStatus,
              ),
              ClayDetailRow(
                label: 'Subtotal',
                value: formatCurrency(transaction.subtotal),
              ),
              ClayDetailRow(
                label: 'Discount',
                value: formatCurrency(transaction.discount),
              ),
              ClayDetailRow(
                label: 'Tax',
                value: formatCurrency(transaction.tax),
              ),
              ClayDetailRow(
                label: 'Total',
                value: formatCurrency(transaction.total),
              ),
              ClayDetailRow(
                label: 'Paid',
                value: formatCurrency(transaction.paidAmount),
              ),
              ClayDetailRow(
                label: 'Due',
                value: formatCurrency(transaction.dueAmount),
              ),
              if (transaction.items != null &&
                  transaction.items!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Items:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...transaction.items!.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.productName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.quantity} x ${formatCurrency(item.unitPrice)}',
                          style: ClayTypography.tabular(
                            Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatCurrency(item.amount),
                          style: ClayTypography.tabular(
                            Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (transaction.notes != null && transaction.notes!.isNotEmpty)
                ClayDetailRow(label: 'Notes', value: transaction.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!transaction.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRecordPaymentDialog(transaction);
              },
              child: const Text('Record Payment'),
            ),
          if (!transaction.isCancelled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showActions(transaction);
              },
              child: const Text('Actions'),
            ),
        ],
      ),
    );
  }

  /// Show transaction actions
  void _showActions(TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(ClayIcons.payments),
              title: const Text('Record Payment'),
              onTap: () {
                Navigator.pop(context);
                _showRecordPaymentDialog(transaction);
              },
            ),
            ListTile(
              leading: const Icon(ClayIcons.edit),
              title: Text(_config.editLabel),
              onTap: () {
                Navigator.pop(context);
                // Show edit dialog
              },
            ),
            ListTile(
              leading: const Icon(ClayIcons.print),
              title: Text(_config.printLabel),
              onTap: () {
                Navigator.pop(context);
                // Print
              },
            ),
            if (_config.hasShareAction)
              ListTile(
                leading: const Icon(ClayIcons.share),
                title: const Text('Share Invoice'),
                onTap: () {
                  Navigator.pop(context);
                  // Share invoice
                },
              ),
            const Divider(),
            ListTile(
              leading: Icon(
                ClayIcons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                _config.cancelTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCancelConfirmation(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show record payment dialog.
  ///
  /// The purchases twin carried extra bank/cheque fields; the sales twin did
  /// not. Each side's fields are preserved behind
  /// [TransactionFlowConfig.hasExtendedPaymentFields].
  void _showRecordPaymentDialog(TransactionModel transaction) {
    final amountController = TextEditingController();
    var selectedMethod = AppConstants.paymentCash;
    final referenceController = TextEditingController();
    final bankController = TextEditingController();
    final chequeNumberController = TextEditingController();
    DateTime? chequeDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Record Payment for ${_config.detailTitlePrefix} ${transaction.invoiceNumber}',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Due Amount: ${formatCurrency(transaction.dueAmount)}',
                style: ClayTypography.tabular(
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
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
                initialValue: selectedMethod,
                items: const [
                  DropdownMenuItem(
                    value: AppConstants.paymentCash,
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.paymentBank,
                    child: Text('Bank Transfer'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.paymentCheque,
                    child: Text('Cheque'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.paymentOnline,
                    child: Text('Online Payment'),
                  ),
                ],
                onChanged: (value) => selectedMethod = value!,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              const SizedBox(height: 12),
              if (_config.hasExtendedPaymentFields &&
                  selectedMethod == AppConstants.paymentBank) ...[
                TextField(
                  controller: bankController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name',
                    hintText: 'Enter bank name',
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_config.hasExtendedPaymentFields &&
                  selectedMethod == AppConstants.paymentCheque) ...[
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
                    text: formatDate(chequeDate),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Cheque Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(ClayIcons.date),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: chequeDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          chequeDate = picked;
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
                  labelText: selectedMethod == AppConstants.paymentCheque
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

              if (amount > transaction.dueAmount) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Payment amount cannot exceed due amount',
                    ),
                  ),
                );
                return;
              }

              // Create payment
              final payment = PaymentModel.create(
                type: _config.paymentRecordType,
                transactionId: transaction.id,
                invoiceNumber: transaction.invoiceNumber,
                contactId: transaction.contactId,
                amount: amount,
                method: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty
                    ? null
                    : referenceController.text.trim(),
                bankName: _config.hasExtendedPaymentFields &&
                        selectedMethod == AppConstants.paymentBank
                    ? (bankController.text.trim().isEmpty
                        ? null
                        : bankController.text.trim())
                    : null,
                chequeNumber: _config.hasExtendedPaymentFields &&
                        selectedMethod == AppConstants.paymentCheque
                    ? (chequeNumberController.text.trim().isEmpty
                        ? null
                        : chequeNumberController.text.trim())
                    : null,
                chequeDate:
                    _config.hasExtendedPaymentFields ? chequeDate : null,
                date: DateTime.now(),
              );

              final hive = ref.read(hiveServiceProvider);
              await PaymentRepository(hive.paymentsBox).savePayment(payment);

              // Update transaction
              final updatedTransaction = transaction.copyWithPayment(
                amount: amount,
                paymentMethod: selectedMethod,
                referenceNumber: referenceController.text.trim().isEmpty
                    ? null
                    : referenceController.text.trim(),
              );

              await TransactionRepository(
                hive.transactionsBox,
              ).updateTransaction(updatedTransaction);
              if (mounted) setState(() {});

              if (!context.mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment recorded successfully'),
                ),
              );
            },
            child: const Text('Record Payment'),
          ),
        ],
      ),
    );
  }

  /// Show cancel confirmation
  void _showCancelConfirmation(TransactionModel transaction) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_config.cancelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_config.cancelConfirmText),
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
              final updatedTransaction = transaction.copyWithCancellation(
                reasonController.text.trim().isEmpty
                    ? 'Cancelled by user'
                    : reasonController.text.trim(),
              );

              await TransactionRepository(
                ref.read(hiveServiceProvider).transactionsBox,
              ).updateTransaction(updatedTransaction);
              if (mounted) setState(() {});

              if (!context.mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_config.cancelSuccessText)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              _config.cancelTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared full-screen editor behind the former add-sale/add-purchase screens.
///
/// The purchases twin had a due-date picker (and a matching date/due-date row
/// layout); the sales twin paired date with discount in one row. Each side's
/// layout is preserved behind [TransactionFlowConfig.hasDueDate].
class TransactionFlowEditor extends ConsumerStatefulWidget {
  const TransactionFlowEditor({
    required this.contacts,
    required this.products,
    required this.config,
    super.key,
  });

  final List<ContactModel> contacts;
  final List<ProductModel> products;
  final TransactionFlowConfig config;

  @override
  ConsumerState<TransactionFlowEditor> createState() =>
      _TransactionFlowEditorState();
}

class _TransactionFlowEditorState extends ConsumerState<TransactionFlowEditor> {
  ContactModel? _selectedContact;
  DateTime? _selectedDate = DateTime.now();
  DateTime? _dueDate;
  final List<TransactionItem> _items = [];
  double _discount = 0;
  String _notes = '';

  TransactionFlowConfig get _config => widget.config;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_config.editorTitle),
          actions: [
            TextButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contact Selection
              DropdownButtonFormField<ContactModel>(
                initialValue: _selectedContact,
                items: widget.contacts
                    .where(
                      (c) =>
                          c.type == _config.contactType ||
                          c.type == AppConstants.contactBoth,
                    )
                    .map(
                      (contact) => DropdownMenuItem(
                        value: contact,
                        child: Text(contact.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedContact = value),
                decoration: InputDecoration(
                  labelText: '${_config.contactLabel} *',
                  border: const OutlineInputBorder(),
                ),
                hint: Text('Select ${_config.contactLabel.toLowerCase()}'),
              ),
              const SizedBox(height: 16),

              // Date Selection
              if (_config.hasDueDate)
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Date *',
                        date: _selectedDate,
                        onPick: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateField(
                        label: 'Due Date',
                        date: _dueDate,
                        onPick: _selectDueDate,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Date *',
                        date: _selectedDate,
                        onPick: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDiscountField()),
                  ],
                ),
              const SizedBox(height: 16),

              if (_config.hasDueDate) ...[
                Row(children: [Expanded(child: _buildDiscountField())]),
                const SizedBox(height: 16),
              ],

              // Items Section
              const ClaySectionTitle('Items'),
              const SizedBox(height: 8),

              // Add Item Button
              OutlinedButton.icon(
                onPressed: _showAddItemDialog,
                icon: const Icon(ClayIcons.add),
                label: const Text('Add Item'),
              ),
              const SizedBox(height: 8),

              // Items List
              if (_items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No items added yet',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: _items.map(_buildItemRow).toList(),
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
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Subtotal', _calculateSubtotal()),
                      _buildSummaryRow('Discount', formatCurrency(_discount)),
                      _buildSummaryRow(
                        'Tax (13%)',
                        formatCurrency(_calculateTax()),
                      ),
                      const Divider(),
                      _buildSummaryRow('Total', _calculateTotal(),
                          isTotal: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  /// Read-only date field shared by the date and due-date pickers.
  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onPick,
  }) =>
      TextFormField(
        readOnly: true,
        controller: TextEditingController(text: formatDate(date)),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(ClayIcons.date),
            onPressed: onPick,
          ),
        ),
      );

  /// Discount field (same widget on both twins, different row placement).
  Widget _buildDiscountField() => TextFormField(
        controller: TextEditingController(text: _discount.toString()),
        decoration: const InputDecoration(
          labelText: 'Discount',
          border: OutlineInputBorder(),
          prefixText: 'रू ',
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => _discount = double.tryParse(value) ?? 0,
      );

  /// Build item row
  Widget _buildItemRow(TransactionItem item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(item.productName)),
            Expanded(
              child: Text(
                item.quantity.toString(),
                style: ClayTypography.tabular(
                  Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency(item.unitPrice),
                style: ClayTypography.tabular(
                  Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency(item.amount),
                style: ClayTypography.tabular(
                  Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                ClayIcons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => _removeItem(item),
            ),
          ],
        ),
      );

  /// Build summary row
  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: isTotal
                  ? Theme.of(
                      context,
                    )
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              value,
              style: ClayTypography.tabular(
                isTotal
                    ? Theme.of(
                        context,
                      )
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );

  /// Calculate subtotal
  String _calculateSubtotal() =>
      formatCurrency(_items.fold(0.0, (sum, item) => sum + item.amount));

  /// Calculate tax
  double _calculateTax() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    return (subtotal - _discount) * 0.13; // 13% VAT
  }

  /// Calculate total
  String _calculateTotal() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    final tax = _calculateTax();
    return formatCurrency(subtotal - _discount + tax);
  }

  /// Select date
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Select due date (purchases only; wired up behind
  /// [TransactionFlowConfig.hasDueDate]).
  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ??
          (_selectedDate ?? DateTime.now()).add(
            const Duration(days: 30),
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _dueDate) {
      setState(() => _dueDate = picked);
    }
  }

  /// Show add item dialog
  void _showAddItemDialog() {
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
                initialValue: selectedProduct,
                items: widget.products
                    .where((p) => p.isActive)
                    .map(
                      (product) => DropdownMenuItem(
                        value: product,
                        child: Text(product.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedProduct = value);
                  if (value != null) {
                    priceController.text = _config.priceOf(value).toString();
                  }
                },
                decoration: const InputDecoration(labelText: 'Product *'),
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
                  const SnackBar(
                    content: Text('Please enter valid quantity and price'),
                  ),
                );
                return;
              }

              setState(() {
                _items.add(
                  TransactionItem.create(
                    productId: selectedProduct!.id,
                    productName: selectedProduct!.name,
                    quantity: quantity,
                    unitPrice: price,
                    discount: discount,
                    unit: selectedProduct!.unit,
                  ),
                );
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

  /// Save transaction
  void _save() {
    if (_selectedContact == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_config.contactRequiredHint)));
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

    final transaction = TransactionModel.create(
      type: _config.type,
      contactId: _selectedContact!.id,
      items: _items,
      subtotal: subtotal,
      discount: _discount,
      tax: tax,
      total: total,
      date: _selectedDate,
      dueDate: _config.hasDueDate ? _dueDate : null,
      notes: _notes.isEmpty ? null : _notes,
    );

    // Save to database
    final hive = ref.read(hiveServiceProvider);
    TransactionRepository(hive.transactionsBox).saveTransaction(transaction);

    // Update contact balance
    final updatedContact = _selectedContact!.copyWithTransaction(
      transactionType: _config.type,
      amount: total,
    );
    ContactRepository(hive.contactsBox).updateContact(updatedContact);

    // Update product quantities
    final productRepo = ProductRepository(hive.productsBox);
    for (final item in _items) {
      ProductModel? product;
      try {
        product = widget.products.firstWhere((p) => p.id == item.productId);
      } on StateError catch (_) {
        product = null;
      }
      if (product != null) {
        productRepo.updateProductQuantity(
          product.id,
          _config.stockSign * item.quantity,
        );
      }
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_config.savedText)));
  }
}
