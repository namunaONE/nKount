import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_initializer.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/utils/web_file.dart';
import '../../../packages/design-system/design_system.dart';

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
      bottomNavigationBar: mainNavBar(context, 5),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Save Settings'),
        content:
            const Text('Are you sure you want to save the current settings?'),
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
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('Company Settings'),
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

/// General Settings Section
class _GeneralSettingsSection extends StatelessWidget {
  const _GeneralSettingsSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('General Settings'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const _SettingItem(
                icon: Icons.language,
                label: 'Currency',
                value: AppConstants.currency,
                trailing: Text('NPR'),
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
              _SettingItem(
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

/// Tax Settings Section
class _TaxSettingsSection extends StatelessWidget {
  const _TaxSettingsSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('Tax Settings'),
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

/// Invoicing Settings Section
class _InvoicingSettingsSection extends StatelessWidget {
  const _InvoicingSettingsSection();

  @override
  Widget build(BuildContext context) => const ClayCard(
        title: ClaySectionTitle('Invoicing Settings'),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _SettingItem(
                icon: Icons.text_fields,
                label: 'Invoice Prefix',
                value: 'INV',
              ),
              Divider(),
              _SettingItem(
                icon: Icons.numbers,
                label: 'Invoice Start Number',
                value: '1',
              ),
              Divider(),
              _SettingItem(
                icon: Icons.text_fields,
                label: 'Purchase Prefix',
                value: 'PUR',
              ),
              Divider(),
              _SettingItem(
                icon: Icons.numbers,
                label: 'Purchase Start Number',
                value: '1',
              ),
              Divider(),
              _SettingItem(
                icon: Icons.numbers,
                label: 'Invoice Expiry Days',
                value: '30',
              ),
            ],
          ),
        ),
      );
}

/// Database Section
class _DatabaseSection extends ConsumerWidget {
  const _DatabaseSection({required this.dbStats});
  final Map<String, dynamic> dbStats;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClayCard(
        title: const ClaySectionTitle('Database'),
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
                      onPressed: () => _showRestoreDialog(context, ref),
                      child: const Text('Restore'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClayButton.outlined(
                onPressed: () => _showResetDialog(context),
                style: const ClayButtonStyle(
                  foregroundColor: ClayColors.error,
                  borderColor: ClayColors.error,
                ),
                child: const Text('Reset Database'),
              ),
            ],
          ),
        ),
      );

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Backup Database'),
        content: const Text(
            'Download a JSON file with all your data? Keep it somewhere safe — it restores everything.'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(context);
              try {
                final data = await hiveService.exportAllData();
                final now = DateTime.now();
                final stamp =
                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                await downloadJsonFile(
                    'nkount-backup-$stamp.json', jsonEncode(data));
                messenger.showSnackBar(
                  const SnackBar(
                      content: Text('Backup downloaded successfully')),
                );
              } on UnsupportedError catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('$e')));
              } on Object catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Backup failed: $e')),
                );
              }
            },
            child: const Text('Backup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Restore Database'),
        content: const Text(
            'Pick a backup file. This REPLACES all current data — back up first if unsure.'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(context);
              try {
                final text = await pickJsonFile();
                if (text == null) return;
                final decoded = jsonDecode(text);
                if (decoded is! Map<String, dynamic> ||
                    !decoded.containsKey('contacts') ||
                    !decoded.containsKey('companies')) {
                  throw const FormatException('Not an nKount backup file');
                }
                await hiveService.importData(decoded);
                ref.invalidate(databaseStatsProvider);
                messenger.showSnackBar(
                  const SnackBar(
                      content: Text('Restore completed successfully')),
                );
              } on UnsupportedError catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('$e')));
              } on FormatException catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Restore failed: $e')),
                );
              } on Object catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Restore failed: $e')),
                );
              }
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
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database reset completed')),
              );
            },
            style: ClayButtonStyle(
              backgroundColor: ClayColors.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
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
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ClayCard(
      title: const ClaySectionTitle('About nKount'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: ClayColors.primary,
              child: Icon(ClayIcons.profit, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: text.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'by ${AppConstants.companyName}',
              style: text.titleSmall?.copyWith(color: ClayColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              'Version ${AppConstants.appVersion}',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appDescription,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Developed by',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.companyName,
              style: text.titleSmall?.copyWith(color: ClayColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.companyWebsite,
              style: text.bodyMedium?.copyWith(
                color: ClayColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.maintainedBy,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.maintainerTeam,
              style: text.titleSmall?.copyWith(color: ClayColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'IRD Compliant',
              style: text.titleSmall?.copyWith(color: ClayColors.success),
            ),
            const SizedBox(height: 4),
            Text(
              'Nepal Financial Reporting Standards (NFRS)',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Setting Item
class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: ClayIconSize.dense, color: scheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              value,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
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

/// Provider for database stats (sync snapshot from local boxes)
final databaseStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final stats = hiveService.getBoxStats();
  return {
    ...stats,
    'total_records': stats.values.fold(0, (sum, count) => sum + count),
    'is_initialized': databaseInitializer.isInitialized,
  };
});
