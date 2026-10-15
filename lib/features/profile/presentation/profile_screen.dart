import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../packages/design-system/design_system.dart';

/// Profile: registered business identity + appearance + settings + about.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final themeMode = ref.watch(themeModeProvider);
    final companies = hive.companiesBox.values.toList();
    final company = companies.isEmpty ? null : companies.first;
    final companyName = company == null ? AppConstants.appName : company.name;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return ClayScaffold(
      appBar: const ClayAppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClayCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: scheme.primaryContainer,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        companyName.isEmpty
                            ? 'n'
                            : companyName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            style: text.titleLarge,
                          ),
                          if (company?.ownerName case final owner?
                              when owner.isNotEmpty)
                            Text(
                              owner,
                              style: text.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          if (company?.email case final email?
                              when email.isNotEmpty)
                            Text(
                              email,
                              style: text.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          Text(
                            company == null
                                ? 'Business account'
                                : 'Registered business',
                            style: text.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (company != null) ...[
              const SizedBox(height: 16),
              ClayCard(
                title: const ClaySectionTitle('Business address'),
                child: Column(
                  children: [
                    if (company.fullAddress.isNotEmpty)
                      _ProfileRow(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: company.fullAddress,
                      ),
                    if ([company.palika, company.district, company.province]
                        .any((e) => e != null && e.isNotEmpty)) ...[
                      const Divider(),
                      _ProfileRow(
                        icon: Icons.map,
                        label: 'Palika · District · Province',
                        value: company.localityLine,
                      ),
                    ],
                    if (company.phone != null && company.phone!.isNotEmpty) ...[
                      const Divider(),
                      _ProfileRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: [
                          company.phone!,
                          if (company.mobile != null &&
                              company.mobile!.isNotEmpty)
                            company.mobile!,
                        ].join(' • '),
                      ),
                    ],
                    if (company.website != null &&
                        company.website!.isNotEmpty) ...[
                      const Divider(),
                      _ProfileRow(
                        icon: Icons.language,
                        label: 'Website',
                        value: company.website!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ClayCard(
                title: const ClaySectionTitle('Registration & tax'),
                child: Column(
                  children: [
                    if (company.registrationNumber != null &&
                        company.registrationNumber!.isNotEmpty) ...[
                      _ProfileRow(
                        icon: Icons.badge,
                        label: 'Registration no.',
                        value: company.registrationNumber!,
                      ),
                    ],
                    if (company.panNumber != null &&
                        company.panNumber!.isNotEmpty) ...[
                      const Divider(),
                      _ProfileRow(
                        icon: Icons.numbers,
                        label: 'PAN',
                        value: company.panNumber!,
                      ),
                    ],
                    if (company.vatNumber != null &&
                        company.vatNumber!.isNotEmpty) ...[
                      const Divider(),
                      _ProfileRow(
                        icon: Icons.numbers,
                        label: 'VAT',
                        value: company.vatNumber!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ClayCard(
              title: const ClaySectionTitle('Appearance'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode),
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode),
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (modes) =>
                      ref.read(themeModeProvider.notifier).state = modes.first,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClayCard(
              title: const ClaySectionTitle('Settings'),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(ClayIcons.settings),
                    title: const Text('App settings'),
                    subtitle: const Text('Company, taxes, backup, preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings'),
                  ),
                  ListTile(
                    leading: const Icon(ClayIcons.reports),
                    title: const Text('Reports'),
                    subtitle: const Text('Sales, purchases, tax summaries'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/reports'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClayCard(
              title: const ClaySectionTitle('About'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${AppConstants.appName} ${AppConstants.appVersion}',
                      style: text.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.maintainedBy,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    Text(
                      AppConstants.maintainerTeam,
                      style: text.labelLarge?.copyWith(color: scheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: mainNavBar(context, 5),
    );
  }
}

/// Label + value row for the business detail cards. Empty values are
/// never built — callers guard with `isNotEmpty` checks.
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: ClayIconSize.md, color: scheme.primary),
          const SizedBox(width: ClaySpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                Text(value, style: text.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
