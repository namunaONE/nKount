import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/database/hive_service.dart';
import '../../core/models/payment_model.dart';
import '../../core/repositories/payment_repository.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../packages/design-system/design_system.dart';

/// Filter radio option for the money-flow filter dialog.
class MoneyFlowFilterOption {
  const MoneyFlowFilterOption({required this.label, required this.value});
  final String label;
  final String value;
}

/// Per-side configuration for [MoneyFlowScreen].
///
/// Every string, route, icon, color, and behavior that differs between the
/// receipts and payments screens is carried here so the screen logic below
/// is a verbatim move of the two original implementations.
class MoneyFlowConfig {
  const MoneyFlowConfig({
    required this.type,
    required this.title,
    required this.searchTooltip,
    required this.searchTitle,
    required this.searchHint,
    required this.filterTitle,
    required this.filterOptions,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyCtaLabel,
    required this.emptyCtaRoute,
    required this.navIndex,
    required this.addButtonLabel,
    required this.formTitle,
    required this.detailTitlePrefix,
    required this.detailFirstRowLabel,
    required this.detailFirstRowUsesReferenceFallback,
    required this.detailContactLabel,
    required this.detailTransactionUsesArticleIcon,
    required this.detailMethodLabel,
    required this.showPrintAction,
    required this.showDeleteAction,
    required this.showTypeDropdown,
    required this.showItemDate,
    required this.showItemContactLine,
    required this.showItemTypeLine,
    required this.fixedItemColor,
    required this.fixedItemIcon,
    required this.amountColor,
    required this.transactionHint,
    required this.invoiceHint,
    required this.contactHint,
    required this.amountHint,
    required this.dateLabel,
    required this.creditOptionLabel,
  });

  /// Config preserving receipts_screen.dart behavior verbatim.
  static const receipt = MoneyFlowConfig(
    type: 'receipt',
    title: 'Receipts',
    searchTooltip: 'Search Receipts',
    searchTitle: 'Search Receipts',
    searchHint: 'Search by reference, contact, or amount',
    filterTitle: 'Filter Receipts',
    filterOptions: [
      MoneyFlowFilterOption(label: 'All', value: 'all'),
      MoneyFlowFilterOption(label: 'Today', value: 'today'),
      MoneyFlowFilterOption(label: 'This Week', value: 'this_week'),
      MoneyFlowFilterOption(label: 'This Month', value: 'this_month'),
      MoneyFlowFilterOption(label: 'Cleared Only', value: 'cleared'),
      MoneyFlowFilterOption(label: 'Pending Only', value: 'pending'),
    ],
    emptyIcon: ClayIcons.transactions,
    emptyTitle: 'No Receipts Found',
    emptySubtitle: 'Add your first receipt to get started',
    emptyCtaLabel: 'Add Receipt',
    emptyCtaRoute: '/receipts',
    navIndex: 3,
    addButtonLabel: 'Add Receipt',
    formTitle: 'Add New Receipt',
    detailTitlePrefix: 'Receipt',
    detailFirstRowLabel: 'Receipt Number',
    detailFirstRowUsesReferenceFallback: true,
    detailContactLabel: 'From Contact',
    detailTransactionUsesArticleIcon: true,
    detailMethodLabel: 'Payment Method',
    showPrintAction: true,
    showDeleteAction: true,
    showTypeDropdown: false,
    showItemDate: true,
    showItemContactLine: true,
    showItemTypeLine: false,
    fixedItemColor: ClayColors.success,
    fixedItemIcon: ClayIcons.transactions,
    amountColor: ClayColors.success,
    transactionHint: 'Related transaction ID',
    invoiceHint: 'Invoice number (optional)',
    contactHint: 'Customer ID',
    amountHint: 'Receipt amount',
    dateLabel: 'Receipt Date',
    creditOptionLabel: 'Credit Card',
  );

