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

/// Sidebar navigation for expanded windows, built from bottom-nav items.
class ClaySidebar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
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
                            Text(
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
class ClayScaffold extends StatelessWidget {
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

  /// Custom sidebar for expanded windows. When null and [bottomNavigationBar]
  /// is a [ClayBottomNavigation], one is built from its items.
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
  Widget build(BuildContext context) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
              _openPalette(context),
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final nav = _nav;
            final content = _constrained(body);

            // Expanded: sidebar + centered content, no bottom bar.
            if (ClayBreakpoints.isExpanded(width) && nav != null) {
              return Scaffold(
                appBar: appBar,
                floatingActionButton: floatingActionButton,
                body: SafeArea(
                  top: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sidebar ??
                          ClaySidebar(
                            items: nav.items,
                            currentIndex: nav.currentIndex,
                            onTap: nav.onTap,
                          ),
                      const VerticalDivider(width: 1),
                      Expanded(child: content),
                    ],
                  ),
                ),
              );
            }

            // Medium: navigation rail + centered content, no bottom bar.
            if (ClayBreakpoints.isMedium(width) && nav != null) {
              return Scaffold(
                appBar: appBar,
                floatingActionButton: floatingActionButton,
                body: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: nav.currentIndex,
                        onDestinationSelected: nav.onTap,
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          for (final item in nav.items)
                            NavigationRailDestination(
                              icon: Icon(item.icon),
                              label: Text(item.label),
                            ),
                        ],
                      ),
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

/// Bottom navigation backed by [BottomNavigationBar].
class ClayBottomNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: Theme.of(context).textTheme.labelSmall,
        unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
        ],
      );
}
