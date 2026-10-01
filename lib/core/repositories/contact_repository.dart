import 'package:hive/hive.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/services/local_storage_service.dart';

/// Repository for managing contacts
class ContactRepository {
  final Box<ContactModel> _contactsBox;

  ContactRepository(this._contactsBox);

  /// Get all contacts
  List<ContactModel> getAllContacts() {
    return _contactsBox.values.toList();
  }

  /// Get contacts by type
  List<ContactModel> getContactsByType(String type) {
    return _contactsBox.values
        .where((contact) => contact.type == type)
        .toList();
  }

  /// Get contact by ID
  ContactModel? getContactById(String id) {
    return _contactsBox.get(id);
  }

  /// Get contacts by name search
  List<ContactModel> searchContacts(String query) {
    final lowerQuery = query.toLowerCase();
    return _contactsBox.values
        .where((contact) => 
          contact.name.toLowerCase().contains(lowerQuery) ||
          (contact.phone?.contains(query) ?? false) ||
          (contact.mobile?.contains(query) ?? false) ||
          (contact.vatNumber?.contains(query) ?? false)
        )
        .toList();
  }

  /// Save contact
  Future<ContactModel> saveContact(ContactModel contact) async {
    await _contactsBox.put(contact.id, contact);
    return contact;
  }

  /// Update contact
  Future<ContactModel> updateContact(ContactModel contact) async {
    await _contactsBox.put(contact.id, contact);
    return contact;
  }

  /// Delete contact
  Future<bool> deleteContact(String id) async {
    final contact = _contactsBox.get(id);
    if (contact != null) {
      await _contactsBox.delete(id);
      return true;
    }
    return false;
  }

  /// Delete all contacts
  Future<void> deleteAllContacts() async {
    await _contactsBox.clear();
  }

  /// Get contacts count
  int getContactsCount() {
    return _contactsBox.length;
  }

  /// Get customers with outstanding balance
  List<ContactModel> getCustomersWithOutstanding() {
    return _contactsBox.values
        .where((contact) => 
          contact.type == AppConstants.CONTACT_CUSTOMER &&
          contact.balance > 0
        )
        .toList();
  }

  /// Get suppliers with outstanding balance
  List<ContactModel> getSuppliersWithOutstanding() {
    return _contactsBox.values
        .where((contact) => 
          contact.type == AppConstants.CONTACT_SUPPLIER &&
          contact.balance < 0
        )
        .toList();
  }

  /// Get total receivables
  double getTotalReceivables() {
    return _contactsBox.values
        .where((contact) => contact.balance > 0)
        .fold(0.0, (sum, contact) => sum + contact.balance);
  }

  /// Get total payables
  double getTotalPayables() {
    return _contactsBox.values
        .where((contact) => contact.balance < 0)
        .fold(0.0, (sum, contact) => sum + contact.balance.abs());
  }

  /// Export contacts to list
  List<Map<String, dynamic>> exportContacts() {
    return _contactsBox.values
        .map((contact) => contact.toJson())
        .toList();
  }

  /// Import contacts from list
  Future<int> importContacts(List<Map<String, dynamic>> contactsData) async {
    int count = 0;
    for (final data in contactsData) {
      try {
        final contact = ContactModel.fromJson(data);
        await _contactsBox.put(contact.id, contact);
        count++;
      } catch (e) {
        // Skip invalid contacts
        continue;
      }
    }
    return count;
  }
}
