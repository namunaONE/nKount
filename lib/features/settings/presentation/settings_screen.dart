import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:nepal_admin_api/nepal_admin_api.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_initializer.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/tax_rate_model.dart';
import '../../../core/utils/tax_rates.dart';
import '../../../core/utils/company_validation.dart';
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

/// Company Settings Section: live values from the registered business
/// profile (reactive via the box listenable, so edits apply instantly).
/// Empty when the database was reset and onboarding hasn't run again.
class _CompanySettingsSection extends StatelessWidget {
  const _CompanySettingsSection();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Box>(
        valueListenable: hiveService.companiesBox.listenable(),
        builder: (context, box, _) {
          final companies = hiveService.companiesBox.values.toList();
          final company = companies.isEmpty ? null : companies.first;
          return ClayCard(
            title: const ClaySectionTitle('Company Settings'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: company == null
                  ? Column(
                      children: [
                        const _SettingItem(
                          icon: Icons.business,
                          label: 'Company Name',
                          value: 'Not registered yet',
                        ),
                        const SizedBox(height: 12),
                        ClayButton.text(
                          onPressed: () {},
                          child: const Text('Edit Company Info'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _SettingItem(
                          icon: Icons.business,
                          label: 'Company Name',
                          value: company.name,
                        ),
                        if (company.ownerName != null &&
                            company.ownerName!.isNotEmpty) ...[
                          const Divider(),
                          _SettingItem(
                            icon: Icons.person,
                            label: 'Owner',
                            value: company.ownerName!,
                          ),
                        ],
                        const Divider(),
                        _SettingItem(
                          icon: Icons.location_on,
                          label: 'Address',
                          value: company.fullAddress.isEmpty
                              ? '—'
                              : company.fullAddress,
                        ),
                        const Divider(),
                        _SettingItem(
                          icon: Icons.map,
                          label: 'Palika · District · Province',
                          value: company.localityLine.isEmpty
                              ? '—'
                              : company.localityLine,
                        ),
                        const Divider(),
                        _SettingItem(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: company.phone ?? '—',
                        ),
                        const Divider(),
                        _SettingItem(
                          icon: Icons.email,
                          label: 'Email',
                          value: company.email ?? '—',
                        ),
                        const Divider(),
                        _SettingItem(
                          icon: Icons.numbers,
                          label: 'VAT Number',
                          value: company.vatNumber ?? '—',
                        ),
                        const Divider(),
                        _SettingItem(
                          icon: Icons.numbers,
                          label: 'PAN Number',
                          value: company.panNumber ?? '—',
                        ),
                        const SizedBox(height: 12),
                        ClayButton.text(
                          onPressed: () =>
                              _EditCompanyForm.show(context, company),
                          child: const Text('Edit Company Info'),
                        ),
                      ],
                    ),
            ),
          );
        },
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

/// Tax Settings Section: live default VAT record, company tax preferences
/// (reactive toggles persisted to the registered profile), and the rate
/// catalog manager. No hardcoded rates or numbers.
class _TaxSettingsSection extends StatelessWidget {
  const _TaxSettingsSection();

  static Future<void> _updateCompany(
    CompanyModel Function(CompanyModel) update,
  ) async {
    final companies = hiveService.companiesBox.values.toList();
    if (companies.isEmpty) return;
    final updated = update(companies.first);
    await hiveService.companiesBox.put(updated.id, updated);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Box>(
        valueListenable: hiveService.companiesBox.listenable(),
        builder: (context, _, __) => ValueListenableBuilder<Box>(
          valueListenable: hiveService.taxRatesBox.listenable(),
          builder: (context, _, __) {
            final companies = hiveService.companiesBox.values.toList();
            final company = companies.isEmpty ? null : companies.first;
            return ClayCard(
              title: const ClaySectionTitle('Tax Settings'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SettingItem(
                      icon: Icons.percent,
                      label: 'Default VAT Rate',
                      value: pct(defaultVatRate(hiveService.taxRatesBox)),
                    ),
                    const Divider(),
                    _SettingItem(
                      icon: Icons.visibility,
                      label: 'Show VAT on Invoice',
                      value: '',
                      trailing: ClaySwitch(
                        value: company?.showTaxOnInvoice ?? true,
                        onChanged: company == null
                            ? null
                            : (v) async => _updateCompany(
                                  (c) => c.copyWith(showTaxOnInvoice: v),
                                ),
                      ),
                    ),
                    const Divider(),
                    _SettingItem(
                      icon: Icons.numbers,
                      label: 'VAT Number',
                      value: company?.vatNumber ?? '—',
                    ),
                    const Divider(),
                    _SettingItem(
                      icon: Icons.visibility,
                      label: 'Show VAT Number on Invoice',
                      value: '',
                      trailing: ClaySwitch(
                        value: company?.showVatNumber ?? true,
                        onChanged: company == null
                            ? null
                            : (v) async => _updateCompany(
                                  (c) => c.copyWith(showVatNumber: v),
                                ),
                      ),
                    ),
                    const Divider(),
                    _SettingItem(
                      icon: Icons.verified,
                      label: 'IRD Registered',
                      value: '',
                      trailing: ClaySwitch(
                        value: company?.isIRDRegistered ?? false,
                        onChanged: company == null
                            ? null
                            : (v) async => _updateCompany(
                                  (c) => c.copyWith(isIRDRegistered: v),
                                ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClayButton.text(
                      onPressed: () => _showManageTaxRates(context),
                      child: const Text('Manage Tax Rates'),
                    ),
                  ],
                ),
              ),
            );
          },
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
            CircleAvatar(
              radius: 40,
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                ClayIcons.profit,
                size: 40,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: text.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'by ${AppConstants.companyName}',
              style: text.titleSmall?.copyWith(color: scheme.primary),
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
              style: text.titleSmall?.copyWith(color: scheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.companyWebsite,
              style: text.bodyMedium?.copyWith(
                color: scheme.primary,
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
              style: text.titleSmall?.copyWith(color: scheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'IRD Compliant',
              style: text.titleSmall?.copyWith(color: scheme.secondary),
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

/// Edit Company Info form. Edits the single registered profile in place
/// (the onboarding gate guarantees exactly one), reusing the shared
/// [CompanyValidators] and the Nepal location picker so rules can't drift
/// from registration. Follows the add-form pattern: the form validates +
/// saves and reports success; the caller pops and confirms.
class _EditCompanyForm extends StatefulWidget {
  const _EditCompanyForm({required this.company, super.key});
  final CompanyModel company;

  static Future<void> show(BuildContext context, CompanyModel company) {
    final key = GlobalKey<_EditCompanyFormState>();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(context);
        return ClayFormDialog(
          title: const Text('Edit Company Info'),
          onSave: () async {
            if (await key.currentState?.save() ?? false) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(
                    content: Text('Company info updated successfully')),
              );
            }
          },
          child: _EditCompanyForm(key: key, company: company),
        );
      },
    );
  }

  @override
  State<_EditCompanyForm> createState() => _EditCompanyFormState();
}

/// Tax rate catalog manager: live list with active toggles, default-VAT
/// selection, add, and guarded delete. All writes go through keyed
/// `put`/`putAll`/`delete` so the section rows update reactively.
void _showManageTaxRates(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => ClayDialog(
      title: const Text('Manage Tax Rates'),
      content: SizedBox(
        width: 520,
        child: ValueListenableBuilder<Box>(
          valueListenable: hiveService.taxRatesBox.listenable(),
          builder: (context, _, __) {
            final rates = hiveService.taxRatesBox.values.toList()
              ..sort((a, b) => a.name.compareTo(b.name));
            if (rates.isEmpty) {
              return const Text('No tax rates yet. Add one to begin.');
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: rates.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final rate = rates[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${rate.name} · ${pct(rate.rate)}'),
                  subtitle: Text(
                    '${rate.code} • ${rate.isActive ? 'Active' : 'Inactive'}'
                    '${rate.isVat && rate.isDefault ? ' • Default VAT' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rate.isVat)
                        IconButton(
                          icon: Icon(
                            rate.isDefault ? Icons.star : Icons.star_border,
                            color: rate.isDefault
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                          tooltip: rate.isDefault
                              ? 'Default VAT rate'
                              : 'Set as default VAT rate',
                          onPressed: rate.isDefault
                              ? null
                              : () async {
                                  // One batched write: exactly one default.
                                  final updates = {
                                    for (final r in hiveService
                                        .taxRatesBox.values
                                        .where((r) => r.isVat))
                                      r.id: r.copyWith(
                                          isDefault: r.id == rate.id),
                                  };
                                  await hiveService.taxRatesBox.putAll(updates);
                                },
                        ),
                      ClaySwitch(
                        value: rate.isActive,
                        onChanged: (v) async => hiveService.taxRatesBox.put(
                          rate.id,
                          rate.copyWith(isActive: v),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(ClayIcons.delete),
                        tooltip: rate.isDefault
                            ? 'The default rate cannot be deleted'
                            : 'Delete rate',
                        onPressed: rate.isDefault
                            ? null
                            : () async {
                                if (await showClayConfirmDialog(
                                  dialogContext,
                                  title: 'Delete Rate?',
                                  message:
                                      'Delete ${rate.name}? This cannot be undone.',
                                  confirmLabel: 'Delete',
                                )) {
                                  await hiveService.taxRatesBox.delete(rate.id);
                                }
                              },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        ClayButton.text(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
        ClayButton(
          onPressed: () => _AddTaxRateForm.show(dialogContext),
          child: const Text('Add Rate'),
        ),
      ],
    ),
  );
}

/// Add-tax-rate form: validated name/code/rate plus the VAT flag.
/// Caller pops and confirms (add-form pattern).
class _AddTaxRateForm extends StatefulWidget {
  const _AddTaxRateForm({super.key});

  static Future<void> show(BuildContext context) {
    final key = GlobalKey<_AddTaxRateFormState>();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final messenger = ScaffoldMessenger.of(context);
        return ClayFormDialog(
          title: const Text('Add Tax Rate'),
          onSave: () async {
            if (await key.currentState?.save() ?? false) {
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Tax rate added')),
              );
            }
          },
          child: _AddTaxRateForm(key: key),
        );
      },
    );
  }

  @override
  State<_AddTaxRateForm> createState() => _AddTaxRateFormState();
}

class _AddTaxRateFormState extends State<_AddTaxRateForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _code = '';
  String _rate = '';
  bool _isVat = false;

  Future<bool> save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    final rate = TaxRateModel.create(
      name: _name.trim(),
      code: _code.trim(),
      rate: double.parse(_rate.trim()),
      isVat: _isVat,
    );
    await hiveService.taxRatesBox.put(rate.id, rate);
    return true;
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayInputWithLabel(
              label: 'Name',
              hintText: 'e.g. Luxury Tax',
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.required(v, 'Name'),
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Code',
              hintText: 'e.g. LUX',
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.required(v, 'Code'),
              onChanged: (v) => _code = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Rate (%)',
              hintText: 'e.g. 5',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              isRequired: true,
              validator: (v) => CompanyValidators.percentage(v, 'Rate'),
              onChanged: (v) => _rate = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClaySwitchInput(
              label: 'VAT rate',
              value: _isVat,
              onChanged: (v) => setState(() => _isVat = v),
            ),
          ],
        ),
      );
}

class _EditCompanyFormState extends State<_EditCompanyForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name = widget.company.name;
  late String _owner = widget.company.ownerName ?? '';
  late String _regNo = widget.company.registrationNumber ?? '';
  late String _address = widget.company.address ?? '';
  late String _city = widget.company.city ?? '';
  late String _provinceId = _provinceIdFor(widget.company.province);
  late String _district = widget.company.district ?? '';
  late String _palika = widget.company.palika ?? '';
  late String _phone = widget.company.phone ?? '';
  late String _mobile = widget.company.mobile ?? '';
  late String _email = widget.company.email ?? '';
  late String _website = widget.company.website ?? '';
  late String _pan = widget.company.panNumber ?? '';
  late String _vat = widget.company.vatNumber ?? '';

  static String _provinceIdFor(String? name) {
    if (name == null || name.isEmpty) return '';
    for (final province in NepalAdminApi.getAllProvinces()) {
      if (province.name == name) return province.id;
    }
    return '';
  }

  Future<bool> save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    final updated = widget.company.copyWith(
      name: _name.trim(),
      ownerName: _owner.trim(),
      registrationNumber: _regNo.trim(),
      address: _address.trim(),
      city: _city.trim().isEmpty ? null : _city.trim(),
      province: _provinceId.isEmpty
          ? null
          : NepalAdminApi.getProvinceById(_provinceId)?.name,
      district: _district.trim().isEmpty ? null : _district.trim(),
      palika: _palika.trim().isEmpty ? null : _palika.trim(),
      phone: _phone.trim(),
      mobile: _mobile.trim().isEmpty ? null : _mobile.trim(),
      email: _email.trim(),
      website: _website.trim().isEmpty ? null : _website.trim(),
      panNumber: _pan.trim(),
      vatNumber: _vat.trim(),
      updatedAt: DateTime.now(),
    );
    await hiveService.companiesBox.put(updated.id, updated);
    return true;
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayInputWithLabel(
              label: 'Business name',
              value: _name,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.required(v, 'Business name'),
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Owner name',
              value: _owner,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.required(v, 'Owner name'),
              onChanged: (v) => _owner = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Registration number',
              value: _regNo,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) =>
                  CompanyValidators.required(v, 'Registration number'),
              onChanged: (v) => _regNo = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Address',
              value: _address,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.required(v, 'Address'),
              onChanged: (v) => _address = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'City',
              value: _city,
              textInputAction: TextInputAction.next,
              onChanged: (v) => _city = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayNepalLocationPicker(
              provinceId: _provinceId.isEmpty ? null : _provinceId,
              districtName: _district.isEmpty ? null : _district,
              palikaName: _palika.isEmpty ? null : _palika,
              onProvinceChanged: (v) => setState(() {
                _provinceId = v ?? '';
                _district = '';
                _palika = '';
              }),
              onDistrictChanged: (v) => setState(() {
                _district = v ?? '';
                _palika = '';
              }),
              onPalikaChanged: (v) => setState(() => _palika = v ?? ''),
              isRequired: true,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Phone',
              value: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.phone(v, required: true),
              onChanged: (v) => _phone = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Mobile',
              value: _mobile,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) => CompanyValidators.phone(v, required: false),
              onChanged: (v) => _mobile = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Email',
              value: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: CompanyValidators.email,
              onChanged: (v) => _email = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Website',
              value: _website,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              onChanged: (v) => _website = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'PAN',
              value: _pan,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => CompanyValidators.taxId(v, 'PAN'),
              onChanged: (v) => _pan = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'VAT',
              value: _vat,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              isRequired: true,
              validator: (v) => CompanyValidators.taxId(v, 'VAT'),
              onChanged: (v) => _vat = v,
            ),
          ],
        ),
      );
}
