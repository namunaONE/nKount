import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/contact_model.dart';
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
                if (sorted.isEmpty) return const _EmptyContactsState();
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) =>
                      _ContactItem(contact: sorted[index]),
                );
              }
              if (sorted.isEmpty) return const _EmptyContactsState();
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
                            Text(
                              'Contacts (${sorted.length})',
                              style: const TextStyle(
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
                              'All contacts',
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
                                label: const Text('Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 0;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Phone',
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
                                label: const Text('Balance',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                numeric: true,
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 3;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 4;
                                  _sortAscending = asc;
                                }),
                              ),
                              const DataColumn(
                                label: Text('Actions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                            source: _ContactsDataSource(
                              contacts: sorted,
                              onView: (c) =>
                                  _showContactDetailDialog(context, c),
                              onDelete: (c) =>
                                  _confirmDeleteContact(context, ref, c),
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
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Contacts'),
        content: ClaySearchInput(
          hintText: 'Search by name, phone, or email',
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
                  value: AppConstants.CONTACT_CUSTOMER,
                  child: Text('Customers')),
              DropdownMenuItem(
                  value: AppConstants.CONTACT_SUPPLIER,
                  child: Text('Suppliers')),
              DropdownMenuItem(
                  value: AppConstants.CONTACT_BOTH, child: Text('Both')),
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
        DataCell(
            Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(c.primaryPhone ?? 'â€”')),
        DataCell(
          Chip(
            label:
                Text(c.typeDisplayName, style: const TextStyle(fontSize: 11)),
            backgroundColor: _contactTypeColor(c.type).withValues(alpha: 0.1),
            side: BorderSide(color: _contactTypeColor(c.type), width: 1),
            visualDensity: VisualDensity.compact,
          ),
        ),
        DataCell(Text(
          'NPR ${c.balance.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: c.balance >= 0 ? ClayColors.success : ClayColors.error,
          ),
        )),
        DataCell(Text(
          c.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 12,
            color: c.isActive ? ClayColors.success : Colors.grey,
          ),
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, size: 18),
              onPressed: () => onView(c),
              tooltip: 'View',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              color: Colors.red,
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
    case AppConstants.CONTACT_CUSTOMER:
      return ClayColors.primary;
    case AppConstants.CONTACT_SUPPLIER:
      return ClayColors.secondary;
    case AppConstants.CONTACT_BOTH:
      return ClayColors.tertiary;
    default:
      return Colors.grey;
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
            _ContactDetailRow(
              icon: Icons.phone,
              label: 'Phone',
              value: contact.primaryPhone ?? 'N/A',
            ),
            const Divider(),
            _ContactDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: contact.email ?? 'N/A',
            ),
            const Divider(),
            _ContactDetailRow(
              icon: Icons.location_on,
              label: 'Address',
              value: contact.fullAddress,
            ),
            const Divider(),
            _ContactDetailRow(
              icon: Icons.money,
              label: 'Balance',
              value: 'NPR ${contact.balance.toStringAsFixed(2)}',
            ),
            const Divider(),
            _ContactDetailRow(
              icon: Icons.category,
              label: 'Type',
              value: contact.typeDisplayName,
            ),
            const Divider(),
            _ContactDetailRow(
              icon: Icons.info,
              label: 'VAT Number',
              value: contact.vatNumber ?? 'N/A',
            ),
            const Divider(),
            _ContactDetailRow(
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
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete contact?'),
      content: Text(
          'Delete ${contact.name}? Linked transactions keep their history.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed ?? false) {
    await hiveService.contactsBox.delete(contact.id);
    ref.invalidate(contactsProvider);
  }
}

/// Empty Contacts State
class _EmptyContactsState extends StatelessWidget {
  const _EmptyContactsState();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Contacts Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first contact to get started',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ClayButton(
              onPressed: () => context.push('/contacts'),
              child: const Text('Add Contact'),
            ),
          ],
        ),
      );
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
                color:
                    _getContactTypeColor(contact.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getContactTypeIcon(contact.type),
                color: _getContactTypeColor(contact.type),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.primaryPhone ?? 'No phone',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.typeDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getContactTypeColor(contact.type),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'NPR ${contact.balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: contact.balance >= 0
                        ? ClayColors.success
                        : ClayColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    color: contact.isActive ? ClayColors.success : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Color _getContactTypeColor(String type) {
    switch (type) {
      case AppConstants.CONTACT_CUSTOMER:
        return ClayColors.primary;
      case AppConstants.CONTACT_SUPPLIER:
        return ClayColors.secondary;
      case AppConstants.CONTACT_BOTH:
        return ClayColors.tertiary;
      default:
        return Colors.grey;
    }
  }

  IconData _getContactTypeIcon(String type) {
    switch (type) {
      case AppConstants.CONTACT_CUSTOMER:
        return Icons.person;
      case AppConstants.CONTACT_SUPPLIER:
        return Icons.business;
      case AppConstants.CONTACT_BOTH:
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
              _ContactDetailRow(
                icon: Icons.phone,
                label: 'Phone',
                value: contact.primaryPhone ?? 'N/A',
              ),
              const Divider(),
              _ContactDetailRow(
                icon: Icons.email,
                label: 'Email',
                value: contact.email ?? 'N/A',
              ),
              const Divider(),
              _ContactDetailRow(
                icon: Icons.location_on,
                label: 'Address',
                value: contact.fullAddress,
              ),
              const Divider(),
              _ContactDetailRow(
                icon: Icons.money,
                label: 'Balance',
                value: 'NPR ${contact.balance.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ContactDetailRow(
                icon: Icons.category,
                label: 'Type',
                value: contact.typeDisplayName,
              ),
              const Divider(),
              _ContactDetailRow(
                icon: Icons.info,
                label: 'VAT Number',
                value: contact.vatNumber ?? 'N/A',
              ),
              const Divider(),
              _ContactDetailRow(
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

/// Contact Detail Row
class _ContactDetailRow extends StatelessWidget {
  const _ContactDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
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
  String _type = AppConstants.CONTACT_CUSTOMER;
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
                      value: AppConstants.CONTACT_CUSTOMER,
                      child: Text('Customer')),
                  DropdownMenuItem(
                      value: AppConstants.CONTACT_SUPPLIER,
                      child: Text('Supplier')),
                  DropdownMenuItem(
                      value: AppConstants.CONTACT_BOTH, child: Text('Both')),
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
