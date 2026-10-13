// Design tokens: spacing, radius, elevation, motion, color, icons,
// breakpoints, and the two-column section layout.
part of '../design_system.dart';

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

/// Corner radii.
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

/// Elevation tokens (M3 levels).
abstract final class ClayElevation {
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;
  static const double level4 = 8;
  static const double level5 = 12;
}

/// Motion tokens (M3 expressive-ish).
abstract final class ClayMotion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration long = Duration(milliseconds: 400);
  static const Curve easing = Curves.easeOutCubic;
}

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

  /// Neutral fallback for const contexts without a BuildContext
  /// (e.g. DataTableSource helpers). Matches M3 onSurfaceVariant.
  static const Color neutral = Color(0xFF49454F);
}

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

/// Adaptive breakpoints (window-size based, never device checks).
abstract final class ClayBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax = 1240;
  static const double maxContentWidth = 1200;

  /// Content width at which two-column section layouts kick in.
  static const double twoColumnMin = 900;

  static bool isCompact(double width) => width < compactMax;
  static bool isMedium(double width) =>
      width >= compactMax && width < mediumMax;
  static bool isExpanded(double width) => width >= mediumMax;
}

/// Two-column section layout: side-by-side on wide content, stacked on
/// narrow. Fixes "cards cover the whole width" by pairing sections
/// (e.g. chart + quick actions) instead of stretching one column.
class ClayTwoColumn extends StatelessWidget {
  const ClayTwoColumn({
    required this.main,
    required this.side,
    super.key,
    this.breakpoint = ClayBreakpoints.twoColumnMin,
    this.mainFlex = 2,
    this.sideFlex = 1,
    this.spacing = ClaySpacing.lg,
  });
  final Widget main;
  final Widget side;
  final double breakpoint;
  final int mainFlex;
  final int sideFlex;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= breakpoint) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: mainFlex, child: main),
                SizedBox(width: spacing),
                Expanded(flex: sideFlex, child: side),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              main,
              SizedBox(height: spacing),
              side,
            ],
          );
        },
      );
}
