import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../themes/clay_theme.dart';
import 'clay_button.dart';

/// Claymorphism Dialog Types
enum ClayDialogType {
  info,
  success,
  warning,
  error,
  confirm,
  custom,
}

/// Claymorphism Dialog Sizes
enum ClayDialogSize {
  sm,
  md,
  lg,
  full,
}

/// A Claymorphism-styled dialog widget
class ClayDialog extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final ClayDialogType type;
  final ClayDialogSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? contentColor;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final List<Widget>? actions;
  final Widget? icon;
  final bool showCloseButton;
  final bool scrollable;
  final bool barrierDismissible;
  final Color barrierColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final String? semanticLabel;
  final AlignmentGeometry? alignment;
  final Insets? insetPadding;
  final Clip clipBehavior;

  const ClayDialog({
    super.key,
    this.child,
    this.children,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.type = ClayDialogType.info,
    this.size = ClayDialogSize.md,
    this.padding,
    this.margin,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.borderRadius,
    this.backgroundColor,
    this.titleColor,
    this.contentColor,
    this.titleStyle,
    this.contentStyle,
    this.actions,
    this.icon,
    this.showCloseButton = true,
    this.scrollable = false,
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOutCirc,
    this.semanticLabel,
    this.alignment,
    this.insetPadding,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    // Get dialog colors based on type
    final dialogColors = _getDialogColors(context, type);
    
    // Get dimensions based on dialog size
    final dialogDimensions = _getDialogDimensions(context, size);
    
    // Get effective padding
    final effectivePadding = padding ?? dialogDimensions.padding;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? dialogDimensions.borderRadius;
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? dialogColors.background;
    
    // Get effective title color
    final effectiveTitleColor = titleColor ?? dialogColors.titleColor;
    
    // Get effective content color
    final effectiveContentColor = contentColor ?? dialogColors.contentColor;
    
    // Get effective title style
    final effectiveTitleStyle = titleStyle ?? ClayTextStyles.dialogTitle.copyWith(
      color: effectiveTitleColor,
    );
    
    // Get effective content style
    final effectiveContentStyle = contentStyle ?? ClayTextStyles.dialogContent.copyWith(
      color: effectiveContentColor,
    );
    
    // Build the dialog content
    final dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with icon and title
        if (icon != null || title != null || titleWidget != null) ...[
          Padding(
            padding: titlePadding ?? const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: dialogColors.iconBackground,
                      borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
                    ),
                    child: icon!,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: titleWidget ?? Text(
                    title ?? '',
                    style: effectiveTitleStyle,
                  ),
                ),
                if (showCloseButton) ...[
                  const SizedBox(width: 8),
                  ClayIconButton(
                    icon: Icon(
                      Icons.close,
                      color: _hexToColor(ClaySemanticColors.textSecondary),
                    ),
                    type: ClayButtonType.text,
                    size: ClayButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            ),
          ),
        ],
        
        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: contentPadding ?? const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (content != null) ...[
                  Text(
                    content!,
                    style: effectiveContentStyle,
                  ),
                  const SizedBox(height: 16),
                ],
                if (contentWidget != null) ...[
                  contentWidget!,
                  const SizedBox(height: 16),
                ],
                if (child != null) ...[
                  child!,
                  const SizedBox(height: 16),
                ],
                if (children != null) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children!,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        
        // Actions
        if (actions != null && actions!.isNotEmpty) ...[
          Padding(
            padding: actionsPadding ?? const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!
                  .asMap()
                  .entries
                  .map((entry) {
                    if (entry.key > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: entry.value,
                      );
                    }
                    return entry.value;
                  })
                  .toList(),
            ),
          ),
        ],
      ],
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: insetPadding ?? dialogDimensions.insetPadding,
      alignment: alignment ?? Alignment.center,
      clipBehavior: clipBehavior,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
              inset: true,
            ),
          ],
        ),
        child: dialogChild,
      ),
    );
  }

  _DialogColors _getDialogColors(BuildContext context, ClayDialogType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (type) {
      case ClayDialogType.info:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          titleColor: _hexToColor(ClaySemanticColors.textPrimary),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.1),
        );
      case ClayDialogType.success:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceSuccess),
          titleColor: _hexToColor(ClaySemanticColors.textSuccess),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusSuccess).withOpacity(0.1),
        );
      case ClayDialogType.warning:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceWarning),
          titleColor: _hexToColor(ClaySemanticColors.textWarning),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusWarning).withOpacity(0.1),
        );
      case ClayDialogType.error:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceError),
          titleColor: _hexToColor(ClaySemanticColors.textError),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusError).withOpacity(0.1),
        );
      case ClayDialogType.confirm:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          titleColor: _hexToColor(ClaySemanticColors.textPrimary),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.1),
        );
      case ClayDialogType.custom:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          titleColor: _hexToColor(ClaySemanticColors.textPrimary),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.surfaceSecondary),
        );
    }
  }

  _DialogDimensions _getDialogDimensions(BuildContext context, ClayDialogSize size) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    switch (size) {
      case ClayDialogSize.sm:
        return _DialogDimensions(
          maxWidth: screenWidth * 0.4,
          maxHeight: screenHeight * 0.4,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          insetPadding: const EdgeInsets.all(24),
        );
      case ClayDialogSize.md:
        return _DialogDimensions(
          maxWidth: screenWidth * 0.6,
          maxHeight: screenHeight * 0.6,
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(ClayTheme.radiusXl),
          insetPadding: const EdgeInsets.all(20),
        );
      case ClayDialogSize.lg:
        return _DialogDimensions(
          maxWidth: screenWidth * 0.8,
          maxHeight: screenHeight * 0.8,
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(ClayTheme.radiusXl),
          insetPadding: const EdgeInsets.all(16),
        );
      case ClayDialogSize.full:
        return _DialogDimensions(
          maxWidth: screenWidth * 0.95,
          maxHeight: screenHeight * 0.95,
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(ClayTheme.radius2Xl),
          insetPadding: const EdgeInsets.all(8),
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

class _DialogColors {
  final Color background;
  final Color titleColor;
  final Color contentColor;
  final Color iconBackground;

  _DialogColors({
    required this.background,
    required this.titleColor,
    required this.contentColor,
    required this.iconBackground,
  });
}

class _DialogDimensions {
  final double maxWidth;
  final double maxHeight;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets insets;

  _DialogDimensions({
    required this.maxWidth,
    required this.maxHeight,
    required this.padding,
    required this.borderRadius,
    required this.insetPadding,
  });
}

/// Claymorphism Alert Dialog
class ClayAlertDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final ClayDialogType type;
  final List<ClayDialogAction> actions;
  final bool showCloseButton;
  final bool barrierDismissible;
  final Color barrierColor;
  final Duration animationDuration;

  const ClayAlertDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.type = ClayDialogType.info,
    this.actions = const [],
    this.showCloseButton = true,
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return ClayDialog(
      title: title,
      titleWidget: titleWidget,
      content: content,
      contentWidget: contentWidget,
      type: type,
      showCloseButton: showCloseButton,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      animationDuration: animationDuration,
      actions: actions.map((action) => action.build(context)).toList(),
    );
  }
}

