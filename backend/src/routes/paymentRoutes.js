/**
 * Payment Routes
 * RESTful endpoints for payment management
 */

const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validatePayment, validatePaymentUpdate } = require('../middleware/validators/paymentValidator');

// Public routes
router.get('/', paymentController.getAllPayments);
router.get('/:id', paymentController.getPaymentById);

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Payment routes
router.post('/', validatePayment, paymentController.createPayment);
router.post('/bulk', paymentController.createPaymentsBulk);
router.put('/:id', validatePaymentUpdate, paymentController.updatePayment);
router.patch('/:id', validatePaymentUpdate, paymentController.updatePaymentPartial);
router.delete('/:id', paymentController.deletePayment);
router.delete('/bulk', paymentController.deletePaymentsBulk);

// Payment types
router.get('/types', paymentController.getPaymentTypes);

// Payment methods
router.get('/methods', paymentController.getPaymentMethods);

// Payment status
router.get('/statuses', paymentController.getPaymentStatuses);
router.put('/:id/status', paymentController.updatePaymentStatus);

// Payment cheque status
router.put('/:id/cheque-status', paymentController.updateChequeStatus);

// Payment statistics
router.get('/stats/summary', paymentController.getPaymentSummaryStats);
router.get('/stats/payments', paymentController.getPaymentStats);
router.get('/stats/receipts', paymentController.getReceiptStats);

// Payment search
router.get('/search', paymentController.searchPayments);

// Payment filters
router.get('/filter/payments', paymentController.getPaymentTransactions);
router.get('/filter/receipts', paymentController.getReceiptTransactions);
router.get('/filter/refunds', paymentController.getRefundTransactions);
router.get('/filter/today', paymentController.getTodayPayments);
router.get('/filter/this-month', paymentController.getThisMonthPayments);
router.get('/filter/this-year', paymentController.getThisYearPayments);
router.get('/filter/pending', paymentController.getPendingPayments);
router.get('/filter/cleared', paymentController.getClearedPayments);
router.get('/filter/failed', paymentController.getFailedPayments);

// Payment by transaction
router.get('/transaction/:transactionId', paymentController.getPaymentsByTransaction);

// Payment by contact
router.get('/contact/:contactId', paymentController.getPaymentsByContact);

// Payment next number
router.get('/next-number', paymentController.getNextPaymentNumber);

// Payment reconciliation
router.post('/reconcile', paymentController.reconcilePayments);

// Export payments
router.get('/export/csv', paymentController.exportPaymentsCSV);
router.get('/export/excel', paymentController.exportPaymentsExcel);
router.get('/export/pdf/:id', paymentController.exportPaymentPDF);

// Import payments
router.post('/import/csv', paymentController.importPaymentsCSV);
router.post('/import/excel', paymentController.importPaymentsExcel);

// Void/Cancel payment
router.post('/:id/void', paymentController.voidPayment);
router.post('/:id/cancel', paymentController.cancelPayment);

// Refund payment
router.post('/:id/refund', paymentController.refundPayment);

module.exports = router;
