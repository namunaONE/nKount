// App shell: theme builder, breakpoints consumers, sidebar, scaffold,
// app bar, icon button, buttons, and main navigation.
part of '../design_system.dart';

/// Background wrapper applied around the router child.
class ClayThemeBuilder extends StatelessWidget {
  const ClayThemeBuilder({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      );
}

/// Expanded sidebar navigation (264px), built from bottom-nav items.
///
/// Deprecated: wide windows now use the same compact [NavigationRail] as
/// medium windows on every platform, so [ClayScaffold] no longer builds
/// this. Kept for API compatibility.
@Deprecated('Expanded sidebar removed; wide windows use the compact rail.')
class ClaySidebar extends ConsumerWidget {
  const ClaySidebar({
    required this.items,
    required this.currentIndex,
    super.key,
    this.onTap,
    this.header,
  });
  final List<ClayBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final badges = _navBadgeCounts(ref);
    return Container(
      width: 264,
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header ??
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('nKount', style: text.titleLarge),
              ),
          const SizedBox(height: ClaySpacing.sm),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Builder(
                builder: (context) {
                  final selected = i == currentIndex;
                  final item = items[i];
                  return Material(
                    color:
                        selected ? scheme.primaryContainer : Colors.transparent,
                    borderRadius: ClayRadius.medium,
                    child: InkWell(
                      borderRadius: ClayRadius.medium,
                      onTap: onTap == null ? null : () => onTap!.call(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: ClayIconSize.md,
                              color: selected
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.label,
                                style: (selected
                                        ? text.labelLarge?.copyWith(
                                            fontWeight: FontWeight.w700)
                                        : text.labelLarge)
                                    ?.copyWith(
                                  color: selected
                                      ? scheme.onPrimaryContainer
                                      : scheme.onSurface,
                                ),
                              ),
                            ),
                            if (i < badges.length && badges[i] != null)
                              _CountPill(count: badges[i]!),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Scaffold passthrough.
class ClayScaffold extends ConsumerWidget {
  const ClayScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.sidebar,
    this.maxContentWidth = ClayBreakpoints.maxContentWidth,
  });
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  /// Deprecated escape hatch: wide windows now use the same compact rail
  /// on every platform. When set, this replaces the rail; otherwise the
  /// rail is built from the bottom navigation items.
  @Deprecated('Wide windows use the compact rail; sidebar no longer default.')
  final Widget? sidebar;
  final double maxContentWidth;

  ClayBottomNavigation? get _nav => bottomNavigationBar is ClayBottomNavigation
      ? bottomNavigationBar as ClayBottomNavigation
      : null;

  Widget _constrained(Widget? child) {
    if (child == null) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }

  static void _openPalette(BuildContext context) {
    // Don't hijack typing inside text fields.
    if (FocusManager.instance.primaryFocus?.context?.widget is EditableText) {
      return;
    }
    showCommandPalette(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
              _openPalette(context),
          // Ctrl+/ as an alternative where Ctrl+K is awkward.
          const SingleActivator(LogicalKeyboardKey.slash, control: true): () =>
              _openPalette(context),
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final nav = _nav;
            final content = _constrained(body);

            // Medium and expanded: the same compact navigation rail on
            // every platform (no expanded sidebar), + centered content,
            // no bottom bar. Compact windows keep the bottom bar below.
            if (width >= ClayBreakpoints.compactMax && nav != null) {
              // ignore: deprecated_member_use_from_same_package
              final side = sidebar;
              return Scaffold(
                appBar: appBar,
                floatingActionButton: floatingActionButton,
                body: SafeArea(
                  top: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      side ?? _compactRail(ref, nav),
                      const VerticalDivider(width: 1),
                      Expanded(child: content),
                    ],
                  ),
                ),
              );
            }

            // Compact: classic bottom bar.
            return Scaffold(
              appBar: appBar,
              body:
                  SafeArea(top: false, child: body ?? const SizedBox.shrink()),
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
            );
          },
        ),
      );

  /// Compact rail shared by medium + expanded windows, with the same
  /// attention badges as the bottom bar (low stock, overdue invoices).
  Widget _compactRail(WidgetRef ref, ClayBottomNavigation nav) {
    final badges = _navBadgeCounts(ref);
    return NavigationRail(
      selectedIndex: nav.currentIndex,
      onDestinationSelected: nav.onTap,
      labelType: NavigationRailLabelType.all,
      destinations: [
        for (var i = 0; i < nav.items.length; i++)
          NavigationRailDestination(
            icon: i < badges.length && badges[i] != null
                ? Badge(
                    label: Text(_badgeLabel(badges[i]!)),
                    child: Icon(nav.items[i].icon),
                  )
                : Icon(nav.items[i].icon),
            label: Text(nav.items[i].label),
          ),
      ],
    );
  }
}

