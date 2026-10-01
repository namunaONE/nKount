import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/providers/storage_providers.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';

/// Contacts Screen for managing customers and suppliers
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String _searchQuery = '';
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);
    final contactRepo = ref.watch(contactRepositoryProvider);
    
    final filteredContacts = _filterContacts(contacts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
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
                hintText: 'Search contacts...',
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
                    'Total Contacts',
                    contacts.length.toString(),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Customers',
                    contactRepo.getContactsByType(AppConstants.CONTACT_CUSTOMER).length.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Suppliers',
                    contactRepo.getContactsByType(AppConstants.CONTACT_SUPPLIER).length.toString(),
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Contacts List
          Expanded(
            child: filteredContacts.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.contacts, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No contacts found',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first contact to get started',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredContacts.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      return _buildContactItem(contact);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddContactDialog(),
      ),
    );
  }

  /// Filter contacts based on search and type
  List<ContactModel> _filterContacts(List<ContactModel> contacts) {
    var filtered = contacts;
    
    if (_selectedType != 'all') {
      filtered = filtered.where((c) => c.type == _selectedType).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((c) => 
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.phone?.contains(_searchQuery) ?? false) ||
            (c.mobile?.contains(_searchQuery) ?? false) ||
            (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
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
                fontSize: 18,
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

  /// Build contact item
  Widget _buildContactItem(ContactModel contact) {
    final color = contact.type == AppConstants.CONTACT_CUSTOMER 
        ? Colors.green 
        : Colors.orange;

    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.primaryPhone ?? 'No phone',
              style: const TextStyle(fontSize: 12),
            ),
            if (contact.balance != 0)
              Text(
                'Balance: ${AppTheme.formatCurrency(contact.balance)}',
                style: TextStyle(
                  fontSize: 11,
                  color: contact.balance > 0 ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showContactActions(contact),
        ),
        onTap: () => _showContactDetails(contact),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Contacts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Contacts'),
              value: 'all',
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Customers'),
              value: AppConstants.CONTACT_CUSTOMER,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Suppliers'),
              value: AppConstants.CONTACT_SUPPLIER,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value!);
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

  /// Show add contact dialog
  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final mobileController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    
    String selectedType = AppConstants.CONTACT_CUSTOMER;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter contact name',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Office phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                  hintText: 'Mobile phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email address',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Street address',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_CUSTOMER,
                    child: const Text('Customer'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_SUPPLIER,
                    child: const Text('Supplier'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_BOTH,
                    child: const Text('Both'),
                  ),
                ],
                onChanged: (value) => selectedType = value!,
                decoration: const InputDecoration(
                  labelText: 'Contact Type',
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
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }
              
              final contact = ContactModel.create(
                name: nameController.text.trim(),
                phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                mobile: mobileController.text.trim().isEmpty ? null : mobileController.text.trim(),
                email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                type: selectedType,
              );
              
              await ref.read(contactRepositoryProvider).saveContact(contact);
              await ref.read(contactsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact added successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show contact details
  void _showContactDetails(ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', contact.typeDisplayName),
              _buildDetailRow('Phone', contact.phone ?? 'N/A'),
              _buildDetailRow('Mobile', contact.mobile ?? 'N/A'),
              _buildDetailRow('Email', contact.email ?? 'N/A'),
              _buildDetailRow('Address', contact.fullAddress),
              _buildDetailRow('VAT Number', contact.vatNumber ?? 'N/A'),
              _buildDetailRow('PAN Number', contact.panNumber ?? 'N/A'),
              _buildDetailRow('Total Purchases', AppTheme.formatCurrency(contact.totalPurchases)),
              _buildDetailRow('Total Sales', AppTheme.formatCurrency(contact.totalSales)),
              _buildDetailRow('Balance', AppTheme.formatCurrency(contact.balance)),
              _buildDetailRow('Status', contact.isActive ? 'Active' : 'Inactive'),
              if (contact.remarks != null && contact.remarks!.isNotEmpty)
                _buildDetailRow('Remarks', contact.remarks!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditContactDialog(contact);
            },
            child: const Text('Edit'),
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
            width: 120,
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

  /// Show contact actions
  void _showContactActions(ContactModel contact) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditContactDialog(contact);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                _duplicateContact(contact);
              },
            ),
            ListTile(
              leading: Icon(
                contact.isActive ? Icons.block : Icons.check_circle,
                color: contact.isActive ? Colors.red : Colors.green,
              ),
              title: Text(contact.isActive ? 'Deactivate' : 'Activate'),
              onTap: () {
                Navigator.pop(context);
                _toggleContactStatus(contact);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(contact);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show edit contact dialog
  void _showEditContactDialog(ContactModel contact) {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phone ?? '');
    final mobileController = TextEditingController(text: contact.mobile ?? '');
    final emailController = TextEditingController(text: contact.email ?? '');
    final addressController = TextEditingController(text: contact.address ?? '');
    final remarksController = TextEditingController(text: contact.remarks ?? '');
    
    String selectedType = contact.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${contact.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_CUSTOMER,
                    child: const Text('Customer'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_SUPPLIER,
                    child: const Text('Supplier'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.CONTACT_BOTH,
                    child: const Text('Both'),
                  ),
                ],
                onChanged: (value) => selectedType = value!,
                decoration: const InputDecoration(
                  labelText: 'Contact Type',
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
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }
              
              final updatedContact = contact.copyWith(
                name: nameController.text.trim(),
                phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                mobile: mobileController.text.trim().isEmpty ? null : mobileController.text.trim(),
                email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                remarks: remarksController.text.trim().isEmpty ? null : remarksController.text.trim(),
                type: selectedType,
                updatedAt: DateTime.now(),
              );
              
              await ref.read(contactRepositoryProvider).updateContact(updatedContact);
              await ref.read(contactsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  /// Duplicate contact
  void _duplicateContact(ContactModel contact) {
    final duplicated = contact.copyWith(
      id: '',
      name: '${contact.name} (Copy)',
      phone: contact.phone,
      mobile: contact.mobile,
      email: contact.email,
      address: contact.address,
      openingBalance: 0,
      totalPurchases: 0,
      totalSales: 0,
      totalPayments: 0,
      totalReceipts: 0,
      balance: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    ref.read(contactRepositoryProvider).saveContact(duplicated);
    ref.read(contactsProvider.notifier).refresh();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact duplicated successfully')),
    );
  }

  /// Toggle contact status
  void _toggleContactStatus(ContactModel contact) {
    final updatedContact = contact.copyWith(
      isActive: !contact.isActive,
      updatedAt: DateTime.now(),
    );
    
    ref.read(contactRepositoryProvider).updateContact(updatedContact);
    ref.read(contactsProvider.notifier).refresh();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact ${updatedContact.isActive ? 'activated' : 'deactivated'} successfully'),
      ),
    );
  }

  /// Show delete confirmation
  void _showDeleteConfirmation(ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete "${contact.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(contactRepositoryProvider).deleteContact(contact.id);
              await ref.read(contactsProvider.notifier).refresh();
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
