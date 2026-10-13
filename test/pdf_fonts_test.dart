import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/core/services/pdf_service.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF generators must use the bundled static Hind font (Devanagari+Latin).
/// Receipt/statement/report previously pointed at non-existent Roboto
/// assets and would crash outright; the invoice used Helvetica (tofu for
/// Devanagari text).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled Hind font assets load and parse (static TTF)', () async {
    for (final asset in [
      'assets/fonts/Hind-Regular.ttf',
      'assets/fonts/Hind-Bold.ttf',
    ]) {
      final bytes = await rootBundle.load(asset);
      expect(bytes.lengthInBytes, greaterThan(0));
      // Must not throw: proves the pdf TTF parser accepts the files.
      expect(() => pw.Font.ttf(bytes), returnsNormally);
    }
  });

  test('summary report generates with Devanagari company name', () async {
    final company = CompanyModel.create(name: 'नमुना ट्रेडर्स');
    final bytes = await PdfService().generateSummaryReportPdf(
      company: company,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      totalSales: 1000,
      totalPurchases: 400,
      totalPayments: 100,
      totalReceipts: 200,
      netProfit: 600,
      totalInvoices: 3,
      totalCustomers: 2,
      totalProducts: 5,
    );
    expect(bytes.lengthInBytes, greaterThan(0));
  });
}
