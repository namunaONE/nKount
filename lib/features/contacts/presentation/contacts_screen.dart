import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/utils/money.dart';
import '../../../packages/design-system/design_system.dart';

/// Contacts Screen: dense sortable table (desktop) + cards (mobile).
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String _searchQuery = '';
  String _selectedType = 'all';
  int _rowsPerPage = 25;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);

    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Contacts'),
        subtitle: const Text('Customers, suppliers, balances'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Contacts',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddContactDialog(context),
            child: const Text('Add Contact'),
          ),
        ],
      ),
      body: contacts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (contactList) {
          final filtered = _filterContacts(contactList);
          final sorted = _sortContacts(filtered);
          return LayoutBuilder(
            builder: (context, constraints) {
              if (ClayBreakpoints.isCompact(constraints.maxWidth)) {
                if (sorted.isEmpty) {
                  return Center(
                    child: ClayEmptyState(
                      icon: Icons.people_alt_outlined,
                      title: 'No Contacts Found',
                      subtitle: 'Add your first contact to get started',
                      action: ClayButton(
                        onPressed: () => context.push('/contacts'),
                        child: const Text('Add Contact'),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) =>
                      _ContactItem(contact: sorted[index]),
                );
              }
              if (sorted.isEmpty) {
                return Center(
                  child: ClayEmptyState(
                    icon: Icons.people_alt_outlined,
                    title: 'No Contacts Found',
                    subtitle: 'Add your first contact to get started',
                    action: ClayButton(
                      onPressed: () => context.push('/contacts'),
                      child: const Text('Add Contact'),
                    ),
                  ),
                );
              }
              return ClayTableCard(
                title: 'Contacts (${sorted.length})',
                tableTitle: 'All contacts',
                searchHint: 'Search...',
                onSearchChanged: (v) => setState(() => _searchQuery = v),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (v) => setState(() => _rowsPerPage = v!),
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: Text('Name',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 0;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Phone',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 1;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Type',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 2;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Balance',
                        style: Theme.of(context).textTheme.labelLarge),
                    numeric: true,
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 3;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Status',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 4;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Actions',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
                source: _ContactsDataSource(
                  contacts: sorted,
                  onView: (c) => _showContactDetailDialog(context, c),
                  onDelete: (c) => _confirmDeleteContact(context, ref, c),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: mainNavBar(context, 1),
    );
  }

  List<ContactModel> _filterContacts(List<ContactModel> list) =>
      list.where((c) {
        if (_selectedType != 'all' && c.type != _selectedType) return false;
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          if (!c.name.toLowerCase().contains(q) &&
              !(c.primaryPhone?.contains(_searchQuery) ?? false) &&
              !(c.email?.toLowerCase().contains(q) ?? false)) {
            return false;
          }
        }
        return c.isActive;
      }).toList();

  List<ContactModel> _sortContacts(List<ContactModel> list) {
    list.sort((a, b) {
      var cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = a.name.compareTo(b.name);
          break;
        case 1:
          cmp = (a.primaryPhone ?? '').compareTo(b.primaryPhone ?? '');
          break;
        case 2:
          cmp = a.type.compareTo(b.type);
          break;
        case 3:
          cmp = a.balance.compareTo(b.balance);
          break;
        case 4:
          cmp = (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0);
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });
    return list;
  }

  void _showSearchDialog(BuildContext context) {
    showClaySearchDialog(
      context,
      title: 'Search Contacts',
      hintText: 'Search by name, phone, or email',
      onChanged: (v) => setState(() => _searchQuery = v),
    );
  }

  void _showFilterDialog(BuildContext context) {
    var selected = _selectedType;
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Filter Contacts'),
        content: SizedBox(
          width: 300,
          child: ClayDropdownInput<String>(
            label: 'Type',
            value: selected,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(
                  value: AppConstants.contactCustomer,
                  child: Text('Customers')),
              DropdownMenuItem(
                  value: AppConstants.contactSupplier,
                  child: Text('Suppliers')),
              DropdownMenuItem(
                  value: AppConstants.contactBoth, child: Text('Both')),
            ],
            onChanged: (v) => selected = v!,
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              setState(() => _selectedType = selected);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ClayFormDialog(
        title: Text('Add New Contact'),
        child: _AddContactForm(),
      ),
    );
  }
}

/// Table data source for contacts.
class _ContactsDataSource extends DataTableSource {
  _ContactsDataSource({
    required this.contacts,
    required this.onView,
    required this.onDelete,
  });
  final List<ContactModel> contacts;
  final void Function(ContactModel) onView;
  final void Function(ContactModel) onDelete;

  @override
  DataRow? getRow(int index) {
    final c = contacts[index];
    return DataRow(
      onSelectChanged: (_) => onView(c),
      cells: [
        DataCell(Text(c.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        DataCell(Text(c.primaryPhone ?? '—')),
        DataCell(
          Chip(
            label: Text(c.typeDisplayName,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5)),
            backgroundColor: _contactTypeColor(c.type).withValues(alpha: 0.1),
            side: BorderSide(color: _contactTypeColor(c.type), width: 1),
            visualDensity: VisualDensity.compact,
          ),
        ),
        DataCell(Text(
          formatCurrency(c.balance),
          style: ClayTypography.tabular(TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: c.balance >= 0 ? ClayColors.success : ClayColors.error,
          )),
        )),
        DataCell(Text(
          c.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: c.isActive ? ClayColors.success : ClayColors.neutral,
          ),
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(ClayIcons.view, size: ClayIconSize.dense),
              onPressed: () => onView(c),
              tooltip: 'View',
            ),
            IconButton(
              icon: const Icon(ClayIcons.delete, size: ClayIconSize.dense),
              color: ClayColors.error,
              onPressed: () => onDelete(c),
              tooltip: 'Delete',
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => contacts.length;
  @override
  int get selectedRowCount => 0;
}

/// Shared contact helpers (used by cards + table).
Color _contactTypeColor(String type) {
  switch (type) {
    case AppConstants.contactCustomer:
      return ClayColors.primary;
    case AppConstants.contactSupplier:
      return ClayColors.secondary;
    case AppConstants.contactBoth:
      return ClayColors.tertiary;
    default:
      return ClayColors.neutral;
  }
}

void _showContactDetailDialog(BuildContext context, ContactModel contact) {
  showDialog(
    context: context,
    builder: (context) => ClayDialog(
      title: Text(contact.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClayDetailRow(
              icon: Icons.phone,
              label: 'Phone',
              value: contact.primaryPhone ?? 'N/A',
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: contact.email ?? 'N/A',
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.location_on,
              label: 'Address',
              value: contact.fullAddress,
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.money,
              label: 'Balance',
              value: formatCurrency(contact.balance),
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.category,
              label: 'Type',
              value: contact.typeDisplayName,
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.info,
              label: 'VAT Number',
              value: contact.vatNumber ?? 'N/A',
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.numbers,
              label: 'PAN Number',
              value: contact.panNumber ?? 'N/A',
            ),
          ],
        ),
      ),
      actions: [
        ClayButton.text(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Future<void> _confirmDeleteContact(
    BuildContext context, WidgetRef ref, ContactModel contact) async {
  if (await showClayConfirmDialog(
    context,
    title: 'Delete contact?',
    message: 'Delete ${contact.name}? Linked transactions keep their history.',
  )) {
    await hiveService.contactsBox.delete(contact.id);
    ref.invalidate(contactsProvider);
  }
}

/// Contact Item (mobile card)
class _ContactItem extends StatelessWidget {
  const _ContactItem({required this.contact});
  final ContactModel contact;

  @override
  Widget build(BuildContext context) => ClayCard(
        onTap: () => _showContactDetailDialog(context, contact),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _contactTypeColor(contact.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getContactTypeIcon(contact.type),
                color: _contactTypeColor(contact.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.primaryPhone ?? 'No phone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.typeDisplayName,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: _contactTypeColor(contact.type)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(contact.balance),
                  style: ClayTypography.tabular(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: contact.balance >= 0
                                ? ClayColors.success
                                : ClayColors.error,
                          )),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: contact.isActive
                          ? ClayColors.success
                          : Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      );

  IconData _getContactTypeIcon(String type) {
    switch (type) {
      case AppConstants.contactCustomer:
        return Icons.person;
      case AppConstants.contactSupplier:
        return Icons.business;
      case AppConstants.contactBoth:
        return Icons.group;
      default:
        return Icons.people;
    }
  }

  void _showContactDetailDialog(BuildContext context, ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text(contact.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClayDetailRow(
                icon: Icons.phone,
                label: 'Phone',
                value: contact.primaryPhone ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.email,
                label: 'Email',
                value: contact.email ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.location_on,
                label: 'Address',
                value: contact.fullAddress,
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.money,
                label: 'Balance',
                value: formatCurrency(contact.balance),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.category,
                label: 'Type',
                value: contact.typeDisplayName,
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.info,
                label: 'VAT Number',
                value: contact.vatNumber ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.numbers,
                label: 'PAN Number',
                value: contact.panNumber ?? 'N/A',
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

/// Add Contact Form
class _AddContactForm extends ConsumerStatefulWidget {
  const _AddContactForm();

  @override
  ConsumerState<_AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends ConsumerState<_AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _mobile = '';
  String _email = '';
  String _address = '';
  String _city = '';
  String _district = '';
  String _vatNumber = '';
  String _panNumber = '';
  String _type = AppConstants.contactCustomer;
  double? _openingBalance;
  bool _isActive = true;
  String _remarks = '';

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClayInputWithLabel(
                label: 'Full Name *',
                hintText: 'Enter contact name',
                value: _name,
                onChanged: (value) => _name = value,
                validator: (value) =>
                    value?.isEmpty ?? false ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'Phone',
                      hintText: 'Phone number',
                      value: _phone,
                      onChanged: (value) => _phone = value,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'Mobile',
                      hintText: 'Mobile number',
                      value: _mobile,
                      onChanged: (value) => _mobile = value,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClayInputWithLabel(
                label: 'Email',
                hintText: 'Email address',
                value: _email,
                onChanged: (value) => _email = value,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              ClayInputWithLabel(
                label: 'Address',
                hintText: 'Street address',
                value: _address,
                onChanged: (value) => _address = value,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'City',
                      hintText: 'City',
                      value: _city,
                      onChanged: (value) => _city = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'District',
                      hintText: 'District',
                      value: _district,
                      onChanged: (value) => _district = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'VAT Number',
                      hintText: 'VAT registration number',
                      value: _vatNumber,
                      onChanged: (value) => _vatNumber = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'PAN Number',
                      hintText: 'PAN number',
                      value: _panNumber,
                      onChanged: (value) => _panNumber = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClayInputWithLabel(
                label: 'Opening Balance',
                hintText: 'Opening balance',
                value: _openingBalance?.toString() ?? '',
                onChanged: (value) => _openingBalance = double.tryParse(value),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ClayDropdownInput<String>(
                label: 'Contact Type',
                value: _type,
                items: const [
                  DropdownMenuItem(
                      value: AppConstants.contactCustomer,
                      child: Text('Customer')),
                  DropdownMenuItem(
                      value: AppConstants.contactSupplier,
                      child: Text('Supplier')),
                  DropdownMenuItem(
                      value: AppConstants.contactBoth, child: Text('Both')),
                ],
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: 16),
              ClaySwitchInput(
                label: 'Active',
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 16),
              ClayInputWithLabel(
                label: 'Remarks',
                hintText: 'Additional notes',
                value: _remarks,
                onChanged: (value) => _remarks = value,
                maxLines: 3,
              ),
            ],
          ),
        ),
      );
}

/// Provider for contacts
final contactsProvider = FutureProvider<List<ContactModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.contactsBox.values.toList();
});