/// Claymorphism Dialog Action
class ClayDialogAction {
  final String text;
  final VoidCallback? onPressed;
  final ClayButtonType type;
  final bool isDisabled;
  final bool isLoading;
  final Widget? icon;

  const ClayDialogAction({
    required this.text,
    this.onPressed,
    this.type = ClayButtonType.primary,
    this.isDisabled = false,
    this.isLoading = false,
    this.icon,
  });

  Widget build(BuildContext context) {
    return ClayButton(
      text: text,
      type: type,
      onPressed: isDisabled || isLoading ? null : onPressed,
      isDisabled: isDisabled,
      isLoading: isLoading,
      icon: icon,
      size: ClayButtonSize.md,
    );
  }
}

/// Claymorphism Confirm Dialog
class ClayConfirmDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final Widget? contentWidget;
  final ClayDialogType type;
  final String confirmText;
  final String cancelText;
  final ClayButtonType confirmButtonType;
  final ClayButtonType cancelButtonType;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool confirmLoading;
  final bool cancelLoading;
  final bool barrierDismissible;

  const ClayConfirmDialog({
    super.key,
    this.title,
    this.content,
    this.contentWidget,
    this.type = ClayDialogType.confirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmButtonType = ClayButtonType.primary,
    this.cancelButtonType = ClayButtonType.secondary,
    this.onConfirm,
    this.onCancel,
    this.confirmLoading = false,
    this.cancelLoading = false,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClayAlertDialog(
      title: title ?? 'Confirm Action',
      content: content,
      contentWidget: contentWidget,
      type: type,
      barrierDismissible: barrierDismissible,
      actions: [
        ClayDialogAction(
          text: cancelText,
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          type: cancelButtonType,
          isLoading: cancelLoading,
        ),
        ClayDialogAction(
          text: confirmText,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          type: confirmButtonType,
          isLoading: confirmLoading,
        ),
      ],
    );
  }
}

