/**
 * Database Connection
 * Sequelize ORM configuration for PostgreSQL
 */

const { Sequelize } = require('sequelize');
const config = require('../config/env');
const { createLogger } = require('winston');

// Create logger
const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/error.log', level: 'error' })
  ]
});

// Database connection configuration
const dbConfig = {
  host: config.db.host,
  port: config.db.port,
  database: config.db.name,
  username: config.db.username,
  password: config.db.password,
  dialect: config.db.dialect,
  logging: config.db.logging ? (msg) => logger.info(msg) : false,
  pool: config.db.pool,
  ssl: config.db.ssl,
  dialectOptions: config.db.dialectOptions,
  define: {
    timestamps: true,
    underscored: true,
    freezeTableName: false,
    charset: 'utf8',
    dialectOptions: {
      useUTC: false,
      dateStrings: true,
      typeCast: true,
    },
  },
  timezone: '+05:45', // Nepal time zone
};

// Create Sequelize instance
const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  {
    host: dbConfig.host,
    port: dbConfig.port,
    dialect: dbConfig.dialect,
    logging: dbConfig.logging,
    pool: dbConfig.pool,
    ssl: dbConfig.ssl,
    dialectOptions: dbConfig.dialectOptions,
    define: dbConfig.define,
    timezone: dbConfig.timezone,
  }
);

// Test database connection
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    logger.info('Database connection has been established successfully.');
    return true;
  } catch (error) {
    logger.error(`Unable to connect to the database: ${error.message}`);
    throw error;
  }
};

// Close database connection
const closeConnection = async () => {
  try {
    await sequelize.close();
    logger.info('Database connection closed.');
    return true;
  } catch (error) {
    logger.error(`Error closing database connection: ${error.message}`);
    throw error;
  }
};

// Sync all models
const syncModels = async (options = {}) => {
  try {
    await sequelize.sync(options);
    logger.info('Database models synced successfully.');
    return true;
  } catch (error) {
    logger.error(`Error syncing database models: ${error.message}`);
    throw error;
  }
};

// Drop all tables (for development/testing)
const dropAllTables = async () => {
  try {
    await sequelize.drop();
    logger.info('All database tables dropped.');
    return true;
  } catch (error) {
    logger.error(`Error dropping database tables: ${error.message}`);
    throw error;
  }
};

// Transaction helpers
const transaction = sequelize.transaction;

// Query interface
const query = sequelize.query;

// Export database connection
module.exports = {
  sequelize,
  testConnection,
  closeConnection,
  syncModels,
  dropAllTables,
  transaction,
  query,
};
