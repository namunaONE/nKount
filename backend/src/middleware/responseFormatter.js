/**
 * Response Formatter Middleware
 * Formats API responses consistently
 */

const config = require('../config/env');
const { createLogger } = require('winston');

const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/responses.log' })
  ]
});

/**
 * Response formatter middleware
 * Adds success method to response object
 */
const responseFormatter = (req, res, next) => {
  // Success response
  res.success = (data, statusCode = 200, meta = {}) => {
    const response = {
      success: true,
      data: data?.data || data,
      message: data?.message,
      ...meta,
    };
    
    // Add pagination if present
    if (data?.pagination) {
      response.pagination = data.pagination;
    }
    
    // Add request ID for tracing
    if (req.requestId) {
      response.requestId = req.requestId;
    }
    
    // Add timestamp
    response.timestamp = new Date().toISOString();
    
    // Add API version
    response.apiVersion = config.apiVersion;
    
    logger.info(`Success response: ${statusCode} - ${req.method} ${req.path}`);
    
    return res.status(statusCode).json(response);
  };
  
  // Error response
  res.error = (error, statusCode = 400) => {
    const response = {
      success: false,
      error: error?.error || error?.message || 'An error occurred',
      code: error?.code || 'INTERNAL_ERROR',
      requestId: req.requestId,
      timestamp: new Date().toISOString(),
      apiVersion: config.apiVersion,
    };
    
    // Add validation errors if present
    if (error?.errors) {
      response.errors = error.errors;
    }
    
    logger.error(`Error response: ${statusCode} - ${req.method} ${req.path} - ${response.error}`);
    
    return res.status(statusCode).json(response);
  };
  
  // Not found response
  res.notFound = (error) => {
    return res.error(error, 404);
  };
  
  // Bad request response
  res.badRequest = (error) => {
    return res.error(error, 400);
  };
  
  // Unauthorized response
  res.unauthorized = (error) => {
    return res.error(error, 401);
  };
  
  // Forbidden response
  res.forbidden = (error) => {
    return res.error(error, 403);
  };
  
  // Conflict response
  res.conflict = (error) => {
    return res.error(error, 409);
  };
  
  // Too many requests response
  res.tooManyRequests = (error) => {
    return res.error(error, 429);
  };
  
  // Internal server error response
  res.internalError = (error) => {
    return res.error(error, 500);
  };
  
  // Service unavailable response
  res.serviceUnavailable = (error) => {
    return res.error(error, 503);
  };
  
  // Created response (201)
  res.created = (data) => {
    return res.success(data, 201);
  };
  
  // No content response (204)
  res.noContent = () => {
    return res.status(204).send();
  };
  
  // Paginated response
  res.paginated = (data, pagination, statusCode = 200) => {
    return res.success({ data, pagination }, statusCode);
  };
  
  next();
};

/**
 * Error handler middleware
 * Handles errors and formats error responses
 */
const errorHandler = (err, req, res, next) => {
  logger.error(`Error: ${err.message}`);
  logger.error(err.stack);
  
  // Handle validation errors
  if (err.name === 'ValidationError') {
    return res.error({
      error: 'Validation failed',
      code: 'VALIDATION_ERROR',
      errors: err.errors,
    }, 400);
  }
  
  // Handle database errors
  if (err.name === 'SequelizeError') {
    return res.error({
      error: 'Database error',
      code: 'DATABASE_ERROR',
      message: err.message,
    }, 500);
  }
  
  // Handle JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.unauthorized({
      error: 'Invalid token',
      code: 'INVALID_TOKEN',
      message: err.message,
    });
  }
  
  // Handle token expiration
  if (err.name === 'TokenExpiredError') {
    return res.unauthorized({
      error: 'Token expired',
      code: 'TOKEN_EXPIRED',
      message: err.message,
    });
  }
  
  // Handle not found errors
  if (err.name === 'NotFoundError') {
    return res.notFound({
      error: 'Resource not found',
      code: 'NOT_FOUND',
      message: err.message,
    });
  }
  
  // Handle duplicate errors
  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.conflict({
      error: 'Duplicate entry',
      code: 'DUPLICATE_ENTRY',
      message: err.message,
    });
  }
  
  // Handle rate limit errors
  if (err.name === 'RateLimitError') {
    return res.tooManyRequests({
      error: 'Too many requests',
      code: 'RATE_LIMIT_EXCEEDED',
      message: err.message,
    });
  }
  
  // Default error
  return res.internalError({
    error: 'Internal server error',
    code: 'INTERNAL_ERROR',
    message: process.env.NODE_ENV === 'development' ? err.message : 'An unexpected error occurred',
  });
};

/**
 * 404 handler
 * Handles routes that don't exist
 */
const notFoundHandler = (req, res) => {
  res.notFound({
    error: 'Endpoint not found',
    code: 'NOT_FOUND',
    path: req.path,
    method: req.method,
  });
};

module.exports = {
  responseFormatter,
  errorHandler,
  notFoundHandler,
};
