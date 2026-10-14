import 'package:flutter/material.dart';

import '../../../packages/design-system/design_system.dart';

/// Design-system gallery: single visual reference for tokens, type scale,
/// cards, buttons, inputs, and iconography.
///
/// Route: `/design-system` (via command palette, not the main nav).
/// Toggle light/dark from the dashboard to review both schemes here.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) => const ClayScaffold(
        appBar: ClayAppBar(
          title: Text('Design System'),
          subtitle: Text('Tokens · type · cards · inputs · icons'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TypeSection(),
              SizedBox(height: 24),
              _ColorSection(),
              SizedBox(height: 24),
              _CardSection(),
              SizedBox(height: 24),
              _StatSection(),
              SizedBox(height: 24),
              _ButtonSection(),
              SizedBox(height: 24),
              _InputSection(),
              SizedBox(height: 24),
              _FormSection(),
              SizedBox(height: 24),
              _AdaptiveSection(),
              SizedBox(height: 24),
              _IconSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      );
}

class _TypeSection extends StatelessWidget {
  const _TypeSection();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final roles = <String, TextStyle?>{
      'Display L': text.displayLarge,
      'Display M': text.displayMedium,
      'Display S': text.displaySmall,
      'Headline L': text.headlineLarge,
      'Headline M': text.headlineMedium,
      'Headline S': text.headlineSmall,
      'Title L': text.titleLarge,
      'Title M': text.titleMedium,
      'Title S': text.titleSmall,
      'Body L': text.bodyLarge,
      'Body M': text.bodyMedium,
      'Body S': text.bodySmall,
      'Label L': text.labelLarge,
      'Label M': text.labelMedium,
      'Label S': text.labelSmall,
    };
    return ClayCard(
      title: const ClaySectionTitle(
        'Typography',
        subtitle: 'Inter + Noto Sans Devanagari fallback · M3 scale',
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in roles.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    SizedBox(
                      width: 96,
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Text('नमुना रू १२३ · Ag', style: entry.value),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ColorSection extends StatelessWidget {
  const _ColorSection();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pairs = <String, (Color, Color)>{
      'Primary': (scheme.primary, scheme.onPrimary),
      'Primary container': (scheme.primaryContainer, scheme.onPrimaryContainer),
      'Secondary': (scheme.secondary, scheme.onSecondary),
      'Secondary container': (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer
      ),
      'Tertiary': (scheme.tertiary, scheme.onTertiary),
      'Surface': (scheme.surface, scheme.onSurface),
      'Error': (scheme.error, scheme.onError),
    };
    final accents = <String, Color>{
      'Success': ClayColors.success,
      'Warning': ClayColors.warning,
      'Error': ClayColors.error,
      'Info': ClayColors.info,
    };
    return ClayCard(
      title: const ClaySectionTitle(
        'Color',
        subtitle: 'Scheme pairs + semantic accents (AA ≥ 4.5)',
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in pairs.entries)
                  Container(
                    width: 148,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: entry.value.$1,
                      borderRadius: ClayRadius.smallPlus,
                    ),
                    child: Text(
                      entry.key,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: entry.value.$2),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in accents.entries)
                  Chip(
                    avatar: Icon(
                      ClayIcons.check,
                      size: ClayIconSize.dense,
                      color: entry.value,
                    ),
                    label: Text(entry.key),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  const _CardSection();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClayCard(
            title: ClaySectionTitle('Cards · Elevated'),
            variant: ClayCardVariant.elevated,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('surfaceContainerLow · elevation 1'),
            ),
          ),
          SizedBox(height: 12),
          ClayCard(
            title: ClaySectionTitle('Cards · Filled'),
            variant: ClayCardVariant.filled,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('surfaceContainerHighest · elevation 0'),
            ),
          ),
          SizedBox(height: 12),
          ClayCard(
            title: ClaySectionTitle('Cards · Outlined'),
            variant: ClayCardVariant.outlined,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('surface · outlineVariant border'),
            ),
          ),
        ],
      );
}

class _StatSection extends StatelessWidget {
  const _StatSection();

