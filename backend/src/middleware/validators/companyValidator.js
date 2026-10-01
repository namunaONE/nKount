/**
 * Company Validator
 * Validates company-related request data
 */

const { body, param, query } = require('express-validator');
const { validate, validateUUID, validateRequired, validateOptional, validateEmail, validateStringLength, validateEnum, validateDate } = require('../validationMiddleware');

/**
 * Validate company creation
 */
const validateCompany = validate([
  // Required fields
  body('name').notEmpty().withMessage('Company name is required'),
  body('name').isString().isLength({ min: 1, max: 255 }).withMessage('Company name must be between 1 and 255 characters'),
  
  // Optional fields with validation
  body('nepaliName').optional().isString().isLength({ max: 255 }).withMessage('Nepali name must be less than 255 characters'),
  body('type').optional().isIn(['sole_proprietorship', 'partnership', 'private_limited', 'public_limited', 'llc', 'cooperative', 'other']).withMessage('Invalid company type'),
  
  // Contact information
  body('phone').optional().isString().isLength({ max: 20 }).withMessage('Phone must be less than 20 characters'),
  body('mobile').optional().isString().isLength({ max: 20 }).withMessage('Mobile must be less than 20 characters'),
  body('email').optional().isEmail().withMessage('Invalid email address'),
  body('website').optional().isURL().withMessage('Invalid website URL'),
  
  // Address
  body('addressLine1').optional().isString().isLength({ max: 255 }),
  body('addressLine2').optional().isString().isLength({ max: 255 }),
  body('city').optional().isString().isLength({ max: 100 }),
  body('district').optional().isString().isLength({ max: 100 }),
  body('state').optional().isString().isLength({ max: 100 }),
  body('country').optional().isString().isLength({ max: 100 }),
  body('postalCode').optional().isString().isLength({ max: 20 }),
  
  // Registration
  body('panNumber').optional().isString().isLength({ max: 50 }),
  body('vatNumber').optional().isString().isLength({ max: 50 }),
  body('registrationNumber').optional().isString().isLength({ max: 100 }),
  body('registrationDate').optional().isISO8601().withMessage('Invalid registration date'),
  
  // Financial
  body('currency').optional().isString().isLength({ min: 3, max: 3 }),
  body('defaultVatRate').optional().isDecimal().withMessage('Default VAT rate must be a decimal number'),
  body('accountingMethod').optional().isIn(['accrual', 'cash']),
  
  // Invoice settings
  body('invoicePrefix').optional().isString().isLength({ max: 20 }),
  body('invoiceNumber').optional().isInt({ min: 1 }),
  body('quotePrefix').optional().isString().isLength({ max: 20 }),
  body('quoteNumber').optional().isInt({ min: 1 }),
  body('purchaseOrderPrefix').optional().isString().isLength({ max: 20 }),
  body('purchaseOrderNumber').optional().isInt({ min: 1 }),
  
  // Fiscal year
  body('fiscalYearStart').optional().isISO8601().withMessage('Invalid fiscal year start date'),
  body('fiscalYearEnd').optional().isISO8601().withMessage('Invalid fiscal year end date'),
  
  // Status
  body('isActive').optional().isBoolean(),
]);

/**
 * Validate company update
 */
