/**
 * Database Models Index
 * Exports all Sequelize models for nKount
 */

const Company = require('./Company');
const Contact = require('./Contact');
const Product = require('./Product');
const Transaction = require('./Transaction');
const TransactionItem = require('./TransactionItem');
const Payment = require('./Payment');
const Category = require('./Category');
const Brand = require('./Brand');
const Unit = require('./Unit');
const TaxRate = require('./TaxRate');
const Setting = require('./Setting');
const SyncLog = require('./SyncLog');
const AuditLog = require('./AuditLog');

// Define model relationships
const defineRelationships = () => {
  // Company relationships
  Company.hasMany(Contact, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  Contact.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(Product, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  Product.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(Transaction, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  Transaction.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(Payment, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  Payment.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(Setting, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  Setting.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(SyncLog, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  SyncLog.belongsTo(Company, { foreignKey: 'companyId' });

  Company.hasMany(AuditLog, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  AuditLog.belongsTo(Company, { foreignKey: 'companyId' });

  // Contact relationships
  Contact.hasMany(Transaction, { foreignKey: 'contactId', onDelete: 'CASCADE' });
  Transaction.belongsTo(Contact, { foreignKey: 'contactId' });

  Contact.hasMany(Payment, { foreignKey: 'contactId', onDelete: 'CASCADE' });
  Payment.belongsTo(Contact, { foreignKey: 'contactId' });

  // Product relationships
  Category.hasMany(Product, { foreignKey: 'categoryId', onDelete: 'SET NULL' });
  Product.belongsTo(Category, { foreignKey: 'categoryId' });

  Brand.hasMany(Product, { foreignKey: 'brandId', onDelete: 'SET NULL' });
  Product.belongsTo(Brand, { foreignKey: 'brandId' });

  Unit.hasMany(Product, { foreignKey: 'unitId', onDelete: 'SET NULL' });
  Product.belongsTo(Unit, { foreignKey: 'unitId' });

  TaxRate.hasMany(Product, { foreignKey: 'taxRateId', onDelete: 'SET NULL' });
  Product.belongsTo(TaxRate, { foreignKey: 'taxRateId' });

  // Transaction relationships
  Transaction.hasMany(TransactionItem, { foreignKey: 'transactionId', onDelete: 'CASCADE' });
  TransactionItem.belongsTo(Transaction, { foreignKey: 'transactionId' });

  Transaction.hasMany(Payment, { foreignKey: 'transactionId', onDelete: 'CASCADE' });
  Payment.belongsTo(Transaction, { foreignKey: 'transactionId' });

  // TransactionItem relationships
  Product.hasMany(TransactionItem, { foreignKey: 'productId', onDelete: 'SET NULL' });
  TransactionItem.belongsTo(Product, { foreignKey: 'productId' });

  // Payment relationships
  Transaction.hasMany(Payment, { foreignKey: 'transactionId', onDelete: 'CASCADE' });
  Payment.belongsTo(Transaction, { foreignKey: 'transactionId' });

  Contact.hasMany(Payment, { foreignKey: 'contactId', onDelete: 'CASCADE' });
  Payment.belongsTo(Contact, { foreignKey: 'contactId' });

  // SyncLog relationships
  Company.hasMany(SyncLog, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  SyncLog.belongsTo(Company, { foreignKey: 'companyId' });

  // AuditLog relationships
  Company.hasMany(AuditLog, { foreignKey: 'companyId', onDelete: 'CASCADE' });
  AuditLog.belongsTo(Company, { foreignKey: 'companyId' });
};

// Initialize all models
const initializeModels = () => {
  defineRelationships();
  
  return {
    Company,
    Contact,
    Product,
    Transaction,
    TransactionItem,
    Payment,
    Category,
    Brand,
    Unit,
    TaxRate,
    Setting,
    SyncLog,
    AuditLog,
  };
};

// Export models
module.exports = {
  Company,
  Contact,
  Product,
  Transaction,
  TransactionItem,
  Payment,
  Category,
  Brand,
  Unit,
  TaxRate,
  Setting,
  SyncLog,
  AuditLog,
  initializeModels,
};
