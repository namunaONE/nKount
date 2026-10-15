import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_admin_api/nepal_admin_api.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Location picker: cascade behavior over the offline dataset.
///
/// No Hive here — the picker is pure synchronous UI over package data.
void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('dataset sanity (offline)', () {
    test('7 provinces, 77 districts', () {
      expect(NepalAdminApi.getAllProvinces(), hasLength(7));
      expect(NepalAdminApi.getAllDistricts(), hasLength(77));
    });

    test('Bagmati scopes Chitwan scopes Bharatpur', () {
      final bagmati = NepalAdminApi.getProvinceById('bagmati');
      expect(bagmati, isNotNull);
      final districts = NepalAdminApi.getDistrictsByProvince('bagmati');
      expect(districts.map((d) => d.name), contains('Chitwan'));
      final palikas = NepalAdminApi.getLocalBodiesByDistrict('Chitwan');
      expect(palikas.map((p) => p.name), contains('Bharatpur'));
    });
  });

  group('ClayNepalLocationPicker', () {
    Future<void> pumpHarness(
      WidgetTester tester, {
      required void Function(String?) onProvince,
      required void Function(String?) onDistrict,
      required void Function(String?) onPalika,
      String? provinceId,
      String? districtName,
      String? palikaName,
    }) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ClayNepalLocationPicker(
                provinceId: provinceId,
                districtName: districtName,
                palikaName: palikaName,
                onProvinceChanged: onProvince,
                onDistrictChanged: onDistrict,
                onPalikaChanged: onPalika,
                isRequired: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    Future<void> openAndPick(
      WidgetTester tester,
      String key,
      String contains,
    ) async {
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(DropdownButtonFormField<String>),
        ),
      );
      await tester.pumpAndSettle();
      final match = find.textContaining(contains);
      expect(match, findsOneWidget);
      await tester.tap(match);
      await tester.pumpAndSettle();
    }

    testWidgets('cascades province to district to palika', (tester) async {
      String? provinceId;
      String? districtName;
      String? palikaName;

      Future<void> repump() => pumpHarness(
            tester,
            onProvince: (v) => provinceId = v,
            onDistrict: (v) => districtName = v,
            onPalika: (v) => palikaName = v,
            provinceId: provinceId,
            districtName: districtName,
            palikaName: palikaName,
          );

      await repump();
      // Seven provinces offered, bilingual labels.
      await tester.tap(find.descendant(
        of: find.byKey(const ValueKey('nepal-province')),
        matching: find.byType(DropdownButtonFormField<String>),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('Bagmati'), findsOneWidget);
      expect(find.textContaining('Koshi'), findsOneWidget);
      await tester.tap(find.textContaining('Bagmati'));
      await tester.pumpAndSettle();
      // Parent clears downstream on upstream change (contract check).
      districtName = null;
      palikaName = null;
      expect(provinceId, 'bagmati');

      await repump();
      await openAndPick(tester, 'nepal-district', 'Chitwan');
      expect(districtName, 'Chitwan');

      await repump();
      await openAndPick(tester, 'nepal-palika', 'Bharatpur');
      expect(palikaName, 'Bharatpur');

      // District menu is scoped: no Koshi districts under Bagmati.
      await repump();
      final districtButton = find.descendant(
        of: find.byKey(const ValueKey('nepal-district')),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      await tester.tap(districtButton);
      await tester.pumpAndSettle();
      expect(find.textContaining('Jhapa'), findsNothing);
      // Toggle shut (the closed button already displays Chitwan).
      await tester.tap(districtButton);
      await tester.pumpAndSettle();
    });

    testWidgets('required province and district block save', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          theme: ClayTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: const ClayNepalLocationPicker(isRequired: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(formKey.currentState?.validate(), isFalse);
      await tester.pump();
      expect(find.text('Province is required'), findsOneWidget);
      expect(find.text('District is required'), findsOneWidget);
      // Palika stays optional.
      expect(find.text('Municipality (Palika) is required'), findsNothing);
    });
  });
}
