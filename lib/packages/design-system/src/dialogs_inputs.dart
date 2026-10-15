// Dialogs, inputs, and the BS date picker.
part of '../design_system.dart';

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

/// Form dialog wrapper: centered 520px dialog on medium+ windows,
/// edge-to-edge fullscreen sheet on compact (phones).
///
/// Renders a neutral Cancel action plus a brand-primary Save action
/// (sticky in the compact sheet, bottom-right in the desktop dialog).
/// Only destructive Delete/Discard confirmations use the error-red roles
/// (see [showClayConfirmDialog]); plain Cancel stays neutral. Callers own
/// validation: the form's `GlobalKey<FormState>` lives with the form
/// widget, so pass a callback that reaches it (see the `static show()`
/// helpers on the add-forms, which use file-scoped privacy for that).
class ClayFormDialog extends StatelessWidget {
  const ClayFormDialog({
    super.key,
    this.title,
    this.child,
    this.actions,
    this.onSave,
    this.saveLabel = 'Save',
    this.onCancel,
    this.cancelLabel = 'Cancel',
    this.showCancel = true,
  });
  final Widget? title;
  final Widget? child;
  final List<Widget>? actions;
  final VoidCallback? onSave;
  final String saveLabel;

  /// Defaults to popping the dialog. Pass a callback to confirm or
  /// discard unsaved input first.
  final VoidCallback? onCancel;
  final String cancelLabel;
  final bool showCancel;

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).width < ClayBreakpoints.compactMax;
    final scheme = Theme.of(context).colorScheme;
    final save = onSave;
    final actionsList = actions;
    final composed = <Widget>[
      if (showCancel)
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: scheme.onSurfaceVariant,
          ),
          child: Text(cancelLabel),
        ),
      ...?actionsList,
      if (save != null) ClayButton(onPressed: save, child: Text(saveLabel)),
    ];

    if (!compact) {
      return AlertDialog(
        title: title,
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(child: child),
        ),
        actions: composed.isEmpty ? null : composed,
      );
    }
    return Dialog.fullscreen(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  const CloseButton(),
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle.merge(
                        style: Theme.of(context).textTheme.titleLarge,
                        child: title!,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: ClaySpacing.cardMedium,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            if (composed.isNotEmpty) ...[
              const Divider(height: 1),
              Padding(
                padding: ClaySpacing.cardMedium,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < composed.length; i++) ...[
                      if (i > 0) const SizedBox(width: ClaySpacing.sm),
                      Flexible(child: composed[i]),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Search input.
class ClaySearchInput extends StatelessWidget {
  const ClaySearchInput({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(ClayIcons.search),
          border: const OutlineInputBorder(
            borderRadius: ClayRadius.medium,
          ),
        ),
      );
}

/// Required-field asterisk: `ClayLabel('Name', isRequired: true)`.
class ClayLabel extends StatelessWidget {
  const ClayLabel(this.label, {super.key, this.isRequired = false});
  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: text.labelLarge),
        if (isRequired)
          Text(' *', style: text.labelLarge?.copyWith(color: scheme.error)),
      ],
    );
  }
}

/// Labeled text input.
///
/// Controlled when [controller] is given, uncontrolled shim ([value]
/// seeds the field) otherwise. Focus traversal via [focusNode] +
/// [textInputAction] + [onFieldSubmitted].
class ClayInputWithLabel extends StatelessWidget {
  const ClayInputWithLabel({
    required this.label,
    super.key,
    this.hintText,
    this.value,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.isRequired = false,
    this.enabled = true,
    this.autovalidateMode,
  });
  final String label;
  final String? hintText;
  final String? value;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRequired;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClayLabel(label, isRequired: isRequired),
          const SizedBox(height: ClaySpacing.sm),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? value : null,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines ?? 1,
            enabled: enabled,
            autovalidateMode: autovalidateMode,
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
    this.focusNode,
    this.isRequired = false,
    this.enabled = true,
  });
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final FocusNode? focusNode;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClayLabel(label, isRequired: isRequired),
          const SizedBox(height: ClaySpacing.sm),
          DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            validator: validator,
            focusNode: focusNode,
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

