import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../themes/clay_theme.dart';

/// Claymorphism Card Types
enum ClayCardType {
  primary,
  secondary,
  tertiary,
  elevated,
  outlined,
  filled,
}

/// Claymorphism Card Sizes
enum ClayCardSize {
  sm,
  md,
  lg,
  custom,
}

/// A Claymorphism-styled card widget with dual shadows and soft 3D appearance
class ClayCard extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final ClayCardType type;
  final ClayCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final bool hasInnerShadow;
  final bool hasOuterShadow;
  final double elevation;
  final bool isClickable;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration animationDuration;
  final Curve animationCurve;

  const ClayCard({
    super.key,
    this.child,
    this.children,
    this.type = ClayCardType.primary,
    this.size = ClayCardSize.md,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
    this.constraints,
    this.gradient,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.hasInnerShadow = true,
    this.hasOuterShadow = true,
    this.elevation = 4,
    this.isClickable = false,
    this.onTap,
    this.onLongPress,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOutCirc,
  }) : assert(
          child != null || children != null,
          'Card must have either child or children',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Get card colors based on type
    final cardColors = _getCardColors(context, type);
    
    // Get dimensions based on card size
    final cardDimensions = _getCardDimensions(size);
    
    // Get effective padding
    final effectivePadding = padding ?? cardDimensions.padding;
    
    // Get effective margin
    final effectiveMargin = margin ?? cardDimensions.margin;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? cardDimensions.borderRadius;
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? cardColors.background;
    
    // Get effective border color
    final effectiveBorderColor = borderColor ?? cardColors.border;
    
    // Get shadows for Claymorphism effect
    final effectiveShadows = shadows ?? _getCardShadows(context, type);
    
    // Build the card content
    final cardContent = Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: effectiveMargin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        gradient: gradient,
        border: effectiveBorderColor != Colors.transparent 
            ? Border.all(color: effectiveBorderColor, width: 1.0)
            : null,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadows,
      ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: effectivePadding,
        child: child ?? Column(
          mainAxisSize: MainAxisSize.min,
          children: children ?? [],
        ),
      ),
    );

    // Wrap with animation if clickable
    if (isClickable) {
      return AnimatedScale(
        duration: animationDuration,
        curve: animationCurve,
        scale: _isPressed ? 0.98 : 1.0,
        child: GestureDetector(
          onTapDown: (_) => _isPressed = true,
          onTapUp: (_) => _isPressed = false,
          onTapCancel: () => _isPressed = false,
          onTap: onTap,
          onLongPress: onLongPress,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }

  bool _isPressed = false;

  _CardColors _getCardColors(BuildContext context, ClayCardType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (type) {
      case ClayCardType.primary:
        return _CardColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          border: Colors.transparent,
        );
      case ClayCardType.secondary:
        return _CardColors(
          background: _hexToColor(ClaySemanticColors.surfaceSecondary),
          border: Colors.transparent,
        );
      case ClayCardType.tertiary:
        return _CardColors(
          background: _hexToColor(ClaySemanticColors.surfaceTertiary),
          border: Colors.transparent,
        );
      case ClayCardType.elevated:
        return _CardColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          border: Colors.transparent,
        );
      case ClayCardType.outlined:
        return _CardColors(
          background: Colors.transparent,
          border: _hexToColor(ClaySemanticColors.borderPrimary),
        );
      case ClayCardType.filled:
        return _CardColors(
          background: _hexToColor(ClaySemanticColors.surfaceFilled),
          border: Colors.transparent,
        );
    }
  }

  _CardDimensions _getCardDimensions(ClayCardSize size) {
    switch (size) {
      case ClayCardSize.sm:
        return _CardDimensions(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(4),
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        );
      case ClayCardSize.md:
        return _CardDimensions(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        );
      case ClayCardSize.lg:
        return _CardDimensions(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(ClayTheme.radiusXl),
        );
      case ClayCardSize.custom:
        return _CardDimensions(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        );
    }
  }

  List<BoxShadow> _getCardShadows(BuildContext context, ClayCardType type) {
    // Claymorphism: Dual shadows (outer + inner)
    final outerShadow = BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    );
    
    final innerShadow = BoxShadow(
      color: Colors.white.withOpacity(0.4),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
      inset: true,
    );
    
    return [outerShadow, innerShadow];
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _CardColors {
  final Color background;
  final Color border;

  _CardColors({
    required this.background,
    required this.border,
  });
}

