import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/models/transaction_item_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/utils/money.dart';
import 'package:nkount/features/contacts/presentation/contacts_screen.dart';
import 'package:nkount/features/dashboard/presentation/dashboard_screen.dart';
import 'package:nkount/features/expenses/presentation/expenses_screen.dart';
import 'package:nkount/features/gallery/presentation/gallery_screen.dart';
import 'package:nkount/features/income/presentation/income_screen.dart';
import 'package:nkount/features/payments/presentation/payments_screen.dart';
import 'package:nkount/features/products/presentation/products_screen.dart';
import 'package:nkount/features/profile/presentation/profile_screen.dart';
import 'package:nkount/features/purchases/presentation/purchases_screen.dart';
import 'package:nkount/features/receipts/presentation/receipts_screen.dart';
import 'package:nkount/features/reports/presentation/reports_screen.dart';
import 'package:nkount/features/sales/presentation/sales_screen.dart';
import 'package:nkount/features/settings/presentation/settings_screen.dart';
import 'package:nkount/features/transactions/presentation/transactions_screen.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// R5 screen smoke tests: every screen must build its first frame without
/// throwing (the R0 sales/purchases crash class). Hive runs on a scratch
/// dir via [HiveService.initialize] `testPath`; one seeded contact, sale,
/// and low-stock product exercise badges, alerts, KPIs, and two-pane paths
/// at 1280px (expanded shell).
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final dir = await Directory.systemTemp.createTemp('nkount_smoke');
    await hiveService.initialize(testPath: dir.path);

    final contact = ContactModel.create(name: 'Seed Customer')
        .copyWithTransaction(
      transactionType: AppConstants.transactionPurchase,
      amount: 100,
    );
    await hiveService.contactsBox.put(contact.id, contact);

    final tx = TransactionModel.create(
      type: AppConstants.transactionSale,
      contactId: contact.id,
      items: [
        TransactionItem.create(
          productId: 'p1',
          productName: 'Seed Widget',
          quantity: 1,
          unitPrice: 1000,
        ),
      ],
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    );
    await hiveService.transactionsBox.put(tx.id, tx);

    final product = ProductModel.create(
      name: 'Seed Widget',
      purchasePrice: 10,
      salePrice: 15,
      quantity: 1,
      minQuantity: 5,
    );
    await hiveService.productsBox.put(product.id, product);
  });

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ClayTheme.lightTheme,
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('dashboard renders seeded revenue + alerts', (tester) async {
    await pumpScreen(tester, const DashboardScreen());
    // 1 x 1000 + 13% VAT, unpaid and overdue.
    expect(find.text(formatCurrency(1130.0)), findsWidgets);
    expect(find.text('Needs attention'), findsOneWidget);
  });

  testWidgets('contacts shows seeded contact', (tester) async {
    await pumpScreen(tester, const ContactsScreen());
    expect(find.text('Seed Customer'), findsWidgets);
  });

  testWidgets('products shows seeded low-stock product', (tester) async {
    await pumpScreen(tester, const ProductsScreen());
    expect(find.text('Seed Widget'), findsWidgets);
  });

  testWidgets('transactions renders two-pane', (tester) async {
    await pumpScreen(tester, const TransactionsScreen());
    expect(find.text('Transactions'), findsWidgets);
  });

  testWidgets('sales builds (R0 crash regression)', (tester) async {
    await pumpScreen(tester, const SalesScreen());
    expect(find.text('Sales'), findsOneWidget);
  });

  testWidgets('purchases builds (R0 crash regression)', (tester) async {
    await pumpScreen(tester, const PurchasesScreen());
    expect(find.text('Purchases'), findsOneWidget);
  });

  testWidgets('income builds', (tester) async {
    await pumpScreen(tester, const IncomeScreen());
    expect(find.text('Income'), findsOneWidget);
  });

  testWidgets('expenses builds', (tester) async {
    await pumpScreen(tester, const ExpensesScreen());
    expect(find.text('Expenses'), findsOneWidget);
  });

  testWidgets('receipts builds', (tester) async {
    await pumpScreen(tester, const ReceiptsScreen());
    expect(find.text('Receipts'), findsOneWidget);
  });

  testWidgets('payments builds', (tester) async {
    await pumpScreen(tester, const PaymentsScreen());
    // Title in app bar + destination label in sidebar.
    expect(find.text('Payments'), findsWidgets);
  });

  testWidgets('profile builds', (tester) async {
    await pumpScreen(tester, const ProfileScreen());
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('reports builds', (tester) async {
    await pumpScreen(tester, const ReportsScreen());
    expect(find.text('Reports'), findsOneWidget);
  });

  testWidgets('settings builds', (tester) async {
    await pumpScreen(tester, const SettingsScreen());
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('gallery builds', (tester) async {
    await pumpScreen(tester, const GalleryScreen());
    expect(find.text('Typography'), findsOneWidget);
  });

  testWidgets('every icon button has a tooltip (a11y)', (tester) async {
    await pumpScreen(tester, const GalleryScreen());
    final buttons =
        tester.widgetList<IconButton>(find.byType(IconButton)).toList();
    expect(buttons, isNotEmpty);
    for (final button in buttons) {
      expect(button.tooltip, isNotNull);
    }
  });
}
