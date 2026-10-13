/// nKount Design System v2 — Material 3 backed.
///
/// Phase 0 (foundation tokens) + Phase 1 (typography/fonts) +
/// Phase 2 (iconography) + Phase 3 (card sizes/styles).
///
/// Backward compatible with all existing `Clay*` call-sites.
/// New tokens are additive: [ClaySpacing], [ClayElevation], [ClayMotion],
/// [ClayIcons], [ClayTypography], [ClayCardVariant], [ClayCardSize],
/// [ClaySectionTitle], [ClayEmptyState].
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/app/commands.dart';

// ── Spacing (4pt grid) ──────────────────────────────────────────────

/// Spacing scale. Use these instead of raw doubles.
abstract final class ClaySpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const EdgeInsets cardCompact = EdgeInsets.all(md);
  static const EdgeInsets cardMedium = EdgeInsets.all(lg);
  static const EdgeInsets cardLarge = EdgeInsets.all(xl);
}

// ── Radius ──────────────────────────────────────────────────────────

/// Corner radii. [small]/[medium]/[large] kept for compat.
abstract final class ClayRadius {
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius smallPlus = BorderRadius.all(Radius.circular(12));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(16));
  static const BorderRadius large = BorderRadius.all(Radius.circular(24));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  static BorderRadius forSize(ClayCardSize size) => switch (size) {
        ClayCardSize.compact => smallPlus,
        ClayCardSize.medium => medium,
        ClayCardSize.large => large,
      };
}

// ── Elevation ───────────────────────────────────────────────────────

/// Elevation tokens (M3 levels).
abstract final class ClayElevation {
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;
}

// ── Motion ──────────────────────────────────────────────────────────

/// Motion tokens (M3 expressive-ish).
abstract final class ClayMotion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration long = Duration(milliseconds: 400);
  static const Curve easing = Curves.easeOutCubic;
}

// ── Colors ──────────────────────────────────────────────────────────

/// Brand palette: deep navy primary seed #002C6D, vivid green secondary.
/// Tonal values from M3 tonal palettes for these seeds
/// (see tool/tones_test.dart): navy T40 #3E5C9F, T60 #728FD5;
/// green T40 #006E27, T50 #008A33, T80 #5EE072, T90 #7CFD8C,
/// T10 #002107. Direct-use accents read on both light and dark surfaces.
///
/// These are *semantic aliases* — the actual [ColorScheme] comes from
/// [ClayTheme]. Prefer `Theme.of(context).colorScheme` in new code;
/// use these only for chart rods, icon tints, and legacy call-sites.
abstract final class ClayColors {
  static const Color primary = Color(0xFF3E5C9F);
  static const Color secondary = Color(0xFF008A33);
  static const Color tertiary = Color(0xFF728FD5);
  static const Color success = Color(0xFF006E27);
  static const Color warning = Color(0xFF7A5900);
  static const Color error = Color(0xFFBA1A1A);
  static const Color info = Color(0xFF3E5C9F);

  // Light-mode tints for icon containers / chart backgrounds.
  static const Color successContainer = Color(0xFFB5F0C0);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color warningContainer = Color(0xFFFFEFC7);
  static const Color infoContainer = Color(0xFFD9E2FF);
}

// ── Iconography ─────────────────────────────────────────────────────

/// Icon sizes. Default tap target stays 48×48 (see [ClayIconButton]).
abstract final class ClayIconSize {
  static const double dense = 18;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 40;
}

/// Semantic icon map — one rounded family, one metaphor per concept.
/// Use these for *new* code. Legacy screens passing raw `Icons.*` still work.
abstract final class ClayIcons {
  // Nav
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData contacts = Icons.people_rounded;
  static const IconData products = Icons.inventory_2_rounded;
  static const IconData transactions = Icons.receipt_long_rounded;
  static const IconData payments = Icons.payments_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData sales = Icons.point_of_sale_rounded;
  static const IconData purchases = Icons.shopping_bag_rounded;
  static const IconData reports = Icons.assessment_rounded;
  static const IconData settings = Icons.settings_rounded;

  // KPI / finance semantics
  static const IconData revenue = Icons.trending_up_rounded;
  static const IconData expenses = Icons.trending_down_rounded;
  static const IconData receivables = Icons.south_west_rounded;
  static const IconData payables = Icons.north_east_rounded;
  static const IconData profit = Icons.account_balance_wallet_rounded;
  static const IconData cash = Icons.payments_rounded;

