import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Contacts Screen with Claymorphism Design
class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Contacts'),
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
          if (contactList.isEmpty) {
            return const _EmptyContactsState();
          }
          return _ContactsList(contacts: contactList);
        },
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 1,
        items: const [
          ClayBottomNavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/'),
          ClayBottomNavItem(icon: Icons.people, label: 'Contacts', route: '/contacts'),
          ClayBottomNavItem(icon: Icons.inventory, label: 'Products', route: '/products'),
          ClayBottomNavItem(icon: Icons.receipt, label: 'Transactions', route: '/transactions'),
          ClayBottomNavItem(icon: Icons.payment, label: 'Payments', route: '/payments'),
        ],
        onTap: (index) {
          final routes = ['/', '/contacts', '/products', '/transactions', '/payments'];
          if (index < routes.length) {
            context.go(routes[index]);
          }
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Contacts'),
        content: const ClaySearchInput(hintText: 'Search by name, phone, or email'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Filter Contacts'),
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
              title: const Text('Customers'),
              value: AppConstants.CONTACT_CUSTOMER,
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Suppliers'),
              value: AppConstants.CONTACT_SUPPLIER,
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

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Contact'),
        child: const _AddContactForm(),
      ),
    );
  }
}

/// Empty Contacts State
class _EmptyContactsState extends StatelessWidget {
  const _EmptyContactsState();

  @override
  Widget build(BuildContext context) {
    return Center(
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
}

/// Contacts List
class _ContactsList extends ConsumerWidget {
  final List<ContactModel> contacts;

  const _ContactsList({required this.contacts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return _ContactItem(contact: contact);
      },
    );
  }
}

/// Contact Item
class _ContactItem extends StatelessWidget {
  final ContactModel contact;

  const _ContactItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showContactDetailDialog(context, contact),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getContactTypeColor(contact.type).withOpacity(0.1),
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
                  color: contact.balance >= 0 ? ClayColors.success : ClayColors.error,
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
  }

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
  final IconData icon;
  final String label;
  final String value;

  const _ContactDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Full Name *',
              hintText: 'Enter contact name',
              value: _name,
              onChanged: (value) => _name = value,
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
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
                DropdownMenuItem(value: AppConstants.CONTACT_CUSTOMER, child: Text('Customer')),
                DropdownMenuItem(value: AppConstants.CONTACT_SUPPLIER, child: Text('Supplier')),
                DropdownMenuItem(value: AppConstants.CONTACT_BOTH, child: Text('Both')),
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
}

/// Provider for contacts
final contactsProvider = FutureProvider<List<ContactModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.contactsBox.values.toList();
});
