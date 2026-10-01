/**
 * Setting Model
 * Represents application settings for a company
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');
const config = require('../config/env');

const Setting = sequelize.define('Setting', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
    allowNull: false,
  },
  
  // Company relationship
  companyId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'company_id',
    references: {
      model: 'companies',
      key: 'id',
    },
  },
  
  // Setting Key
  key: {
    type: DataTypes.STRING(100),
    allowNull: false,
    field: 'key',
  },
  
  // Setting Value
  value: {
    type: DataTypes.TEXT,
    field: 'value',
  },
  
  // Setting Type
  type: {
    type: DataTypes.ENUM('string', 'number', 'boolean', 'json'),
    defaultValue: 'string',
    field: 'type',
  },
  
  // Category
  category: {
    type: DataTypes.STRING(50),
    field: 'category',
  },
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  
  // Is Default
  isDefault: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'is_default',
  },
  
  // Timestamps
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
    field: 'created_at',
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
    field: 'updated_at',
  },
  
  // Soft delete
  deletedAt: {
    type: DataTypes.DATE,
    field: 'deleted_at',
  },
}, {
  tableName: 'settings',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'settings_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'settings_key_idx',
      fields: ['key'],
      unique: true,
      where: {
        key: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'settings_category_idx',
      fields: ['category'],
    },
  ],
  
  // Scopes
  scopes: {
    byCompany: (companyId) => {
      return {
        where: { companyId, deletedAt: null },
      };
    },
    byCategory: (category) => {
      return {
        where: { category, deletedAt: null },
      };
    },
    byKey: (key) => {
      return {
        where: { key, deletedAt: null },
      };
    },
  },
});

// Instance methods
Setting.prototype.getValue = function() {
  switch (this.type) {
    case 'number':
      return parseFloat(this.value);
    case 'boolean':
      return this.value === 'true' || this.value === true || this.value === '1';
    case 'json':
      try {
        return JSON.parse(this.value);
      } catch (e) {
        return this.value;
      }
    default:
      return this.value;
  }
};

Setting.prototype.setValue = function(newValue) {
  switch (this.type) {
    case 'number':
      this.value = newValue.toString();
      break;
    case 'boolean':
      this.value = newValue ? 'true' : 'false';
      break;
    case 'json':
      this.value = JSON.stringify(newValue);
      break;
    default:
      this.value = newValue;
  }
};

// Class methods
Setting.get = async function(companyId, key, defaultValue = null) {
  const setting = await this.findOne({
    where: { companyId, key, deletedAt: null },
  });
  
  if (!setting) return defaultValue;
  return setting.getValue();
};

Setting.set = async function(companyId, key, value, type = 'string', category = 'general') {
  const existing = await this.findOne({
    where: { companyId, key, deletedAt: null },
  });
  
  if (existing) {
    existing.value = value;
    existing.type = type;
    existing.category = category;
    await existing.save();
    return existing;
  }
  
  return this.create({
    companyId,
    key,
    value,
    type,
    category,
  });
};

Setting.getAllByCategory = async function(companyId, category) {
  const settings = await this.findAll({
    where: { companyId, category, deletedAt: null },
  });
  
  const result = {};
  settings.forEach(setting => {
    result[setting.key] = setting.getValue();
  });
  
  return result;
};

Setting.getAll = async function(companyId) {
  const settings = await this.findAll({
    where: { companyId, deletedAt: null },
  });
  
  const result = {};
  settings.forEach(setting => {
    result[setting.key] = setting.getValue();
  });
  
  return result;
};

Setting.bulkSet = async function(companyId, settingsMap) {
  const transactions = [];
  
  for (const [key, value] of Object.entries(settingsMap)) {
    const existing = await this.findOne({
      where: { companyId, key, deletedAt: null },
    });
    
    if (existing) {
      existing.value = value;
      transactions.push(existing.save());
    } else {
      transactions.push(this.create({
        companyId,
        key,
        value: value,
        type: typeof value === 'number' ? 'number' : typeof value === 'boolean' ? 'boolean' : 'string',
        category: 'general',
      }));
    }
  }
  
  await Promise.all(transactions);
  return true;
};

// Default settings for new companies
Setting.defaultSettings = {
  // General
  company_name: '',
  currency: config.nepali.currency,
  currency_symbol: config.nepali.currencySymbol,
  date_format: config.nepali.dateFormat,
  time_format: config.nepali.timeFormat,
  
  // IRD
  ird_enabled: true,
  default_vat_rate: config.ird.vatRate,
  fiscal_year: config.ird.fiscalYear,
  
  // Invoice
  invoice_prefix: 'INV',
  quote_prefix: 'QUOTE',
  purchase_order_prefix: 'PO',
  
  // Numbering
  auto_increment_invoices: true,
  auto_increment_quotes: true,
  auto_increment_purchase_orders: true,
  
  // Display
  theme: 'light',
  language: 'en',
  show_nepali_date: true,
  
  // Notifications
  enable_notifications: true,
  low_stock_notification: true,
  low_stock_threshold: 5,
  
  // Reports
  default_report_period: 'monthly',
  show_dashboard_stats: true,
};

module.exports = Setting;
