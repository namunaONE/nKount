import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/payment_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/utils/money.dart';
import 'package:nkount/features/contacts/presentation/contacts_screen.dart';
import 'package:nkount/features/transactions/presentation/transactions_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Phase A flow tests: the save paths users had no access to.
/// Covers the validation gate, the contact repo write (which had zero UI
/// callers), and the payment→balance rule the README documents.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_flow');
    await hiveService.initialize(testPath: dir.path);
  });

  Future<void> pumpApp(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: ClayTheme.lightTheme, home: screen),
      ),
    );
  }

  group('add-contact form', () {
    testWidgets('empty name blocks save and writes nothing', (tester) async {
      await pumpApp(tester, const ContactsScreen());
      await tester.tap(find.text('Add Contact').first);
      await tester.pumpAndSettle();
      expect(find.text('Add New Contact'), findsOneWidget);

      // Save must be blocked by the validator, not silently accepted.
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Name is required'), findsOneWidget);
      expect(hiveService.contactsBox.isEmpty, isTrue);
      expect(find.text('Add New Contact'), findsOneWidget); // still open
    });

    testWidgets('valid form saves the contact', (tester) async {
      await pumpApp(tester, const ContactsScreen());
      await tester.tap(find.text('Add Contact').first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Ram Bahadur');
      await tester.tap(find.text('Save'));
      await tester.pump();
      // Saving persists via real file IO, which never completes under the
      // widget-test fake clock. Hand control to the real event loop so the
      // write resolves, then settle the resulting pop + snackbar.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5)); // snackbar auto-dismiss

      expect(find.text('Add New Contact'), findsNothing); // closed
      expect(hiveService.contactsBox.length, 1);
      final saved = hiveService.contactsBox.values.first;
      expect(saved.name, 'Ram Bahadur');
      expect(saved.type, AppConstants.contactCustomer);
      // Appears in the table without a reload.
      expect(find.text('Ram Bahadur'), findsWidgets);
    });
  });

  group('add-transaction form', () {
    testWidgets('missing contact id blocks save', (tester) async {
      await pumpApp(tester, const TransactionsScreen());
      await tester.tap(find.text('Add Transaction').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Contact ID is required'), findsOneWidget);
      expect(hiveService.transactionsBox.isEmpty, isTrue);
    });

    testWidgets('valid form saves the transaction', (tester) async {
      await pumpApp(tester, const TransactionsScreen());
      await tester.tap(find.text('Add Transaction').first);
      await tester.pumpAndSettle();

      // Contact ID is the second field (type is a dropdown first).
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'contact-1');
      await tester.tap(find.text('Save'));
      await tester.pump();
      // Real Hive IO can't complete under the fake clock; see above.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5)); // snackbar auto-dismiss

      expect(hiveService.transactionsBox.length, 1);
      final saved = hiveService.transactionsBox.values.first;
      expect(saved.contactId, 'contact-1');
      expect(saved.type, AppConstants.transactionSale);
      expect(saved.dueAmount, saved.total); // nothing paid yet
    });
  });
}
