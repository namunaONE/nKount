import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../themes/clay_theme.dart';
import 'clay_button.dart';

/// Claymorphism App Bar Types
enum ClayAppBarType {
  primary,
  secondary,
  transparent,
  surface,
}

/// Claymorphism App Bar Sizes
enum ClayAppBarSize {
  sm,
  md,
  lg,
}

/// A Claymorphism-styled app bar widget
class ClayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? flexibleSpace;
  final Widget? bottom;
  final ClayAppBarType type;
  final ClayAppBarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final double? elevation;
  final double? height;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final TextStyle? titleStyle;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final PreferredSizeWidget? bottomPreferredSize;
  final bool hasInnerShadow;
  final bool hasOuterShadow;

  const ClayAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleText,
    this.actions,
    this.leading,
    this.flexibleSpace,
    this.bottom,
    this.type = ClayAppBarType.primary,
    this.size = ClayAppBarSize.md,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation = 4,
    this.height,
    this.titlePadding,
    this.actionsPadding,
    this.leadingPadding,
    this.titleStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.bottomPreferredSize,
    this.hasInnerShadow = true,
    this.hasOuterShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get app bar colors based on type
    final appBarColors = _getAppBarColors(context, type);
    
    // Get dimensions based on app bar size
    final appBarDimensions = _getAppBarDimensions(size);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? appBarColors.background;
    
    // Get effective foreground color
    final effectiveForegroundColor = foregroundColor ?? appBarColors.foreground;
    
    // Get effective elevation
    final effectiveElevation = elevation ?? appBarDimensions.elevation;
    
    // Get effective height
    final effectiveHeight = height ?? appBarDimensions.height;
    
    // Get effective title style
    final effectiveTitleStyle = titleStyle ?? ClayTextStyles.appBarTitle.copyWith(
      color: effectiveForegroundColor,
    );
    
    // Get effective icon theme
    final effectiveIconTheme = iconTheme ?? IconThemeData(
      color: effectiveForegroundColor,
      size: appBarDimensions.iconSize,
    );
    
    // Get effective actions icon theme
    final effectiveActionsIconTheme = actionsIconTheme ?? IconThemeData(
      color: effectiveForegroundColor,
      size: appBarDimensions.iconSize,
    );
    
    // Get effective title padding
    final effectiveTitlePadding = titlePadding ?? appBarDimensions.titlePadding;
    
    // Get effective actions padding
    final effectiveActionsPadding = actionsPadding ?? appBarDimensions.actionsPadding;
    
    // Get effective leading padding
    final effectiveLeadingPadding = leadingPadding ?? appBarDimensions.leadingPadding;
    
    // Get effective title spacing
    final effectiveTitleSpacing = titleSpacing ?? appBarDimensions.titleSpacing;

    // Build the app bar
    return AppBar(
      title: titleWidget ?? title ?? (titleText != null ? Text(titleText!, style: effectiveTitleStyle) : null),
      actions: actions,
      leading: leading,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      shadowColor: shadowColor ?? Colors.black.withOpacity(0.1),
      elevation: effectiveElevation,
      titlePadding: effectiveTitlePadding,
      titleSpacing: effectiveTitleSpacing,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      iconTheme: effectiveIconTheme,
      actionsIconTheme: effectiveActionsIconTheme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    height ?? _getAppBarDimensions(size).height,
  );

  _AppBarColors _getAppBarColors(BuildContext context, ClayAppBarType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (type) {
      case ClayAppBarType.primary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.secondary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.transparent:
        return _AppBarColors(
          background: Colors.transparent,
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.surface:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
    }
  }

  _AppBarDimensions _getAppBarDimensions(ClayAppBarSize size) {
    switch (size) {
      case ClayAppBarSize.sm:
        return _AppBarDimensions(
          height: kToolbarHeight * 0.8,
          iconSize: 20,
          elevation: 2,
          titlePadding: const EdgeInsets.symmetric(horizontal: 8),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 4),
          titleSpacing: 8,
        );
      case ClayAppBarSize.md:
        return _AppBarDimensions(
          height: kToolbarHeight,
          iconSize: 24,
          elevation: 4,
          titlePadding: const EdgeInsets.symmetric(horizontal: 16),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 8),
          titleSpacing: 16,
        );
      case ClayAppBarSize.lg:
        return _AppBarDimensions(
          height: kToolbarHeight * 1.2,
          iconSize: 28,
          elevation: 6,
          titlePadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 12),
          titleSpacing: 24,
        );
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _AppBarColors {
  final Color background;
  final Color foreground;

  _AppBarColors({
    required this.background,
    required this.foreground,
  });
}

