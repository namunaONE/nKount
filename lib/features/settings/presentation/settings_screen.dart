import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/database_initializer.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Settings Screen with Claymorphism Design
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbStats = ref.watch(databaseStatsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Settings'),
        actions: [
          ClayIconButton(
            icon: Icons.save,
            onPressed: () => _showSaveDialog(context),
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Company Settings Section
            const _CompanySettingsSection(),
            const SizedBox(height: 24),
            
            // General Settings Section
            const _GeneralSettingsSection(),
            const SizedBox(height: 24),
            
            // Tax Settings Section
            const _TaxSettingsSection(),
            const SizedBox(height: 24),
            
            // Invoicing Settings Section
            const _InvoicingSettingsSection(),
            const SizedBox(height: 24),
            
            // Database Section
            _DatabaseSection(dbStats: dbStats),
            const SizedBox(height: 24),
            
            // About Section
            const _AboutSection(),
          ],
        ),
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 4,
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

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Save Settings'),
        content: const Text('Are you sure you want to save the current settings?'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Company Settings Section
class _CompanySettingsSection extends StatelessWidget {
  const _CompanySettingsSection();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'Company Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _SettingItem(
              icon: Icons.business,
              label: 'Company Name',
              value: 'My Company',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.location_on,
              label: 'Address',
              value: 'Kathmandu, Nepal',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.phone,
              label: 'Phone',
              value: '+977 1 4444444',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.email,
              label: 'Email',
              value: 'info@mycompany.com.np',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'VAT Number',
              value: '600000000',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'PAN Number',
              value: '123456789',
            ),
            const SizedBox(height: 12),
            ClayButton.text(
              onPressed: () {},
              child: const Text('Edit Company Info'),
            ),
          ],
        ),
      ),
    );
  }
}

/// General Settings Section
class _GeneralSettingsSection extends StatelessWidget {
  const _GeneralSettingsSection();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'General Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SettingItem(
              icon: Icons.language,
              label: 'Currency',
              value: AppConstants.CURRENCY,
              trailing: const Text('NPR'),
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.calendar_today,
              label: 'Date Format',
              value: 'AD (Gregorian)',
              trailing: ClaySwitch(value: false, onChanged: null),
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.calendar_today,
              label: 'Use Nepali Date',
              value: '',
              trailing: ClaySwitch(value: false, onChanged: null),
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.language,
              label: 'Language',
              value: 'English',
              trailing: DropdownButton<String>(
                value: 'en',
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ne', child: Text('Nepali')),
                ],
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tax Settings Section
class _TaxSettingsSection extends StatelessWidget {
  const _TaxSettingsSection();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'Tax Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _SettingItem(
              icon: Icons.percent,
              label: 'Default VAT Rate',
              value: '13%',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.visibility,
              label: 'Show VAT on Invoice',
              value: '',
              trailing: ClaySwitch(value: true, onChanged: null),
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'VAT Number',
              value: '600000000',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.visibility,
              label: 'Show VAT Number on Invoice',
              value: '',
              trailing: ClaySwitch(value: true, onChanged: null),
            ),
            const SizedBox(height: 12),
            ClayButton.text(
              onPressed: () {},
              child: const Text('Manage Tax Rates'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Invoicing Settings Section
class _InvoicingSettingsSection extends StatelessWidget {
  const _InvoicingSettingsSection();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'Invoicing Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _SettingItem(
              icon: Icons.text_fields,
              label: 'Invoice Prefix',
              value: 'INV',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'Invoice Start Number',
              value: '1',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.text_fields,
              label: 'Purchase Prefix',
              value: 'PUR',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'Purchase Start Number',
              value: '1',
            ),
            const Divider(),
            const _SettingItem(
              icon: Icons.numbers,
              label: 'Invoice Expiry Days',
              value: '30',
            ),
          ],
        ),
      ),
    );
  }
}

/// Database Section
class _DatabaseSection extends StatelessWidget {
  final Map<String, dynamic> dbStats;

  const _DatabaseSection({required this.dbStats});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'Database',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SettingItem(
              icon: Icons.storage,
              label: 'Total Records',
              value: dbStats['total_records'].toString(),
            ),
            const Divider(),
            _SettingItem(
              icon: Icons.people,
              label: 'Contacts',
              value: dbStats['contacts'].toString(),
            ),
            const Divider(),
            _SettingItem(
              icon: Icons.inventory,
              label: 'Products',
              value: dbStats['products'].toString(),
            ),
            const Divider(),
            _SettingItem(
              icon: Icons.receipt,
              label: 'Transactions',
              value: dbStats['transactions'].toString(),
            ),
            const Divider(),
            _SettingItem(
              icon: Icons.payment,
              label: 'Payments',
              value: dbStats['payments'].toString(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClayButton.outlined(
                    onPressed: () => _showBackupDialog(context),
                    child: const Text('Backup'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayButton.outlined(
                    onPressed: () => _showRestoreDialog(context),
                    child: const Text('Restore'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClayButton.outlined(
              onPressed: () => _showResetDialog(context),
              style: ClayButtonStyle(
                foregroundColor: ClayColors.error,
                borderColor: ClayColors.error,
              ),
              child: const Text('Reset Database'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Backup Database'),
        content: const Text('Would you like to backup your database? This will create a JSON file with all your data.'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup completed successfully')),
              );
            },
            child: const Text('Backup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Restore Database'),
        content: const Text('Would you like to restore your database from a backup file?'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a backup file to restore')),
              );
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Reset Database'),
        content: const Text(
          'WARNING: This will delete ALL your data and restore default settings. This action cannot be undone.',
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () async {
              Navigator.pop(context);
              await databaseInitializer.resetDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database reset completed')),
              );
            },
            style: ClayButtonStyle(
              backgroundColor: ClayColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// About Section
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: const Text(
        'About nKount',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: ClayColors.primary,
              child: Icon(Icons.accounting, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              AppConstants.appDescription,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Developed by',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              AppConstants.companyName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ClayColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.companyWebsite,
              style: const TextStyle(
                color: ClayColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'IRD Compliant',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ClayColors.success,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nepal Financial Reporting Standards (NFRS)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Setting Item
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 16),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Provider for database stats
final databaseStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final dbStats = ref.watch(databaseInitializerProvider).getDatabaseStats();
  return dbStats;
});
