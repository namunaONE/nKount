/// Compat design-system shim (Material-backed).
///
/// The app was written against a `packages/design-system` workspace package
/// that was never committed (see README project structure). This file provides
/// source-compatible `Clay*` widgets backed by Material 3 so the app compiles
/// and runs offline-first while the real Claymorphism system is built (P4).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features/app/commands.dart';

/// Brand palette: deep navy primary seed #002C6D, vivid green secondary
/// seed #4FD166. Tonal values below come from the M3 tonal palettes
/// generated for these seeds (see tool/tones_test.dart):
/// navy T40 #3E5C9F, T60 #728FD5; green T40 #006E27, T50 #008A33,
/// T80 #5EE072, T90 #7CFD8C, T10 #002107. Direct-use accents are picked
/// to read on both light and dark surfaces.
abstract final class ClayColors {
  static const Color primary = Color(0xFF3E5C9F);
  static const Color secondary = Color(0xFF008A33);
  static const Color tertiary = Color(0xFF728FD5);
  static const Color success = Color(0xFF006E27);
  static const Color warning = Color(0xFF7A5900);
  static const Color error = Color(0xFFBA1A1A);
  static const Color info = Color(0xFF3E5C9F);
}

/// Corner radii.
abstract final class ClayRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius large = BorderRadius.all(Radius.circular(24));
}

/// App themes: M3 fidelity scheme from the navy seed (keeps brand
/// identity — tonalSpot would wash it to steel blue), with the secondary
/// roles pinned to the green tonal palette. All roles meet M3 contrast.
abstract final class ClayTheme {
  static const Color seedPrimary = Color(0xFF002C6D);

  static ColorScheme _scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: seedPrimary,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    if (brightness == Brightness.light) {
      return base.copyWith(
        secondary: const Color(0xFF006E27),
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFF7CFD8C),
        onSecondaryContainer: const Color(0xFF002107),
      );
    }
    return base.copyWith(
      secondary: const Color(0xFF5EE072),
      onSecondary: const Color(0xFF003910),
      secondaryContainer: const Color(0xFF00531B),
      onSecondaryContainer: const Color(0xFF7CFD8C),
    );
  }

  static ThemeData get lightTheme {
    final scheme = _scheme(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF1F2F6),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 3,
        shadowColor: Colors.black12,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
    );
  }

  static ThemeData get darkTheme {
    final scheme = _scheme(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 3,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
    );
  }
}

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

/// Adaptive breakpoints (window-size based, never device checks).
abstract final class ClayBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax = 1240;
  static const double maxContentWidth = 1200;

  static bool isCompact(double width) => width < compactMax;
  static bool isMedium(double width) =>
      width >= compactMax && width < mediumMax;
  static bool isExpanded(double width) => width >= mediumMax;
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
    return Container(
      width: 264,
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header ??
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'nKount',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          const SizedBox(height: 8),
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
                              color: selected
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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

/// App bar with optional subtitle.
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
    return AppBar(
      title: sub == null
          ? title
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [title, sub],
            ),
      actions: actions,
    );
  }
}

/// Icon button passthrough.
class ClayIconButton extends StatelessWidget {
  const ClayIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip,
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
    final iconWidget = icon == null ? null : Icon(icon);
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
  ClayBottomNavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/'),
  ClayBottomNavItem(icon: Icons.people, label: 'Contacts', route: '/contacts'),
  ClayBottomNavItem(
      icon: Icons.inventory, label: 'Products', route: '/products'),
  ClayBottomNavItem(
      icon: Icons.receipt, label: 'Transactions', route: '/transactions'),
  ClayBottomNavItem(icon: Icons.payment, label: 'Payments', route: '/payments'),
  ClayBottomNavItem(icon: Icons.person, label: 'Profile', route: '/profile'),
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
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
        ],
      );
}

/// Card wrapper.
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    this.title,
    this.child,
    this.onTap,
    this.padding,
  });
  final Widget? title;
  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) title!,
          if (child != null) child!,
        ],
      ),
    );
    return Card(
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: ClayRadius.medium,
              onTap: onTap,
              child: content,
            ),
    );
  }
}

/// Stat card with icon + value.
class ClayStatCard extends StatelessWidget {
  const ClayStatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
    this.iconColor,
    this.onTap,
    this.subtitle,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle;
    return ClayCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          if (sub != null)
            Text(sub, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Dialog wrapper.
class ClayDialog extends StatelessWidget {
  const ClayDialog({super.key, this.title, this.content, this.actions});
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
}

/// Form dialog wrapper.
class ClayFormDialog extends StatelessWidget {
  const ClayFormDialog({super.key, this.title, this.child, this.actions});
  final Widget? title;
  final Widget? child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: title,
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(child: child),
        ),
        actions: actions,
      );
}

/// Search input.
class ClaySearchInput extends StatelessWidget {
  const ClaySearchInput({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
  });
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(
            borderRadius: ClayRadius.medium,
          ),
        ),
      );
}

/// Labeled text input (uncontrolled shim: [value] seeds the field).
class ClayInputWithLabel extends StatelessWidget {
  const ClayInputWithLabel({
    required this.label,
    super.key,
    this.hintText,
    this.value,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.maxLines,
  });
  final String label;
  final String? hintText;
  final String? value;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(hintText: hintText),
          ),
        ],
      );
}

/// Dropdown input.
class ClayDropdownInput<T> extends StatelessWidget {
  const ClayDropdownInput({
    required this.label,
    required this.value,
    required this.items,
    super.key,
    this.onChanged,
    this.validator,
  });
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      );
}

/// Switch row.
class ClaySwitch extends StatelessWidget {
  const ClaySwitch({required this.value, required this.onChanged, super.key});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) =>
      Switch(value: value, onChanged: onChanged);
}

/// Labeled switch input.
class ClaySwitchInput extends StatelessWidget {
  const ClaySwitchInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label)),
          Switch(value: value, onChanged: onChanged),
        ],
      );
}

/// Radio list tile.
class ClayRadioListTile<T> extends StatelessWidget {
  const ClayRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.title,
  });
  final Widget? title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => RadioGroup<T>(
        groupValue: groupValue,
        onChanged: onChanged,
        child: RadioListTile<T>(
          title: title,
          value: value,
        ),
      );
}

/// Date input (AD picker; BS picker lands in P4).
class ClayDateInput extends StatelessWidget {
  const ClayDateInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final text =
        value == null ? '' : value!.toLocal().toString().split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: text),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            onChanged?.call(picked);
          },
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}

/// Currency/amount input.
class ClayCurrencyInput extends StatelessWidget {
  const ClayCurrencyInput({
    required this.label,
    super.key,
    this.hintText,
    this.value,
    this.onChanged,
    this.validator,
  });
  final String label;
  final String? hintText;
  final double? value;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<double>? validator;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value?.toString() ?? '',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) => onChanged?.call(double.tryParse(text)),
            validator: (text) => validator?.call(
              text == null || text.isEmpty ? null : double.tryParse(text),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: 'Rs ',
            ),
          ),
        ],
      );
}