class _AppBarDimensions {
  final double height;
  final double iconSize;
  final double elevation;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry actionsPadding;
  final EdgeInsetsGeometry leadingPadding;
  final double titleSpacing;

  _AppBarDimensions({
    required this.height,
    required this.iconSize,
    required this.elevation,
    required this.titlePadding,
    required this.actionsPadding,
    required this.leadingPadding,
    required this.titleSpacing,
  });
}

/// Claymorphism Sliver App Bar
class ClaySliverAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? flexibleSpace;
  final Widget? expandedTitle;
  final Widget? collapsedTitle;
  final ClayAppBarType type;
  final ClayAppBarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? height;
  final double? collapsedHeight;
  final double? expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final bool hasInnerShadow;
  final bool hasOuterShadow;

  const ClaySliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleText,
    this.actions,
    this.leading,
    this.flexibleSpace,
    this.expandedTitle,
    this.collapsedTitle,
    this.type = ClayAppBarType.primary,
    this.size = ClayAppBarSize.md,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4,
    this.height,
    this.collapsedHeight,
    this.expandedHeight = 200,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.stretch = false,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.hasInnerShadow = true,
    this.hasOuterShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get app bar colors based on type
    final appBarColors = _getAppBarColors(context, type);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? appBarColors.background;
    
    // Get effective foreground color
    final effectiveForegroundColor = foregroundColor ?? appBarColors.foreground;
    
    // Get effective elevation
    final effectiveElevation = elevation ?? 4;
    
    // Get effective collapsed height
    final effectiveCollapsedHeight = collapsedHeight ?? kToolbarHeight;
    
    // Get effective title style
    final effectiveTitleStyle = ClayTextStyles.appBarTitle.copyWith(
      color: effectiveForegroundColor,
    );

    return SliverAppBar(
      title: collapsedTitle ?? titleWidget ?? title ?? (titleText != null ? Text(titleText!, style: effectiveTitleStyle) : null),
      actions: actions,
      leading: leading,
      flexibleSpace: flexibleSpace ?? expandedTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      collapsedHeight: effectiveCollapsedHeight,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      stretchTriggerOffset: 100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(ClayTheme.radiusXl),
        ),
      ),
    );
  }

  _AppBarColors _getAppBarColors(BuildContext context, ClayAppBarType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (type) {
      case ClayAppBarType.primary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.secondary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.transparent:
        return _AppBarColors(
          background: Colors.transparent,
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.surface:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Claymorphism Tab Bar
class ClayTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double? indicatorWeight;
  final double? indicatorPadding;
  final EdgeInsetsGeometry? indicatorMargin;
  final bool isScrollable;
  final TabBarIndicatorSize? indicatorSize;
  final double? height;

  const ClayTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 2,
    this.indicatorPadding = 4,
    this.indicatorMargin,
    this.isScrollable = false,
    this.indicatorSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? _hexToColor(ClaySemanticColors.surfaceSecondary);
    
    // Get effective indicator color
    final effectiveIndicatorColor = indicatorColor ?? _hexToColor(ClaySemanticColors.brandPrimary);
    
    // Get effective label color
    final effectiveLabelColor = labelColor ?? _hexToColor(ClaySemanticColors.textPrimary);
    
    // Get effective unselected label color
    final effectiveUnselectedLabelColor = unselectedLabelColor ?? _hexToColor(ClaySemanticColors.textSecondary);
    
    // Get effective indicator margin
    final effectiveIndicatorMargin = indicatorMargin ?? const EdgeInsets.symmetric(horizontal: 16);

    return Container(
      color: effectiveBackgroundColor,
      child: TabBar(
        tabs: tabs,
        controller: controller,
        indicatorColor: effectiveIndicatorColor,
        labelColor: effectiveLabelColor,
        unselectedLabelColor: effectiveUnselectedLabelColor,
        indicatorWeight: indicatorWeight,
        indicatorPadding: EdgeInsets.symmetric(horizontal: indicatorPadding!),
        indicatorMargin: effectiveIndicatorMargin,
        isScrollable: isScrollable,
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
        labelStyle: ClayTextStyles.tabLabel,
        unselectedLabelStyle: ClayTextStyles.tabLabel.copyWith(
          color: effectiveUnselectedLabelColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    height ?? kTextTabBarHeight,
  );

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Claymorphism Bottom Navigation Bar
class ClayBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ClayBottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final double? height;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  const ClayBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.height,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? _hexToColor(ClaySemanticColors.surfacePrimary);
    
    // Get effective selected item color
    final effectiveSelectedItemColor = selectedItemColor ?? _hexToColor(ClaySemanticColors.brandPrimary);
    
    // Get effective unselected item color
    final effectiveUnselectedItemColor = unselectedItemColor ?? _hexToColor(ClaySemanticColors.textSecondary);
    
    // Get effective selected icon theme
    final effectiveSelectedIconTheme = selectedIconTheme ?? IconThemeData(
      color: effectiveSelectedItemColor,
      size: 24,
    );
    
    // Get effective unselected icon theme
    final effectiveUnselectedIconTheme = unselectedIconTheme ?? IconThemeData(
      color: effectiveUnselectedItemColor,
      size: 24,
    );
    
    // Get effective selected label style
    final effectiveSelectedLabelStyle = selectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveSelectedItemColor,
    );
    
    // Get effective unselected label style
    final effectiveUnselectedLabelStyle = unselectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveUnselectedItemColor,
    );

    return Container(
      height: height ?? kBottomNavigationBarHeight,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ClayTheme.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, -4),
            spreadRadius: 0,
            inset: true,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items
            .asMap()
            .entries
            .map((entry) => BottomNavigationBarItem(
                  icon: entry.value.icon,
                  activeIcon: entry.value.activeIcon ?? entry.value.icon,
                  label: entry.value.label,
                  backgroundColor: Colors.transparent,
                ))
            .toList(),
        backgroundColor: Colors.transparent,
        selectedItemColor: effectiveSelectedItemColor,
        unselectedItemColor: effectiveUnselectedItemColor,
        elevation: 0,
        selectedIconTheme: effectiveSelectedIconTheme,
        unselectedIconTheme: effectiveUnselectedIconTheme,
        selectedLabelStyle: effectiveSelectedLabelStyle,
        unselectedLabelStyle: effectiveUnselectedLabelStyle,
        showSelectedLabels: showSelectedLabels,
        showUnselectedLabels: showUnselectedLabels,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Claymorphism Bottom Navigation Bar Item
class ClayBottomNavigationBarItem {
  final Widget icon;
  final Widget? activeIcon;
  final String? label;
  final String? semanticLabel;
  final Color? backgroundColor;

  const ClayBottomNavigationBarItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.semanticLabel,
    this.backgroundColor,
  });
}

/// Claymorphism Toolbar
class ClayToolbar extends StatelessWidget {
  final Widget? title;
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final ClayAppBarType type;
  final ClayAppBarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const ClayToolbar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleText,
    this.actions,
    this.leading,
    this.type = ClayAppBarType.secondary,
    this.size = ClayAppBarSize.md,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get app bar colors based on type
    final appBarColors = _getAppBarColors(context, type);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? appBarColors.background;
    
    // Get effective foreground color
    final effectiveForegroundColor = foregroundColor ?? appBarColors.foreground;
    
    // Get effective height
    final effectiveHeight = height ?? _getAppBarDimensions(size).height;
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);
    
    // Get effective title style
    final effectiveTitleStyle = ClayTextStyles.toolbarTitle.copyWith(
      color: effectiveForegroundColor,
    );

    return Container(
      height: effectiveHeight,
      color: effectiveBackgroundColor,
      padding: effectivePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: titleWidget ?? title ?? (titleText != null ? Text(titleText!, style: effectiveTitleStyle) : null) ?? const SizedBox.shrink(),
          ),
          if (actions != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!
                  .asMap()
                  .entries
                  .map((entry) {
                    if (entry.key > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: entry.value,
                      );
                    }
                    return entry.value;
                  })
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  _AppBarColors _getAppBarColors(BuildContext context, ClayAppBarType type) {
    switch (type) {
      case ClayAppBarType.primary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.secondary:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.transparent:
        return _AppBarColors(
          background: Colors.transparent,
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
      case ClayAppBarType.surface:
        return _AppBarColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
        );
    }
  }

  _AppBarDimensions _getAppBarDimensions(ClayAppBarSize size) {
    switch (size) {
      case ClayAppBarSize.sm:
        return _AppBarDimensions(
          height: kToolbarHeight * 0.8,
          iconSize: 20,
          elevation: 2,
          titlePadding: const EdgeInsets.symmetric(horizontal: 8),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 4),
          titleSpacing: 8,
        );
      case ClayAppBarSize.md:
        return _AppBarDimensions(
          height: kToolbarHeight,
          iconSize: 24,
          elevation: 4,
          titlePadding: const EdgeInsets.symmetric(horizontal: 16),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 8),
          titleSpacing: 16,
        );
      case ClayAppBarSize.lg:
        return _AppBarDimensions(
          height: kToolbarHeight * 1.2,
          iconSize: 28,
          elevation: 6,
          titlePadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
          leadingPadding: const EdgeInsets.symmetric(horizontal: 12),
          titleSpacing: 24,
        );
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