  /// Config preserving payments_screen.dart behavior verbatim.
  static const payment = MoneyFlowConfig(
    type: 'payment',
    title: 'Payments',
    searchTooltip: 'Search Payments',
    searchTitle: 'Search Payments',
    searchHint: 'Search by reference, contact, or amount',
    filterTitle: 'Filter Payments',
    filterOptions: [
      MoneyFlowFilterOption(label: 'All', value: 'all'),
      MoneyFlowFilterOption(label: 'Payments', value: 'payment'),
      MoneyFlowFilterOption(label: 'Receipts', value: 'receipt'),
      MoneyFlowFilterOption(label: 'Today', value: 'today'),
      MoneyFlowFilterOption(label: 'This Month', value: 'this_month'),
    ],
    emptyIcon: ClayIcons.payments,
    emptyTitle: 'No Payments Found',
    emptySubtitle: 'Add your first payment to get started',
    emptyCtaLabel: 'Add Payment',
    emptyCtaRoute: '/payments',
    navIndex: 4,
    addButtonLabel: 'Add Payment',
    formTitle: 'Add New Payment',
    // Null => use the record's typeDisplayName ('Payment' / 'Receipt').
    detailTitlePrefix: null,
    detailFirstRowLabel: 'Invoice Number',
    detailFirstRowUsesReferenceFallback: false,
    detailContactLabel: 'Contact ID',
    detailTransactionUsesArticleIcon: false,
    detailMethodLabel: 'Method',
    showPrintAction: false,
    showDeleteAction: false,
    showTypeDropdown: true,
    showItemDate: false,
    showItemContactLine: false,
    showItemTypeLine: true,
    // Null => derive per-record from the shared type switch below.
    fixedItemColor: null,
    fixedItemIcon: null,
    amountColor: ClayColors.primary,
    transactionHint: 'Transaction ID',
    invoiceHint: 'Invoice number',
    contactHint: 'Contact ID',
    amountHint: 'Amount',
    dateLabel: 'Payment Date',
    creditOptionLabel: 'Credit',
  );

  /// 'receipt' / 'payment'. Used to watch/invalidate [moneyFlowProvider].
  final String type;
  final String title;
  final String searchTooltip;
  final String searchTitle;
  final String searchHint;
  final String filterTitle;
  final List<MoneyFlowFilterOption> filterOptions;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final String emptyCtaLabel;
  final String emptyCtaRoute;
  final int navIndex;
  final String addButtonLabel;
  final String formTitle;

  /// Detail dialog title prefix. Null => record's typeDisplayName.
  /// Receipt side hardcodes 'Receipt' (identical output: receipts screen
  /// only ever shows receipt records, whose typeDisplayName is 'Receipt').
  final String? detailTitlePrefix;
  final String detailFirstRowLabel;
  final bool detailFirstRowUsesReferenceFallback;
  final String detailContactLabel;
  final bool detailTransactionUsesArticleIcon;
  final String detailMethodLabel;
  final bool showPrintAction;
  final bool showDeleteAction;
  final bool showTypeDropdown;
  final bool showItemDate;
  final bool showItemContactLine;
  final bool showItemTypeLine;
  final Color? fixedItemColor;
  final IconData? fixedItemIcon;
  final Color amountColor;
  final String transactionHint;
  final String invoiceHint;
  final String contactHint;
  final String amountHint;
  final String dateLabel;
  final String creditOptionLabel;

  String detailTitle(PaymentModel p) =>
      '${detailTitlePrefix ?? p.typeDisplayName} - ${p.referenceDisplay}';
}

/// Shared provider replacing file-local receiptsProvider/paymentsProvider.
/// (Verified: neither old provider was referenced outside its own file.)
final moneyFlowProvider =
    FutureProvider.family<List<PaymentModel>, String>((ref, type) async {
  final hive = ref.watch(hiveServiceProvider);
  return hive.paymentsBox.values.where((p) => p.type == type).toList();
});

/// Shared money-flow screen (receipts + payments).
class MoneyFlowScreen extends ConsumerStatefulWidget {
  const MoneyFlowScreen({required this.config, super.key});

  final MoneyFlowConfig config;

  @override
  ConsumerState<MoneyFlowScreen> createState() => MoneyFlowScreenState();
}

class MoneyFlowScreenState extends ConsumerState<MoneyFlowScreen> {
  String _searchQuery = '';

  MoneyFlowConfig get config => widget.config;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(moneyFlowProvider(config.type));

