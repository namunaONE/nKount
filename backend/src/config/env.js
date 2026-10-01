/**
 * Environment Configuration
 * Centralized configuration management for nKount API
 */

require('dotenv').config();

const env = process.env;

// Validate required environment variables
const requiredVars = [
  'NODE_ENV',
  'PORT',
  'DB_HOST',
  'DB_PORT',
  'DB_NAME',
  'DB_USERNAME',
  'DB_PASSWORD',
  'JWT_SECRET',
];

const missingVars = requiredVars.filter(varName => !env[varName] && env.NODE_ENV === 'production');

if (missingVars.length > 0 && env.NODE_ENV === 'production') {
  throw new Error(`Missing required environment variables: ${missingVars.join(', ')}`);
}

// Default configuration
const config = {
  // Environment
  nodeEnv: env.NODE_ENV || 'development',
  isProduction: env.NODE_ENV === 'production',
  isDevelopment: env.NODE_ENV === 'development',
  isTest: env.NODE_ENV === 'test',
  
  // Server
  port: parseInt(env.PORT, 10) || 3000,
  host: env.HOST || 'localhost',
  apiVersion: env.API_VERSION || '1.0.0',
  
  // Database
  db: {
    host: env.DB_HOST || 'localhost',
    port: parseInt(env.DB_PORT, 10) || 5432,
    name: env.DB_NAME || 'nkount',
    username: env.DB_USERNAME || 'postgres',
    password: env.DB_PASSWORD || '',
    dialect: env.DB_DIALECT || 'postgres',
    logging: env.DB_LOGGING === 'true' || false,
    pool: {
      max: parseInt(env.DB_POOL_MAX, 10) || 10,
      min: parseInt(env.DB_POOL_MIN, 10) || 0,
      acquire: parseInt(env.DB_POOL_ACQUIRE, 10) || 30000,
      idle: parseInt(env.DB_POOL_IDLE, 10) || 10000,
    },
    ssl: env.DB_SSL === 'true' || false,
    dialectOptions: env.DB_SSL === 'true' ? {
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    } : {},
  },
  
  // JWT Authentication
  jwt: {
    secret: env.JWT_SECRET || 'nkount-secret-key-change-in-production',
    expiresIn: env.JWT_EXPIRES_IN || '1d',
    refreshExpiresIn: env.JWT_REFRESH_EXPIRES_IN || '7d',
    issuer: env.JWT_ISSUER || 'nkount-api',
    audience: env.JWT_AUDIENCE || 'nkount-client',
  },
  
  // Rate Limiting
  rateLimit: {
    windowMs: parseInt(env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000,
    max: parseInt(env.RATE_LIMIT_MAX, 10) || 1000,
  },
  
  // CORS
  cors: {
    origins: env.ALLOWED_ORIGINS?.split(',') || ['*'],
    methods: env.ALLOWED_METHODS?.split(',') || ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: env.ALLOWED_HEADERS?.split(',') || ['Content-Type', 'Authorization', 'X-Request-ID'],
    credentials: env.CORS_CREDENTIALS === 'true' || false,
  },
  
  // Logging
  logging: {
    level: env.LOG_LEVEL || 'info',
    filePath: env.LOG_FILE_PATH || 'logs',
    maxFiles: parseInt(env.LOG_MAX_FILES, 10) || 5,
    maxSize: parseInt(env.LOG_MAX_SIZE, 10) || 10 * 1024 * 1024, // 10MB
  },
  
  // IRD Compliance
  ird: {
    enabled: env.IRD_ENABLED !== 'false',
    vatRate: parseFloat(env.DEFAULT_VAT_RATE, 10) || 13.0,
    fiscalYear: env.IRD_FISCAL_YEAR || '2081/82',
    eBillingEnabled: env.IRD_E_BILLING_ENABLED === 'true' || false,
    eBillingUrl: env.IRD_E_BILLING_URL || 'https://ebilling.ird.gov.np',
  },
  
  // NFRS Compliance
  nfrs: {
    enabled: env.NFRS_ENABLED !== 'false',
    standards: env.NFRS_STANDARDS || 'NFRS',
  },
  
  // Nepali Localization
  nepali: {
    currency: env.NEPALI_CURRENCY || 'NPR',
    currencySymbol: env.NEPALI_CURRENCY_SYMBOL || 'à¤°à¥',
    dateFormat: env.NEPALI_DATE_FORMAT || 'yyyy-MM-dd',
    timeFormat: env.NEPALI_TIME_FORMAT || 'HH:mm:ss',
    locale: env.NEPALI_LOCALE || 'ne-NP',
  },
  
  // File Upload
  upload: {
    maxFileSize: parseInt(env.MAX_FILE_SIZE, 10) || 10 * 1024 * 1024, // 10MB
    tempDir: env.UPLOAD_TEMP_DIR || 'uploads/temp',
    permanentDir: env.UPLOAD_PERMANENT_DIR || 'uploads/permanent',
    allowedTypes: env.UPLOAD_ALLOWED_TYPES?.split(',') || ['image/jpeg', 'image/png', 'application/pdf'],
  },
  
  // Sync Configuration
  sync: {
    enabled: env.SYNC_ENABLED === 'true' || false,
    interval: parseInt(env.SYNC_INTERVAL_MS, 10) || 30000, // 30 seconds
    batchSize: parseInt(env.SYNC_BATCH_SIZE, 10) || 100,
    conflictResolution: env.SYNC_CONFLICT_RESOLUTION || 'server-wins', // server-wins, client-wins, manual
  },
  
  // Security
  security: {
    bcryptRounds: parseInt(env.BCRYPT_ROUNDS, 10) || 10,
    sessionTimeout: parseInt(env.SESSION_TIMEOUT_MINUTES, 10) || 30,
    passwordMinLength: parseInt(env.PASSWORD_MIN_LENGTH, 10) || 8,
  },
};

// Export configuration
module.exports = config;
