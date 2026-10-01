/**
 * Report Routes
 * RESTful endpoints for report generation
 */

const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validateReportRequest } = require('../middleware/validators/reportValidator');

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Dashboard reports
router.get('/dashboard/summary', reportController.getDashboardSummary);
router.get('/dashboard/stats', reportController.getDashboardStats);
router.get('/dashboard/charts', reportController.getDashboardCharts);

// Sales reports
router.get('/sales/summary', reportController.getSalesSummaryReport);
router.get('/sales/daily', reportController.getDailySalesReport);
router.get('/sales/monthly', reportController.getMonthlySalesReport);
router.get('/sales/yearly', reportController.getYearlySalesReport);
router.get('/sales/customer', reportController.getCustomerSalesReport);
router.get('/sales/product', reportController.getProductSalesReport);
router.get('/sales/by-date', reportController.getSalesByDateReport);

// Purchase reports
router.get('/purchases/summary', reportController.getPurchaseSummaryReport);
router.get('/purchases/daily', reportController.getDailyPurchaseReport);
router.get('/purchases/monthly', reportController.getMonthlyPurchaseReport);
router.get('/purchases/yearly', reportController.getYearlyPurchaseReport);
router.get('/purchases/supplier', reportController.getSupplierPurchaseReport);
router.get('/purchases/product', reportController.getProductPurchaseReport);
router.get('/purchases/by-date', reportController.getPurchasesByDateReport);

// Payment reports
router.get('/payments/summary', reportController.getPaymentSummaryReport);
router.get('/payments/daily', reportController.getDailyPaymentReport);
router.get('/payments/monthly', reportController.getMonthlyPaymentReport);
router.get('/payments/by-method', reportController.getPaymentsByMethodReport);
router.get('/payments/by-contact', reportController.getPaymentsByContactReport);

// Receipt reports
router.get('/receipts/summary', reportController.getReceiptSummaryReport);
router.get('/receipts/daily', reportController.getDailyReceiptReport);
router.get('/receipts/monthly', reportController.getMonthlyReceiptReport);

// Inventory reports
router.get('/inventory/summary', reportController.getInventorySummaryReport);
router.get('/inventory/detailed', reportController.getDetailedInventoryReport);
router.get('/inventory/valuation', reportController.getInventoryValuationReport);
router.get('/inventory/movement', reportController.getInventoryMovementReport);
router.get('/inventory/low-stock', reportController.getLowStockReport);
router.get('/inventory/out-of-stock', reportController.getOutOfStockReport);

// Financial reports
router.get('/financial/profit-loss', reportController.getProfitAndLossReport);
router.get('/financial/balance-sheet', reportController.getBalanceSheetReport);
router.get('/financial/cash-flow', reportController.getCashFlowReport);
router.get('/financial/trial-balance', reportController.getTrialBalanceReport);
router.get('/financial/general-ledger', reportController.getGeneralLedgerReport);

// Tax reports (IRD compliant)
router.get('/tax/vat', reportController.getVATReport);
router.get('/tax/vat-summary', reportController.getVATSummaryReport);
router.get('/tax/vat-detailed', reportController.getVATDetailedReport);
router.get('/tax/ird', reportController.getIRDReport);
router.get('/tax/ird-summary', reportController.getIRDSummaryReport);
router.get('/tax/ird-detailed', reportController.getIRDDetailedReport);

// Contact reports
router.get('/contacts/summary', reportController.getContactSummaryReport);
router.get('/contacts/customers', reportController.getCustomerReport);
router.get('/contacts/suppliers', reportController.getSupplierReport);
router.get('/contacts/outstanding', reportController.getOutstandingReport);
router.get('/contacts/aging', reportController.getAgingReport);

// Product reports
router.get('/products/summary', reportController.getProductSummaryReport);
router.get('/products/pricing', reportController.getProductPricingReport);
router.get('/products/costing', reportController.getProductCostingReport);
router.get('/products/profitability', reportController.getProductProfitabilityReport);

// Custom reports
router.post('/custom', validateReportRequest, reportController.generateCustomReport);

// Report metadata
router.get('/metadata/filters', reportController.getReportFilters);
router.get('/metadata/fields', reportController.getReportFields);
router.get('/metadata/periods', reportController.getReportPeriods);

// Report export
router.get('/export/csv', reportController.exportReportCSV);
router.get('/export/excel', reportController.exportReportExcel);
router.get('/export/pdf', reportController.exportReportPDF);
router.post('/export/email', reportController.emailReport);

// Report scheduling
router.post('/schedule', reportController.scheduleReport);
router.get('/schedules', reportController.getScheduledReports);
router.delete('/schedule/:id', reportController.deleteScheduledReport);

// Report history
router.get('/history', reportController.getReportHistory);
router.get('/history/:id', reportController.getReportHistoryById);

module.exports = router;
