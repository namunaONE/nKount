import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';
import '../../packages/design-system/design_system.dart';

/// A single command-palette entry.
class AppCommand {
  const AppCommand({
    required this.title,
    required this.icon,
    required this.hint,
    required this.run,
  });
  final String title;
  final IconData icon;
  final String hint;
  final void Function(BuildContext context) run;
}

/// All palette commands: navigation + creation shortcuts.
List<AppCommand> appCommands() => [
      _go('Dashboard', ClayIcons.dashboard, '/', 'G D'),
      _go('Contacts', ClayIcons.contacts, '/contacts', 'G C'),
      _go('Products', ClayIcons.products, '/products', 'G P'),
      _go('Transactions', ClayIcons.transactions, '/transactions', 'G T'),
      _go('New Sale', ClayIcons.sales, '/sales', 'G S'),
      _go('New Purchase', ClayIcons.purchases, '/purchases', 'G B'),
      _go('Payments', ClayIcons.payments, '/payments', 'G Y'),
      _go('Reports', ClayIcons.reports, '/reports', 'G R'),
      _go('Settings', ClayIcons.settings, '/settings', 'G ,'),
      _go('Profile', ClayIcons.profile, '/profile', 'G .'),
      _go('Design System', Icons.palette_rounded, '/design-system', 'G X'),
      AppCommand(
        title: 'Toggle dark mode',
        icon: Icons.brightness_6,
        hint: 'G T',
        run: (context) {
          final container = ProviderScope.containerOf(context);
          final current = container.read(themeModeProvider);
          container.read(themeModeProvider.notifier).state =
              current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        },
      ),
    ];

AppCommand _go(String title, IconData icon, String route, String hint) =>
    AppCommand(
      title: title,
      icon: icon,
      hint: hint,
      run: (context) => context.go(route),
    );

/// Shows the Ctrl+K command palette.
Future<void> showCommandPalette(BuildContext context) => showDialog(
      context: context,
      builder: (context) => const _CommandPaletteDialog(),
    );

class _CommandPaletteDialog extends StatefulWidget {
  const _CommandPaletteDialog();

  @override
  State<_CommandPaletteDialog> createState() => _CommandPaletteDialogState();
}

class _CommandPaletteDialogState extends State<_CommandPaletteDialog> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commands = appCommands()
        .where((c) => c.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Dialog(
      insetPadding:
          const EdgeInsets.only(top: 120, left: 24, right: 24, bottom: 24),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Type a command... (Esc to close)',
                  prefixIcon: Icon(ClayIcons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _query = v),
                onSubmitted: (_) {
                  if (commands.isNotEmpty) {
                    Navigator.pop(context);
                    commands.first.run(context);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: commands.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No matching commands'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: commands.length,
                      itemBuilder: (context, i) {
                        final cmd = commands[i];
                        return ListTile(
                          leading: Icon(cmd.icon),
                          title: Text(cmd.title),
                          trailing: Text(
                            cmd.hint,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            cmd.run(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
