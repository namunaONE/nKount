import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../themes/clay_theme.dart';

/// Claymorphism Button Types
enum ClayButtonType {
  primary,
  secondary,
  tertiary,
  success,
  warning,
  error,
  text,
  icon,
}

/// Claymorphism Button Sizes
enum ClayButtonSize {
  sm,
  md,
  lg,
  xl,
}

/// A Claymorphism-styled button widget with press animations
class ClayButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final ClayButtonType type;
  final ClayButtonSize size;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BoxShadow? outerShadow;
  final BoxShadow? innerShadow;
  final Duration animationDuration;
  final Curve animationCurve;

  const ClayButton({
    super.key,
    this.text,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.type = ClayButtonType.primary,
    this.size = ClayButtonSize.md,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.outerShadow,
    this.innerShadow,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOutCirc,
  }) : assert(
          text != null || icon != null || leadingIcon != null || trailingIcon != null,
          'Button must have at least one child: text, icon, leadingIcon, or trailingIcon',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !isDisabled && !isLoading;
    
    // Get colors based on button type
    final buttonColors = _getButtonColors(context, type, isEnabled);
    
    // Get dimensions based on button size
    final buttonDimensions = _getButtonDimensions(size);
    
    // Get shadows for Claymorphism effect
    final shadows = _getButtonShadows(context, type, isEnabled);
    
    // Get border radius
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(ClayTheme.radiusLg);
    
    // Get padding
    final effectivePadding = padding ?? 
        EdgeInsets.symmetric(
          horizontal: buttonDimensions.horizontalPadding,
          vertical: buttonDimensions.verticalPadding,
        );
    
    // Get margin
    final effectiveMargin = margin ?? EdgeInsets.zero;

    return AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      margin: effectiveMargin,
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: AnimatedScale(
        duration: Duration(milliseconds: isLoading ? 0 : animationDuration ~/ 2),
        scale: isLoading ? 0.98 : 1.0,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          onLongPress: isEnabled ? onLongPress : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? buttonColors.background,
            foregroundColor: foregroundColor ?? buttonColors.foreground,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
            ),
            disabledBackgroundColor: buttonColors.disabledBackground,
            disabledForegroundColor: buttonColors.disabledForeground,
          ).copyWith(
            shadow: shadows,
          ),
          child: isLoading
              ? SizedBox(
                  width: buttonDimensions.loadingSize,
                  height: buttonDimensions.loadingSize,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      foregroundColor ?? buttonColors.foreground,
                    ),
                    strokeWidth: 2.0,
                  ),
                )
              : _buildButtonChild(
                  context,
                  buttonColors,
                  buttonDimensions,
                ),
        ),
      ),
    );
  }

  Widget _buildButtonChild(
    BuildContext context,
    _ButtonColors colors,
    _ButtonDimensions dimensions,
  ) {
    final children = <Widget>[];
    
    // Leading icon
    if (leadingIcon != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(right: dimensions.iconSpacing),
          child: leadingIcon!,
        ),
      );
    }
    
    // Icon only (if no text)
    if (icon != null && text == null) {
      children.add(icon!);
    }
    
    // Text
    if (text != null) {
      children.add(
        Text(
          text!,
          style: textStyle ?? _getTextStyle(context, type, dimensions),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    
    // Icon with text
    if (icon != null && text != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(left: dimensions.iconSpacing),
          child: icon!,
        ),
      );
    }
    
    // Trailing icon
    if (trailingIcon != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(left: dimensions.iconSpacing),
          child: trailingIcon!,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  _ButtonColors _getButtonColors(
    BuildContext context,
    ClayButtonType type,
    bool isEnabled,
  ) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    switch (type) {
      case ClayButtonType.primary:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.brandPrimary) 
              : _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.4),
          foreground: _hexToColor(ClaySemanticColors.textOnPrimary),
          disabledBackground: _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.4),
          disabledForeground: _hexToColor(ClaySemanticColors.textOnPrimary).withOpacity(0.6),
        );
      case ClayButtonType.secondary:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.surfaceSecondary) 
              : _hexToColor(ClaySemanticColors.surfaceSecondary).withOpacity(0.6),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
          disabledBackground: _hexToColor(ClaySemanticColors.surfaceSecondary).withOpacity(0.6),
          disabledForeground: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayButtonType.tertiary:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.surfaceTertiary) 
              : _hexToColor(ClaySemanticColors.surfaceTertiary).withOpacity(0.6),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
          disabledBackground: _hexToColor(ClaySemanticColors.surfaceTertiary).withOpacity(0.6),
          disabledForeground: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayButtonType.success:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.statusSuccess) 
              : _hexToColor(ClaySemanticColors.statusSuccess).withOpacity(0.4),
          foreground: _hexToColor(ClaySemanticColors.textOnSuccess),
          disabledBackground: _hexToColor(ClaySemanticColors.statusSuccess).withOpacity(0.4),
          disabledForeground: _hexToColor(ClaySemanticColors.textOnSuccess).withOpacity(0.6),
        );
      case ClayButtonType.warning:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.statusWarning) 
              : _hexToColor(ClaySemanticColors.statusWarning).withOpacity(0.4),
          foreground: _hexToColor(ClaySemanticColors.textOnWarning),
          disabledBackground: _hexToColor(ClaySemanticColors.statusWarning).withOpacity(0.4),
          disabledForeground: _hexToColor(ClaySemanticColors.textOnWarning).withOpacity(0.6),
        );
      case ClayButtonType.error:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.statusError) 
              : _hexToColor(ClaySemanticColors.statusError).withOpacity(0.4),
          foreground: _hexToColor(ClaySemanticColors.textOnError),
          disabledBackground: _hexToColor(ClaySemanticColors.statusError).withOpacity(0.4),
          disabledForeground: _hexToColor(ClaySemanticColors.textOnError).withOpacity(0.6),
        );
      case ClayButtonType.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isEnabled 
              ? _hexToColor(ClaySemanticColors.textPrimary) 
              : _hexToColor(ClaySemanticColors.textSecondary),
          disabledBackground: Colors.transparent,
          disabledForeground: _hexToColor(ClaySemanticColors.textSecondary),
        );
      case ClayButtonType.icon:
        return _ButtonColors(
          background: isEnabled 
              ? _hexToColor(ClaySemanticColors.surfacePrimary) 
              : _hexToColor(ClaySemanticColors.surfacePrimary).withOpacity(0.6),
          foreground: _hexToColor(ClaySemanticColors.textPrimary),
          disabledBackground: _hexToColor(ClaySemanticColors.surfacePrimary).withOpacity(0.6),
          disabledForeground: _hexToColor(ClaySemanticColors.textSecondary),
        );
    }
  }

  _ButtonDimensions _getButtonDimensions(ClayButtonSize size) {
    switch (size) {
      case ClayButtonSize.sm:
        return _ButtonDimensions(
          height: 32.0,
          horizontalPadding: 12.0,
          verticalPadding: 6.0,
          fontSize: ClayTypography.fontSizeSm,
          iconSize: 16.0,
          iconSpacing: 6.0,
          loadingSize: 16.0,
        );
      case ClayButtonSize.md:
        return _ButtonDimensions(
          height: 40.0,
          horizontalPadding: 16.0,
          verticalPadding: 8.0,
          fontSize: ClayTypography.fontSizeBase,
          iconSize: 18.0,
          iconSpacing: 8.0,
          loadingSize: 18.0,
        );
      case ClayButtonSize.lg:
        return _ButtonDimensions(
          height: 48.0,
          horizontalPadding: 20.0,
          verticalPadding: 10.0,
          fontSize: ClayTypography.fontSizeLg,
          iconSize: 20.0,
          iconSpacing: 10.0,
          loadingSize: 20.0,
        );
      case ClayButtonSize.xl:
        return _ButtonDimensions(
          height: 56.0,
          horizontalPadding: 24.0,
          verticalPadding: 12.0,
          fontSize: ClayTypography.fontSizeXl,
          iconSize: 24.0,
          iconSpacing: 12.0,
          loadingSize: 24.0,
        );
    }
  }

  TextStyle _getTextStyle(
    BuildContext context,
    ClayButtonType type,
    _ButtonDimensions dimensions,
  ) {
    final colors = _getButtonColors(context, type, true);
    
    switch (type) {
      case ClayButtonType.primary:
        return ClayTextStyles.buttonPrimary.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.secondary:
        return ClayTextStyles.buttonSecondary.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.tertiary:
        return ClayTextStyles.buttonTertiary.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.success:
        return ClayTextStyles.buttonSuccess.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.warning:
        return ClayTextStyles.buttonWarning.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.error:
        return ClayTextStyles.buttonError.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.text:
        return ClayTextStyles.buttonText.copyWith(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
      case ClayButtonType.icon:
        return TextStyle(
          fontSize: dimensions.fontSize,
          color: colors.foreground,
        );
    }
  }

  List<BoxShadow> _getButtonShadows(
    BuildContext context,
    ClayButtonType type,
    bool isEnabled,
  ) {
    if (!isEnabled) {
      return [
        BoxShadow(
          color: Colors.transparent,
          blurRadius: 0,
          offset: Offset.zero,
        ),
      ];
    }
    
    // Claymorphism: Dual shadows (outer + inner)
    final outerShadow = BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    );
    
    final innerShadow = BoxShadow(
      color: Colors.white.withOpacity(0.4),
      blurRadius: 4,
      offset: const Offset(0, 2),
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

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
  });
}

