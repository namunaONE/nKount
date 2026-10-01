/**
 * Transaction Routes
 * RESTful endpoints for transaction management
 */

const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validateTransaction, validateTransactionUpdate } = require('../middleware/validators/transactionValidator');

// Public routes
router.get('/', transactionController.getAllTransactions);
router.get('/:id', transactionController.getTransactionById);

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Transaction routes
router.post('/', validateTransaction, transactionController.createTransaction);
router.post('/bulk', transactionController.createTransactionsBulk);
router.put('/:id', validateTransactionUpdate, transactionController.updateTransaction);
router.patch('/:id', validateTransactionUpdate, transactionController.updateTransactionPartial);
router.delete('/:id', transactionController.deleteTransaction);
router.delete('/bulk', transactionController.deleteTransactionsBulk);

// Transaction types
router.get('/types', transactionController.getTransactionTypes);

// Transaction status
router.get('/statuses', transactionController.getTransactionStatuses);
router.put('/:id/status', transactionController.updateTransactionStatus);
router.put('/:id/payment-status', transactionController.updatePaymentStatus);

// Transaction items
router.get('/:id/items', transactionController.getTransactionItems);
router.post('/:id/items', transactionController.addTransactionItem);
router.put('/:id/items/:itemId', transactionController.updateTransactionItem);
router.delete('/:id/items/:itemId', transactionController.deleteTransactionItem);

// Transaction payments
router.get('/:id/payments', transactionController.getTransactionPayments);

// Transaction totals
router.get('/:id/totals', transactionController.getTransactionTotals);
router.post('/:id/calculate', transactionController.calculateTransactionTotals);

// Transaction number
router.get('/next-number', transactionController.getNextTransactionNumber);

// Transaction statistics
router.get('/stats/sales', transactionController.getSalesStats);
router.get('/stats/purchases', transactionController.getPurchaseStats);
router.get('/stats/summary', transactionController.getTransactionSummaryStats);

// Transaction search
router.get('/search', transactionController.searchTransactions);

// Transaction filters
router.get('/filter/sales', transactionController.getSalesTransactions);
router.get('/filter/purchases', transactionController.getPurchaseTransactions);
router.get('/filter/quotes', transactionController.getQuoteTransactions);
router.get('/filter/purchase-orders', transactionController.getPurchaseOrderTransactions);
router.get('/filter/returns', transactionController.getReturnTransactions);
router.get('/filter/unpaid', transactionController.getUnpaidTransactions);
router.get('/filter/paid', transactionController.getPaidTransactions);
router.get('/filter/partially-paid', transactionController.getPartiallyPaidTransactions);
router.get('/filter/overdue', transactionController.getOverdueTransactions);
router.get('/filter/today', transactionController.getTodayTransactions);
router.get('/filter/this-month', transactionController.getThisMonthTransactions);
router.get('/filter/this-year', transactionController.getThisYearTransactions);

// IRD Compliance
router.post('/:id/ird/verify', transactionController.verifyIRD);
router.get('/:id/ird/qrcode', transactionController.getIRDQRCode);

// E-Billing
router.post('/:id/ebilling/submit', transactionController.submitToEBilling);
router.get('/:id/ebilling/status', transactionController.getEBillingStatus);

// Export transactions
router.get('/export/csv', transactionController.exportTransactionsCSV);
router.get('/export/excel', transactionController.exportTransactionsExcel);
router.get('/export/pdf/:id', transactionController.exportTransactionPDF);

// Import transactions
router.post('/import/csv', transactionController.importTransactionsCSV);
router.post('/import/excel', transactionController.importTransactionsExcel);

// Void/Cancel transaction
router.post('/:id/void', transactionController.voidTransaction);
router.post('/:id/cancel', transactionController.cancelTransaction);

// Duplicate transaction
router.post('/:id/duplicate', transactionController.duplicateTransaction);

// Convert quote to invoice
router.post('/:id/convert-to-invoice', transactionController.convertQuoteToInvoice);

// Convert purchase order to purchase
router.post('/:id/convert-to-purchase', transactionController.convertPurchaseOrderToPurchase);

module.exports = router;
