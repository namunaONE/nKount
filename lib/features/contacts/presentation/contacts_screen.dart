import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/repositories/contact_repository.dart';
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
  String? _selectedId;
  List<ContactModel> _visibleContacts = [];

  /// Selected contact for the wide-window detail pane: the visible contact
  /// matching [_selectedId], else the first visible contact, else null.
  /// [_visibleContacts] is refreshed from `sorted` on every build, so a
  /// deleted selection naturally falls back without explicit clearing.
  ContactModel? get _selected {
    if (_visibleContacts.isEmpty) return null;
    for (final c in _visibleContacts) {
      if (c.id == _selectedId) return c;
    }
    return _visibleContacts.first;
  }

  /// Wide windows select into the detail pane; narrow windows keep the dialog.
  void _openOrSelect(BuildContext context, ContactModel contact) {
    if (MediaQuery.sizeOf(context).width >= ClayBreakpoints.twoColumnMin) {
      setState(() => _selectedId = contact.id);
    } else {
      _showContactDetailDialog(context, contact);
    }
  }

  /// Detail pane reusing the dialog's rows and callbacks (Edit + Delete).
  Widget _buildDetailPane(ContactModel? contact) {
    if (contact == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ClayCard(
          child: ClayEmptyState(
            title: 'Select a contact',
            icon: ClayIcons.contacts,
          ),
        ),
      );
    }
    final c = contact;
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ClayCard(
          title: ClaySectionTitle(c.name),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._contactDetailRows(c),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClayButton(
                        onPressed: () => _AddContactForm.showEdit(context, c),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClayButton.text(
                        onPressed: () => _confirmDeleteContact(context, ref, c),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

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
        loading: () => const ClaySkeletonList(),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (contactList) {
          final filtered = _filterContacts(contactList);
          final sorted = _sortContacts(filtered);
          _visibleContacts = sorted;
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
                        onPressed: () => _AddContactForm.show(context),
                        child: const Text('Add Contact'),
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(contactsProvider);
                    await ref.read(contactsProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) => ClayEntrance(
                      delay: ClayMotion.stagger(index),
                      child: _ContactItem(contact: sorted[index]),
                    ),
                  ),
                );
              }
              if (sorted.isEmpty) {
                return Center(
                  child: ClayEmptyState(
                    icon: Icons.people_alt_outlined,
                    title: 'No Contacts Found',
                    subtitle: 'Add your first contact to get started',
                    action: ClayButton(
                      onPressed: () => _AddContactForm.show(context),
                      child: const Text('Add Contact'),
                    ),
                  ),
                );
              }
              final tableCard = ClayTableCard(
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
                  onView: (c) => _openOrSelect(context, c),
                  onDelete: (c) => _confirmDeleteContact(context, ref, c),
                ),
              );
              return LayoutBuilder(
                builder: (context, wide) {
                  if (wide.maxWidth >= ClayBreakpoints.twoColumnMin) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: tableCard),
                        const SizedBox(width: 16),
                        Expanded(flex: 1, child: _buildDetailPane(_selected)),
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

  void _showAddContactDialog(BuildContext context) =>
      _AddContactForm.show(context);
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

/// Shared detail rows for the contact dialog and the wide-window detail pane.
List<Widget> _contactDetailRows(ContactModel contact) => [
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
    ];

void _showContactDetailDialog(BuildContext context, ContactModel contact) {
  showDialog(
    context: context,
    builder: (context) => ClayDialog(
      title: Text(contact.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _contactDetailRows(contact),
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
            children: _contactDetailRows(contact),
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ClayButton(
            onPressed: () {
              Navigator.pop(context);
              _AddContactForm.showEdit(context, contact);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

/// Add/Edit Contact Form: pre-fills from [existing] when editing and
/// preserves identity plus running balances on save.
class _AddContactForm extends ConsumerStatefulWidget {
  const _AddContactForm({super.key, this.existing});
  final ContactModel? existing;

  /// Shows the add-contact dialog. The form owns validation + saving and
  /// reports success; this pops the dialog and confirms on the caller's
  /// context (the screen underneath, which outlives the dialog).
  static Future<void> show(BuildContext context) {
    final key = GlobalKey<_AddContactFormState>();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(context);
        return ClayFormDialog(
          title: const Text('Add New Contact'),
          onSave: () async {
            if (await key.currentState?.save() ?? false) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Contact saved successfully')),
              );
            }
          },
          child: _AddContactForm(key: key),
        );
      },
    );
  }

  /// Shows the edit-contact dialog for [contact].
  static Future<void> showEdit(BuildContext context, ContactModel contact) {
    final key = GlobalKey<_AddContactFormState>();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(context);
        return ClayFormDialog(
          title: const Text('Edit Contact'),
          onSave: () async {
            if (await key.currentState?.save() ?? false) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Contact updated successfully')),
              );
            }
          },
          child: _AddContactForm(key: key, existing: contact),
        );
      },
    );
  }

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
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing == null) return;
    _name = existing.name;
    _phone = existing.phone ?? '';
    _mobile = existing.mobile ?? '';
    _email = existing.email ?? '';
    _address = existing.address ?? '';
    _city = existing.city ?? '';
    _district = existing.district ?? '';
    _vatNumber = existing.vatNumber ?? '';
    _panNumber = existing.panNumber ?? '';
    _type = existing.type;
    _openingBalance = existing.openingBalance;
    _isActive = existing.isActive;
    _remarks = existing.remarks ?? '';
  }

  Future<bool> save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    final hive = ref.read(hiveServiceProvider);
    final existing = widget.existing;
    if (existing == null) {
      await ContactRepository(hive.contactsBox).saveContact(
        ContactModel.create(
          name: _name.trim(),
          phone: _phone.trim().isEmpty ? null : _phone.trim(),
          mobile: _mobile.trim().isEmpty ? null : _mobile.trim(),
          email: _email.trim().isEmpty ? null : _email.trim(),
          address: _address.trim().isEmpty ? null : _address.trim(),
          city: _city.trim().isEmpty ? null : _city.trim(),
          district: _district.trim().isEmpty ? null : _district.trim(),
          vatNumber: _vatNumber.trim().isEmpty ? null : _vatNumber.trim(),
          panNumber: _panNumber.trim().isEmpty ? null : _panNumber.trim(),
          type: _type,
          openingBalance: _openingBalance,
          isActive: _isActive,
          remarks: _remarks.trim().isEmpty ? null : _remarks.trim(),
        ),
      );
    } else {
      // Identity and running balances carry over; only the edited
      // profile fields change.
      await ContactRepository(hive.contactsBox).updateContact(
        existing.copyWith(
          name: _name.trim(),
          phone: _phone.trim().isEmpty ? null : _phone.trim(),
          mobile: _mobile.trim().isEmpty ? null : _mobile.trim(),
          email: _email.trim().isEmpty ? null : _email.trim(),
          address: _address.trim().isEmpty ? null : _address.trim(),
          city: _city.trim().isEmpty ? null : _city.trim(),
          district: _district.trim().isEmpty ? null : _district.trim(),
          vatNumber: _vatNumber.trim().isEmpty ? null : _vatNumber.trim(),
          panNumber: _panNumber.trim().isEmpty ? null : _panNumber.trim(),
          type: _type,
          openingBalance: _openingBalance,
          isActive: _isActive,
          remarks: _remarks.trim().isEmpty ? null : _remarks.trim(),
        ),
      );
    }
    ref.invalidate(contactsProvider);
    return true;
  }

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