/// Claymorphism Form Dialog
class ClayFormDialog extends StatefulWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? fields;
  final ClayDialogType type;
  final ClayDialogSize size;
  final String confirmText;
  final String cancelText;
  final ClayButtonType confirmButtonType;
  final ClayButtonType cancelButtonType;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool confirmLoading;
  final bool cancelLoading;
  final bool barrierDismissible;
  final GlobalKey<FormState>? formKey;

  const ClayFormDialog({
    super.key,
    this.title,
    this.content,
    this.fields,
    this.type = ClayDialogType.custom,
    this.size = ClayDialogSize.md,
    this.confirmText = 'Save',
    this.cancelText = 'Cancel',
    this.confirmButtonType = ClayButtonType.primary,
    this.cancelButtonType = ClayButtonType.secondary,
    this.onConfirm,
    this.onCancel,
    this.confirmLoading = false,
    this.cancelLoading = false,
    this.barrierDismissible = true,
    this.formKey,
  });

  @override
  State<ClayFormDialog> createState() => _ClayFormDialogState();
}

class _ClayFormDialogState extends State<ClayFormDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final effectiveFormKey = widget.formKey ?? _formKey;
    
    return ClayDialog(
      title: widget.title,
      type: widget.type,
      size: widget.size,
      barrierDismissible: widget.barrierDismissible,
      child: Form(
        key: effectiveFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.content != null) widget.content!,
            if (widget.fields != null) ...widget.fields!,
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClayButton(
                  text: widget.cancelText,
                  type: widget.cancelButtonType,
                  onPressed: widget.onCancel ?? () => Navigator.of(context).pop(false),
                  isLoading: widget.cancelLoading,
                  size: ClayButtonSize.md,
                ),
                const SizedBox(width: 12),
                ClayButton(
                  text: widget.confirmText,
                  type: widget.confirmButtonType,
                  onPressed: widget.confirmLoading 
                      ? null 
                      : () {
                          if (effectiveFormKey.currentState!.validate()) {
                            widget.onConfirm?.call();
                            Navigator.of(context).pop(true);
                          }
                        },
                  isLoading: widget.confirmLoading,
                  size: ClayButtonSize.md,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Claymorphism Bottom Sheet
class ClayBottomSheet extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final String? title;
  final Widget? titleWidget;
  final ClayDialogType type;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final bool showCloseButton;
  final bool scrollable;
  final bool isDismissible;
  final bool enableDrag;

  const ClayBottomSheet({
    super.key,
    this.child,
    this.children,
    this.title,
    this.titleWidget,
    this.type = ClayDialogType.custom,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.showCloseButton = true,
    this.scrollable = false,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get dialog colors based on type
    final dialogColors = _getDialogColors(context, type);
    
    // Get effective background color
    final effectiveBackgroundColor = backgroundColor ?? dialogColors.background;
    
    // Get effective border radius
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ClayTheme.radiusXl);
    
    // Get effective padding
    final effectivePadding = padding ?? const EdgeInsets.all(20);
    
    // Build the content
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: BoxDecoration(
              color: _hexToColor(ClaySemanticColors.borderPrimary),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        
        // Header
        if (title != null || titleWidget != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: titleWidget ?? Text(
                    title ?? '',
                    style: ClayTextStyles.dialogTitle.copyWith(
                      color: _hexToColor(ClaySemanticColors.textPrimary),
                    ),
                  ),
                ),
                if (showCloseButton) ...[
                  ClayIconButton(
                    icon: Icon(
                      Icons.close,
                      color: _hexToColor(ClaySemanticColors.textSecondary),
                    ),
                    type: ClayButtonType.text,
                    size: ClayButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            ),
          ),
        ],
        
        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (child != null) child!,
                if (children != null) ...children!,
              ],
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: effectiveBorderRadius.topLeft,
          topRight: effectiveBorderRadius.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, -12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: content,
    );
  }

  _DialogColors _getDialogColors(BuildContext context, ClayDialogType type) {
    switch (type) {
      case ClayDialogType.info:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          titleColor: _hexToColor(ClaySemanticColors.textPrimary),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.brandPrimary).withOpacity(0.1),
        );
      case ClayDialogType.success:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceSuccess),
          titleColor: _hexToColor(ClaySemanticColors.textSuccess),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusSuccess).withOpacity(0.1),
        );
      case ClayDialogType.warning:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceWarning),
          titleColor: _hexToColor(ClaySemanticColors.textWarning),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusWarning).withOpacity(0.1),
        );
      case ClayDialogType.error:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfaceError),
          titleColor: _hexToColor(ClaySemanticColors.textError),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.statusError).withOpacity(0.1),
        );
      case ClayDialogType.confirm:
      case ClayDialogType.custom:
        return _DialogColors(
          background: _hexToColor(ClaySemanticColors.surfacePrimary),
          titleColor: _hexToColor(ClaySemanticColors.textPrimary),
          contentColor: _hexToColor(ClaySemanticColors.textSecondary),
          iconBackground: _hexToColor(ClaySemanticColors.surfaceSecondary),
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

/// Helper function to show a Claymorphism dialog
Future<T?> showClayDialog<T>(
  BuildContext context, {
    required WidgetBuilder builder,
    ClayDialogType type = ClayDialogType.custom,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOutCirc,
    String? barrierLabel,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: animationDuration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: animationCurve,
        ),
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: animationCurve,
          ),
          child: child,
        ),
      );
    },
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

/// Helper function to show a Claymorphism alert
Future<bool?> showClayAlert(
  BuildContext context, {
    String? title,
    String? content,
    ClayDialogType type = ClayDialogType.info,
    String confirmText = 'OK',
    ClayButtonType confirmButtonType = ClayButtonType.primary,
    bool barrierDismissible = true,
  }) {
  return showClayDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ClayAlertDialog(
      title: title,
      content: content,
      type: type,
      actions: [
        ClayDialogAction(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          type: confirmButtonType,
        ),
      ],
    ),
  );
}

/// Helper function to show a Claymorphism confirmation dialog
Future<bool?> showClayConfirm(
  BuildContext context, {
    String? title,
    String? content,
    ClayDialogType type = ClayDialogType.confirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    ClayButtonType confirmButtonType = ClayButtonType.primary,
    ClayButtonType cancelButtonType = ClayButtonType.secondary,
    bool barrierDismissible = true,
  }) {
  return showClayDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ClayConfirmDialog(
      title: title,
      content: content,
      type: type,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmButtonType: confirmButtonType,
      cancelButtonType: cancelButtonType,
    ),
  );
}