const validateCompanyUpdate = validate([
  // At least one field must be provided
  body().custom((value, { req }) => {
    const hasFields = Object.keys(req.body).length > 0;
    if (!hasFields) {
      throw new Error('At least one field must be provided for update');
    }
    return true;
  }),
  
  // Name validation (if provided)
  body('name').optional().isString().isLength({ min: 1, max: 255 }).withMessage('Company name must be between 1 and 255 characters'),
  body('nepaliName').optional().isString().isLength({ max: 255 }).withMessage('Nepali name must be less than 255 characters'),
  body('type').optional().isIn(['sole_proprietorship', 'partnership', 'private_limited', 'public_limited', 'llc', 'cooperative', 'other']).withMessage('Invalid company type'),
  
  // Contact information
  body('phone').optional().isString().isLength({ max: 20 }).withMessage('Phone must be less than 20 characters'),
  body('mobile').optional().isString().isLength({ max: 20 }).withMessage('Mobile must be less than 20 characters'),
  body('email').optional().isEmail().withMessage('Invalid email address'),
  body('website').optional().isURL().withMessage('Invalid website URL'),
  
  // Address
  body('addressLine1').optional().isString().isLength({ max: 255 }),
  body('addressLine2').optional().isString().isLength({ max: 255 }),
  body('city').optional().isString().isLength({ max: 100 }),
  body('district').optional().isString().isLength({ max: 100 }),
  body('state').optional().isString().isLength({ max: 100 }),
  body('country').optional().isString().isLength({ max: 100 }),
  body('postalCode').optional().isString().isLength({ max: 20 }),
  
  // Registration
  body('panNumber').optional().isString().isLength({ max: 50 }),
  body('vatNumber').optional().isString().isLength({ max: 50 }),
  body('registrationNumber').optional().isString().isLength({ max: 100 }),
  body('registrationDate').optional().isISO8601().withMessage('Invalid registration date'),
  
  // Financial
  body('currency').optional().isString().isLength({ min: 3, max: 3 }),
  body('defaultVatRate').optional().isDecimal().withMessage('Default VAT rate must be a decimal number'),
  body('accountingMethod').optional().isIn(['accrual', 'cash']),
  
  // Invoice settings
  body('invoicePrefix').optional().isString().isLength({ max: 20 }),
  body('invoiceNumber').optional().isInt({ min: 1 }),
  body('quotePrefix').optional().isString().isLength({ max: 20 }),
  body('quoteNumber').optional().isInt({ min: 1 }),
  body('purchaseOrderPrefix').optional().isString().isLength({ max: 20 }),
  body('purchaseOrderNumber').optional().isInt({ min: 1 }),
  
  // Fiscal year
  body('fiscalYearStart').optional().isISO8601().withMessage('Invalid fiscal year start date'),
  body('fiscalYearEnd').optional().isISO8601().withMessage('Invalid fiscal year end date'),
  
  // Status
  body('isActive').optional().isBoolean(),
]);

/**
 * Validate company ID parameter
 */
const validateCompanyId = validate([
  param('id').isUUID().withMessage('Invalid company ID'),
]);

/**
 * Validate company search query
 */
const validateCompanySearch = validate([
  query('search').optional().isString().isLength({ min: 1, max: 255 }).withMessage('Search query must be between 1 and 255 characters'),
  query('isActive').optional().isBoolean(),
  query('type').optional().isIn(['sole_proprietorship', 'partnership', 'private_limited', 'public_limited', 'llc', 'cooperative', 'other']),
  ...require('../validationMiddleware').validatePagination(),
]);

/**
 * Validate company settings
 */
const validateCompanySettings = validate([
  body().isObject().withMessage('Settings must be an object'),
  body().custom((value) => {
    if (Object.keys(value).length === 0) {
      throw new Error('At least one setting must be provided');
    }
    return true;
  }),
]);

/**
 * Validate fiscal year update
 */
const validateFiscalYear = validate([
  body('fiscalYearStart').optional().isISO8601().withMessage('Invalid fiscal year start date'),
  body('fiscalYearEnd').optional().isISO8601().withMessage('Invalid fiscal year end date'),
  body().custom((value, { req }) => {
    const { fiscalYearStart, fiscalYearEnd } = req.body;
    if (fiscalYearStart && fiscalYearEnd && new Date(fiscalYearStart) >= new Date(fiscalYearEnd)) {
      throw new Error('Fiscal year start must be before end');
    }
    return true;
  }),
]);

module.exports = {
  validateCompany,
  validateCompanyUpdate,
  validateCompanyId,
  validateCompanySearch,
  validateCompanySettings,
  validateFiscalYear,
};