  @override
  Widget build(BuildContext context) => const ClayCard(
        title: ClaySectionTitle(
          'Stat cards',
          subtitle: '40dp tint · headlineSmall tabular · labelMedium',
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ClayStatCard(
                  title: 'Revenue',
                  value: 'रू 12,340.00',
                  icon: ClayIcons.revenue,
                  iconColor: ClayColors.success,
                  subtitle: 'This month',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ClayStatCard(
                  title: 'Payables',
                  value: 'रू 4,120.50',
                  icon: ClayIcons.payables,
                  iconColor: ClayColors.warning,
                  subtitle: 'This month',
                ),
              ),
            ],
          ),
        ),
      );
}

class _ButtonSection extends StatelessWidget {
  const _ButtonSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('Buttons · 48dp targets'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ClayButton(onPressed: () {}, child: const Text('Elevated')),
              ClayButton.outlined(
                  onPressed: () {}, child: const Text('Outlined')),
              ClayButton.text(onPressed: () {}, child: const Text('Text')),
              const ClayIconButton(
                  icon: ClayIcons.search, tooltip: 'Search'),
            ],
          ),
        ),
      );
}

class _InputSection extends StatelessWidget {
  const _InputSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle('Inputs'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ClaySearchInput(hintText: 'Search…'),
              const SizedBox(height: 12),
              const ClayInputWithLabel(
                label: 'Company name',
                hintText: 'My Company',
              ),
              const SizedBox(height: 12),
              ClayDropdownInput<String>(
                label: 'Currency',
                value: 'NPR',
                items: const [
                  DropdownMenuItem(value: 'NPR', child: Text('NPR')),
                  DropdownMenuItem(value: 'INR', child: Text('INR')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              const ClayCurrencyInput(label: 'Amount', hintText: '0.00'),
            ],
          ),
        ),
      );
}

class _FormSection extends StatelessWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) => ClayCard(
        title: const ClaySectionTitle(
          'Forms',
          subtitle: 'Controlled · required · BS date',
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ClayInputWithLabel(
                label: 'Company name',
                hintText: 'My Company',
                isRequired: true,
              ),
              const SizedBox(height: 12),
              const ClayCurrencyInput(
                label: 'Opening balance',
                hintText: '0.00',
                isRequired: true,
              ),
              const SizedBox(height: 12),
              ClayBsDateInput(
                label: 'Fiscal start',
                value: DateTime(2025, 10, 13),
                onChanged: null,
                isRequired: true,
              ),
            ],
          ),
        ),
      );
}

class _AdaptiveSection extends StatelessWidget {
  const _AdaptiveSection();

  @override
  Widget build(BuildContext context) => const ClayCard(
        title: ClaySectionTitle(
          'Adaptive',
          subtitle: 'Two-column · tiles · trend · sparkline',
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClayActionTile(
                      icon: ClayIcons.sales,
                      title: 'New Sale',
                      iconColor: ClayColors.success,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ClayActionTile(
                      icon: ClayIcons.purchases,
                      title: 'New Purchase',
                      iconColor: ClayColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ClayTrend(pct: 12.5),
                  ClayTrend(pct: -8.2, invert: true),
                ],
              ),
              SizedBox(height: 12),
              ClaySparkline(
                data: [3, 5, 4, 7, 6, 9],
                color: ClayColors.success,
              ),
            ],
          ),
        ),
      );
}

class _IconSection extends StatelessWidget {
  const _IconSection();

  @override
  Widget build(BuildContext context) {
    const icons = <String, IconData>{
      'dashboard': ClayIcons.dashboard,
      'contacts': ClayIcons.contacts,
      'products': ClayIcons.products,
      'transactions': ClayIcons.transactions,
      'payments': ClayIcons.payments,
      'revenue': ClayIcons.revenue,
      'expenses': ClayIcons.expenses,
      'receivables': ClayIcons.receivables,
      'payables': ClayIcons.payables,
      'profit': ClayIcons.profit,
      'search': ClayIcons.search,
      'date': ClayIcons.date,
    };
    return ClayCard(
      title: const ClaySectionTitle(
        'Icons',
        subtitle: 'Rounded family · 24dp glyph · 48dp target',
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in icons.entries)
              Chip(
                avatar: Icon(entry.value, size: ClayIconSize.dense),
                label: Text(entry.key),
              ),
          ],
        ),
      ),
    );
  }
}
