/**
 * Company Model
 * Represents a business/company in the accounting system
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');
const config = require('../config/env');

const Company = sequelize.define('Company', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
    allowNull: false,
  },
  
  // Basic Information
  name: {
    type: DataTypes.STRING(255),
    allowNull: false,
    field: 'name',
  },
  
  // Nepali name (for local display)
  nepaliName: {
    type: DataTypes.STRING(255),
    field: 'nepali_name',
  },
  
  // Company Type
  type: {
    type: DataTypes.ENUM(
      'sole_proprietorship',
      'partnership',
      'private_limited',
      'public_limited',
      'llc',
      'cooperative',
      'other'
    ),
    defaultValue: 'sole_proprietorship',
    field: 'type',
  },
  
  // Contact Information
  phone: {
    type: DataTypes.STRING(20),
    field: 'phone',
  },
  mobile: {
    type: DataTypes.STRING(20),
    field: 'mobile',
  },
  email: {
    type: DataTypes.STRING(255),
    validate: {
      isEmail: true,
    },
    field: 'email',
  },
  website: {
    type: DataTypes.STRING(255),
    field: 'website',
  },
  
  // Address
  addressLine1: {
    type: DataTypes.STRING(255),
    field: 'address_line_1',
  },
  addressLine2: {
    type: DataTypes.STRING(255),
    field: 'address_line_2',
  },
  city: {
    type: DataTypes.STRING(100),
    field: 'city',
  },
  district: {
    type: DataTypes.STRING(100),
    field: 'district',
  },
  state: {
    type: DataTypes.STRING(100),
    field: 'state',
  },
  country: {
    type: DataTypes.STRING(100),
    defaultValue: 'Nepal',
    field: 'country',
  },
  postalCode: {
    type: DataTypes.STRING(20),
    field: 'postal_code',
  },
  
  // Registration Information
  panNumber: {
    type: DataTypes.STRING(50),
    field: 'pan_number',
  },
  vatNumber: {
    type: DataTypes.STRING(50),
    field: 'vat_number',
  },
  registrationNumber: {
    type: DataTypes.STRING(100),
    field: 'registration_number',
  },
  registrationDate: {
    type: DataTypes.DATEONLY,
    field: 'registration_date',
  },
  
  // Financial Information
  currency: {
    type: DataTypes.STRING(3),
    defaultValue: config.nepali.currency,
    field: 'currency',
  },
  fiscalYearStart: {
    type: DataTypes.DATEONLY,
    field: 'fiscal_year_start',
  },
  fiscalYearEnd: {
    type: DataTypes.DATEONLY,
    field: 'fiscal_year_end',
  },
  
  // Accounting Settings
  accountingMethod: {
    type: DataTypes.ENUM('accrual', 'cash'),
    defaultValue: 'accrual',
    field: 'accounting_method',
  },
  
  // Default VAT Rate
  defaultVatRate: {
    type: DataTypes.DECIMAL(5, 2),
    defaultValue: config.ird.vatRate,
    field: 'default_vat_rate',
  },
  
  // Invoice Settings
  invoicePrefix: {
    type: DataTypes.STRING(20),
    defaultValue: 'INV',
    field: 'invoice_prefix',
  },
  invoiceNumber: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
    field: 'invoice_number',
  },
  quotePrefix: {
    type: DataTypes.STRING(20),
    defaultValue: 'QUOTE',
    field: 'quote_prefix',
  },
  quoteNumber: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
    field: 'quote_number',
  },
  purchaseOrderPrefix: {
    type: DataTypes.STRING(20),
    defaultValue: 'PO',
    field: 'purchase_order_prefix',
  },
  purchaseOrderNumber: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
    field: 'purchase_order_number',
  },
  
  // Logo and Branding
  logo: {
    type: DataTypes.STRING(255),
    field: 'logo',
  },
  
  // Status
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'is_active',
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
  tableName: 'companies',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'companies_name_idx',
      fields: ['name'],
    },
    {
      name: 'companies_pan_number_idx',
      fields: ['pan_number'],
      unique: true,
      where: {
        pan_number: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'companies_vat_number_idx',
      fields: ['vat_number'],
      unique: true,
      where: {
        vat_number: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'companies_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (company, options) => {
      // Ensure Nepali name is set if not provided
      if (!company.nepaliName && company.name) {
        company.nepaliName = company.name;
      }
      
      // Set default fiscal year for Nepal
      if (!company.fiscalYearStart) {
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear();
        company.fiscalYearStart = new Date(currentYear, 3, 1); // April 1
        company.fiscalYearEnd = new Date(currentYear + 1, 2, 31); // March 31
      }
    },
    
    beforeUpdate: async (company, options) => {
      // Update Nepali name if name is changed
      if (company.changed('name') && !company.nepaliName) {
        company.nepaliName = company.name;
      }
    },
  },
  
  // Scopes
  scopes: {
    active: {
      where: { isActive: true, deletedAt: null },
    },
    byType: (type) => {
      return {
        where: { type, deletedAt: null },
      };
    },
    search: (query) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { name: { [sequelize.Op.iLike]: `%${query}%` } },
            { nepaliName: { [sequelize.Op.iLike]: `%${query}%` } },
            { panNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { vatNumber: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          deletedAt: null,
        },
      };
    },
  },
});

// Class methods
Company.getNextInvoiceNumber = async function(companyId) {
  const company = await this.findByPk(companyId);
  if (!company) {
    throw new Error('Company not found');
  }
  
  const nextNumber = company.invoiceNumber + 1;
  await company.update({ invoiceNumber: nextNumber });
  
  return `${company.invoicePrefix}-${nextNumber.toString().padStart(6, '0')}`;
};

Company.getNextQuoteNumber = async function(companyId) {
  const company = await this.findByPk(companyId);
  if (!company) {
    throw new Error('Company not found');
  }
  
  const nextNumber = company.quoteNumber + 1;
  await company.update({ quoteNumber: nextNumber });
  
  return `${company.quotePrefix}-${nextNumber.toString().padStart(6, '0')}`;
};

Company.getNextPurchaseOrderNumber = async function(companyId) {
  const company = await this.findByPk(companyId);
  if (!company) {
    throw new Error('Company not found');
  }
  
  const nextNumber = company.purchaseOrderNumber + 1;
  await company.update({ purchaseOrderNumber: nextNumber });
  
  return `${company.purchaseOrderPrefix}-${nextNumber.toString().padStart(6, '0')}`;
};

// Instance methods
Company.prototype.getFullAddress = function() {
  const parts = [
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.district,
    this.state,
    this.country,
    this.postalCode,
  ].filter(part => part);
  
  return parts.join(', ');
};

Company.prototype.getIRDInfo = function() {
  return {
    panNumber: this.panNumber,
    vatNumber: this.vatNumber,
    registrationNumber: this.registrationNumber,
    fiscalYear: `${this.fiscalYearStart?.toISOString().split('T')[0]} to ${this.fiscalYearEnd?.toISOString().split('T')[0]}`,
    defaultVatRate: this.defaultVatRate,
  };
};

module.exports = Company;
