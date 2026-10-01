import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../themes/clay_theme.dart';

/// Claymorphism Input Types
enum ClayInputType {
  text,
  number,
  email,
  phone,
  password,
  multiline,
  search,
  date,
  time,
  currency,
}

/// Claymorphism Input Sizes
enum ClayInputSize {
  sm,
  md,
  lg,
}

/// Claymorphism Input States
enum ClayInputState {
  normal,
  focused,
  error,
  disabled,
  readonly,
}

/// A Claymorphism-styled input field widget
class ClayInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final ClayInputType type;
  final ClayInputSize size;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool expands;
  final bool isDense;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final Color? filledColor;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;
  final double errorBorderWidth;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onFocusChanged;
  final String? Function(String?)? validator;
  final bool showCounter;
  final bool showClearButton;
  final Duration animationDuration;
  final Curve animationCurve;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const ClayInput({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.type = ClayInputType.text,
    this.size = ClayInputSize.md,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.isDense = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.filledColor,
    this.hoverColor,
    this.width,
    this.height,
    this.contentPadding,
    this.margin,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    this.errorBorderWidth = 2.0,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onFocusChanged,
    this.validator,
    this.showCounter = false,
    this.showClearButton = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOutCirc,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  State<ClayInput> createState() => _ClayInputState();
}

class _ClayInputState extends State<ClayInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    
    _controller.addListener(_updateState);
    _focusNode.addListener(_updateFocus);
    
    _updateState();
  }

  @override
  void didUpdateWidget(ClayInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_updateState);
      _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
      _controller.addListener(_updateState);
    }
    if (widget.initialValue != oldWidget.initialValue && widget.controller == null) {
      _controller.text = widget.initialValue ?? '';
    }
    if (widget.errorText != oldWidget.errorText) {
      _hasError = widget.errorText != null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _focusNode.removeListener(_updateFocus);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _showClear = widget.showClearButton && 
            _controller.text.isNotEmpty && 
            !widget.readOnly && 
            widget.enabled;
      });
    }
  }

  void _updateFocus() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      widget.onFocusChanged?.call();
    }
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    _updateState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Get input colors based on state
    final inputColors = _getInputColors();
    
    // Get dimensions based on input size
    final inputDimensions = _getInputDimensions();
    
    // Get effective keyboard type
    final effectiveKeyboardType = widget.keyboardType ?? _getKeyboardType();
    
    // Get effective text input action
    final effectiveTextInputAction = widget.textInputAction ?? 
        (widget.maxLines == null || widget.maxLines! > 1 
            ? TextInputAction.newline 
            : TextInputAction.done);
    
    // Get effective content padding
    final effectiveContentPadding = widget.contentPadding ?? inputDimensions.padding;
    
    // Get effective border radius
    final effectiveBorderRadius = widget.borderRadius ?? inputDimensions.borderRadius;
    
    // Get effective margin
    final effectiveMargin = widget.margin ?? EdgeInsets.zero;
    
    // Get effective width
    final effectiveWidth = widget.width ?? (widget.expands ? double.infinity : null);
    
    // Get effective height
    final effectiveHeight = widget.height ?? inputDimensions.height;
    
    // Build the input decoration
    final decoration = InputDecoration(
      labelText: widget.label,
      labelStyle: widget.labelStyle ?? ClayTextStyles.inputLabel.copyWith(
        color: inputColors.labelColor,
      ),
      hintText: widget.hint ?? widget.placeholder,
      hintStyle: widget.hintStyle ?? ClayTextStyles.inputHint.copyWith(
        color: inputColors.hintColor,
      ),
      helperText: widget.helperText,
      helperStyle: widget.helperStyle ?? ClayTextStyles.inputHelper.copyWith(
        color: inputColors.helperColor,
      ),
      errorText: widget.errorText,
      errorStyle: widget.errorStyle ?? ClayTextStyles.inputError.copyWith(
        color: inputColors.errorColor,
      ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _showClear 
          ? GestureDetector(
              onTap: _clearText,
              child: Icon(
                Icons.clear,
                size: inputDimensions.iconSize,
                color: inputColors.clearIconColor,
              ),
            )
          : widget.suffixIcon,
      prefix: widget.prefix,
      suffix: widget.suffix,
      contentPadding: effectiveContentPadding,
      border: OutlineInputBorder(
        borderRadius: effectiveBorderRadius,
        borderSide: BorderSide(
          color: inputColors.borderColor,
          width: inputColors.borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: effectiveBorderRadius,
        borderSide: BorderSide(
          color: inputColors.borderColor,
          width: inputColors.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: effectiveBorderRadius,
        borderSide: BorderSide(
          color: inputColors.focusedBorderColor,
          width: inputColors.focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: effectiveBorderRadius,
        borderSide: BorderSide(
          color: inputColors.errorBorderColor,
          width: inputColors.errorBorderWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: effectiveBorderRadius,
        borderSide: BorderSide(
          color: inputColors.disabledBorderColor,
          width: inputColors.borderWidth,
        ),
      ),
      filled: true,
      fillColor: inputColors.backgroundColor,
      hoverColor: inputColors.hoverColor,
      counterText: widget.showCounter ? null : '',
      isDense: widget.isDense,
    );

    return Container(
      margin: effectiveMargin,
      width: effectiveWidth,
      height: effectiveHeight,
      child: AnimatedScale(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        scale: _isFocused ? 1.01 : 1.0,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          initialValue: widget.controller == null ? widget.initialValue : null,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled && !_isFocused,
          autofocus: widget.autofocus,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          expands: widget.expands,
          maxLines: widget.expands ? null : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: effectiveKeyboardType,
          textInputAction: effectiveTextInputAction,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          style: widget.style ?? ClayTextStyles.inputText.copyWith(
            color: inputColors.textColor,
          ),
          inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
          decoration: decoration,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
        ),
      ),
    );
  }

  _InputColors _getInputColors() {
    final isDisabled = !widget.enabled || widget.readOnly;
    final hasError = widget.errorText != null || _hasError;
    
    Color backgroundColor;
    Color borderColor;
    Color focusedBorderColor;
    Color errorBorderColor;
    Color disabledBorderColor;
    Color textColor;
    Color hintColor;
    Color labelColor;
    Color helperColor;
    Color errorColor;
    Color clearIconColor;
    Color hoverColor;
    
    if (isDisabled) {
      backgroundColor = _hexToColor(ClaySemanticColors.surfaceDisabled);
      borderColor = _hexToColor(ClaySemanticColors.borderDisabled);
      focusedBorderColor = _hexToColor(ClaySemanticColors.borderDisabled);
      errorBorderColor = _hexToColor(ClaySemanticColors.borderError);
      disabledBorderColor = _hexToColor(ClaySemanticColors.borderDisabled);
      textColor = _hexToColor(ClaySemanticColors.textDisabled);
      hintColor = _hexToColor(ClaySemanticColors.textDisabled);
      labelColor = _hexToColor(ClaySemanticColors.textDisabled);
      helperColor = _hexToColor(ClaySemanticColors.textDisabled);
      errorColor = _hexToColor(ClaySemanticColors.textError);
      clearIconColor = _hexToColor(ClaySemanticColors.textDisabled);
      hoverColor = Colors.transparent;
    } else if (hasError) {
      backgroundColor = _hexToColor(ClaySemanticColors.surfaceError);
      borderColor = _hexToColor(ClaySemanticColors.borderError);
      focusedBorderColor = _hexToColor(ClaySemanticColors.borderError);
      errorBorderColor = _hexToColor(ClaySemanticColors.borderError);
      disabledBorderColor = _hexToColor(ClaySemanticColors.borderError);
      textColor = _hexToColor(ClaySemanticColors.textPrimary);
      hintColor = _hexToColor(ClaySemanticColors.textHint);
      labelColor = _hexToColor(ClaySemanticColors.textError);
      helperColor = _hexToColor(ClaySemanticColors.textError);
      errorColor = _hexToColor(ClaySemanticColors.textError);
      clearIconColor = _hexToColor(ClaySemanticColors.textSecondary);
      hoverColor = _hexToColor(ClaySemanticColors.surfaceHover);
    } else if (_isFocused) {
      backgroundColor = _hexToColor(ClaySemanticColors.surfaceFocused);
      borderColor = _hexToColor(ClaySemanticColors.borderFocused);
      focusedBorderColor = _hexToColor(ClaySemanticColors.borderFocused);
      errorBorderColor = _hexToColor(ClaySemanticColors.borderError);
      disabledBorderColor = _hexToColor(ClaySemanticColors.borderDisabled);
      textColor = _hexToColor(ClaySemanticColors.textPrimary);
      hintColor = _hexToColor(ClaySemanticColors.textHint);
      labelColor = _hexToColor(ClaySemanticColors.textPrimary);
      helperColor = _hexToColor(ClaySemanticColors.textHelper);
      errorColor = _hexToColor(ClaySemanticColors.textError);
      clearIconColor = _hexToColor(ClaySemanticColors.textSecondary);
      hoverColor = _hexToColor(ClaySemanticColors.surfaceHover);
    } else {
      backgroundColor = widget.backgroundColor ?? _hexToColor(ClaySemanticColors.surfacePrimary);
      borderColor = widget.borderColor ?? _hexToColor(ClaySemanticColors.borderPrimary);
      focusedBorderColor = widget.focusedBorderColor ?? _hexToColor(ClaySemanticColors.borderFocused);
      errorBorderColor = widget.errorBorderColor ?? _hexToColor(ClaySemanticColors.borderError);
      disabledBorderColor = widget.disabledBorderColor ?? _hexToColor(ClaySemanticColors.borderDisabled);
      textColor = _hexToColor(ClaySemanticColors.textPrimary);
      hintColor = _hexToColor(ClaySemanticColors.textHint);
      labelColor = _hexToColor(ClaySemanticColors.textSecondary);
      helperColor = _hexToColor(ClaySemanticColors.textHelper);
      errorColor = _hexToColor(ClaySemanticColors.textError);
      clearIconColor = _hexToColor(ClaySemanticColors.textSecondary);
      hoverColor = widget.hoverColor ?? _hexToColor(ClaySemanticColors.surfaceHover);
    }

    return _InputColors(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      errorBorderColor: errorBorderColor,
      disabledBorderColor: disabledBorderColor,
      textColor: textColor,
      hintColor: hintColor,
      labelColor: labelColor,
      helperColor: helperColor,
      errorColor: errorColor,
      clearIconColor: clearIconColor,
      hoverColor: hoverColor,
      borderWidth: widget.borderWidth,
      focusedBorderWidth: widget.focusedBorderWidth,
      errorBorderWidth: widget.errorBorderWidth,
    );
  }

  _InputDimensions _getInputDimensions() {
    switch (widget.size) {
      case ClayInputSize.sm:
        return _InputDimensions(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          iconSize: 16,
          fontSize: ClayTypography.fontSizeSm,
        );
      case ClayInputSize.md:
        return _InputDimensions(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          iconSize: 18,
          fontSize: ClayTypography.fontSizeBase,
        );
      case ClayInputSize.lg:
        return _InputDimensions(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          borderRadius: BorderRadius.circular(ClayTheme.radiusXl),
          iconSize: 20,
          fontSize: ClayTypography.fontSizeLg,
        );
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case ClayInputType.text:
        return TextInputType.text;
      case ClayInputType.number:
        return TextInputType.number;
      case ClayInputType.email:
        return TextInputType.emailAddress;
      case ClayInputType.phone:
        return TextInputType.phone;
      case ClayInputType.password:
        return TextInputType.visiblePassword;
      case ClayInputType.multiline:
        return TextInputType.multiline;
      case ClayInputType.search:
        return TextInputType.text;
      case ClayInputType.date:
        return TextInputType.datetime;
      case ClayInputType.time:
        return TextInputType.datetime;
      case ClayInputType.currency:
        return TextInputType.numberWithOptions(decimal: true);
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[];
    
    switch (widget.type) {
      case ClayInputType.number:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case ClayInputType.phone:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case ClayInputType.currency:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*')));
        break;
      default:
        break;
    }
    
    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }
    
    return formatters;
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _InputColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color disabledBorderColor;
  final Color textColor;
  final Color hintColor;
  final Color labelColor;
  final Color helperColor;
  final Color errorColor;
  final Color clearIconColor;
  final Color hoverColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final double errorBorderWidth;

  _InputColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.errorBorderColor,
    required this.disabledBorderColor,
    required this.textColor,
    required this.hintColor,
    required this.labelColor,
    required this.helperColor,
    required this.errorColor,
    required this.clearIconColor,
    required this.hoverColor,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.errorBorderWidth,
  });
}

class _InputDimensions {
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double iconSize;
  final double fontSize;

  _InputDimensions({
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
  });
}

/// Claymorphism Input with Label and Helper
class ClayInputWithLabel extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hint;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ClayInputType type;
  final ClayInputSize size;
  final bool required;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const ClayInputWithLabel({
    super.key,
    this.controller,
    this.initialValue,
    required this.label,
    this.hint,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.type = ClayInputType.text,
    this.size = ClayInputSize.md,
    this.required = false,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: ClayTextStyles.inputLabel.copyWith(
              color: _hexToColor(ClaySemanticColors.textPrimary),
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: ClayTextStyles.inputLabel.copyWith(
                        color: _hexToColor(ClaySemanticColors.textError),
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        ClayInput(
          controller: controller,
          initialValue: initialValue,
          hint: hint,
          placeholder: placeholder,
          helperText: helperText,
          errorText: errorText,
          type: type,
          size: size,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          showClearButton: true,
        ),
      ],
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Claymorphism Currency Input
class ClayCurrencyInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final String currencySymbol;
  final ClayInputSize size;
  final bool required;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  const ClayCurrencyInput({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.currencySymbol = 'à¤°à¥', // Nepali Rupee symbol
    this.size = ClayInputSize.md,
    this.required = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClayInputWithLabel(
      controller: controller,
      initialValue: initialValue,
      label: label ?? 'Amount',
      hint: hint,
      placeholder: placeholder ?? '0.00',
      helperText: helperText,
      errorText: errorText,
      type: ClayInputType.currency,
      size: size,
      required: required,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*')),
      ],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      prefix: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          currencySymbol,
          style: ClayTextStyles.inputPrefix.copyWith(
            color: _hexToColor(ClaySemanticColors.textSecondary),
          ),
        ),
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

/// Claymorphism Search Input
class ClaySearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? placeholder;
  final ClayInputSize size;
  final bool readOnly;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;

  const ClaySearchInput({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.placeholder = 'Search...',
    this.size = ClayInputSize.md,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.onSearch,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ClayInput(
      controller: controller,
      initialValue: initialValue,
      label: label,
      hint: hint,
      placeholder: placeholder,
      type: ClayInputType.search,
      size: size,
      readOnly: readOnly,
      enabled: enabled,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: (value) {
        onSubmitted?.call(value);
        onSearch?.call();
      },
      prefixIcon: Icon(
        Icons.search,
        color: _hexToColor(ClaySemanticColors.textTertiary),
      ),
      showClearButton: true,
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