  // Actions
  static const IconData add = Icons.add_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData view = Icons.visibility_outlined;
  static const IconData print = Icons.print_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData date = Icons.calendar_today_rounded;
  static const IconData check = Icons.check_circle_rounded;
  static const IconData alert = Icons.warning_amber_rounded;
  static const IconData empty = Icons.inbox_outlined;
}

// ── Typography ──────────────────────────────────────────────────────

/// Typography: Inter (Latin) + Noto Sans Devanagari (fallback).
///
/// M3 type scale — 5 roles × 3 sizes = 15 tokens. Sizes/line-heights/
/// tracking follow https://m3.material.io/styles/typography.
/// Never hard-code `TextStyle(fontSize: …)` in screens; use
/// `Theme.of(context).textTheme.*` or the helpers below.
abstract final class ClayTypography {
  static const String latinFamily = 'Inter';
  static const List<String> fallback = ['Noto Sans Devanagari'];

  static TextStyle _withFallback(TextStyle? s) =>
      (s ?? const TextStyle()).copyWith(fontFamilyFallback: fallback);

  /// Inter-based M3 scale with Devanagari fallback on every style.
  static TextTheme textTheme([TextTheme? base]) {
    final resolved = base ?? ThemeData.light().textTheme;
    final inter = GoogleFonts.interTextTheme(resolved);
    return TextTheme(
      displayLarge: _withFallback(inter.displayLarge
          ?.copyWith(fontSize: 57, height: 64 / 57, letterSpacing: -0.25)),
      displayMedium: _withFallback(inter.displayMedium
          ?.copyWith(fontSize: 45, height: 52 / 45, letterSpacing: 0)),
      displaySmall: _withFallback(inter.displaySmall
          ?.copyWith(fontSize: 36, height: 44 / 36, letterSpacing: 0)),
      headlineLarge: _withFallback(inter.headlineLarge
          ?.copyWith(fontSize: 32, height: 40 / 32, letterSpacing: 0)),
      headlineMedium: _withFallback(inter.headlineMedium
          ?.copyWith(fontSize: 28, height: 36 / 28, letterSpacing: 0)),
      headlineSmall: _withFallback(inter.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          letterSpacing: 0,
          fontWeight: FontWeight.w600)),
      titleLarge: _withFallback(inter.titleLarge?.copyWith(
          fontSize: 22,
          height: 28 / 22,
          letterSpacing: 0,
          fontWeight: FontWeight.w600)),
      titleMedium: _withFallback(inter.titleMedium?.copyWith(
          fontSize: 16,
          height: 24 / 16,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500)),
      titleSmall: _withFallback(inter.titleSmall?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500)),
      bodyLarge: _withFallback(inter.bodyLarge
          ?.copyWith(fontSize: 16, height: 24 / 16, letterSpacing: 0.5)),
      bodyMedium: _withFallback(inter.bodyMedium
          ?.copyWith(fontSize: 14, height: 20 / 14, letterSpacing: 0.25)),
      bodySmall: _withFallback(inter.bodySmall
          ?.copyWith(fontSize: 12, height: 16 / 12, letterSpacing: 0.4)),
      labelLarge: _withFallback(inter.labelLarge?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500)),
      labelMedium: _withFallback(inter.labelMedium?.copyWith(
          fontSize: 12,
          height: 16 / 12,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500)),
      labelSmall: _withFallback(inter.labelSmall?.copyWith(
          fontSize: 11,
          height: 16 / 11,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500)),
    );
  }

  /// Tabular figures for currency / KPI values (keeps digits aligned).
  static TextStyle tabular(TextStyle? s) => (s ?? const TextStyle()).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