    return ClayScaffold(
      appBar: ClayAppBar(
        title: Text(config.title),
        actions: [
          ClayIconButton(
            icon: ClayIcons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: config.searchTooltip,
          ),
          ClayIconButton(
            icon: ClayIcons.filter,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddDialog(context),
            child: Text(config.addButtonLabel),
          ),
        ],
      ),
      body: items.when(
        loading: () => const ClaySkeletonList(),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (itemList) {
          final filtered = _filterItems(itemList);
          if (filtered.isEmpty) {
            return Center(
              child: ClayEmptyState(
                icon: config.emptyIcon,
                title: config.emptyTitle,
                subtitle: config.emptySubtitle,
                action: ClayButton(
                  onPressed: () => _MoneyFlowForm.show(context, config),
                  child: Text(config.emptyCtaLabel),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(moneyFlowProvider(config.type));
              await ref.read(moneyFlowProvider(config.type).future);
            },
            child: _MoneyFlowList(config: config, items: filtered),
          );
        },
      ),
      bottomNavigationBar: mainNavBar(context, config.navIndex),
    );
  }

  List<PaymentModel> _filterItems(List<PaymentModel> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list
        .where((p) =>
            (p.invoiceNumber?.toLowerCase().contains(q) ?? false) ||
            (p.notes?.toLowerCase().contains(q) ?? false) ||
            p.contactId.toLowerCase().contains(q))
        .toList();
  }

  void _showSearchDialog(BuildContext context) {
    showClaySearchDialog(
      context,
      title: config.searchTitle,
      hintText: config.searchHint,
      onChanged: (v) => setState(() => _searchQuery = v),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text(config.filterTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in config.filterOptions)
              ClayRadioListTile<String>(
                title: Text(option.label),
                value: option.value,
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

  void _showAddDialog(BuildContext context) =>
      _MoneyFlowForm.show(context, config);
}

/// Money-flow list
class _MoneyFlowList extends ConsumerWidget {
  const _MoneyFlowList({required this.config, required this.items});
  final MoneyFlowConfig config;
  final List<PaymentModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ClayEntrance(
            delay: ClayMotion.stagger(index),
            child: _MoneyFlowItem(config: config, item: item),
          );
        },
      );
}

/// Money-flow item
class _MoneyFlowItem extends StatelessWidget {
  const _MoneyFlowItem({required this.config, required this.item});
  final MoneyFlowConfig config;
  final PaymentModel item;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final status = item.isClearedPayment ? 'Cleared' : 'Pending';
    final accent = config.fixedItemColor ?? _typeColor(item.type);
    final icon = config.fixedItemIcon ?? _typeIcon(item.type);
    return ClayCard(
      onTap: () => _showDetailDialog(context, item),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.invoiceNumber ?? item.referenceDisplay,
                  style:
                      text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (config.showItemContactLine) ...[
                  const SizedBox(height: 4),
                  Text(
                    'From: ${item.contactId}',
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
                if (config.showItemTypeLine) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.typeDisplayName,
                    style: text.bodySmall?.copyWith(
                      color: _typeColor(item.type),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  item.methodDisplayName,
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(item.amount),
                style: ClayTypography.tabular(
                  text.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: config.amountColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ClayStatusBadge(
                label: status,
                color: _statusColor(context, status),
              ),
              if (config.showItemDate) ...[
                const SizedBox(height: 4),
                Text(
                  item.date != null ? formatDate(item.date) : 'N/A',
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, PaymentModel item) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text(config.detailTitle(item)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClayDetailRow(
                icon: ClayIcons.transactions,
                label: config.detailFirstRowLabel,
                value: config.detailFirstRowUsesReferenceFallback
                    ? item.invoiceNumber ?? item.referenceDisplay
                    : item.invoiceNumber ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.date,
                label: 'Date',
                value: item.date != null ? formatDate(item.date) : 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.contacts,
                label: config.detailContactLabel,
                value: item.contactId,
              ),
              const Divider(),
              ClayDetailRow(
                icon: config.detailTransactionUsesArticleIcon
                    ? Icons.article
                    : ClayIcons.contacts,
                label: 'Transaction ID',
                value: item.transactionId,
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.cash,
                label: 'Amount',
                value: formatCurrency(item.amount),
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.payments,
                label: config.detailMethodLabel,
                value: item.methodDisplayName,
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.numbers,
                label: 'Reference',
                value: item.referenceDisplay,
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.account_balance,
                label: 'Bank',
                value: item.bankName ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.description,
                label: 'Cheque Number',
                value: item.chequeNumber ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.note,
                label: 'Notes',
                value: item.notes ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.info,
                label: 'Status',
                value: item.isClearedPayment ? 'Cleared' : 'Pending',
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
          if (config.showDeleteAction)
            ClayButton(
              onPressed: () {},
              style: ClayButtonStyle(
                backgroundColor: ClayColors.error.withValues(alpha: 0.1),
                foregroundColor: ClayColors.error,
              ),
              child: const Text('Delete'),
            ),
          if (config.showPrintAction)
            ClayButton(
              onPressed: () => _showPrintOptions(context, item),
              icon: ClayIcons.print,
              child: const Text('Print'),
            ),
        ],
      ),
    );
  }

  void _showPrintOptions(BuildContext context, PaymentModel item) {
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

/// Payment type color mapping (moved verbatim from payments_screen.dart).
/// The receipts screen used a fixed ClayColors.success icon, preserved via
/// [MoneyFlowConfig.fixedItemColor] (which equals this switch's 'receipt'
/// branch; only the icon differs: fixed transactions vs receivables).
Color _typeColor(String type) {
  switch (type) {
    case 'payment':
      return ClayColors.error;
    case 'receipt':
      return ClayColors.success;
    default:
      return ClayColors.neutral;
  }
}

/// Payment type icon mapping (moved verbatim from payments_screen.dart).
IconData _typeIcon(String type) {
  switch (type) {
    case 'payment':
      return ClayIcons.payables;
    case 'receipt':
      return ClayIcons.receivables;
    default:
      return ClayIcons.payments;
  }
}

/// Status color mapping for receipt/payment badges.
/// (Verified identical in both original files; kept as one shared copy.)
Color _statusColor(BuildContext context, String status) {
  switch (status) {
    case 'Cleared':
      return ClayColors.success;
    case 'Pending':
      return ClayColors.warning;
    default:
      return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

/// Add money-flow form
class _MoneyFlowForm extends ConsumerStatefulWidget {
  const _MoneyFlowForm({required this.config, super.key});

  final MoneyFlowConfig config;

  /// Shows the add dialog (form owns validation + save).
  static Future<void> show(BuildContext context, MoneyFlowConfig config) {
    final key = GlobalKey<_MoneyFlowFormState>();
    return showDialog(
      context: context,
      builder: (_) => ClayFormDialog(
        title: Text(config.formTitle),
        onSave: () => key.currentState?._save(),
        child: _MoneyFlowForm(key: key, config: config),
      ),
    );
  }

  @override
  ConsumerState<_MoneyFlowForm> createState() => _MoneyFlowFormState();
}

class _MoneyFlowFormState extends ConsumerState<_MoneyFlowForm> {
  final _formKey = GlobalKey<FormState>();
  late String _type = widget.config.type;
  String _transactionId = '';
  String _invoiceNumber = '';
  String _contactId = '';
  double _amount = 0.0;
  String _method = AppConstants.paymentCash;
  String _referenceNumber = '';
  String _bankName = '';
  String _chequeNumber = '';
  DateTime? _chequeDate;
  DateTime? _date;
  String _notes = '';

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final hive = ref.read(hiveServiceProvider);
    await PaymentRepository(hive.paymentsBox).savePayment(
      PaymentModel.create(
        type: _type,
        transactionId: _transactionId.trim(),
        invoiceNumber:
            _invoiceNumber.trim().isEmpty ? null : _invoiceNumber.trim(),
        contactId: _contactId.trim(),
        amount: _amount,
        method: _method,
        referenceNumber:
            _referenceNumber.trim().isEmpty ? null : _referenceNumber.trim(),
        bankName: _bankName.trim().isEmpty ? null : _bankName.trim(),
        chequeNumber:
            _chequeNumber.trim().isEmpty ? null : _chequeNumber.trim(),
        chequeDate: _chequeDate,
        date: _date ?? DateTime.now(),
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
      ),
    );
    ref.invalidate(moneyFlowProvider(_type));
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (config.showTypeDropdown) ...[
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
            ],
            ClayInputWithLabel(
              label: 'Transaction ID *',
              hintText: config.transactionHint,
              value: _transactionId,
              onChanged: (value) => _transactionId = value,
              validator: (value) =>
                  value?.isEmpty ?? false ? 'Transaction ID is required' : null,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Invoice Number',
              hintText: config.invoiceHint,
              value: _invoiceNumber,
              onChanged: (value) => _invoiceNumber = value,
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Contact ID *',
              hintText: config.contactHint,
              value: _contactId,
              onChanged: (value) => _contactId = value,
              validator: (value) =>
                  value?.isEmpty ?? false ? 'Contact ID is required' : null,
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Amount *',
              hintText: config.amountHint,
              value: _amount,
              onChanged: (value) => _amount = value ?? 0,
              validator: (value) =>
                  value == null || value <= 0 ? 'Amount is required' : null,
            ),
            const SizedBox(height: 16),
            ClayDropdownInput<String>(
              label: 'Payment Method *',
              value: _method,
              items: [
                const DropdownMenuItem(
                    value: AppConstants.paymentCash, child: Text('Cash')),
                const DropdownMenuItem(
                    value: AppConstants.paymentBank,
                    child: Text('Bank Transfer')),
                const DropdownMenuItem(
                    value: AppConstants.paymentCheque, child: Text('Cheque')),
                const DropdownMenuItem(
                    value: AppConstants.paymentOnline,
                    child: Text('Online Payment')),
                DropdownMenuItem(
                    value: AppConstants.paymentCredit,
                    child: Text(config.creditOptionLabel)),
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
            if (_method == AppConstants.paymentBank ||
                _method == AppConstants.paymentCheque) ...[
              ClayInputWithLabel(
                label: 'Bank Name',
                hintText: 'Bank name',
                value: _bankName,
                onChanged: (value) => _bankName = value,
              ),
              const SizedBox(height: 16),
            ],
            if (_method == AppConstants.paymentCheque) ...[
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
              label: config.dateLabel,
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
