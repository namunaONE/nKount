// Nepal location picker: cascading Province → District → Palika,
// backed by the offline `nepal_admin_api` dataset (no network, no Hive).
part of '../design_system.dart';

/// Cascading Nepal location picker (Province → District → Palika).
///
/// Controlled: the parent owns [provinceId], [districtName] and
/// [palikaName], and MUST clear downstream values when an upstream one
/// changes (a Chitwan district pick is meaningless under Koshi).
/// Labels are bilingual (`displayBoth`); Devanagari renders through the
/// theme font fallback. Data is offline and synchronous, so this is safe
/// in widget tests without any async bridging.
class ClayNepalLocationPicker extends StatelessWidget {
  const ClayNepalLocationPicker({
    super.key,
    this.provinceId,
    this.districtName,
    this.palikaName,
    this.onProvinceChanged,
    this.onDistrictChanged,
    this.onPalikaChanged,
    this.provinceValidator,
    this.districtValidator,
    this.palikaValidator,
    this.isRequired = false,
    this.enabled = true,
  });

  /// `Province.id` (e.g. `'bagmati'`).
  final String? provinceId;

  /// `District.name` (e.g. `'Chitwan'`), scoped to [provinceId].
  final String? districtName;

  /// `LocalBody.name` (e.g. `'Bharatpur'`), scoped to [districtName].
  /// Optional: palikas number 753, so collecting only province + district
  /// is a supported shorthand.
  final String? palikaName;

  final ValueChanged<String?>? onProvinceChanged;
  final ValueChanged<String?>? onDistrictChanged;
  final ValueChanged<String?>? onPalikaChanged;
  final FormFieldValidator<String>? provinceValidator;
  final FormFieldValidator<String>? districtValidator;
  final FormFieldValidator<String>? palikaValidator;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final provinces = NepalAdminApi.getAllProvinces();
    final districts = provinceId == null
        ? const <District>[]
        : NepalAdminApi.getDistrictsByProvince(provinceId!);
    final palikas = districtName == null
        ? const <LocalBody>[]
        : NepalAdminApi.getLocalBodiesByDistrict(districtName!);
    return Column(
      children: [
        ClayDropdownInput<String>(
          key: const ValueKey('nepal-province'),
          label: 'Province',
          value: provinceId,
          items: [
            for (final province in provinces)
              DropdownMenuItem(
                value: province.id,
                child: Text(province.displayBoth),
              ),
          ],
          onChanged: onProvinceChanged,
          validator: provinceValidator ??
              (isRequired
                  ? (value) => value == null ? 'Province is required' : null
                  : null),
          isRequired: isRequired,
          enabled: enabled,
        ),
        const SizedBox(height: ClaySpacing.lg),
        ClayDropdownInput<String>(
          key: const ValueKey('nepal-district'),
          label: 'District',
          value: districtName,
          items: [
            for (final district in districts)
              DropdownMenuItem(
                value: district.name,
                child: Text(district.displayBoth),
              ),
          ],
          onChanged: onDistrictChanged,
          validator: districtValidator ??
              (isRequired
                  ? (value) => value == null ? 'District is required' : null
                  : null),
          isRequired: isRequired,
          enabled: enabled,
        ),
        const SizedBox(height: ClaySpacing.lg),
        ClayDropdownInput<String>(
          key: const ValueKey('nepal-palika'),
          label: 'Municipality (Palika)',
          value: palikaName,
          items: [
            for (final palika in palikas)
              DropdownMenuItem(
                value: palika.name,
                child: Text('${palika.displayBoth} · ${palika.typeName}'),
              ),
          ],
          onChanged: onPalikaChanged,
          validator: palikaValidator,
          enabled: enabled,
        ),
      ],
    );
  }
}