class _ButtonDimensions {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;
  final double iconSpacing;
  final double loadingSize;

  _ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.iconSpacing,
    required this.loadingSize,
  });
}

/// Icon Button with Claymorphism styling
class ClayIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final ClayButtonType type;
  final ClayButtonSize size;
  final bool isDisabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final String? tooltip;
  final Duration animationDuration;

  const ClayIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.type = ClayButtonType.icon,
    this.size = ClayButtonSize.md,
    this.isDisabled = false,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final button = ClayButton(
      icon: isLoading 
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? _hexToColor(ClaySemanticColors.textPrimary),
                ),
                strokeWidth: 2.0,
              ),
            )
          : icon,
      type: type,
      size: size,
      onPressed: isDisabled || isLoading ? null : onPressed,
      isDisabled: isDisabled || isLoading,
      isLoading: false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius ?? BorderRadius.circular(ClayTheme.radiusMd),
      animationDuration: animationDuration,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    
    return button;
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Floating Action Button with Claymorphism styling
class ClayFAB extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final ClayButtonType type;
  final bool isExtended;
  final String? label;
  final bool isDisabled;
  final bool isLoading;

  const ClayFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.type = ClayButtonType.primary,
    this.isExtended = false,
    this.label,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = FloatingActionButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      backgroundColor: isDisabled 
          ? _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.4)
          : _hexToColor(ClaySemanticColors.brandPrimary),
      foregroundColor: _hexToColor(ClaySemanticColors.textOnPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
      ),
      elevation: 8,
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _hexToColor(ClaySemanticColors.textOnPrimary),
              ),
              strokeWidth: 2.0,
            )
          : icon,
    );

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: isDisabled || isLoading ? null : onPressed,
        label: Text(label!),
        icon: isLoading ? null : icon,
        backgroundColor: isDisabled 
            ? _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.4)
            : _hexToColor(ClaySemanticColors.brandPrimary),
        foregroundColor: _hexToColor(ClaySemanticColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
        elevation: 8,
      );
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