/// Date input (AD calendar). For Bikram Sambat, use [ClayBsDateInput].
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
        const SizedBox(height: ClaySpacing.sm),
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

/// Currency/amount input with tabular figures and à¤°à¥‚ prefix.
class ClayCurrencyInput extends StatelessWidget {
  const ClayCurrencyInput({
    required this.label,
    super.key,
    this.hintText,
    this.value,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
  });
  final String label;
  final String? hintText;
  final double? value;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<double?>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<double>? validator;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClayLabel(label, isRequired: isRequired),
          const SizedBox(height: ClaySpacing.sm),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? (value?.toString() ?? '') : null,
            focusNode: focusNode,
            textInputAction: textInputAction,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style:
                ClayTypography.tabular(Theme.of(context).textTheme.bodyLarge),
            onChanged: (text) => onChanged?.call(double.tryParse(text)),
            onFieldSubmitted: onFieldSubmitted,
            validator: (text) => validator?.call(
              text == null || text.isEmpty ? null : double.tryParse(text),
            ),
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: 'à¤°à¥‚ ',
            ),
          ),
        ],
      );
}

/// Bikram Sambat date helpers (public `nepali_utils` API only).
abstract final class ClayBsDate {
  static const List<String> months = [
    'Baisakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra',
  ];

  /// Sunday-first short weekday headers (Nepal standard).
  static const List<String> weekdays = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  /// `2083-06-27`; empty string for null.
  static String format(DateTime? ad) {
    if (ad == null) return '';
    final bs = ad.toNepaliDateTime();
    return '${bs.year}-${bs.month.toString().padLeft(2, '0')}-'
        '${bs.day.toString().padLeft(2, '0')}';
  }

  /// `Ashwin 10, 2083 BS`.
  static String formatLong(DateTime? ad) {
    if (ad == null) return '';
    final bs = ad.toNepaliDateTime();
    return '${months[bs.month - 1]} ${bs.day}, ${bs.year} BS';
  }

  static int daysInMonth(int bsYear, int bsMonth) =>
      NepaliDateTime(bsYear, bsMonth).totalDays;
}

/// BS-first date input: displays Bikram Sambat by default with an AD
/// fallback picker. Value stays [DateTime] (AD) so models don't change.
class ClayBsDateInput extends StatefulWidget {
  const ClayBsDateInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<ClayBsDateInput> createState() => _ClayBsDateInputState();
}

class _ClayBsDateInputState extends State<ClayBsDateInput> {
  bool _bsMode = true;

  DateTime get _first => widget.firstDate ?? DateTime(2000);
  DateTime get _last => widget.lastDate ?? DateTime(2100);

  Future<void> _pick() async {
    final now = DateTime.now();
    final initialBs =
        widget.value?.toNepaliDateTime() ?? now.toNepaliDateTime();
    final result = await showDialog<_BsPickResult>(
      context: context,
      builder: (_) => _BsPickerDialog(
        initial: initialBs,
        firstDate: _first,
        lastDate: _last,
      ),
    );
    if (!mounted) return;
    switch (result) {
      case _BsPicked(:final bs):
        widget.onChanged?.call(bs.toDateTime());
      case _BsPickAd():
        final ad = await showDatePicker(
          context: context,
          initialDate: widget.value ?? now,
          firstDate: _first,
          lastDate: _last,
        );
        if (!mounted) return;
        widget.onChanged?.call(ad);
        if (ad != null) setState(() => _bsMode = false);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.value == null
        ? ''
        : _bsMode
            ? ClayBsDate.formatLong(widget.value)
            : '${ClayBsDate.format(widget.value)} AD';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClayLabel(widget.label, isRequired: widget.isRequired),
        const SizedBox(height: ClaySpacing.sm),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: text),
          onTap: _pick,
          style: ClayTypography.tabular(Theme.of(context).textTheme.bodyLarge),
          decoration: const InputDecoration(
            suffixIcon: Icon(ClayIcons.date),
          ),
        ),
      ],
    );
  }
}

