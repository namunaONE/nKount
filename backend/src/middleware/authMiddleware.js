/**
 * Authentication Middleware
 * Handles JWT authentication and authorization
 */

const jwt = require('jsonwebtoken');
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
    new createLogger.transports.File({ filename: 'logs/auth.log' })
  ]
});

/**
 * Generate JWT token
 */
const generateToken = (payload, expiresIn = config.jwt.expiresIn) => {
  return jwt.sign(payload, config.jwt.secret, {
    expiresIn,
    issuer: config.jwt.issuer,
    audience: config.jwt.audience,
  });
};

/**
 * Verify JWT token
 */
const verifyToken = (token) => {
  try {
    return jwt.verify(token, config.jwt.secret, {
      issuer: config.jwt.issuer,
      audience: config.jwt.audience,
    });
  } catch (error) {
    logger.error(`JWT verification failed: ${error.message}`);
    return null;
  }
};

/**
 * Decode JWT token (without verification)
 */
const decodeToken = (token) => {
  try {
    return jwt.decode(token);
  } catch (error) {
    logger.error(`JWT decode failed: ${error.message}`);
    return null;
  }
};

/**
 * Authentication middleware
 * Validates JWT token from Authorization header
 */
const authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN
    
    if (!token) {
      return res.unauthorized({
        error: 'Access denied. No token provided.',
        code: 'NO_TOKEN_PROVIDED',
      });
    }
    
    // Verify token
    const decoded = verifyToken(token);
    
    if (!decoded) {
      return res.unauthorized({
        error: 'Invalid token.',
        code: 'INVALID_TOKEN',
      });
    }
    
    // Check if token is expired
    if (decoded.exp && decoded.exp < Date.now() / 1000) {
      return res.unauthorized({
        error: 'Token expired.',
        code: 'TOKEN_EXPIRED',
      });
    }
    
    // Attach user to request
    req.user = decoded;
    req.token = token;
    
    // Log successful authentication
    logger.info(`User authenticated: ${decoded.id || decoded.email}`);
    
    next();
  } catch (error) {
    logger.error(`Authentication error: ${error.message}`);
    return res.unauthorized({
      error: 'Authentication failed.',
      code: 'AUTHENTICATION_FAILED',
    });
  }
};

/**
 * Optional authentication middleware
 * Sets req.user if token is valid, but doesn't block if not
 */
const optionalAuthenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
      return next();
    }
    
    const decoded = verifyToken(token);
    
    if (!decoded) {
      return next();
    }
    
    if (decoded.exp && decoded.exp < Date.now() / 1000) {
      return next();
    }
    
    req.user = decoded;
    req.token = token;
    
    next();
  } catch (error) {
    logger.error(`Optional authentication error: ${error.message}`);
    next();
  }
};

/**
 * Authorization middleware factory
 * Checks if user has required role(s)
 */
const authorize = (roles = []) => {
  return (req, res, next) => {
    try {
      if (!req.user) {
        return res.unauthorized({
          error: 'Access denied. Authentication required.',
          code: 'AUTHENTICATION_REQUIRED',
        });
      }
      
      if (roles.length === 0) {
        return next();
      }
      
      const userRoles = req.user.roles || [];
      const hasRequiredRole = roles.some(role => userRoles.includes(role));
      
      if (!hasRequiredRole) {
        return res.forbidden({
          error: 'Access denied. Insufficient permissions.',
          code: 'INSUFFICIENT_PERMISSIONS',
          requiredRoles: roles,
          userRoles,
        });
      }
      
      next();
    } catch (error) {
      logger.error(`Authorization error: ${error.message}`);
      return res.forbidden({
        error: 'Authorization failed.',
        code: 'AUTHORIZATION_FAILED',
      });
    }
  };
};

/**
 * Company ownership middleware
 * Checks if user belongs to the specified company
 */
const checkCompanyOwnership = (companyIdParam = 'companyId') => {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return res.unauthorized({
          error: 'Authentication required.',
          code: 'AUTHENTICATION_REQUIRED',
        });
      }
      
      const companyId = req.params[companyIdParam] || req.body[companyIdParam] || req.query[companyIdParam];
      
      if (!companyId) {
        return res.badRequest({
          error: 'Company ID is required.',
          code: 'COMPANY_ID_REQUIRED',
        });
      }
      
      // In a real implementation, you would check if the user belongs to this company
      // For now, we'll skip this check as we're not implementing full auth
      // This is a placeholder for the actual implementation
      
      // Check if user is admin (bypass check)
      if (req.user.roles && req.user.roles.includes('admin')) {
        return next();
      }
      
      // Check if user's company ID matches
      if (req.user.companyId && req.user.companyId === companyId) {
        return next();
      }
      
      // Check if user has access to this company
      // This would typically query a user-company relationship table
      // For now, we'll allow all requests in development
      if (process.env.NODE_ENV === 'development') {
        logger.warn(`Development mode: Skipping company ownership check for user ${req.user.id}`);
        return next();
      }
      
      return res.forbidden({
        error: 'Access denied. You do not have permission to access this company.',
        code: 'COMPANY_ACCESS_DENIED',
      });
    } catch (error) {
      logger.error(`Company ownership check error: ${error.message}`);
      return res.forbidden({
        error: 'Company ownership verification failed.',
        code: 'COMPANY_OWNERSHIP_VERIFICATION_FAILED',
      });
    }
  };
};

/**
 * Refresh token middleware
 * Handles token refresh
 */
const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    
    if (!refreshToken) {
      return res.badRequest({
        error: 'Refresh token is required.',
        code: 'REFRESH_TOKEN_REQUIRED',
      });
    }
    
    // Verify refresh token
    const decoded = verifyToken(refreshToken);
    
    if (!decoded) {
      return res.unauthorized({
        error: 'Invalid refresh token.',
        code: 'INVALID_REFRESH_TOKEN',
      });
    }
    
    // Generate new access token
    const newToken = generateToken(
      { id: decoded.id, email: decoded.email, roles: decoded.roles },
      config.jwt.expiresIn
    );
    
    res.success({
      data: { token: newToken },
      message: 'Token refreshed successfully',
    });
  } catch (error) {
    logger.error(`Refresh token error: ${error.message}`);
    next(error);
  }
};

/**
 * Validate API key middleware
 * Validates API key for service-to-service communication
 */
const validateApiKey = async (req, res, next) => {
  try {
    const apiKey = req.headers['x-api-key'];
    const expectedApiKey = process.env.API_KEY;
    
    if (!apiKey) {
      return res.unauthorized({
        error: 'API key is required.',
        code: 'API_KEY_REQUIRED',
      });
    }
    
    if (apiKey !== expectedApiKey) {
      return res.unauthorized({
        error: 'Invalid API key.',
        code: 'INVALID_API_KEY',
      });
    }
    
    next();
  } catch (error) {
    logger.error(`API key validation error: ${error.message}`);
    next(error);
  }
};

module.exports = {
  authenticate,
  optionalAuthenticate,
  authorize,
  checkCompanyOwnership,
  refreshToken,
  validateApiKey,
  generateToken,
  verifyToken,
  decodeToken,
};