/// App bar with optional subtitle. Title uses `titleLarge`,
/// subtitle uses `bodySmall` onSurfaceVariant (no hard-coded grey).
class ClayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ClayAppBar({
    required this.title,
    super.key,
    this.subtitle,
    this.actions,
  });
  final Widget title;
  final Widget? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle == null ? kToolbarHeight : kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    final sub = subtitle;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    Widget defaultStyled(Widget w) => w;
    return AppBar(
      title: sub == null
          ? DefaultTextStyle.merge(style: text.titleLarge, child: title)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                    style: text.titleLarge, child: defaultStyled(title)),
                DefaultTextStyle.merge(
                  style:
                      text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  child: sub,
                ),
              ],
            ),
      actions: actions,
    );
  }
}

/// Icon button with 48×48 minimum target and 24dp glyph.
class ClayIconButton extends StatelessWidget {
  const ClayIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.iconSize = ClayIconSize.md,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon, size: iconSize),
        onPressed: onPressed,
        tooltip: tooltip,
        style: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
        ),
      );
}

/// Button style bag.
class ClayButtonStyle {
  const ClayButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  });
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
}

ButtonStyle _toButtonStyle(ClayButtonStyle? style) {
  if (style == null) return const ButtonStyle();
  return ButtonStyle(
    backgroundColor: style.backgroundColor == null
        ? null
        : WidgetStatePropertyAll(style.backgroundColor),
    foregroundColor: style.foregroundColor == null
        ? null
        : WidgetStatePropertyAll(style.foregroundColor),
    padding:
        style.padding == null ? null : WidgetStatePropertyAll(style.padding),
    shape: style.borderRadius == null
        ? null
        : WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: style.borderRadius!),
          ),
    side: style.borderColor == null
        ? null
        : WidgetStatePropertyAll(BorderSide(color: style.borderColor!)),
  );
}

/// Elevated-style button with text/outlined variants.
class ClayButton extends StatelessWidget {
  const ClayButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.style,
    this.icon,
  })  : _text = false,
        _outlined = false;

  const ClayButton.text({
    required this.onPressed,
    required this.child,
    super.key,
  })  : style = null,
        icon = null,
        _text = true,
        _outlined = false;

  const ClayButton.outlined({
    required this.onPressed,
    required this.child,
    super.key,
    this.style,
  })  : icon = null,
        _text = false,
        _outlined = true;
  final VoidCallback? onPressed;
  final Widget child;
  final ClayButtonStyle? style;
  final IconData? icon;
  final bool _text;
  final bool _outlined;

  @override
  Widget build(BuildContext context) {
    final s = _toButtonStyle(style);
    final label = child;
    final iconWidget =
        icon == null ? null : Icon(icon, size: ClayIconSize.dense);
    if (_text) {
      if (iconWidget == null) {
        return TextButton(onPressed: onPressed, style: s, child: label);
      }
      return TextButton.icon(
        onPressed: onPressed,
        style: s,
        icon: iconWidget,
        label: label,
      );
    }
    if (_outlined) {
      if (iconWidget == null) {
        return OutlinedButton(onPressed: onPressed, style: s, child: label);
      }
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: s,
        icon: iconWidget,
        label: label,
      );
    }
    if (iconWidget == null) {
      return ElevatedButton(onPressed: onPressed, style: s, child: label);
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: s,
      icon: iconWidget,
      label: label,
    );
  }
}

/// Bottom navigation item data.
class ClayBottomNavItem {
  const ClayBottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String route;
}

/// App-wide main destinations (single source of truth for every shell).
const kMainNavItems = [
  ClayBottomNavItem(icon: ClayIcons.dashboard, label: 'Dashboard', route: '/'),
  ClayBottomNavItem(
      icon: ClayIcons.contacts, label: 'Contacts', route: '/contacts'),
  ClayBottomNavItem(
      icon: ClayIcons.products, label: 'Products', route: '/products'),
  ClayBottomNavItem(
      icon: ClayIcons.transactions,
      label: 'Transactions',
      route: '/transactions'),
  ClayBottomNavItem(
      icon: ClayIcons.payments, label: 'Payments', route: '/payments'),
  ClayBottomNavItem(
      icon: ClayIcons.profile, label: 'Profile', route: '/profile'),
];