sealed class _BsPickResult {
  const _BsPickResult();
}

class _BsPicked extends _BsPickResult {
  const _BsPicked(this.bs);
  final NepaliDateTime bs;
}

class _BsPickAd extends _BsPickResult {
  const _BsPickAd();
}

/// BS month-grid picker dialog with a BS|AD mode switch.
class _BsPickerDialog extends StatefulWidget {
  const _BsPickerDialog({
    required this.initial,
    required this.firstDate,
    required this.lastDate,
  });
  final NepaliDateTime initial;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_BsPickerDialog> createState() => _BsPickerDialogState();
}

class _BsPickerDialogState extends State<_BsPickerDialog> {
  late int _year;
  late int _month;
  bool _bsMode = true;

  late final NepaliDateTime _firstBs;
  late final NepaliDateTime _lastBs;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year;
    _month = widget.initial.month;
    _firstBs = widget.firstDate.toNepaliDateTime();
    _lastBs = widget.lastDate.toNepaliDateTime();
  }

  bool get _canPrev =>
      _year > _firstBs.year ||
      (_year == _firstBs.year && _month > _firstBs.month);
  bool get _canNext =>
      _year < _lastBs.year || (_year == _lastBs.year && _month < _lastBs.month);

  void _step(int delta) {
    var m = _month + delta;
    var y = _year;
    if (m < 1) {
      m = 12;
      y -= 1;
    } else if (m > 12) {
      m = 1;
      y += 1;
    }
    setState(() {
      _year = y;
      _month = m;
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Select date'),
        content: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('BS')),
                  ButtonSegment(value: false, label: Text('AD')),
                ],
                selected: {_bsMode},
                onSelectionChanged: (selected) {
                  if (selected.first) {
                    setState(() => _bsMode = true);
                  } else {
                    Navigator.pop(context, const _BsPickAd());
                  }
                },
              ),
              const SizedBox(height: ClaySpacing.md),
              if (_bsMode)
                _BsMonthGrid(
                  year: _year,
                  month: _month,
                  initial: widget.initial,
                  canPrev: _canPrev,
                  canNext: _canNext,
                  onStep: _step,
                  onPick: (day) => Navigator.pop(
                    context,
                    _BsPicked(NepaliDateTime(_year, _month, day)),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
}

/// BS month grid (extracted from [_BsPickerDialogState] for readability).
class _BsMonthGrid extends StatelessWidget {
  const _BsMonthGrid({
    required this.year,
    required this.month,
    required this.initial,
    required this.canPrev,
    required this.canNext,
    required this.onStep,
    required this.onPick,
  });
  final int year;
  final int month;
  final NepaliDateTime initial;
  final bool canPrev;
  final bool canNext;
  final ValueChanged<int> onStep;
  final ValueChanged<int> onPick;

  int _cellCount() {
    final days = ClayBsDate.daysInMonth(year, month);
    final firstWeekday =
        NepaliDateTime(year, month, 1).toDateTime().weekday % 7;
    return days + firstWeekday;
  }

  int? _dayAt(int index) {
    final firstWeekday =
        NepaliDateTime(year, month, 1).toDateTime().weekday % 7;
    final day = index - firstWeekday + 1;
    if (day < 1 || day > ClayBsDate.daysInMonth(year, month)) return null;
    return day;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: canPrev ? () => onStep(-1) : null,
              tooltip: 'Previous month',
            ),
            Expanded(
              child: Text(
                '${ClayBsDate.months[month - 1]} $year',
                style: text.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: canNext ? () => onStep(1) : null,
              tooltip: 'Next month',
            ),
          ],
        ),
        const SizedBox(height: ClaySpacing.sm),
        Row(
          children: [
            for (final d in ClayBsDate.weekdays)
              Expanded(
                child: Text(
                  d,
                  style:
                      text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        const SizedBox(height: ClaySpacing.xs),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: _cellCount(),
          itemBuilder: (context, index) {
            final day = _dayAt(index);
            if (day == null) return const SizedBox.shrink();
            final selected = year == initial.year &&
                month == initial.month &&
                day == initial.day;
            final todayBs = NepaliDateTime.now();
            final isToday = year == todayBs.year &&
                month == todayBs.month &&
                day == todayBs.day;
            return InkWell(
              borderRadius: ClayRadius.full,
              onTap: () => onPick(day),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? scheme.primary : null,
                  border: isToday && !selected
                      ? Border.all(color: scheme.primary)
                      : null,
                  borderRadius: ClayRadius.full,
                ),
                child: Text(
                  '$day',
                  style: text.bodyMedium?.copyWith(
                    color: selected ? scheme.onPrimary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : null,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

enum ToastVariant { success, error, info, warning }

class ClayToast {
  ClayToast._();

  static ClayToastController show(
    BuildContext context,
    String message, {
    ToastVariant variant = ToastVariant.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final controller = ClayToastController._();
    _ClayToastOverlay.insert(
      context,
      _ToastEntry(
        message: message,
        variant: variant,
        duration: duration,
        controller: controller,
      ),
    );
    return controller;
  }

  static void success(BuildContext context, String message) =>
      show(context, message, variant: ToastVariant.success);

  static void error(BuildContext context, String message) =>
      show(context, message, variant: ToastVariant.error);

  static void info(BuildContext context, String message) =>
      show(context, message, variant: ToastVariant.info);

  static void warning(BuildContext context, String message) =>
      show(context, message, variant: ToastVariant.warning);
}

class ClayToastController {
  ClayToastController._();
  void dismiss() => _ClayToastOverlay.dismiss(this);
}

class _ToastEntry {
  const _ToastEntry({
    required this.message,
    required this.variant,
    required this.duration,
    required this.controller,
  });
  final String message;
  final ToastVariant variant;
  final Duration duration;
  final ClayToastController controller;
}

class _ClayToastOverlay {
  static final List<_ToastEntry> _stack = [];
  static final Map<ClayToastController, _ToastEntry> _byController = {};

  static void insert(BuildContext context, _ToastEntry entry) {
    final overlay = Overlay.of(context);
    if (_stack.isEmpty) {
      _stack.add(entry);
      _byController[entry.controller] = entry;
      _showNext(overlay);
    } else {
      _stack.add(entry);
    }
  }

  static void _showNext(OverlayState overlay) {
    if (_stack.isEmpty) return;
    final entry = _stack.first;
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        entry: entry,
        onDismiss: () {
          _stack.remove(entry);
          _byController.remove(entry.controller);
          overlayEntry.remove();
          _showNext(overlay);
        },
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(entry.duration, () {
      if (_stack.isNotEmpty && _stack.first == entry) {
        overlayEntry.remove();
        _stack.remove(entry);
        _byController.remove(entry.controller);
        _showNext(overlay);
      }
    });
  }

  static void dismiss(ClayToastController controller) {
    final entry = _byController[controller];
    if (entry != null) {
      _stack.remove(entry);
      _byController.remove(controller);
    }
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.entry,
    required this.onDismiss,
  });
  final _ToastEntry entry;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ClayMotion.short,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  late final Animation<double> _fade = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg, icon) = switch (widget.entry.variant) {
      ToastVariant.success => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
          Icons.check_circle_rounded
        ),
      ToastVariant.error => (
          scheme.errorContainer,
          scheme.onErrorContainer,
          Icons.error_rounded
        ),
      ToastVariant.warning => (
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
          Icons.warning_amber_rounded
        ),
      ToastVariant.info => (
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
          Icons.info_rounded
        ),
    };
    return SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Dismissible(
                key: ValueKey(widget.entry),
                direction: DismissDirection.horizontal,
                onDismissed: (_) => widget.onDismiss(),
                child: Material(
                  color: bg,
                  elevation: ClayElevation.level3,
                  borderRadius: ClayRadius.medium,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ClaySpacing.lg,
                      vertical: ClaySpacing.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: fg, size: 20),
                        const SizedBox(width: ClaySpacing.sm),
                        Flexible(
                          child: Text(
                            widget.entry.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: fg),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
