/**
 * Error Handler Middleware
 * Centralized error handling for the application
 */

const { createLogger } = require('winston');
const config = require('../config/env');

const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/errors.log' })
  ]
});

/**
 * Custom error classes
 */
class AppError extends Error {
  constructor(message, statusCode, code, errors = []) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    this.code = code;
    this.errors = errors;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message, errors = []) {
    super(message, 400, 'VALIDATION_ERROR', errors);
  }
}

class AuthenticationError extends AppError {
  constructor(message, code = 'AUTHENTICATION_ERROR') {
    super(message, 401, code);
  }
}

class AuthorizationError extends AppError {
  constructor(message, code = 'AUTHORIZATION_ERROR') {
    super(message, 403, code);
  }
}

class NotFoundError extends AppError {
  constructor(message, code = 'NOT_FOUND') {
    super(message, 404, code);
  }
}

class ConflictError extends AppError {
  constructor(message, code = 'CONFLICT') {
    super(message, 409, code);
  }
}

class RateLimitError extends AppError {
  constructor(message, code = 'RATE_LIMIT_EXCEEDED') {
    super(message, 429, code);
  }
}

class DatabaseError extends AppError {
  constructor(message, code = 'DATABASE_ERROR', errors = []) {
    super(message, 500, code, errors);
  }
}

/**
 * Error handler middleware
 * Handles all errors and formats responses
 */
const errorHandler = (err, req, res, next) => {
  // Log the error
  logger.error(`Error: ${err.message}`, {
    error: err.message,
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
    request: {
      id: req.requestId,
      method: req.method,
      path: req.path,
      ip: req.ip,
      userId: req.user?.id,
    },
  });
  
  // Determine error type and format response
  let statusCode = err.statusCode || 500;
  let code = err.code || 'INTERNAL_ERROR';
  let message = err.message || 'An unexpected error occurred';
  let errors = err.errors || [];
  
  // Handle specific error types
  if (err.name === 'ValidationError' || err.name === 'SequelizeValidationError') {
    statusCode = 400;
    code = 'VALIDATION_ERROR';
    message = 'Validation failed';
    errors = err.errors || Object.values(err.errors || {}).map(e => e.message);
  }
  
  if (err.name === 'UnauthorizedError' || err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
    statusCode = 401;
    code = 'AUTHENTICATION_ERROR';
    message = 'Authentication failed';
  }
  
  if (err.name === 'ForbiddenError') {
    statusCode = 403;
    code = 'AUTHORIZATION_ERROR';
    message = 'Access denied';
  }
  
  if (err.name === 'SequelizeDatabaseError' || err.name === 'DatabaseError') {
    statusCode = 500;
    code = 'DATABASE_ERROR';
    message = process.env.NODE_ENV === 'development' ? err.message : 'Database error';
  }
  
  if (err.name === 'SequelizeUniqueConstraintError') {
    statusCode = 409;
    code = 'DUPLICATE_ENTRY';
    message = 'Duplicate entry';
    errors = err.errors || [err.message];
  }
  
  if (err.name === 'SequelizeConnectionError' || err.name === 'SequelizeConnectionRefusedError') {
    statusCode = 503;
    code = 'DATABASE_CONNECTION_ERROR';
    message = 'Database connection error';
  }
  
  if (err.code === 'LIMIT_FILE_SIZE') {
    statusCode = 400;
    code = 'FILE_TOO_LARGE';
    message = `File size exceeds maximum limit of ${config.upload.maxFileSize / (1024 * 1024)}MB`;
  }
  
  if (err.code === 'LIMIT_UNEXPECTED_FILE') {
    statusCode = 400;
    code = 'UNEXPECTED_FILE';
    message = 'An unexpected file was uploaded';
  }
  
  if (err.name === 'MulterError') {
    statusCode = 400;
    code = 'UPLOAD_ERROR';
    message = err.message;
  }
  
  // Handle rate limiting
  if (err.code === 'RATE_LIMIT_EXCEEDED' || err.statusCode === 429) {
    statusCode = 429;
    code = 'RATE_LIMIT_EXCEEDED';
    message = err.message || 'Too many requests';
  }
  
  // Format the response
  const response = {
    success: false,
    error: message,
    code,
    requestId: req.requestId,
    timestamp: new Date().toISOString(),
    apiVersion: config.apiVersion,
  };
  
  // Add errors array if present
  if (errors.length > 0) {
    response.errors = errors;
  }
  
  // Add stack trace in development
  if (process.env.NODE_ENV === 'development') {
    response.stack = err.stack;
  }
  
  // Send response
  res.status(statusCode).json(response);
};

/**
 * 404 handler
 * Handles routes that don't exist
 */
const notFoundHandler = (req, res, next) => {
  const error = new NotFoundError('Endpoint not found', 'NOT_FOUND');
  next(error);
};

/**
 * Async error handler wrapper
 * Wraps async route handlers to catch errors
 */
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

/**
 * Throw custom errors
 */
const throwError = (error) => {
  throw error;
};

module.exports = {
  errorHandler,
  notFoundHandler,
  asyncHandler,
  throwError,
  AppError,
  ValidationError,
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ConflictError,
  RateLimitError,
  DatabaseError,
};
