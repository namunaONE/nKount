import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../packages/design-system/design_system.dart';

/// Configuration covering everything that differs between the
/// income and expenses flows. All strings/routes/colors here are
/// copied verbatim from the original per-side screens.
class SimpleFlowConfig {
  const SimpleFlowConfig({
    required this.type,
    required this.title,
    required this.searchTitle,
    required this.searchHint,
    required this.searchTooltip,
    required this.filterTitle,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyCtaLabel,
    required this.emptyCtaRoute,
    required this.addTitle,
    required this.addButtonLabel,
    required this.detailTitlePrefix,
    required this.numberLabel,
    required this.contactRowLabel,
    required this.categoryRowLabel,
    required this.formNumberLabel,
    required this.formNumberHint,
    required this.formContactLabel,
    required this.formContactHint,
    required this.formAmountHint,
    required this.formCategoryLabel,
    required this.formCategoryRequiredMessage,
    required this.formVatHint,
    required this.defaultVatRate,
    required this.defaultVatIncluded,
    required this.formDescriptionHint,
    required this.sourceOptions,
    required this.labelKeywords,
    required this.statIcon,
    required this.accentColor,
  });

  /// Transaction type filter (AppConstants.transaction*).
  final String type;

  /// App bar title.
  final String title;

  /// Search dialog title + hint, and search button tooltip.
  final String searchTitle;
  final String searchHint;
  final String searchTooltip;

  /// Filter dialog title.
  final String filterTitle;

  /// Empty-state icon/title/subtitle/CTA.
  final String emptyTitle;
  final String emptySubtitle;
  final String emptyCtaLabel;
  final String emptyCtaRoute;

  /// Add-form dialog title + app bar button label.
  final String addTitle;
  final String addButtonLabel;

  /// Detail dialog title prefix ('Income - ' / 'Expense - ').
  final String detailTitlePrefix;

  /// Detail-row labels that differ per side.
  final String numberLabel;
  final String contactRowLabel;
  final String categoryRowLabel;

  /// Add-form labels/hints that differ per side.
  final String formNumberLabel;
  final String formNumberHint;
  final String formContactLabel;
  final String formContactHint;
  final String formAmountHint;
  final String formCategoryLabel;
  final String formCategoryRequiredMessage;
  final String formVatHint;
  final double defaultVatRate;
  final bool defaultVatIncluded;
  final String formDescriptionHint;

  /// Dropdown options for the source/category field.
  final List<String> sourceOptions;

  /// Flattened keyword -> label table. Insertion order is match
  /// priority (first keyword contained in the notes wins), mirroring
  /// the original ordered tuple tables.
  final Map<String, String> labelKeywords;

  /// Empty-state + list-item icon.
  final IconData statIcon;

  /// List-item icon container tint + amount color.
  final Color accentColor;

  static const income = SimpleFlowConfig(
    type: AppConstants.transactionIncome,
    title: 'Income',
    searchTitle: 'Search Income',
    searchHint: 'Search by description, source, or amount',
    searchTooltip: 'Search Income',
    filterTitle: 'Filter Income',
    emptyTitle: 'No Income Found',
    emptySubtitle: 'Add your first income to get started',
    emptyCtaLabel: 'Add Income',
    emptyCtaRoute: '/income',
    addTitle: 'Add New Income',
    addButtonLabel: 'Add Income',
    detailTitlePrefix: 'Income - ',
    numberLabel: 'Income No',
    contactRowLabel: 'Contact / Source',
    categoryRowLabel: 'Source',
    formNumberLabel: 'Income Number',
    formNumberHint: 'Income reference number',
    formContactLabel: 'Contact / Source (Optional)',
    formContactHint: 'Contact ID or source name',
    formAmountHint: 'Income amount',
    formCategoryLabel: 'Income Source *',
    formCategoryRequiredMessage: 'Source is required',
    formVatHint: 'VAT rate (if applicable)',
    // Most income types don't have VAT in Nepal
    defaultVatRate: 0.0,
    defaultVatIncluded: false,
    formDescriptionHint: 'Income description',
    sourceOptions: [
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
    ],
    labelKeywords: {
      'sale': 'Sales',
      'revenue': 'Sales',
      'service': 'Service',
      'interest': 'Interest',
      'rent': 'Rent',
      'lease': 'Rent',
      'investment': 'Investment',
      'commission': 'Commission',
      'refund': 'Refund',
      'discount': 'Discount Received',
      'subsidy': 'Subsidy',
      'grant': 'Grant',
      'gift': 'Gift',
      'other': 'Other Income',
    },
    statIcon: ClayIcons.revenue,
    accentColor: ClayColors.success,
  );

