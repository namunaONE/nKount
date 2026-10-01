/**
 * Validation Middleware
 * Validates request data using express-validator
 */

const { validationResult } = require('express-validator');
const { createLogger } = require('winston');

const logger = createLogger({
  level: 'info',
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/validation.log' })
  ]
});

/**
 * Validation middleware factory
 * Validates request data and returns formatted errors
 */
const validate = (validations) => {
  return async (req, res, next) => {
    // Run all validations
    await Promise.all(validations.map(validation => validation.run(req)));
    
    // Check for validation errors
    const errors = validationResult(req);
    
    if (errors.isEmpty()) {
      return next();
    }
    
    // Format validation errors
    const formattedErrors = errors.array().map(error => ({
      field: error.path || error.param,
      message: error.msg,
      value: error.value,
      location: error.location,
    }));
    
    logger.warn(`Validation failed: ${JSON.stringify(formattedErrors)}`);
    
    return res.badRequest({
      error: 'Validation failed',
      code: 'VALIDATION_ERROR',
      errors: formattedErrors,
    });
  };
};

/**
 * Validate UUID parameter
 */
const validateUUID = (field = 'id', location = 'params') => {
  return require('express-validator').param(field, `${field} must be a valid UUID`)
    .isUUID();
};

/**
 * Validate required fields
 */
const validateRequired = (fields, location = 'body') => {
  return fields.map(field => {
    return require('express-validator')[location](field, `${field} is required`)
      .notEmpty();
  });
};

/**
 * Validate optional fields
 */
const validateOptional = (fields, location = 'body') => {
  return fields.map(field => {
    return require('express-validator')[location](field)
      .optional();
  });
};

/**
 * Validate email
 */
const validateEmail = (field = 'email', location = 'body') => {
  return require('express-validator')[location](field, `${field} must be a valid email`)
    .isEmail();
};

/**
 * Validate phone number
 */
const validatePhone = (field = 'phone', location = 'body') => {
  return require('express-validator')[location](field, `${field} must be a valid phone number`)
    .isMobilePhone();
};

/**
 * Validate number
 */
const validateNumber = (field, location = 'body', options = {}) => {
  const validator = require('express-validator')[location](field, `${field} must be a valid number`)
    .isNumeric();
  
  if (options.min !== undefined) {
    validator.isFloat({ min: options.min });
  }
  
  if (options.max !== undefined) {
    validator.isFloat({ max: options.max });
  }
  
  return validator;
};

/**
 * Validate decimal
 */
const validateDecimal = (field, location = 'body', options = {}) => {
  const validator = require('express-validator')[location](field, `${field} must be a valid decimal number`)
    .isDecimal();
  
  if (options.min !== undefined) {
    validator.isFloat({ min: options.min });
  }
  
  if (options.max !== undefined) {
    validator.isFloat({ max: options.max });
  }
  
  return validator;
};

/**
 * Validate date
 */
const validateDate = (field = 'date', location = 'body') => {
  return require('express-validator')[location](field, `${field} must be a valid date`)
    .isISO8601();
};

/**
 * Validate boolean
 */
const validateBoolean = (field, location = 'body') => {
  return require('express-validator')[location](field, `${field} must be a boolean`)
    .isBoolean();
};

/**
 * Validate string length
 */
const validateStringLength = (field, location = 'body', options = {}) => {
  const validator = require('express-validator')[location](field);
  
  if (options.min !== undefined) {
    validator.isLength({ min: options.min });
  }
  
  if (options.max !== undefined) {
    validator.isLength({ max: options.max });
  }
  
  return validator;
};

/**
 * Validate enum
 */
const validateEnum = (field, values, location = 'body') => {
  return require('express-validator')[location](field, `${field} must be one of: ${values.join(', ')}`)
    .isIn(values);
};

/**
 * Validate array
 */
const validateArray = (field, location = 'body', options = {}) => {
  const validator = require('express-validator')[location](field, `${field} must be an array`)
    .isArray();
  
  if (options.minLength !== undefined) {
    validator.isLength({ min: options.minLength });
  }
  
  if (options.maxLength !== undefined) {
    validator.isLength({ max: options.maxLength });
  }
  
  return validator;
};

/**
 * Validate object
 */
const validateObject = (field, location = 'body') => {
  return require('express-validator')[location](field, `${field} must be an object`)
    .isObject();
};

/**
 * Custom validator
 */
const customValidator = (field, validatorFn, message, location = 'body') => {
  return require('express-validator')[location](field, message)
    .custom(validatorFn);
};

/**
 * Validate pagination parameters
 */
const validatePagination = () => {
  return [
    require('express-validator').query('page')
      .optional()
      .isInt({ min: 1 })
      .withMessage('Page must be a positive integer'),
    require('express-validator').query('limit')
      .optional()
      .isInt({ min: 1, max: 100 })
      .withMessage('Limit must be between 1 and 100'),
    require('express-validator').query('sortBy')
      .optional()
      .isString()
      .withMessage('sortBy must be a string'),
    require('express-validator').query('sortOrder')
      .optional()
      .isIn(['asc', 'desc'])
      .withMessage('sortOrder must be asc or desc'),
  ];
};

/**
 * Validate search parameters
 */
const validateSearch = () => {
  return [
    require('express-validator').query('query')
      .optional()
      .isString()
      .isLength({ min: 1, max: 255 })
      .withMessage('Search query must be between 1 and 255 characters'),
  ];
};

/**
 * Validate date range parameters
 */
const validateDateRange = () => {
  return [
    require('express-validator').query('startDate')
      .optional()
      .isISO8601()
      .withMessage('startDate must be a valid date'),
    require('express-validator').query('endDate')
      .optional()
      .isISO8601()
      .withMessage('endDate must be a valid date'),
    require('express-validator').query('startDate')
      .custom((value, { req }) => {
        if (value && req.query.endDate && new Date(value) > new Date(req.query.endDate)) {
          throw new Error('startDate must be before endDate');
        }
        return true;
      }),
  ];
};

module.exports = {
  validate,
  validateUUID,
  validateRequired,
  validateOptional,
  validateEmail,
  validatePhone,
  validateNumber,
  validateDecimal,
  validateDate,
  validateBoolean,
  validateStringLength,
  validateEnum,
  validateArray,
  validateObject,
  customValidator,
  validatePagination,
  validateSearch,
  validateDateRange,
};
