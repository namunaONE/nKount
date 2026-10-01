/**
 * Company Routes
 * RESTful endpoints for company management
 */

const express = require('express');
const router = express.Router();
const companyController = require('../controllers/companyController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validateCompany, validateCompanyUpdate } = require('../middleware/validators/companyValidator');

// Public routes
router.get('/', companyController.getAllCompanies);
router.get('/:id', companyController.getCompanyById);

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Company routes
router.post('/', validateCompany, companyController.createCompany);
router.put('/:id', validateCompanyUpdate, companyController.updateCompany);
router.patch('/:id', validateCompanyUpdate, companyController.updateCompanyPartial);
router.delete('/:id', companyController.deleteCompany);

// Company settings
router.get('/:id/settings', companyController.getCompanySettings);
router.put('/:id/settings', companyController.updateCompanySettings);

// Company IRD info
router.get('/:id/ird', companyController.getCompanyIRDInfo);

// Company fiscal year
router.get('/:id/fiscal-year', companyController.getFiscalYearInfo);
router.put('/:id/fiscal-year', companyController.updateFiscalYear);

// Company invoice numbering
router.get('/:id/invoice-number', companyController.getNextInvoiceNumber);
router.get('/:id/quote-number', companyController.getNextQuoteNumber);
router.get('/:id/po-number', companyController.getNextPurchaseOrderNumber);

// Company statistics
router.get('/:id/stats', companyController.getCompanyStats);

// Search companies
router.get('/search', companyController.searchCompanies);

module.exports = router;