// ── Theme ───────────────────────────────────────────────────────────

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

  static TextTheme _text(TextTheme base) => ClayTypography.textTheme(base);

  static ThemeData get lightTheme {
    final scheme = _scheme(Brightness.light);
    final text = _text(ThemeData.light(useMaterial3: true).textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF1F2F6),
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: text.titleLarge,
      ),
      iconTheme: const IconThemeData(size: ClayIconSize.md),
      cardTheme: const CardThemeData(
        elevation: ClayElevation.level2,
        shadowColor: Colors.black12,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          iconSize: WidgetStatePropertyAll(ClayIconSize.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
        border: const OutlineInputBorder(borderRadius: ClayRadius.medium),
        enabledBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: text.bodySmall,
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: scheme.secondary,
        labelStyle: text.labelLarge!,
        brightness: Brightness.light,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.large),
      ),
      dividerTheme: DividerThemeData(
          color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle:
            text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      ),
    );
  }

  static ThemeData get darkTheme {
    final scheme = _scheme(Brightness.dark);
    final text = _text(ThemeData.dark(useMaterial3: true).textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: text.titleLarge,
      ),
      iconTheme: const IconThemeData(size: ClayIconSize.md),
      cardTheme: const CardThemeData(
        elevation: ClayElevation.level2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
              horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
          shape:
              const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          iconSize: WidgetStatePropertyAll(ClayIconSize.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: ClaySpacing.lg, vertical: ClaySpacing.md),
        border: const OutlineInputBorder(borderRadius: ClayRadius.medium),
        enabledBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ClayRadius.medium,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: text.bodySmall,
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: scheme.secondary,
        labelStyle: text.labelLarge!,
        brightness: Brightness.dark,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: ClayRadius.large),
      ),
      dividerTheme: DividerThemeData(
          color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: const RoundedRectangleBorder(borderRadius: ClayRadius.smallPlus),
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle:
            text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
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

// ── Cards ───────────────────────────────────────────────────────────

/// M3 card variants.
enum ClayCardVariant { elevated, filled, outlined }

/// Card sizes: padding + radius + icon treatment.
enum ClayCardSize { compact, medium, large }

/// Card wrapper with M3 elevated/filled/outlined variants and S/M/L sizes.
///
/// Backwards compatible: `ClayCard(title:…, child:…)` renders as
/// elevated/medium with zero outer padding (callers add their own
/// `Padding(16)` today). New code should pass `variant`/`size` and let
/// the card own its padding via [ClaySectionTitle]/[ClayEmptyState].
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    this.title,
    this.child,
    this.onTap,
    this.padding,
    this.variant = ClayCardVariant.elevated,
    this.size = ClayCardSize.medium,
  });
  final Widget? title;
  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final ClayCardVariant variant;
  final ClayCardSize size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color color, double elevation, BorderSide? side) = switch (variant) {
      ClayCardVariant.elevated => (
          scheme.surfaceContainerLow,
          ClayElevation.level1,
          null
        ),
      ClayCardVariant.filled => (
          scheme.surfaceContainerHighest,
          ClayElevation.level0,
          null
        ),
      ClayCardVariant.outlined => (
          scheme.surface,
          ClayElevation.level0,
          BorderSide(color: scheme.outlineVariant)
        ),
    };
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
    final shape = RoundedRectangleBorder(
      borderRadius: ClayRadius.forSize(size),
      side: side ?? BorderSide.none,
    );
    final card = Card(
      color: color,
      elevation: elevation,
      shape: shape,
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: ClayRadius.forSize(size),
              onTap: onTap,
              child: content,
            ),
    );
    return card;
  }
}

/// Standard card heading. Replaces `Text(fontSize: 18, bold)` litter.
class ClaySectionTitle extends StatelessWidget {
  const ClaySectionTitle(this.title, {super.key, this.action, this.subtitle});
  final String title;
  final Widget? action;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final sub = subtitle;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleLarge),
              if (sub != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(sub,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// Standard empty state (icon + title + optional action).
class ClayEmptyState extends StatelessWidget {
  const ClayEmptyState(
      {required this.title, super.key, this.icon, this.subtitle, this.action});
  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: ClaySpacing.cardMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: ClayRadius.full,
            ),
            child: Icon(icon ?? ClayIcons.empty,
                size: ClayIconSize.lg, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: ClaySpacing.md),
          Text(title, style: text.titleMedium, textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: ClaySpacing.xs),
            Text(subtitle!,
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
          if (action != null) ...[
            const SizedBox(height: ClaySpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Stat card with icon + value. v2: 40dp tinted icon container,
/// `headlineSmall` tabular value, `labelMedium` title.
class ClayStatCard extends StatelessWidget {
  const ClayStatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
    this.iconColor,
    this.onTap,
    this.subtitle,
    this.variant = ClayCardVariant.elevated,
    this.size = ClayCardSize.medium,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? subtitle;
  final ClayCardVariant variant;
  final ClayCardSize size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final sub = subtitle;
    final tint = iconColor ?? scheme.primary;
    return ClayCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      variant: variant,
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: ClayRadius.smallPlus,
            ),
            child: Icon(icon, color: tint, size: 22),
          ),
          const SizedBox(height: ClaySpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ClayTypography.tabular(text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            )),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          if (sub != null)
            Text(sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
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
          prefixIcon: const Icon(ClayIcons.search),
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
            suffixIcon: Icon(ClayIcons.date),
          ),
        ),
      ],
    );
  }
}

/// Currency/amount input with tabular figures.
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
            style:
                ClayTypography.tabular(Theme.of(context).textTheme.bodyLarge),
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
