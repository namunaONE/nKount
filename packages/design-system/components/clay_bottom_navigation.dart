import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../themes/clay_theme.dart';
import 'clay_button.dart';

/// Claymorphism Bottom Navigation Types
enum ClayBottomNavType {
  primary,
  secondary,
  floating,
}

/// Claymorphism Bottom Navigation Item
class ClayBottomNavItem {
  final Widget icon;
  final Widget? activeIcon;
  final String? label;
  final String? semanticLabel;
  final Color? iconColor;
  final Color? activeIconColor;
  final Color? labelColor;
  final Color? activeLabelColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const ClayBottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.semanticLabel,
    this.iconColor,
    this.activeIconColor,
    this.labelColor,
    this.activeLabelColor,
    this.iconSize,
    this.padding,
  });
}

/// A Claymorphism-styled bottom navigation bar
class ClayBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ClayBottomNavItem> items;
  final ClayBottomNavType type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showLabels;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final Duration animationDuration;
  final Curve animationCurve;

  const ClayBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.type = ClayBottomNavType.primary,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.showLabels = true,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOutCirc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get bottom nav colors based on type
    final bottomNavColors = _getBottomNavColors(context, type);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? bottomNavColors.background;
    
    // Get effective selected item color
    final effectiveSelectedItemColor = selectedItemColor ?? bottomNavColors.selectedItem;
    
    // Get effective unselected item color
    final effectiveUnselectedItemColor = unselectedItemColor ?? bottomNavColors.unselectedItem;
    
    // Get effective height
    final effectiveHeight = height ?? kBottomNavigationBarHeight;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.vertical(
      top: Radius.circular(ClayTheme.radiusXl),
    );
    
    // Get effective margin
    final effectiveMargin = margin ?? EdgeInsets.zero;
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.symmetric(vertical: 4);
    
    // Get effective selected label style
    final effectiveSelectedLabelStyle = selectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveSelectedItemColor,
      fontWeight: FontWeight.bold,
    );
    
    // Get effective unselected label style
    final effectiveUnselectedLabelStyle = unselectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveUnselectedItemColor,
    );

    return Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items
            .asMap()
            .entries
            .map((entry) => _buildNavItem(
                  context,
                  entry.value,
                  entry.key,
                  effectiveSelectedItemColor,
                  effectiveUnselectedItemColor,
                  effectiveSelectedLabelStyle,
                  effectiveUnselectedLabelStyle,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    ClayBottomNavItem item,
    int index,
    Color selectedColor,
    Color unselectedColor,
    TextStyle selectedLabelStyle,
    TextStyle unselectedLabelStyle,
  ) {
    final isSelected = index == currentIndex;
    final iconColor = isSelected 
        ? (item.activeIconColor ?? selectedColor) 
        : (item.iconColor ?? unselectedColor);
    final labelColor = isSelected 
        ? (item.activeLabelColor ?? selectedColor) 
        : (item.labelColor ?? unselectedColor);
    final effectiveIconSize = item.iconSize ?? 24;
    final effectivePadding = item.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

    return AnimatedScale(
      duration: animationDuration,
      curve: animationCurve,
      scale: isSelected ? 1.1 : 1.0,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: effectiveIconSize,
                ),
                child: isSelected && item.activeIcon != null 
                    ? item.activeIcon! 
                    : item.icon,
              ),
              if (showLabels && (showSelectedLabels || isSelected) && (showUnselectedLabels || !isSelected) && item.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.label!,
                  style: isSelected ? selectedLabelStyle : unselectedLabelStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _BottomNavColors _getBottomNavColors(BuildContext context, ClayBottomNavType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (type) {
      case ClayBottomNavType.primary:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayBottomNavType.secondary:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayBottomNavType.floating:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
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

class _BottomNavColors {
  final Color background;
  final Color selectedItem;
  final Color unselectedItem;

  _BottomNavColors({
    required this.background,
    required this.selectedItem,
    required this.unselectedItem,
  });
}

/// Claymorphism Floating Action Button with Navigation
class ClayNavFAB extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ClayBottomNavItem> items;
  final Widget? fabIcon;
  final Widget? fabLabel;
  final Color? fabBackgroundColor;
  final Color? fabForegroundColor;
  final double? fabElevation;
  final double? fabSize;
  final BorderRadiusGeometry? fabBorderRadius;
  final bool fabExtended;

  const ClayNavFAB({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.fabIcon,
    this.fabLabel,
    this.fabBackgroundColor,
    this.fabForegroundColor,
    this.fabElevation = 8,
    this.fabSize = 56,
    this.fabBorderRadius,
    this.fabExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get effective FAB background color
    final effectiveFabBackgroundColor = fabBackgroundColor ?? _hexToColor(ClaySemanticColors.brandPrimary);
    
    // Get effective FAB foreground color
    final effectiveFabForegroundColor = fabForegroundColor ?? _hexToColor(ClaySemanticColors.textOnPrimary);
    
    // Get effective FAB border radius
    final effectiveFabBorderRadius = fabBorderRadius ?? BorderRadius.circular(ClayTheme.radiusLg);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClayFAB(
          icon: fabIcon ?? const Icon(Icons.add),
          label: fabLabel,
          type: ClayButtonType.primary,
          isExtended: fabExtended,
          onPressed: () {
            // Default behavior: open the first item
            if (items.isNotEmpty) {
              onTap(0);
            }
          },
        ),
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
        type: ClayBottomNavType.floating,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ClayTheme.radius2Xl),
        ),
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.only(top: 8),
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

/// Claymorphism Navigation Rail
class ClayNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ClayBottomNavItem> items;
  final ClayBottomNavType type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showLabels;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget? leading;
  final Widget? trailing;

  const ClayNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.type = ClayBottomNavType.primary,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 4,
    this.width = 80,
    this.borderRadius,
    this.margin,
    this.padding,
    this.showLabels = true,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOutCirc,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get bottom nav colors based on type
    final bottomNavColors = _getBottomNavColors(context, type);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? bottomNavColors.background;
    
    // Get effective selected item color
    final effectiveSelectedItemColor = selectedItemColor ?? bottomNavColors.selectedItem;
    
    // Get effective unselected item color
    final effectiveUnselectedItemColor = unselectedItemColor ?? bottomNavColors.unselectedItem;
    
    // Get effective width
    final effectiveWidth = width ?? 80;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ClayTheme.radiusLg);
    
    // Get effective margin
    final effectiveMargin = margin ?? EdgeInsets.zero;
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.symmetric(vertical: 8);
    
    // Get effective selected label style
    final effectiveSelectedLabelStyle = selectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveSelectedItemColor,
      fontWeight: FontWeight.bold,
    );
    
    // Get effective unselected label style
    final effectiveUnselectedLabelStyle = unselectedLabelStyle ?? ClayTextStyles.navLabel.copyWith(
      color: effectiveUnselectedItemColor,
    );

    return Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      width: effectiveWidth,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(8, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(4, 0),
            spreadRadius: 0,
            inset: true,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(height: 16),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .asMap()
                    .entries
                    .map((entry) => _buildNavItem(
                          context,
                          entry.value,
                          entry.key,
                          effectiveSelectedItemColor,
                          effectiveUnselectedItemColor,
                          effectiveSelectedLabelStyle,
                          effectiveUnselectedLabelStyle,
                        ))
                    .toList(),
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(height: 16),
            trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    ClayBottomNavItem item,
    int index,
    Color selectedColor,
    Color unselectedColor,
    TextStyle selectedLabelStyle,
    TextStyle unselectedLabelStyle,
  ) {
    final isSelected = index == currentIndex;
    final iconColor = isSelected 
        ? (item.activeIconColor ?? selectedColor) 
        : (item.iconColor ?? unselectedColor);
    final labelColor = isSelected 
        ? (item.activeLabelColor ?? selectedColor) 
        : (item.labelColor ?? unselectedColor);
    final effectiveIconSize = item.iconSize ?? 24;
    final effectivePadding = item.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 12);

    return AnimatedScale(
      duration: animationDuration,
      curve: animationCurve,
      scale: isSelected ? 1.1 : 1.0,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: effectiveIconSize,
                ),
                child: isSelected && item.activeIcon != null 
                    ? item.activeIcon! 
                    : item.icon,
              ),
              if (showLabels && (showSelectedLabels || isSelected) && (showUnselectedLabels || !isSelected) && item.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.label!,
                  style: isSelected ? selectedLabelStyle : unselectedLabelStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _BottomNavColors _getBottomNavColors(BuildContext context, ClayBottomNavType type) {
    switch (type) {
      case ClayBottomNavType.primary:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayBottomNavType.secondary:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayBottomNavType.floating:
        return _BottomNavColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          selectedItem: _hexToColor(ClaySemanticColors.brandPrimary),
          unselectedItem: _hexToColor(ClaySemanticColors.textSecondary),
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

/// Claymorphism Navigation Drawer
class ClayNavigationDrawer extends StatelessWidget {
  final Widget? header;
  final List<Widget> children;
  final Color? backgroundColor;
  final double? elevation;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const ClayNavigationDrawer({
    super.key,
    this.header,
    required this.children,
    this.backgroundColor,
    this.elevation = 16,
    this.width,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? _hexToColor(ClaySemanticColors.surfacePrimary);
    
    // Get effective width
    final effectiveWidth = width ?? MediaQuery.of(context).size.width * 0.7;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.zero;
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.all(16);

    return Container(
      width: effectiveWidth,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(16, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(8, 0),
            spreadRadius: 0,
            inset: true,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            header!,
            const SizedBox(height: 16),
          ],
          Expanded(
            child: SingleChildScrollView(
              padding: effectivePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
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

/// Claymorphism Navigation Drawer Header
class ClayDrawerHeader extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const ClayDrawerHeader({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? _hexToColor(ClaySemanticColors.brandPrimary);
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.all(20);
    
    // Get effective margin
    final effectiveMargin = margin ?? EdgeInsets.zero;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.zero;

    return Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
      ),
      child: child ?? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(height: 12),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: ClayTextStyles.drawerHeaderTitle.copyWith(
                color: _hexToColor(ClaySemanticColors.textOnPrimary),
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: ClayTextStyles.drawerHeaderSubtitle.copyWith(
                color: _hexToColor(ClaySemanticColors.textOnPrimary).withOpacity(0.8),
              ),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(height: 12),
            trailing!,
          ],
        ],
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
