// Cards, stats, trends, sparklines, detail rows, badges, and the
// confirm/search dialog helpers.
part of '../design_system.dart';

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

/// Desktop data-table scaffold shared by contacts/products/transactions:
/// titled card + search box + [PaginatedDataTable].
///
/// The table scrolls internally (its own horizontal viewport); callers must
/// NOT wrap it in another horizontal scroller — an unbounded ancestor
/// makes its header/footer rows assert with infinite width. Screens own
/// [columns] (incl. sort callbacks) and [source]; this owns layout and
/// pagination chrome.
class ClayTableCard extends StatelessWidget {
  const ClayTableCard({
    required this.title,
    required this.tableTitle,
    required this.columns,
    required this.source,
    super.key,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.rowsPerPage = 25,
    this.availableRowsPerPage = const [10, 25, 50, 100],
    this.onRowsPerPageChanged,
    this.sortColumnIndex,
    this.sortAscending = true,
  });
  final String title;
  final String tableTitle;
  final List<DataColumn> columns;
  final DataTableSource source;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final int? sortColumnIndex;
  final bool sortAscending;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final height =
              constraints.maxHeight.isFinite ? constraints.maxHeight : 600.0;
          return SizedBox(
            height: height,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 280,
                          child: ClaySearchInput(
                            hintText: searchHint,
                            onChanged: onSearchChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                        header: Text(
                          tableTitle,
                          style:
                              Theme.of(context).textTheme.labelLarge,
                        ),
                        rowsPerPage: rowsPerPage,
                        availableRowsPerPage: availableRowsPerPage,
                        onRowsPerPageChanged: onRowsPerPageChanged,
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: sortAscending,
                        showCheckboxColumn: false,
                        columns: columns,
                        source: source,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
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

/// Quick-action tile: 48dp tinted icon + centered title for adaptive
/// grids (premium replacement for chip-wrap action lists).
class ClayActionTile extends StatelessWidget {
  const ClayActionTile({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.iconColor,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final tint = iconColor ?? scheme.primary;
    final sub = subtitle;
    return ClayCard(
      variant: ClayCardVariant.filled,
      size: ClayCardSize.compact,
      padding: ClaySpacing.cardMedium,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: ClayRadius.smallPlus,
            ),
            child: Icon(icon, color: tint, size: ClayIconSize.md),
          ),
          const SizedBox(height: ClaySpacing.sm),
          Text(
            title,
            style: text.labelLarge,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (sub != null)
            Text(
              sub,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

/// Month-over-month trend chip: ▲ 12.5% / ▼ 3.1% / — 0.0%.
/// Set [invert] for expenses (down is good).
class ClayTrend extends StatelessWidget {
  const ClayTrend({required this.pct, super.key, this.invert = false});
  final double pct;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final up = pct > 0.05;
    final down = pct < -0.05;
    final good = up != invert && (up || down);
    final color = !up && !down
        ? scheme.onSurfaceVariant
        : good
            ? ClayColors.success
            : ClayColors.error;
    final icon = !up && !down
        ? Icons.trending_flat_rounded
        : up
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: ClayRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${pct.abs().toStringAsFixed(1)}%',
            style: ClayTypography.tabular(
              text.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini sparkline (dependency-free CustomPainter): line + soft fill.
/// Renders nothing when fewer than 2 points.
class ClaySparkline extends StatelessWidget {
  const ClaySparkline({
    required this.data,
    required this.color,
    super.key,
    this.height = 36,
  });
  final List<double> data;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(data: data, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.data, required this.color});
  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final span = (max - min).abs() < 1e-9 ? 1.0 : max - min;
    const pad = 3.0;
    final points = [
      for (var i = 0; i < data.length; i++)
        Offset(
          pad +
              (size.width - pad * 2) *
                  (data.length == 1 ? 0.5 : i / (data.length - 1)),
          size.height -
              pad -
              (size.height - pad * 2) * ((data[i] - min) / span),
        ),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    final fill = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = color.withValues(alpha: 0.12),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(points.last, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.data != data || old.color != color;
}

/// Detail row for view dialogs. Two layouts, one widget:
/// * with [icon]: icon + label + ': ' + value (contacts, products,
///   income, expenses, receipts, payments dialogs);
/// * without: space-between label/value (transactions, sales, purchases).
class ClayDetailRow extends StatelessWidget {
  const ClayDetailRow({
    required this.label,
    required this.value,
    super.key,
    this.icon,
    this.valueColor,
    this.isBold = false,
    this.tabular = false,
  });
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final bool isBold;
  final bool tabular;

  TextStyle? _valueStyle(BuildContext context) {
    final text = Theme.of(context).textTheme;
    var style = isBold ? text.titleMedium : text.bodyMedium;
    if (!isBold) style = style?.copyWith(fontWeight: FontWeight.w500);
    if (tabular) style = ClayTypography.tabular(style);
    if (valueColor != null) style = style?.copyWith(color: valueColor);
    return style;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final iconData = icon;
    if (iconData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: _valueStyle(context),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(iconData, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Text(
            label,
            style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          const Text(': '),
          Expanded(
            child: Text(value, style: _valueStyle(context)),
          ),
        ],
      ),
    );
  }
}

/// Status badge: tinted container + bold label. Screens own the
/// status→color mapping; this owns the rendering.
class ClayStatusBadge extends StatelessWidget {
  const ClayStatusBadge({
    required this.label,
    required this.color,
    super.key,
  });
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: ClayRadius.small,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      );
}

/// Destructive confirmation dialog. Returns true when confirmed.
/// Cupertino style on iOS/macOS, Material elsewhere.
Future<bool> showClayConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Search dialog shell: title + autofocus input + Cancel.
/// Callers own the query state via [onChanged].
Future<void> showClaySearchDialog(
  BuildContext context, {
  required String title,
  required String hintText,
  ValueChanged<String>? onChanged,
}) =>
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text(title),
        content: ClaySearchInput(
          hintText: hintText,
          autofocus: true,
          onChanged: onChanged,
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

/// Stat card with icon + value. 40dp tinted icon container,
/// `headlineSmall` tabular value, `labelMedium` title.
/// Optional [trend] chip beside the icon and [spark] line.
class ClayStatCard extends StatelessWidget {
  const ClayStatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
    this.iconColor,
    this.onTap,
    this.subtitle,
    this.trend,
    this.spark,
    this.variant = ClayCardVariant.elevated,
    this.size = ClayCardSize.medium,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? subtitle;
  final Widget? trend;
  final List<double>? spark;
  final ClayCardVariant variant;
  final ClayCardSize size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final sub = subtitle;
    final tint = iconColor ?? scheme.primary;
    final trendWidget = trend;
    final sparkData = spark;
    final iconBox = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: ClayRadius.smallPlus,
      ),
      child: Icon(icon, color: tint, size: 22),
    );
    return ClayCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      variant: variant,
      size: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trendWidget == null)
            Align(alignment: Alignment.centerLeft, child: iconBox)
          else
            Row(
              children: [
                iconBox,
                const Spacer(),
                trendWidget,
              ],
            ),
          const SizedBox(height: ClaySpacing.sm),
          AnimatedSwitcher(
            duration: ClayMotion.medium,
            switchInCurve: ClayMotion.easing,
            child: Text(
              value,
              key: ValueKey(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ClayTypography.tabular(text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              )),
            ),
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
          if (sparkData != null && sparkData.length > 1) ...[
            const SizedBox(height: ClaySpacing.sm),
            ClaySparkline(data: sparkData, color: tint),
          ],
        ],
      ),
    );
  }
}