  static const expense = SimpleFlowConfig(
    type: AppConstants.transactionExpense,
    title: 'Expenses',
    searchTitle: 'Search Expenses',
    searchHint: 'Search by description, category, or amount',
    searchTooltip: 'Search Expenses',
    filterTitle: 'Filter Expenses',
    emptyTitle: 'No Expenses Found',
    emptySubtitle: 'Add your first expense to get started',
    emptyCtaLabel: 'Add Expense',
    emptyCtaRoute: '/expenses',
    addTitle: 'Add New Expense',
    addButtonLabel: 'Add Expense',
    detailTitlePrefix: 'Expense - ',
    numberLabel: 'Expense No',
    contactRowLabel: 'Contact',
    categoryRowLabel: 'Category',
    formNumberLabel: 'Expense Number',
    formNumberHint: 'Expense reference number',
    formContactLabel: 'Contact / Vendor (Optional)',
    formContactHint: 'Contact ID or name',
    formAmountHint: 'Expense amount',
    formCategoryLabel: 'Category *',
    formCategoryRequiredMessage: 'Category is required',
    formVatHint: 'VAT rate',
    defaultVatRate: 13.0,
    defaultVatIncluded: true,
    formDescriptionHint: 'Expense description',
    sourceOptions: [
      'General',
      'Rent',
      'Salary',
      'Electricity',
      'Water',
      'Internet',
      'Phone',
      'Transport',
      'Food',
      'Office Supplies',
      'Travel',
      'Maintenance',
      'Insurance',
      'Tax',
      'Bank Charges',
      'Marketing',
      'Professional Fees',
      'Miscellaneous',
    ],
    labelKeywords: {
      'rent': 'Rent',
      'salary': 'Salary',
      'electricity': 'Electricity',
      'electric': 'Electricity',
      'water': 'Water',
      'internet': 'Internet',
      'wifi': 'Internet',
      'phone': 'Phone',
      'mobile': 'Phone',
      'transport': 'Transport',
      'fuel': 'Transport',
      'food': 'Food',
      'meal': 'Food',
      'stationery': 'Office',
      'office': 'Office',
      'travel': 'Travel',
      'maintenance': 'Maintenance',
      'insurance': 'Insurance',
      'tax': 'Tax',
      'bank': 'Bank Charges',
      'interest': 'Bank Charges',
      'advertising': 'Marketing',
      'marketing': 'Marketing',
    },
    statIcon: ClayIcons.expenses,
    accentColor: ClayColors.error,
  );
}

/// One family replacing the file-local incomeProvider/expensesProvider.
final simpleFlowProvider =
    FutureProvider.family<List<TransactionModel>, String>((ref, type) async {
  final hive = ref.watch(hiveServiceProvider);
  return hive.transactionsBox.values.where((t) => t.type == type).toList();
});

/// Shared income/expenses screen. Thin per-side subclasses in the
/// original paths supply the config.
class SimpleFlowScreen extends ConsumerStatefulWidget {
  const SimpleFlowScreen({required this.config, super.key});

  final SimpleFlowConfig config;

  @override
  ConsumerState<SimpleFlowScreen> createState() => SimpleFlowScreenState();
}

class SimpleFlowScreenState extends ConsumerState<SimpleFlowScreen> {
  String _searchQuery = '';

  SimpleFlowConfig get config => widget.config;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(simpleFlowProvider(config.type));

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
                icon: config.statIcon,
                title: config.emptyTitle,
                subtitle: config.emptySubtitle,
                action: ClayButton(
                  onPressed: () => context.push(config.emptyCtaRoute),
                  child: Text(config.emptyCtaLabel),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(simpleFlowProvider(config.type));
              await ref.read(simpleFlowProvider(config.type).future);
            },
            child: _SimpleFlowList(items: filtered, config: config),
          );
        },
      ),
      bottomNavigationBar: mainNavBar(context, 3),
    );
  }

  List<TransactionModel> _filterItems(List<TransactionModel> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list
        .where((t) =>
            (t.invoiceNumber?.toLowerCase().contains(q) ?? false) ||
            (t.notes?.toLowerCase().contains(q) ?? false) ||
            t.contactId.toLowerCase().contains(q))
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

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: Text(config.addTitle),
        child: _AddSimpleFlowForm(config: config),
      ),
    );
  }
}

/// Shared list.
class _SimpleFlowList extends ConsumerWidget {
  const _SimpleFlowList({required this.items, required this.config});
  final List<TransactionModel> items;
  final SimpleFlowConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ClayEntrance(
            delay: ClayMotion.stagger(index),
            child: _SimpleFlowItem(item: item, config: config),
          );
        },
      );
}

