import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/company_model.dart';
import '../../../packages/design-system/design_system.dart';

/// First-run business registration wizard.
///
/// Blocking gate (see the router `redirect` in `app.dart`): the app shows
/// this until a company profile exists in Hive. Three validated steps —
/// Business, Contact, Tax — then a keyed `put` of the [CompanyModel] and
/// a `go('/')` into the app. Local-only: no accounts, no network.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const List<String> _steps = ['Business', 'Contact', 'Tax'];

  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRe = RegExp(r'^[+\d][\d\s-]{6,}$');
  static final RegExp _taxIdRe = RegExp(r'^\d{9}$');

  int _step = 0;
  bool _saving = false;

  final _businessKey = GlobalKey<FormState>();
  final _contactKey = GlobalKey<FormState>();
  final _taxKey = GlobalKey<FormState>();

  String _name = '';
  String _owner = '';
  String _regNo = '';
  String _address = '';
  String _city = '';
  String _district = '';
  String _phone = '';
  String _mobile = '';
  String _email = '';
  String _pan = '';
  String _vat = '';
  String _website = '';

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;

  String? _phoneValidator(String? value, {required bool required}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Phone is required' : null;
    }
    if (!_phoneRe.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRe.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _taxIdValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    if (!_taxIdRe.hasMatch(value.trim())) {
      return '$label must be 9 digits';
    }
    return null;
  }

  void _continue() {
    final key = (_step == 0
        ? _businessKey
        : _step == 1
            ? _contactKey
            : _taxKey);
    if (!(key.currentState?.validate() ?? false)) return;
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final hive = ref.read(hiveServiceProvider);
      final company = CompanyModel.create(
        name: _name.trim(),
        ownerName: _owner.trim(),
        registrationNumber: _regNo.trim(),
        address: _address.trim(),
        city: _city.trim().isEmpty ? null : _city.trim(),
        district: _district.trim().isEmpty ? null : _district.trim(),
        phone: _phone.trim(),
        mobile: _mobile.trim().isEmpty ? null : _mobile.trim(),
        email: _email.trim(),
        website: _website.trim().isEmpty ? null : _website.trim(),
        panNumber: _pan.trim(),
        vatNumber: _vat.trim(),
      );
      await hive.companiesBox.put(company.id, company);
      if (!mounted) return;
      context.go('/');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: scheme.primaryContainer,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          ClayIcons.profit,
                          size: 30,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: ClaySpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to nKount',
                              style: text.headlineSmall,
                            ),
                            Text(
                              'Register your business to get started',
                              style: text.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ClaySpacing.xl),
                  Row(
                    children: [
                      for (var i = 0; i < _steps.length; i++) ...[
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              color: i <= _step
                                  ? scheme.primary
                                  : scheme.surfaceContainerHighest,
                            ),
                          ),
                        Text(
                          _steps[i],
                          style: text.labelLarge?.copyWith(
                            color: i == _step
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                            fontWeight: i == _step ? FontWeight.w700 : null,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: ClaySpacing.sm),
                  LinearProgressIndicator(value: (_step + 1) / _steps.length),
                  const SizedBox(height: ClaySpacing.xl),
                  if (_step == 0) _businessForm(),
                  if (_step == 1) _contactForm(),
                  if (_step == 2) _taxForm(),
                  const SizedBox(height: ClaySpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_step > 0)
                        TextButton(
                          onPressed:
                              _saving ? null : () => setState(() => _step--),
                          style: TextButton.styleFrom(
                            foregroundColor: scheme.onSurfaceVariant,
                          ),
                          child: const Text('Back'),
                        ),
                      const SizedBox(width: ClaySpacing.sm),
                      ClayButton(
                        onPressed: _saving ? null : _continue,
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _step == 2 ? 'Register Business' : 'Continue',
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _businessForm() => Form(
        key: _businessKey,
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Business name',
              hintText: 'e.g. Shree Traders',
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _required(v, 'Business name'),
              onChanged: (v) => _name = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Owner name',
              hintText: 'e.g. Ram Bahadur',
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _required(v, 'Owner name'),
              onChanged: (v) => _owner = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Registration number',
              hintText: 'Company registration no.',
              textInputAction: TextInputAction.done,
              isRequired: true,
              validator: (v) => _required(v, 'Registration number'),
              onChanged: (v) => _regNo = v,
            ),
          ],
        ),
      );

  Widget _contactForm() => Form(
        key: _contactKey,
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Address',
              hintText: 'Street / ward',
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _required(v, 'Address'),
              onChanged: (v) => _address = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'City',
              hintText: 'e.g. Kathmandu',
              textInputAction: TextInputAction.next,
              onChanged: (v) => _city = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'District',
              hintText: 'e.g. Kathmandu',
              textInputAction: TextInputAction.next,
              onChanged: (v) => _district = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Phone',
              hintText: '+977 1 4444444',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _phoneValidator(v, required: true),
              onChanged: (v) => _phone = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Mobile',
              hintText: '98XXXXXXXX',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) => _phoneValidator(v, required: false),
              onChanged: (v) => _mobile = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Email',
              hintText: 'info@business.com.np',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              isRequired: true,
              validator: _emailValidator,
              onChanged: (v) => _email = v,
            ),
          ],
        ),
      );

  Widget _taxForm() => Form(
        key: _taxKey,
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'PAN',
              hintText: '9-digit PAN',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _taxIdValidator(v, 'PAN'),
              onChanged: (v) => _pan = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'VAT',
              hintText: '9-digit VAT number',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              isRequired: true,
              validator: (v) => _taxIdValidator(v, 'VAT'),
              onChanged: (v) => _vat = v,
            ),
            const SizedBox(height: ClaySpacing.lg),
            ClayInputWithLabel(
              label: 'Website',
              hintText: 'https://example.com.np',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onChanged: (v) => _website = v,
            ),
          ],
        ),
      );
}
