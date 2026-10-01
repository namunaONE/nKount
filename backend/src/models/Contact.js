/**
 * Contact Model
 * Represents customers, suppliers, and other contacts
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Contact = sequelize.define('Contact', {
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
  
  // Contact Type
  type: {
    type: DataTypes.ENUM('customer', 'supplier', 'both', 'employee', 'other'),
    defaultValue: 'customer',
    field: 'type',
  },
  
  // Basic Information
  firstName: {
    type: DataTypes.STRING(100),
    field: 'first_name',
  },
  lastName: {
    type: DataTypes.STRING(100),
    field: 'last_name',
  },
  fullName: {
    type: DataTypes.VIRTUAL,
    get() {
      return `${this.firstName || ''} ${this.lastName || ''}`.trim();
    },
    set(value) {
      // Split full name into first and last name
      const parts = value?.split(' ') || [];
      this.firstName = parts.slice(0, -1).join(' ') || null;
      this.lastName = parts.length > 0 ? parts[parts.length - 1] : null;
    },
  },
  
  // Nepali name
  nepaliName: {
    type: DataTypes.STRING(255),
    field: 'nepali_name',
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
  
  // Tax Information
  panNumber: {
    type: DataTypes.STRING(50),
    field: 'pan_number',
  },
  vatNumber: {
    type: DataTypes.STRING(50),
    field: 'vat_number',
  },
  
  // Financial Information
  openingBalance: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'opening_balance',
  },
  creditLimit: {
    type: DataTypes.DECIMAL(15, 2),
    field: 'credit_limit',
  },
  
  // Payment Terms
  paymentTerms: {
    type: DataTypes.INTEGER,
    comment: 'Number of days for payment terms',
    field: 'payment_terms',
  },
  paymentMethod: {
    type: DataTypes.ENUM('cash', 'bank', 'cheque', 'online', 'credit'),
    defaultValue: 'cash',
    field: 'payment_method',
  },
  
  // Bank Information
  bankName: {
    type: DataTypes.STRING(100),
    field: 'bank_name',
  },
  bankBranch: {
    type: DataTypes.STRING(100),
    field: 'bank_branch',
  },
  bankAccountNumber: {
    type: DataTypes.STRING(50),
    field: 'bank_account_number',
  },
  
  // Tracking Information
  totalPurchases: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'total_purchases',
  },
  totalSales: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'total_sales',
  },
  totalPayments: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'total_payments',
  },
  totalReceipts: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'total_receipts',
  },
  
  // Current Balance (calculated field)
  currentBalance: {
    type: DataTypes.VIRTUAL,
    get() {
      // For customers: Total Sales - Total Receipts + Opening Balance
      // For suppliers: Total Purchases - Total Payments + Opening Balance
      if (this.type === 'customer' || this.type === 'both') {
        return (this.openingBalance || 0) + (this.totalSales || 0) - (this.totalReceipts || 0);
      } else if (this.type === 'supplier' || this.type === 'both') {
        return (this.openingBalance || 0) + (this.totalPurchases || 0) - (this.totalPayments || 0);
      }
      return this.openingBalance || 0;
    },
  },
  
  // Notes
  notes: {
    type: DataTypes.TEXT,
    field: 'notes',
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
  tableName: 'contacts',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'contacts_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'contacts_type_idx',
      fields: ['type'],
    },
    {
      name: 'contacts_name_idx',
      fields: ['first_name', 'last_name'],
    },
    {
      name: 'contacts_pan_number_idx',
      fields: ['pan_number'],
      unique: true,
      where: {
        pan_number: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'contacts_vat_number_idx',
      fields: ['vat_number'],
      unique: true,
      where: {
        vat_number: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'contacts_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (contact, options) => {
      // Ensure Nepali name is set if not provided
      if (!contact.nepaliName && (contact.firstName || contact.lastName)) {
        contact.nepaliName = contact.fullName;
      }
    },
    
    beforeUpdate: async (contact, options) => {
      // Update Nepali name if name is changed
      if ((contact.changed('firstName') || contact.changed('lastName')) && !contact.nepaliName) {
        contact.nepaliName = contact.fullName;
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
    customers: {
      where: { type: { [sequelize.Op.or]: ['customer', 'both'] }, deletedAt: null },
    },
    suppliers: {
      where: { type: { [sequelize.Op.or]: ['supplier', 'both'] }, deletedAt: null },
    },
    search: (query, companyId) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { firstName: { [sequelize.Op.iLike]: `%${query}%` } },
            { lastName: { [sequelize.Op.iLike]: `%${query}%` } },
            { fullName: { [sequelize.Op.iLike]: `%${query}%` } },
            { nepaliName: { [sequelize.Op.iLike]: `%${query}%` } },
            { phone: { [sequelize.Op.iLike]: `%${query}%` } },
            { mobile: { [sequelize.Op.iLike]: `%${query}%` } },
            { email: { [sequelize.Op.iLike]: `%${query}%` } },
            { panNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { vatNumber: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          companyId,
          deletedAt: null,
        },
      };
    },
    withBalance: (balanceType) => {
      return {
        where: {
          [sequelize.Op.and]: [
            {
              [sequelize.Op.or]: [
                { type: 'customer' },
                { type: 'both' },
              ],
            },
            {
              [sequelize.Op[balanceType === 'positive' ? 'gt' : 'lt']]: sequelize.literal(`
                (opening_balance + COALESCE(total_sales, 0) - COALESCE(total_receipts, 0)) 
                ${balanceType === 'positive' ? '>' : '<'} 0
              `),
            },
          ],
          deletedAt: null,
        },
      };
    },
  },
});

// Class methods
Contact.getCustomerCount = async function(companyId) {
  return this.count({
    where: {
      companyId,
      type: { [sequelize.Op.or]: ['customer', 'both'] },
      deletedAt: null,
    },
  });
};

Contact.getSupplierCount = async function(companyId) {
  return this.count({
    where: {
      companyId,
      type: { [sequelize.Op.or]: ['supplier', 'both'] },
      deletedAt: null,
    },
  });
};

Contact.getTotalOutstanding = async function(companyId, type = 'customer') {
  const contacts = await this.findAll({
    where: {
      companyId,
      type: type === 'customer' ? { [sequelize.Op.or]: ['customer', 'both'] } : { [sequelize.Op.or]: ['supplier', 'both'] },
      deletedAt: null,
    },
    attributes: [
      'id',
      'type',
      'openingBalance',
      'totalPurchases',
      'totalSales',
      'totalPayments',
      'totalReceipts',
    ],
  });
  
  let total = 0;
  contacts.forEach(contact => {
    if (type === 'customer') {
      total += (contact.openingBalance || 0) + (contact.totalSales || 0) - (contact.totalReceipts || 0);
    } else {
      total += (contact.openingBalance || 0) + (contact.totalPurchases || 0) - (contact.totalPayments || 0);
    }
  });
  
  return total;
};

// Instance methods
Contact.prototype.getFullAddress = function() {
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

Contact.prototype.getContactTypeDisplay = function() {
  const types = {
    customer: 'Customer',
    supplier: 'Supplier',
    both: 'Customer & Supplier',
    employee: 'Employee',
    other: 'Other',
  };
  return types[this.type] || this.type;
};

Contact.prototype.getPaymentTermsDisplay = function() {
  if (!this.paymentTerms) return 'Due on Receipt';
  return `Net ${this.paymentTerms} days`;
};

Contact.prototype.getBalanceStatus = function() {
  const balance = this.currentBalance;
  
  if (balance > 0) {
    return this.type === 'customer' ? 'Receivable' : 'Payable';
  } else if (balance < 0) {
    return this.type === 'customer' ? 'Prepaid' : 'Pre-received';
  }
  return 'Balanced';
};

Contact.prototype.updateBalance = async function(amount, transactionType) {
  // Update balance based on transaction type
  // transactionType: 'sale', 'purchase', 'payment', 'receipt'
  
  const updates = {};
  
  switch (transactionType) {
    case 'sale':
      updates.totalSales = (this.totalSales || 0) + amount;
      break;
    case 'purchase':
      updates.totalPurchases = (this.totalPurchases || 0) + amount;
      break;
    case 'payment':
      updates.totalPayments = (this.totalPayments || 0) + amount;
      break;
    case 'receipt':
      updates.totalReceipts = (this.totalReceipts || 0) + amount;
      break;
  }
  
  await this.update(updates);
  return this;
};

module.exports = Contact;
