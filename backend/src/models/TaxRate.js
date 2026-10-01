/**
 * TaxRate Model
 * Represents tax rates for products and transactions
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');
const config = require('../config/env');

const TaxRate = sequelize.define('TaxRate', {
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
  
  // Basic Information
  code: {
    type: DataTypes.STRING(20),
    field: 'code',
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
    field: 'name',
  },
  nepaliName: {
    type: DataTypes.STRING(100),
    field: 'nepali_name',
  },
  
  // Rate
  rate: {
    type: DataTypes.DECIMAL(5, 2),
    defaultValue: config.ird.vatRate,
    field: 'rate',
  },
  
  // Tax Type
  type: {
    type: DataTypes.ENUM('vat', 'excise', 'custom', 'service', 'other'),
    defaultValue: 'vat',
    field: 'type',
  },
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  
  // IRD Compliance
  irdCode: {
    type: DataTypes.STRING(50),
    field: 'ird_code',
  },
  isIRDCompliant: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'is_ird_compliant',
  },
  
  // Effective Date
  effectiveFrom: {
    type: DataTypes.DATEONLY,
    field: 'effective_from',
  },
  effectiveTo: {
    type: DataTypes.DATEONLY,
    field: 'effective_to',
  },
  
  // Is Default
  isDefault: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'is_default',
  },
  
  // Display Order
  displayOrder: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    field: 'display_order',
  },
  
  // Status
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'is_active',
  },
  
  // Custom Fields
  customFields: {
    type: DataTypes.JSONB,
    field: 'custom_fields',
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
  tableName: 'tax_rates',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'tax_rates_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'tax_rates_code_idx',
      fields: ['code'],
      unique: true,
      where: {
        code: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'tax_rates_name_idx',
      fields: ['name'],
    },
    {
      name: 'tax_rates_is_default_idx',
      fields: ['is_default'],
      unique: true,
      where: {
        is_default: true,
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'tax_rates_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (taxRate, options) => {
      // Ensure Nepali name is set if not provided
      if (!taxRate.nepaliName && taxRate.name) {
        taxRate.nepaliName = taxRate.name;
      }
      
      // Generate code if not provided
      if (!taxRate.code) {
        const companyId = taxRate.companyId;
        const count = await TaxRate.count({ where: { companyId } });
        taxRate.code = `TAX-${(count + 1).toString().padStart(4, '0')}`;
      }
      
      // Set display order if not provided
      if (!taxRate.displayOrder) {
        const count = await TaxRate.count({ where: { companyId: taxRate.companyId } });
        taxRate.displayOrder = count + 1;
      }
      
      // Ensure only one default per company
      if (taxRate.isDefault) {
        await TaxRate.update(
          { isDefault: false },
          {
            where: {
              companyId: taxRate.companyId,
              id: { [sequelize.Op.ne]: taxRate.id },
            },
          }
        );
      }
    },
    
    beforeUpdate: async (taxRate, options) => {
      // Update Nepali name if name is changed
      if (taxRate.changed('name') && !taxRate.nepaliName) {
        taxRate.nepaliName = taxRate.name;
      }
      
      // Ensure only one default per company
      if (taxRate.changed('isDefault') && taxRate.isDefault) {
        await TaxRate.update(
          { isDefault: false },
          {
            where: {
              companyId: taxRate.companyId,
              id: { [sequelize.Op.ne]: taxRate.id },
            },
          }
        );
      }
    },
  },
  
  // Scopes
  scopes: {
    active: {
      where: { isActive: true, deletedAt: null },
    },
    byCompany: (companyId) => {
      return {
        where: { companyId, deletedAt: null },
        order: [['display_order', 'ASC'], ['name', 'ASC']],
      };
    },
    default: {
      where: { isDefault: true, deletedAt: null },
    },
    search: (query, companyId) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { name: { [sequelize.Op.iLike]: `%${query}%` } },
            { nepaliName: { [sequelize.Op.iLike]: `%${query}%` } },
            { code: { [sequelize.Op.iLike]: `%${query}%` } },
            { description: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          companyId,
          deletedAt: null,
        },
        order: [['display_order', 'ASC'], ['name', 'ASC']],
      };
    },
  },
});

// Instance methods
TaxRate.prototype.getDisplayName = function() {
  return `${this.name} (${this.rate}%)`;
};

TaxRate.prototype.getTypeDisplay = function() {
  const types = {
    vat: 'VAT',
    excise: 'Excise Duty',
    custom: 'Custom Duty',
    service: 'Service Tax',
    other: 'Other',
  };
  return types[this.type] || this.type;
};

TaxRate.prototype.isCurrentlyEffective = function() {
  const now = new Date();
  const today = now.toISOString().split('T')[0];
  
  if (this.effectiveFrom && this.effectiveFrom > today) return false;
  if (this.effectiveTo && this.effectiveTo < today) return false;
  
  return true;
};

// Class methods
TaxRate.getDefaultRate = async function(companyId) {
  return this.findOne({
    where: { companyId, isDefault: true, deletedAt: null },
  });
};

TaxRate.getByRate = async function(companyId, rate) {
  return this.findOne({
    where: { companyId, rate, deletedAt: null },
  });
};

TaxRate.getNextDisplayOrder = async function(companyId) {
  const count = await this.count({
    where: { companyId, deletedAt: null },
  });
  return count + 1;
};

// Predefined tax rates for Nepal
TaxRate.predefinedRates = [
  { name: 'Standard VAT', nepaliName: 'मूल भ्याट', rate: 13.0, type: 'vat', irdCode: 'VAT-13', isIRDCompliant: true, isDefault: true },
  { name: 'Zero VAT', nepaliName: 'शून्य भ्याट', rate: 0.0, type: 'vat', irdCode: 'VAT-0', isIRDCompliant: true },
  { name: 'Exempt', nepaliName: 'छूट', rate: 0.0, type: 'vat', irdCode: 'VAT-EX', isIRDCompliant: true },
  { name: 'Excise Duty', nepaliName: 'उत्पादन कर', rate: 10.0, type: 'excise', irdCode: 'EXC-10' },
  { name: 'Service Tax', nepaliName: 'सेवा कर', rate: 10.0, type: 'service', irdCode: 'SVC-10' },
];

module.exports = TaxRate;