/// Attention counts aligned to [kMainNavItems] order.
/// Index 2 (Products) = low-stock lines, index 3 (Transactions) = overdue
/// invoices. Null = no badge. Computed from live boxes on every build
/// (same freshness semantics as dashboard KPIs); capped at 99+ for display.
List<int?> _navBadgeCounts(WidgetRef ref) {
  final hive = ref.watch(hiveServiceProvider);
  final now = DateTime.now();
  final overdue = hive.transactionsBox.values
      .where((t) =>
          !t.isCancelled &&
          t.dueAmount > 0 &&
          t.dueDate != null &&
          t.dueDate!.isBefore(now))
      .length;
  final lowStock = hive.productsBox.values
      .where((p) => p.isActive && p.quantity <= p.minQuantity)
      .length;
  final lowStockBadge = lowStock == 0 ? null : lowStock;
  final overdueBadge = overdue == 0 ? null : overdue;
  return [
    null,
    null,
    lowStockBadge,
    overdueBadge,
    null,
    null,
  ];
}

String _badgeLabel(int count) => count > 99 ? '99+' : '$count';

/// Small count pill for sidebar rows (tertiary keeps it distinct from the
/// selected-row primaryContainer background in both modes).
class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: ClayRadius.full,
      ),
      child: Text(
        _badgeLabel(count),
        style: text.labelSmall?.copyWith(
          color: scheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Builds the shared bottom bar; rail/sidebar derive from the same items.
ClayBottomNavigation mainNavBar(BuildContext context, int currentIndex) =>
    ClayBottomNavigation(
      currentIndex: currentIndex,
      items: kMainNavItems,
      onTap: (index) {
        if (index < kMainNavItems.length) {
          context.go(kMainNavItems[index].route);
        }
      },
    );

/// Bottom navigation backed by M3 [NavigationBar] (pill indicator,
/// tonal surface). Destinations 2/3 carry attention badges.
class ClayBottomNavigation extends ConsumerWidget {
  const ClayBottomNavigation({
    required this.currentIndex,
    required this.items,
    super.key,
    this.onTap,
  });
  final int currentIndex;
  final List<ClayBottomNavItem> items;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = _navBadgeCounts(ref);
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        for (var i = 0; i < items.length; i++)
          if (badges.length > i && badges[i] != null)
            NavigationDestination(
              icon: Badge(
                label: Text(_badgeLabel(badges[i]!)),
                child: Icon(items[i].icon),
              ),
              label: items[i].label,
            )
          else
            NavigationDestination(
              icon: Icon(items[i].icon),
              label: items[i].label,
            ),
      ],
    );
  }
}

/// Command-palette search field: an icon button that opens an M3 search
/// view with live command suggestions (same registry as Ctrl+K).
class ClayCommandSearch extends StatelessWidget {
  const ClayCommandSearch({
    super.key,
    this.tooltip = 'Search actions (Ctrl+K)',
  });
  final String? tooltip;

  @override
  Widget build(BuildContext context) => SearchAnchor(
        builder: (context, controller) => ClayIconButton(
          icon: ClayIcons.search,
          tooltip: tooltip,
          onPressed: () => controller.openView(),
        ),
        suggestionsBuilder: (context, controller) {
          final matches = filterCommands(controller.text);
          if (matches.isEmpty) {
            return [
              const ListTile(title: Text('No matching commands')),
            ];
          }
          final text = Theme.of(context).textTheme;
          final scheme = Theme.of(context).colorScheme;
          return [
            for (final cmd in matches)
              ListTile(
                leading: Icon(cmd.icon),
                title: Text(cmd.title),
                trailing: Text(
                  cmd.hint,
                  style:
                      text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                onTap: () {
                  controller.closeView(controller.text);
                  cmd.run(context);
                },
              ),
          ];
        },
      );
}

/// Entrance animation: fade + slight rise, plays once per element.
/// Wrap list items as `ClayEntrance(delay: ClayMotion.stagger(index))`.
/// Scrolling back reuses elements, so entrances don't replay.
class ClayEntrance extends StatefulWidget {
  const ClayEntrance({
    required this.child,
    super.key,
    this.delay = Duration.zero,
  });
  final Widget child;
  final Duration delay;

  @override
  State<ClayEntrance> createState() => _ClayEntranceState();
}

class _ClayEntranceState extends State<ClayEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ClayMotion.medium,
  );
  late final Animation<double> _opacity = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: ClayMotion.easing));
  late final Animation<Offset> _offset = Tween<Offset>(
          begin: const Offset(0, 0.12), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: ClayMotion.easing));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _offset, child: widget.child),
      );
}

/// Skeleton loading list: shimmering tonal bars for list screens.
class ClaySkeletonList extends StatelessWidget {
  const ClaySkeletonList({super.key, this.rows = 6});
  final int rows;

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rows,
        itemBuilder: (context, index) => const _ShimmerBar(),
      );
}

class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar();

  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ClayMotion.long,
  )..repeat(reverse: true);
  late final Animation<double> _opacity = Tween<double>(begin: 0.45, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: ClayMotion.easing));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: ClayRadius.smallPlus,
          ),
        ),
      );
}