class _CardDimensions {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  _CardDimensions({
    required this.padding,
    required this.margin,
    required this.borderRadius,
  });
}

/// Claymorphism Card Header
class ClayCardHeader extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double gap;

  const ClayCardHeader({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: 12),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    
    if (leading != null) {
      children.add(leading!);
    }
    
    if (title != null || subtitle != null) {
      final titleColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) title!,
          if (subtitle != null) subtitle!,
        ].where((w) => w != null).map((w) => w!).toList(),
      );
      children.add(titleColumn);
    }
    
    if (trailing != null) {
      children.add(trailing!);
    }

    return Padding(
      padding: padding!,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children
            .asMap()
            .entries
            .map((entry) {
              if (entry.key > 0) {
                return Padding(
                  padding: EdgeInsets.only(left: gap),
                  child: entry.value,
                );
              }
              return entry.value;
            })
            .toList(),
      ),
    );
  }
}

/// Claymorphism Card Body
class ClayCardBody extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double gap;

  const ClayCardBody({
    super.key,
    this.child,
    this.children,
    this.padding = const EdgeInsets.only(top: 8, bottom: 8),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.gap = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveChildren = children ?? (child != null ? [child!] : []);
    
    if (effectiveChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding!,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: effectiveChildren
            .asMap()
            .entries
            .map((entry) {
              if (entry.key > 0) {
                return Padding(
                  padding: EdgeInsets.only(top: gap),
                  child: entry.value,
                );
              }
              return entry.value;
            })
            .toList(),
      ),
    );
  }
}

/// Claymorphism Card Footer
class ClayCardFooter extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double gap;

  const ClayCardFooter({
    super.key,
    this.child,
    this.children,
    this.padding = const EdgeInsets.only(top: 12),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveChildren = children ?? (child != null ? [child!] : []);
    
    if (effectiveChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding!,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: effectiveChildren
            .asMap()
            .entries
            .map((entry) {
              if (entry.key > 0) {
                return Padding(
                  padding: EdgeInsets.only(left: gap),
                  child: entry.value,
                );
              }
              return entry.value;
            })
            .toList(),
      ),
    );
  }
}

/// Claymorphism Card with Header, Body, Footer
class ClayCardComplete extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final ClayCardType type;
  final ClayCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final bool hasInnerShadow;
  final bool hasOuterShadow;
  final bool isClickable;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration animationDuration;

  const ClayCardComplete({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.type = ClayCardType.primary,
    this.size = ClayCardSize.md,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
    this.constraints,
    this.gradient,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.hasInnerShadow = true,
    this.hasOuterShadow = true,
    this.isClickable = false,
    this.onTap,
    this.onLongPress,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    
    if (header != null) {
      children.add(header!);
    }
    
    if (body != null) {
      children.add(body!);
    }
    
    if (footer != null) {
      children.add(footer!);
    }

    return ClayCard(
      children: children,
      type: type,
      size: size,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      width: width,
      height: height,
      constraints: constraints,
      gradient: gradient,
      shadows: shadows,
      clipBehavior: clipBehavior,
      hasInnerShadow: hasInnerShadow,
      hasOuterShadow: hasOuterShadow,
      isClickable: isClickable,
      onTap: onTap,
      onLongPress: onLongPress,
      animationDuration: animationDuration,
    );
  }
}

/// Claymorphism Stat Card for displaying metrics
class ClayStatCard extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconBackground;
  final Color? iconColor;
  final ClayCardType type;
  final ClayCardSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  const ClayStatCard({
    super.key,
    this.icon,
    this.label,
    this.value,
    this.subtitle,
    this.trailing,
    this.iconBackground,
    this.iconColor,
    this.type = ClayCardType.primary,
    this.size = ClayCardSize.md,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ClayCard(
      type: type,
      size: size,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      isClickable: onTap != null,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBackground ?? _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
              ),
              child: icon!,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null) ...[
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _hexToColor(ClaySemanticColors.textSecondary),
                        ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (value != null) ...[
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _hexToColor(ClaySemanticColors.textPrimary),
                        ),
                  ),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _hexToColor(ClaySemanticColors.textTertiary),
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
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
