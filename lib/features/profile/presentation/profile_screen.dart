import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../packages/design-system/design_system.dart';

/// Profile: identity + appearance (theme) + settings entry + about.
/// Settings and the theme toggle live here instead of scattered gears.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveServiceProvider);
    final themeMode = ref.watch(themeModeProvider);
    final companies = hive.companiesBox.values.toList();
    final companyName =
        companies.isEmpty ? AppConstants.appName : companies.first.name;
    final companyEmail = companies.isEmpty ? null : companies.first.email;

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
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [ClayColors.primary, ClayColors.secondary],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        companyName.isEmpty
                            ? 'n'
                            : companyName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (companyEmail != null && companyEmail.isNotEmpty)
                            Text(
                              companyEmail,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          const Text(
                            'Business account',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClayCard(
              title: const Text(
                'Appearance',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('App settings'),
                    subtitle: const Text('Company, taxes, backup, preferences'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.assessment),
                    title: const Text('Reports'),
                    subtitle: const Text('Sales, purchases, tax summaries'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/reports'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const ClayCard(
              title: Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${AppConstants.appName} ${AppConstants.appVersion}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppConstants.maintainedBy,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      AppConstants.maintainerTeam,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ClayColors.primary,
                      ),
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