/// Shared list item + detail dialog.
class _SimpleFlowItem extends StatelessWidget {
  const _SimpleFlowItem({required this.item, required this.config});
  final TransactionModel item;
  final SimpleFlowConfig config;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ClayCard(
      onTap: () => _showDetailDialog(context, item),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: config.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              config.statIcon,
              color: config.accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.invoiceNumber ?? 'N/A',
                  style:
                      text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item.notes ?? 'No description',
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getLabel(item),
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
                formatCurrency(item.total),
                style: ClayTypography.tabular(
                  text.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: config.accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.date != null ? formatDate(item.date) : 'N/A',
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLabel(TransactionModel item) {
    // Extract category from notes or items
    final notes = item.notes;
    if (notes == null || notes.isEmpty) return 'General';
    final lowerNotes = notes.toLowerCase();
    for (final entry in config.labelKeywords.entries) {
      if (lowerNotes.contains(entry.key)) return entry.value;
    }
    return 'General';
  }

  void _showDetailDialog(BuildContext context, TransactionModel item) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title:
            Text('${config.detailTitlePrefix}${item.invoiceNumber ?? 'N/A'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClayDetailRow(
                icon: ClayIcons.transactions,
                label: config.numberLabel,
                value: item.invoiceNumber ?? 'N/A',
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
                label: config.contactRowLabel,
                value: item.contactId,
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.cash,
                label: 'Amount',
                value: formatCurrency(item.total),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.percent,
                label: 'VAT Rate',
                value: '${item.vatRate}%',
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.cash,
                label: 'VAT Amount',
                value: formatCurrency(item.tax),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.note,
                label: 'Description',
                value: item.notes ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.category,
                label: config.categoryRowLabel,
                value: _getLabel(item),
              ),
              const Divider(),
              ClayDetailRow(
                icon: ClayIcons.payments,
                label: 'Payment Method',
                value: item.paymentMethod ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.info,
                label: 'Payment Status',
                value: item.paymentStatus,
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
              backgroundColor: ClayColors.error.withValues(alpha: 0.1),
              foregroundColor: ClayColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Shared add form.
class _AddSimpleFlowForm extends ConsumerStatefulWidget {
  const _AddSimpleFlowForm({required this.config});

  final SimpleFlowConfig config;

  @override
  ConsumerState<_AddSimpleFlowForm> createState() => _AddSimpleFlowFormState();
}

class _AddSimpleFlowFormState extends ConsumerState<_AddSimpleFlowForm> {
  final _formKey = GlobalKey<FormState>();
  String _invoiceNumber = '';
  String _contactId = '';
  double _amount = 0.0;
  String _description = '';
  late String _source;
  String _paymentMethod = AppConstants.paymentCash;
  late double _vatRate;
  late bool _isVatIncluded;
  DateTime? _date;
  String _referenceNumber = '';

  @override
  void initState() {
    super.initState();
    _source = 'General';
    _vatRate = widget.config.defaultVatRate;
    _isVatIncluded = widget.config.defaultVatIncluded;
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClayInputWithLabel(
                label: widget.config.formNumberLabel,
                hintText: widget.config.formNumberHint,
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
                label: widget.config.formContactLabel,
                hintText: widget.config.formContactHint,
                value: _contactId,
                onChanged: (value) => _contactId = value,
              ),
              const SizedBox(height: 16),
              ClayCurrencyInput(
                label: 'Amount *',
                hintText: widget.config.formAmountHint,
                value: _amount,
                onChanged: (value) => _amount = value ?? 0,
                validator: (value) =>
                    value == null || value <= 0 ? 'Amount is required' : null,
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: widget.config.formCategoryLabel,
                value: _source,
                items: widget.config.sourceOptions
                    .map((source) => DropdownMenuItem(
                          value: source,
                          child: Text(source),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _source = value!),
                validator: (value) => value == null
                    ? widget.config.formCategoryRequiredMessage
                    : null,
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: 'Payment Method',
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(
                      value: AppConstants.paymentCash, child: Text('Cash')),
                  DropdownMenuItem(
                      value: AppConstants.paymentBank,
                      child: Text('Bank Transfer')),
                  DropdownMenuItem(
                      value: AppConstants.paymentCheque, child: Text('Cheque')),
                  DropdownMenuItem(
                      value: AppConstants.paymentOnline,
                      child: Text('Online Payment')),
                  DropdownMenuItem(
                      value: AppConstants.paymentCredit,
                      child: Text('Credit Card')),
                ],
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'VAT Rate %',
                      hintText: widget.config.formVatHint,
                      value: _vatRate.toString(),
                      onChanged: (value) => _vatRate = double.tryParse(value) ??
                          widget.config.defaultVatRate,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClaySwitchInput(
                      label: 'VAT Included',
                      value: _isVatIncluded,
                      onChanged: (value) =>
                          setState(() => _isVatIncluded = value),
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
                hintText: widget.config.formDescriptionHint,
                value: _description,
                onChanged: (value) => _description = value,
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? false
                    ? 'Description is recommended'
                    : null,
              ),
            ],
          ),
        ),
      );
}
