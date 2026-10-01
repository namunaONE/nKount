/// PDF Service for nKount
/// Generates professional invoices, receipts, and reports in PDF format

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/models/company_model.dart';
import 'package:nkount/core/models/contact_model.dart';
import 'package:nkount/core/models/transaction_model.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/core/database/hive_service.dart';

/// PDF Service for generating accounting documents
class PdfService {
  static final PdfService _instance = PdfService._internal();
  
  // Font configuration
  static final pw.Font _regularFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
  );
  static final pw.Font _boldFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
  );
  static final pw.Font _nepaliFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Preeti.ttf'),
  );
  
  // Private constructor
  PdfService._internal();
  
  // Factory constructor
  factory PdfService() => _instance;
  
  /// Generate an invoice PDF
  Future<Uint8List> generateInvoicePdf({
    required TransactionModel transaction,
    required CompanyModel company,
    required ContactModel contact,
    required List<ProductModel> products,
    bool showTax = true,
    bool showVatNumber = true,
  }) async {
    final pdf = pw.Document();
    
    // Load fonts
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );
    
    // Create invoice
    pdf.addPage(
      await _buildInvoicePage(
        transaction: transaction,
        company: company,
        contact: contact,
        products: products,
        showTax: showTax,
        showVatNumber: showVatNumber,
        regularFont: regularFont,
        boldFont: boldFont,
      ),
    );
    
    return pdf.save();
  }
  
  /// Build invoice page
  Future<pw.Page> _buildInvoicePage({
    required TransactionModel transaction,
    required CompanyModel company,
    required ContactModel contact,
    required List<ProductModel> products,
    required bool showTax,
    required bool showVatNumber,
    required pw.Font regularFont,
    required pw.Font boldFont,
  }) async {
    // Get transaction items
    final items = transaction.items ?? [];
    
    // Calculate totals
    final subtotal = transaction.subtotal;
    final discount = transaction.discount;
    final tax = transaction.tax;
    final total = transaction.total;
    final paid = transaction.paidAmount;
    final due = transaction.dueAmount;
    
    // Find product details
    final productMap = {for (var p in products) p.id: p};
    
    return pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with company info
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Company logo/name
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        company.name,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 24,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        company.address ?? '',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        '${company.city ?? ''}, ${company.district ?? ''}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      if (company.phone != null && company.phone!.isNotEmpty)
                        pw.Text(
                          'Phone: ${company.phone}',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                        ),
                      if (company.email != null && company.email!.isNotEmpty)
                        pw.Text(
                          'Email: ${company.email}',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                        ),
                      if (showVatNumber && company.vatNumber != null && company.vatNumber!.isNotEmpty)
                        pw.Text(
                          'VAT No: ${company.vatNumber}',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                        ),
                      if (company.panNumber != null && company.panNumber!.isNotEmpty)
                        pw.Text(
                          'PAN No: ${company.panNumber}',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Invoice details
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.grey400,
                          width: 1,
                        ),
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(8),
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 20,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'Invoice No: ${transaction.invoiceNumber ?? 'N/A'}',
                            style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Date: ${_formatDate(transaction.date)}',
                            style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 12,
                            ),
                          ),
                          if (transaction.dueDate != null)
                            pw.Text(
                              'Due: ${_formatDate(transaction.dueDate)}',
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            pw.Divider(height: 20, thickness: 1),
            
            // Customer info
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'To:',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      contact.name,
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      contact.address ?? '',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      '${contact.city ?? ''}, ${contact.district ?? ''}',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                      ),
                    ),
                    if (contact.vatNumber != null && contact.vatNumber!.isNotEmpty)
                      pw.Text(
                        'VAT No: ${contact.vatNumber}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    if (contact.panNumber != null && contact.panNumber!.isNotEmpty)
                      pw.Text(
                        'PAN No: ${contact.panNumber}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Items table
            pw.Table.fromTextArray(
              headers: [
                'S.N.',
                'Description',
                'Qty',
                'Unit',
                'Rate',
                if (showTax) 'Tax',
                'Amount',
              ],
              data: _buildInvoiceTableData(
                items: items,
                products: productMap,
                showTax: showTax,
              ),
              border: pw.TableBorder.all(
                color: PdfColors.grey300,
                width: 0.5,
              ),
              headerStyle: pw.TextStyle(
                font: boldFont,
                fontSize: 12,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(6),
              headerPadding: const pw.EdgeInsets.all(8),
              columnWidths: {
                0: const pw.FixedColumnWidth(40),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FixedColumnWidth(60),
                3: const pw.FixedColumnWidth(60),
                4: const pw.FixedColumnWidth(80),
                if (showTax) 5: const pw.FixedColumnWidth(80),
                if (showTax) 6: const pw.FixedColumnWidth(100),
                if (!showTax) 5: const pw.FixedColumnWidth(100),
              },
            ),
            
            pw.SizedBox(height: 10),
            
            // Totals
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.SizedBox(
                      width: 200,
                      child: pw.Text(
                        'Subtotal:',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.SizedBox(width: 16),
                    pw.Text(
                      '${AppConstants.CURRENCY} ${_formatCurrency(subtotal)}',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (discount > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          'Discount:',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 16),
                      pw.Text(
                        '-${AppConstants.CURRENCY} ${_formatCurrency(discount)}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (showTax && tax > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          'VAT (${transaction.vatRate}%):',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 16),
                      pw.Text(
                        '+${AppConstants.CURRENCY} ${_formatCurrency(tax)}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                pw.Divider(
                  height: 1,
                  thickness: 1,
                  color: PdfColors.grey400,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.SizedBox(
                      width: 200,
                      child: pw.Text(
                        'Total:',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.SizedBox(width: 16),
                    pw.Text(
                      '${AppConstants.CURRENCY} ${_formatCurrency(total)}',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (paid > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          'Paid:',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 16),
                      pw.Text(
                        '${AppConstants.CURRENCY} ${_formatCurrency(paid)}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (due > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          'Due:',
                          style: pw.TextStyle(
                            font: regularFont,
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(width: 16),
                      pw.Text(
                        '${AppConstants.CURRENCY} ${_formatCurrency(due)}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                          color: PdfColors.red600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            pw.SizedBox(height: 20),
            
            // Footer
            pw.Divider(height: 1, thickness: 1, color: PdfColors.grey300),
            pw.SizedBox(height: 10),
            pw.Text(
              company.footerText ?? 'Thank you for your business!',
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 12,
                color: PdfColors.grey600,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'IRD Compliant | Nepal Financial Reporting Standards (NFRS)',
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 10,
                color: PdfColors.grey500,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        );
      },
      margin: const pw.EdgeInsets.all(32),
    );
  }
  
  /// Build invoice table data
  List<List<String>> _buildInvoiceTableData({
    required List<dynamic> items,
    required Map<String, ProductModel> products,
    required bool showTax,
  }) {
    final data = <List<String>>[];
    
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final product = products[item.productId];
      final productName = product?.name ?? item.productName;
      final unit = product?.unit ?? item.unit ?? 'Unit';
      
      final row = [
        (i + 1).toString(),
        productName,
        item.quantity.toStringAsFixed(2),
        unit,
        _formatCurrency(item.unitPrice),
      ];
      
      if (showTax) {
        row.add(_formatCurrency(item.tax));
      }
      
      row.add(_formatCurrency(item.amount));
      data.add(row);
    }
    
    return data;
  }
  
  /// Format date
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd').format(date);
  }
  
  /// Format currency
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }
  
  /// Generate a receipt PDF
  Future<Uint8List> generateReceiptPdf({
    required TransactionModel transaction,
    required CompanyModel company,
    required ContactModel contact,
    required double amount,
    required String paymentMethod,
    required String referenceNumber,
  }) async {
    final pdf = pw.Document();
    
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        company.name,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 20,
                        ),
                      ),
                      pw.Text(
                        company.address ?? '',
                        style: pw.TextStyle(font: regularFont, fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Text(
                    'RECEIPT',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 24,
                      color: PdfColors.green700,
                    ),
                  ),
                ],
              ),
              
              pw.Divider(height: 20, thickness: 1),
              
              // Receipt details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Receipt No: ${transaction.invoiceNumber ?? 'N/A'}'),
                      pw.SizedBox(height: 4),
                      pw.Text('Date: ${_formatDate(transaction.date)}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice: ${transaction.invoiceNumber ?? 'N/A'}'),
                      pw.SizedBox(height: 4),
                      pw.Text('Payment: $paymentMethod'),
                    ],
                  ),
                ],
              ),
              
              pw.Divider(height: 20, thickness: 1),
              
              // Customer info
              pw.Text(
                'Received from:',
                style: pw.TextStyle(font: boldFont, fontSize: 14),
              ),
              pw.Text(
                contact.name,
                style: pw.TextStyle(font: boldFont, fontSize: 14),
              ),
              
              pw.SizedBox(height: 20),
              
              // Amount
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Amount Received:',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                  pw.Text(
                    '${AppConstants.CURRENCY} ${_formatCurrency(amount)}',
                    style: pw.TextStyle(font: boldFont, fontSize: 16),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 10),
              
              // Reference
              pw.Text(
                'Reference: $referenceNumber',
                style: pw.TextStyle(font: regularFont, fontSize: 12),
              ),
              
              pw.SizedBox(height: 20),
              
              // Footer
              pw.Divider(height: 1, thickness: 1),
              pw.SizedBox(height: 10),
              pw.Text(
                'Thank you for your payment!',
                style: pw.TextStyle(font: regularFont, fontSize: 12),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
        margin: const pw.EdgeInsets.all(32),
      ),
    );
    
    return pdf.save();
  }
  
  /// Generate a statement PDF
  Future<Uint8List> generateStatementPdf({
    required CompanyModel company,
    required ContactModel contact,
    required List<TransactionModel> transactions,
    required double openingBalance,
    required double closingBalance,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        company.name,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 20,
                        ),
                      ),
                      pw.Text(company.address ?? ''),
                      pw.Text('${company.city ?? ''}, ${company.district ?? ''}'),
                    ],
                  ),
                  pw.Text(
                    'ACCOUNT STATEMENT',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              
              pw.Divider(height: 20, thickness: 1),
              
              // Statement info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Statement for:', style: pw.TextStyle(font: boldFont)),
                      pw.Text(contact.name),
                      pw.Text(contact.address ?? ''),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Period:', style: pw.TextStyle(font: boldFont)),
                      pw.Text('${_formatDate(startDate)} to ${_formatDate(endDate)}'),
                    ],
                  ),
                ],
              ),
              
              pw.Divider(height: 20, thickness: 1),
              
              // Table
              pw.Table.fromTextArray(
                headers: [
                  'Date',
                  'Invoice No',
                  'Description',
                  'Debit',
                  'Credit',
                  'Balance',
                ],
                data: _buildStatementTableData(
                  transactions: transactions,
                  openingBalance: openingBalance,
                ),
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColors.blue900),
                cellPadding: const pw.EdgeInsets.all(6),
                columnWidths: {
                  0: const pw.FixedColumnWidth(100),
                  1: const pw.FixedColumnWidth(100),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FixedColumnWidth(80),
                  4: const pw.FixedColumnWidth(80),
                  5: const pw.FixedColumnWidth(100),
                },
              ),
              
              pw.SizedBox(height: 10),
              
              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.SizedBox(
                    width: 300,
                    child: pw.Text(
                      'Closing Balance:',
                      style: pw.TextStyle(font: boldFont, fontSize: 14),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Text(
                    '${AppConstants.CURRENCY} ${_formatCurrency(closingBalance)}',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Footer
              pw.Divider(height: 1, thickness: 1),
              pw.Text(
                'This is a computer-generated statement. No signature required.',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
        margin: const pw.EdgeInsets.all(32),
      ),
    );
    
    return pdf.save();
  }
  
  /// Build statement table data
  List<List<String>> _buildStatementTableData({
    required List<TransactionModel> transactions,
    required double openingBalance,
  }) {
    final data = <List<String>>[];
    
    // Opening balance
    data.add([
      '',
      '',
      'Opening Balance',
      '',
      '',
      _formatCurrency(openingBalance),
    ]);
    
    // Transactions
    double runningBalance = openingBalance;
    for (final transaction in transactions) {
      final date = _formatDate(transaction.date);
      final invoiceNo = transaction.invoiceNumber ?? 'N/A';
      final description = transaction.typeDisplayName;
      
      double debit = 0;
      double credit = 0;
      
      if (transaction.type == AppConstants.TRANSACTION_SALE ||
          transaction.type == AppConstants.TRANSACTION_RECEIPT) {
        credit = transaction.total;
      } else {
        debit = transaction.total;
      }
      
      runningBalance += (credit - debit);
      
      data.add([
        date,
        invoiceNo,
        description,
        debit > 0 ? _formatCurrency(debit) : '',
        credit > 0 ? _formatCurrency(credit) : '',
        _formatCurrency(runningBalance),
      ]);
    }
    
    return data;
  }
  
  /// Generate a summary report PDF
  Future<Uint8List> generateSummaryReportPdf({
    required CompanyModel company,
    required DateTime startDate,
    required DateTime endDate,
    required double totalSales,
    required double totalPurchases,
    required double totalPayments,
    required double totalReceipts,
    required double netProfit,
    required int totalInvoices,
    required int totalCustomers,
    required int totalProducts,
  }) async {
    final pdf = pw.Document();
    
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        company.name,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 20,
                        ),
                      ),
                      pw.Text(company.address ?? ''),
                    ],
                  ),
                  pw.Text(
                    'SUMMARY REPORT',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 20,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              
              pw.Divider(height: 20, thickness: 1),
              
              // Period
              pw.Text(
                'Period: ${_formatDate(startDate)} to ${_formatDate(endDate)}',
                style: pw.TextStyle(font: regularFont, fontSize: 12),
              ),
              
              pw.SizedBox(height: 20),
              
              // Summary cards
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Sales',
                      value: '${AppConstants.CURRENCY} ${_formatCurrency(totalSales)}',
                      color: PdfColors.green700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Purchases',
                      value: '${AppConstants.CURRENCY} ${_formatCurrency(totalPurchases)}',
                      color: PdfColors.red700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Net Profit',
                      value: '${AppConstants.CURRENCY} ${_formatCurrency(netProfit)}',
                      color: PdfColors.blue700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 16),
              
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Invoices',
                      value: totalInvoices.toString(),
                      color: PdfColors.purple700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Customers',
                      value: totalCustomers.toString(),
                      color: PdfColors.orange700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildSummaryCard(
                      title: 'Products',
                      value: totalProducts.toString(),
                      color: PdfColors.teal700,
                      boldFont: boldFont,
                      regularFont: regularFont,
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Detailed table
              pw.Text(
                'Financial Summary',
                style: pw.TextStyle(font: boldFont, fontSize: 16),
              ),
              pw.SizedBox(height: 8),
              
              pw.Table.fromTextArray(
                headers: [
                  'Category',
                  'Amount',
                ],
                data: [
                  ['Total Sales', '${AppConstants.CURRENCY} ${_formatCurrency(totalSales)}'],
                  ['Total Purchases', '${AppConstants.CURRENCY} ${_formatCurrency(totalPurchases)}'],
                  ['Total Payments', '${AppConstants.CURRENCY} ${_formatCurrency(totalPayments)}'],
                  ['Total Receipts', '${AppConstants.CURRENCY} ${_formatCurrency(totalReceipts)}'],
                  ['', ''],
                  ['Net Profit', '${AppConstants.CURRENCY} ${_formatCurrency(netProfit)}'],
                ],
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColors.blue900),
                cellPadding: const pw.EdgeInsets.all(8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FixedColumnWidth(120),
                },
              ),
              
              pw.SizedBox(height: 20),
              
              // Footer
              pw.Divider(height: 1, thickness: 1),
              pw.Text(
                'IRD Compliant | Nepal Financial Reporting Standards (NFRS)',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
        margin: const pw.EdgeInsets.all(32),
      ),
    );
    
    return pdf.save();
  }
  
  /// Build summary card
  pw.Widget _buildSummaryCard({
    required String title,
    required String value,
    required PdfColor color,
    required pw.Font boldFont,
    required pw.Font regularFont,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: color.withOpacity(0.1),
        border: pw.Border.all(color: color, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Print a PDF
  Future<void> printPdf(Uint8List pdfBytes, {String? jobName}) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: jobName ?? 'nKount Document',
      );
    } catch (e) {
      throw Exception('Failed to print: $e');
    }
  }
  
  /// Share a PDF
  Future<void> sharePdf(Uint8List pdfBytes, {String? fileName}) async {
    try {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName ?? 'nkount_document.pdf',
      );
    } catch (e) {
      throw Exception('Failed to share: $e');
    }
  }
  
  /// Save a PDF to device
  Future<void> savePdf(Uint8List pdfBytes, {String? fileName}) async {
    try {
      // This will trigger a download in web
      final blob = ui.Blob([pdfBytes]);
      final url = ui.Url.createObjectUrlFromBlob(blob);
      
      final anchor = ui.document.createElement('a') as ui.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName ?? 'nkount_document.pdf';
      
      ui.document.body!.children.add(anchor);
      anchor.click();
      ui.document.body!.children.remove(anchor);
      ui.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Failed to save: $e');
    }
  }
}

// Singleton instance
final pdfService = PdfService();
