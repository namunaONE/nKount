/**
 * Request Logger Middleware
 * Logs all incoming requests for debugging and analytics
 */

const { createLogger, format } = require('winston');
const config = require('../config/env');

// Create logger
const logger = createLogger({
  level: config.logging.level,
  format: format.combine(
    format.timestamp(),
    format.json()
  ),
  transports: [
    new createLogger.transports.Console({
      format: format.combine(
        format.colorize(),
        format.simple()
      )
    }),
    new createLogger.transports.File({
      filename: 'logs/requests.log',
      maxsize: config.logging.maxSize,
      maxFiles: config.logging.maxFiles,
    })
  ]
});

/**
 * Request logger middleware
 * Logs request details before processing
 */
const requestLogger = (req, res, next) => {
  // Start timer
  const start = Date.now();
  
  // Store request start time
  req.requestStartTime = start;
  
  // Log request
  const logData = {
    requestId: req.requestId,
    timestamp: new Date().toISOString(),
    method: req.method,
    path: req.path,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
    referer: req.get('Referer'),
    origin: req.get('Origin'),
    userId: req.user?.id,
    userEmail: req.user?.email,
    userRoles: req.user?.roles,
    companyId: req.user?.companyId,
  };
  
  // Log different levels based on method
  if (req.method === 'GET') {
    logger.info('Request started', logData);
  } else if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
    logger.info('Request started', logData);
  } else if (req.method === 'DELETE') {
    logger.warn('Request started', logData);
  } else {
    logger.debug('Request started', logData);
  }
  
  // Add response finish listener to log response time
  res.on('finish', () => {
    const duration = Date.now() - start;
    
    const responseLogData = {
      ...logData,
      statusCode: res.statusCode,
      duration: `${duration}ms`,
    };
    
    // Log response
    if (res.statusCode >= 500) {
      logger.error('Request completed', responseLogData);
    } else if (res.statusCode >= 400) {
      logger.warn('Request completed', responseLogData);
    } else if (res.statusCode >= 300) {
      logger.info('Request completed', responseLogData);
    } else {
      logger.debug('Request completed', responseLogData);
    }
  });
  
  // Add error listener
  res.on('error', (err) => {
    const duration = Date.now() - start;
    
    logger.error('Request error', {
      ...logData,
      duration: `${duration}ms`,
      error: err.message,
      stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
    });
  });
  
  next();
};

/**
 * Slow request logger middleware
 * Logs requests that take longer than threshold
 */
const slowRequestLogger = (threshold = 1000) => {
  return (req, res, next) => {
    const start = Date.now();
    
    res.on('finish', () => {
      const duration = Date.now() - start;
      
      if (duration > threshold) {
        logger.warn('Slow request', {
          requestId: req.requestId,
          method: req.method,
          path: req.path,
          duration: `${duration}ms`,
          threshold: `${threshold}ms`,
          ip: req.ip,
          userId: req.user?.id,
        });
      }
    });
    
    next();
  };
};

/**
 * Error request logger middleware
 * Logs requests that result in errors
 */
const errorRequestLogger = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    if (res.statusCode >= 400) {
      const duration = Date.now() - start;
      
      logger.error('Error request', {
        requestId: req.requestId,
        method: req.method,
        path: req.path,
        statusCode: res.statusCode,
        duration: `${duration}ms`,
        ip: req.ip,
        userId: req.user?.id,
        userAgent: req.get('User-Agent'),
      });
    }
  });
  
  next();
};

/**
 * API usage logger middleware
 * Logs API usage for analytics
 */
const apiUsageLogger = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    
    // Log API usage (only for API routes)
    if (req.path.startsWith('/api/')) {
      logger.info('API usage', {
        requestId: req.requestId,
        timestamp: new Date().toISOString(),
        method: req.method,
        path: req.path,
        statusCode: res.statusCode,
        duration: `${duration}ms`,
        ip: req.ip,
        userId: req.user?.id,
        companyId: req.user?.companyId,
      });
    }
  });
  
  next();
};

/**
 * Security logger middleware
 * Logs potential security issues
 */
const securityLogger = (req, res, next) => {
  // Check for suspicious patterns
  const suspiciousPatterns = [
    /\b(?:select|insert|update|delete|drop)\b/i,
    /\b(?:--|\/\*|\*\/|;|\b(?:or|and)\b\s+1=1)\b/i,
    /\b(?:union|exec|execute|alter|truncate)\b/i,
    /\b(?:password|secret|token|key)\b.*=.*['"]/i,
    /\b(?:script|onerror|onclick|onload)\b/i,
  ];
  
  const checkForSuspicious = (str) => {
    return suspiciousPatterns.some(pattern => pattern.test(str));
  };
  
  // Check URL
  if (checkForSuspicious(req.url)) {
    logger.warn('Suspicious request URL', {
      requestId: req.requestId,
      ip: req.ip,
      url: req.url,
      userAgent: req.get('User-Agent'),
    });
  }
  
  // Check query parameters
  if (req.query) {
    Object.entries(req.query).forEach(([key, value]) => {
      if (checkForSuspicious(key) || checkForSuspicious(value)) {
        logger.warn('Suspicious query parameter', {
          requestId: req.requestId,
          ip: req.ip,
          parameter: key,
          value: value,
          url: req.url,
        });
      }
    });
  }
  
  // Check body
  if (req.body && typeof req.body === 'object') {
    Object.entries(req.body).forEach(([key, value]) => {
      if (checkForSuspicious(key) || (typeof value === 'string' && checkForSuspicious(value))) {
        logger.warn('Suspicious request body', {
          requestId: req.requestId,
          ip: req.ip,
          field: key,
          value: typeof value === 'string' ? value.substring(0, 100) : '[complex]',
          url: req.url,
        });
      }
    });
  }
  
  next();
};

module.exports = {
  requestLogger,
  slowRequestLogger,
  errorRequestLogger,
  apiUsageLogger,
  securityLogger,
};
