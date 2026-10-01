/**
 * Contact Routes
 * RESTful endpoints for contact management
 */

const express = require('express');
const router = express.Router();
const contactController = require('../controllers/contactController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');
const { validateContact, validateContactUpdate } = require('../middleware/validators/contactValidator');

// Public routes
router.get('/', contactController.getAllContacts);
router.get('/:id', contactController.getContactById);

// Protected routes (require authentication)
router.use(authMiddleware.authenticate);

// Contact routes
router.post('/', validateContact, contactController.createContact);
router.post('/bulk', contactController.createContactsBulk);
router.put('/:id', validateContactUpdate, contactController.updateContact);
router.patch('/:id', validateContactUpdate, contactController.updateContactPartial);
router.delete('/:id', contactController.deleteContact);
router.delete('/bulk', contactController.deleteContactsBulk);

// Contact categories
router.get('/:id/transactions', contactController.getContactTransactions);
router.get('/:id/payments', contactController.getContactPayments);
router.get('/:id/balance', contactController.getContactBalance);

// Contact statistics
router.get('/:id/stats', contactController.getContactStats);

// Contact types
router.get('/types', contactController.getContactTypes);

// Search contacts
router.get('/search', contactController.searchContacts);

// Export contacts
router.get('/export/csv', contactController.exportContactsCSV);
router.get('/export/excel', contactController.exportContactsExcel);

// Import contacts
router.post('/import/csv', contactController.importContactsCSV);
router.post('/import/excel', contactController.importContactsExcel);

module.exports = router;
