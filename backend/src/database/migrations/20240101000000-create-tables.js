/**
 * Database Migration: Create All Tables
 * This migration creates all the necessary tables for nKount
 */

const { sequelize } = require('../connection');
const { createLogger } = require('winston');

const logger = createLogger({
  level: 'info',
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/migrations.log' })
  ]
});

// Models to sync
const models = [
  'Company',
  'Contact',
  'Product',
  'Category',
  'Brand',
  'Unit',
  'TaxRate',
  'Transaction',
  'TransactionItem',
  'Payment',
  'Setting',
  'SyncLog',
  'AuditLog',
];

const migrate = async () => {
  try {
    logger.info('Starting database migration...');
    
    // Test connection
    await sequelize.authenticate();
    logger.info('Database connection established');
    
    // Sync all models
    for (const modelName of models) {
      const model = require(`../../models/${modelName}`);
      logger.info(`Syncing ${modelName} model...`);
      await model.sync({ alter: true });
      logger.info(`Synced ${modelName} model`);
    }
    
    // Define relationships
    const { initializeModels } = require('../../models/index');
    initializeModels();
    logger.info('Initialized model relationships');
    
    logger.info('Migration completed successfully');
    return true;
  } catch (error) {
    logger.error(`Migration failed: ${error.message}`);
    logger.error(error.stack);
    throw error;
  }
};

const rollback = async () => {
  try {
    logger.info('Starting database rollback...');
    
    // Drop all tables in reverse order
    const reverseModels = [...models].reverse();
    
    for (const modelName of reverseModels) {
      const model = require(`../../models/${modelName}`);
      logger.info(`Dropping ${modelName} table...`);
      await model.drop();
      logger.info(`Dropped ${modelName} table`);
    }
    
    logger.info('Rollback completed successfully');
    return true;
  } catch (error) {
    logger.error(`Rollback failed: ${error.message}`);
    logger.error(error.stack);
    throw error;
  }
};

module.exports = {
  migrate,
  rollback,
  models,
};

// Run migration if this file is executed directly
if (require.main === module) {
  migrate()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}
