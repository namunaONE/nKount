/**
 * Transaction Model
 * Represents sales, purchases, and other financial transactions
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Transaction = sequelize.define('Transaction', {
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
  
  // Contact relationship
  contactId: {
    type: DataTypes.UUID,
    field: 'contact_id',
    references: {
      model: 'contacts',
      key: 'id',
    },
  },
  
  // Transaction Type
  type: {
    type: DataTypes.ENUM(
      'sale',
      'purchase',
      'quote',
      'purchase_order',
      'return',
      'purchase_return',
      'adjustment',
      'transfer'
    ),
    allowNull: false,
    field: 'type',
  },
  
  // Transaction Number
  transactionNumber: {
    type: DataTypes.STRING(50),
    allowNull: false,
    field: 'transaction_number',
  },
  
  // Reference Number (for external references)
  referenceNumber: {
    type: DataTypes.STRING(100),
    field: 'reference_number',
  },
  
  // Date and Time
  date: {
    type: DataTypes.DATEONLY,
    defaultValue: DataTypes.NOW,
    field: 'date',
  },
  time: {
    type: DataTypes.TIME,
    field: 'time',
  },
  dueDate: {
    type: DataTypes.DATEONLY,
    field: 'due_date',
  },
  
  // Nepali Date (Bikram Sambat)
  nepaliDate: {
    type: DataTypes.STRING(20),
    field: 'nepali_date',
  },
  
  // Status
  status: {
    type: DataTypes.ENUM(
      'draft',
      'pending',
      'confirmed',
      'completed',
      'cancelled',
      'returned',
      'partially_paid'
    ),
    defaultValue: 'draft',
    field: 'status',
  },
  
  // Payment Status
  paymentStatus: {
    type: DataTypes.ENUM(
      'unpaid',
      'pending',
      'partially_paid',
      'paid',
      'overpaid',
      'refunded',
      'cancelled'
    ),
    defaultValue: 'unpaid',
    field: 'payment_status',
  },
  
  // Financial Information
  subtotal: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'subtotal',
  },
  discount: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'discount',
  },
  discountType: {
    type: DataTypes.ENUM('percentage', 'fixed'),
    defaultValue: 'percentage',
    field: 'discount_type',
  },
  tax: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'tax',
  },
  taxRate: {
    type: DataTypes.DECIMAL(5, 2),
    defaultValue: 13.0,
    field: 'tax_rate',
  },
  total: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'total',
  },
  
  // Amount Paid
  amountPaid: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'amount_paid',
  },
  
  // Balance Due
  balanceDue: {
    type: DataTypes.VIRTUAL,
    get() {
      return (this.total || 0) - (this.amountPaid || 0);
    },
  },
  
  // Currency
  currency: {
    type: DataTypes.STRING(3),
    defaultValue: 'NPR',
    field: 'currency',
  },
  exchangeRate: {
    type: DataTypes.DECIMAL(10, 6),
    defaultValue: 1,
    field: 'exchange_rate',
  },
  
  // Shipping Information
  shippingAddress: {
    type: DataTypes.TEXT,
    field: 'shipping_address',
  },
  shippingMethod: {
    type: DataTypes.STRING(100),
    field: 'shipping_method',
  },
  shippingCost: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0,
    field: 'shipping_cost',
  },
  
  // Notes
  notes: {
    type: DataTypes.TEXT,
    field: 'notes',
  },
  internalNotes: {
    type: DataTypes.TEXT,
    field: 'internal_notes',
  },
  
  // Terms and Conditions
  termsAndConditions: {
    type: DataTypes.TEXT,
    field: 'terms_and_conditions',
  },
  
  // IRD Compliance Fields
  irdInvoiceNumber: {
    type: DataTypes.STRING(50),
    field: 'ird_invoice_number',
  },
  irdQrCode: {
    type: DataTypes.STRING(255),
    field: 'ird_qr_code',
  },
  irdVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'ird_verified',
  },
  irdVerificationDate: {
    type: DataTypes.DATE,
    field: 'ird_verification_date',
  },
  
  // E-Billing Information
  eBillingEnabled: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'e_billing_enabled',
  },
  eBillingStatus: {
    type: DataTypes.STRING(50),
    field: 'e_billing_status',
  },
  eBillingReference: {
    type: DataTypes.STRING(100),
    field: 'e_billing_reference',
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
  tableName: 'transactions',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'transactions_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'transactions_contact_id_idx',
      fields: ['contact_id'],
    },
    {
      name: 'transactions_type_idx',
      fields: ['type'],
    },
    {
      name: 'transactions_transaction_number_idx',
      fields: ['transaction_number'],
      unique: true,
    },
    {
      name: 'transactions_status_idx',
      fields: ['status'],
    },
    {
      name: 'transactions_payment_status_idx',
      fields: ['payment_status'],
    },
    {
      name: 'transactions_date_idx',
      fields: ['date'],
    },
    {
      name: 'transactions_due_date_idx',
      fields: ['due_date'],
    },
    {
      name: 'transactions_ird_invoice_number_idx',
      fields: ['ird_invoice_number'],
      unique: true,
      where: {
        ird_invoice_number: { [sequelize.Op.ne]: null },
      },
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (transaction, options) => {
      // Generate transaction number if not provided
      if (!transaction.transactionNumber) {
        const companyId = transaction.companyId;
        const company = await sequelize.models.Company.findByPk(companyId);
        
        if (company) {
          let prefix;
          switch (transaction.type) {
            case 'sale':
              prefix = company.invoicePrefix || 'INV';
              break;
            case 'purchase':
              prefix = 'PUR';
              break;
            case 'quote':
              prefix = company.quotePrefix || 'QUOTE';
              break;
            case 'purchase_order':
              prefix = company.purchaseOrderPrefix || 'PO';
              break;
            case 'return':
              prefix = 'RET';
              break;
            case 'purchase_return':
              prefix = 'PRET';
              break;
            default:
              prefix = 'TXN';
          }
          
          const count = await Transaction.count({
            where: { companyId, type: transaction.type }
          });
          
          transaction.transactionNumber = `${prefix}-${(count + 1).toString().padStart(6, '0')}`;
        }
      }
      
      // Calculate total if not provided
      if (!transaction.total && transaction.subtotal !== undefined) {
        transaction.total = transaction.calculateTotal();
      }
    },
    
    beforeUpdate: async (transaction, options) => {
      // Recalculate total if subtotal, discount, or tax changed
      if (
        transaction.changed('subtotal') ||
        transaction.changed('discount') ||
        transaction.changed('discountType') ||
        transaction.changed('tax') ||
        transaction.changed('taxRate')
      ) {
        transaction.total = transaction.calculateTotal();
      }
    },
  },
  
  // Scopes
  scopes: {
    active: {
      where: { deletedAt: null },
    },
    byType: (type) => {
      return {
        where: { type, deletedAt: null },
      };
    },
    byStatus: (status) => {
      return {
        where: { status, deletedAt: null },
      };
    },
    byPaymentStatus: (paymentStatus) => {
      return {
        where: { paymentStatus, deletedAt: null },
      };
    },
    sales: {
      where: { type: { [sequelize.Op.or]: ['sale', 'quote'] }, deletedAt: null },
    },
    purchases: {
      where: { type: { [sequelize.Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null },
    },
    returns: {
      where: { type: { [sequelize.Op.or]: ['return', 'purchase_return'] }, deletedAt: null },
    },
    unpaid: {
      where: { paymentStatus: { [sequelize.Op.or]: ['unpaid', 'pending'] }, deletedAt: null },
    },
    paid: {
      where: { paymentStatus: 'paid', deletedAt: null },
    },
    partiallyPaid: {
      where: { paymentStatus: 'partially_paid', deletedAt: null },
    },
    overdue: {
      where: {
        paymentStatus: { [sequelize.Op.or]: ['unpaid', 'pending', 'partially_paid'] },
        dueDate: { [sequelize.Op.lt]: new Date() },
        deletedAt: null,
      },
    },
    today: {
      where: {
        date: new Date().toISOString().split('T')[0],
        deletedAt: null,
      },
    },
    thisMonth: {
      where: {
        date: {
          [sequelize.Op.gte]: new Date(new Date().getFullYear(), new Date().getMonth(), 1),
          [sequelize.Op.lte]: new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0),
        },
        deletedAt: null,
      },
    },
    thisYear: {
      where: {
        date: {
          [sequelize.Op.gte]: new Date(new Date().getFullYear(), 0, 1),
          [sequelize.Op.lte]: new Date(new Date().getFullYear(), 11, 31),
        },
        deletedAt: null,
      },
    },
    search: (query, companyId) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { transactionNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { referenceNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { irdInvoiceNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { notes: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          companyId,
          deletedAt: null,
        },
      };
    },
  },
});

// Instance methods
Transaction.prototype.calculateTotal = function() {
  let subtotal = this.subtotal || 0;
  
  // Apply discount
  if (this.discount && this.discount > 0) {
    if (this.discountType === 'percentage') {
      subtotal -= subtotal * (this.discount / 100);
    } else {
      subtotal -= this.discount;
    }
  }
  
  // Add tax
  const taxAmount = (subtotal * (this.taxRate || 0)) / 100;
  
  // Add shipping cost
  const shippingCost = this.shippingCost || 0;
  
  return subtotal + taxAmount + shippingCost;
};

Transaction.prototype.getDisplayNumber = function() {
  return this.transactionNumber;
};

Transaction.prototype.getTypeDisplay = function() {
  const types = {
    sale: 'Sale',
    purchase: 'Purchase',
    quote: 'Quote',
    purchase_order: 'Purchase Order',
    return: 'Sales Return',
    purchase_return: 'Purchase Return',
    adjustment: 'Adjustment',
    transfer: 'Transfer',
  };
  return types[this.type] || this.type;
};

Transaction.prototype.getStatusDisplay = function() {
  const statuses = {
    draft: 'Draft',
    pending: 'Pending',
    confirmed: 'Confirmed',
    completed: 'Completed',
    cancelled: 'Cancelled',
    returned: 'Returned',
    partially_paid: 'Partially Paid',
  };
  return statuses[this.status] || this.status;
};

Transaction.prototype.getPaymentStatusDisplay = function() {
  const statuses = {
    unpaid: 'Unpaid',
    pending: 'Pending',
    partially_paid: 'Partially Paid',
    paid: 'Paid',
    overpaid: 'Overpaid',
    refunded: 'Refunded',
    cancelled: 'Cancelled',
  };
  return statuses[this.paymentStatus] || this.paymentStatus;
};

Transaction.prototype.getPaymentStatusColor = function() {
  const colors = {
    unpaid: 'red',
    pending: 'orange',
    partially_paid: 'yellow',
    paid: 'green',
    overpaid: 'blue',
    refunded: 'purple',
    cancelled: 'gray',
  };
  return colors[this.paymentStatus] || 'gray';
};

Transaction.prototype.isOverdue = function() {
  if (!this.dueDate) return false;
  if (this.paymentStatus === 'paid') return false;
  
  const dueDate = new Date(this.dueDate);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  return dueDate < today;
};

Transaction.prototype.getDaysOverdue = function() {
  if (!this.isOverdue()) return 0;
  
  const dueDate = new Date(this.dueDate);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const diffTime = today - dueDate;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  return diffDays;
};

Transaction.prototype.updatePaymentStatus = async function(newAmountPaid = 0) {
  const total = this.total || 0;
  const amountPaid = this.amountPaid || 0;
  const newTotalPaid = amountPaid + newAmountPaid;
  
  let newStatus;
  
  if (newTotalPaid >= total) {
    newStatus = newTotalPaid > total ? 'overpaid' : 'paid';
  } else if (newTotalPaid > 0) {
    newStatus = 'partially_paid';
  } else {
    newStatus = 'unpaid';
  }
  
  await this.update({
    amountPaid: newTotalPaid,
    paymentStatus: newStatus,
  });
  
  return this;
};

Transaction.prototype.cancel = async function() {
  await this.update({
    status: 'cancelled',
    paymentStatus: 'cancelled',
  });
  
  return this;
};

Transaction.prototype.confirm = async function() {
  await this.update({
    status: 'confirmed',
  });
  
  return this;
};

Transaction.prototype.complete = async function() {
  await this.update({
    status: 'completed',
    paymentStatus: this.amountPaid >= this.total ? 'paid' : this.paymentStatus,
  });
  
  return this;
};

// Class methods
Transaction.getNextNumber = async function(companyId, type) {
  const company = await sequelize.models.Company.findByPk(companyId);
  const count = await this.count({ where: { companyId, type } });
  
  let prefix;
  switch (type) {
    case 'sale':
      prefix = company?.invoicePrefix || 'INV';
      break;
    case 'purchase':
      prefix = 'PUR';
      break;
    case 'quote':
      prefix = company?.quotePrefix || 'QUOTE';
      break;
    case 'purchase_order':
      prefix = company?.purchaseOrderPrefix || 'PO';
      break;
    default:
      prefix = 'TXN';
  }
  
  return `${prefix}-${(count + 1).toString().padStart(6, '0')}`;
};

Transaction.getTotalSales = async function(companyId, startDate, endDate) {
  return this.sum('total', {
    where: {
      companyId,
      type: { [sequelize.Op.or]: ['sale', 'quote'] },
      status: { [sequelize.Op.or]: ['confirmed', 'completed'] },
      date: {
        [sequelize.Op.gte]: startDate,
        [sequelize.Op.lte]: endDate,
      },
      deletedAt: null,
    },
  });
};

Transaction.getTotalPurchases = async function(companyId, startDate, endDate) {
  return this.sum('total', {
    where: {
      companyId,
      type: { [sequelize.Op.or]: ['purchase', 'purchase_order'] },
      status: { [sequelize.Op.or]: ['confirmed', 'completed'] },
      date: {
        [sequelize.Op.gte]: startDate,
        [sequelize.Op.lte]: endDate,
      },
      deletedAt: null,
    },
  });
};

Transaction.getOutstandingAmount = async function(companyId) {
  const result = await this.sum('balanceDue', {
    where: {
      companyId,
      type: { [sequelize.Op.or]: ['sale', 'purchase'] },
      paymentStatus: { [sequelize.Op.or]: ['unpaid', 'pending', 'partially_paid'] },
      deletedAt: null,
    },
  });
  
  return result || 0;
};

module.exports = Transaction;
