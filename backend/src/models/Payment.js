/**
 * Payment Model
 * Represents payments and receipts
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Payment = sequelize.define('Payment', {
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
  
  // Transaction relationship (optional - payment can be standalone)
  transactionId: {
    type: DataTypes.UUID,
    field: 'transaction_id',
    references: {
      model: 'transactions',
      key: 'id',
    },
    onDelete: 'SET NULL',
  },
  
  // Contact relationship
  contactId: {
    type: DataTypes.UUID,
    field: 'contact_id',
    references: {
      model: 'contacts',
      key: 'id',
    },
    onDelete: 'SET NULL',
  },
  
  // Payment Type
  type: {
    type: DataTypes.ENUM('payment', 'receipt', 'refund', 'adjustment'),
    defaultValue: 'payment',
    field: 'type',
  },
  
  // Payment Number
  paymentNumber: {
    type: DataTypes.STRING(50),
    field: 'payment_number',
  },
  
  // Date
  date: {
    type: DataTypes.DATEONLY,
    defaultValue: DataTypes.NOW,
    field: 'date',
  },
  
  // Nepali Date
  nepaliDate: {
    type: DataTypes.STRING(20),
    field: 'nepali_date',
  },
  
  // Amount
  amount: {
    type: DataTypes.DECIMAL(15, 2),
    defaultValue: 0,
    field: 'amount',
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
  
  // Payment Method
  method: {
    type: DataTypes.ENUM(
      'cash',
      'bank',
      'cheque',
      'online',
      'credit_card',
      'debit_card',
      'mobile_banking',
      'wallet',
      'other'
    ),
    defaultValue: 'cash',
    field: 'method',
  },
  
  // Bank Information
  bank: {
    type: DataTypes.STRING(100),
    field: 'bank',
  },
  branch: {
    type: DataTypes.STRING(100),
    field: 'branch',
  },
  accountNumber: {
    type: DataTypes.STRING(50),
    field: 'account_number',
  },
  
  // Cheque Information
  chequeNumber: {
    type: DataTypes.STRING(50),
    field: 'cheque_number',
  },
  chequeDate: {
    type: DataTypes.DATEONLY,
    field: 'cheque_date',
  },
  chequeStatus: {
    type: DataTypes.ENUM('pending', 'cleared', 'bounced', 'cancelled'),
    defaultValue: 'pending',
    field: 'cheque_status',
  },
  
  // Online Payment Information
  transactionReference: {
    type: DataTypes.STRING(255),
    field: 'transaction_reference',
  },
  paymentGateway: {
    type: DataTypes.STRING(50),
    field: 'payment_gateway',
  },
  
  // Card Information
  cardLastFour: {
    type: DataTypes.STRING(4),
    field: 'card_last_four',
  },
  cardType: {
    type: DataTypes.STRING(20),
    field: 'card_type',
  },
  
  // Wallet Information
  walletProvider: {
    type: DataTypes.STRING(50),
    field: 'wallet_provider',
  },
  walletTransactionId: {
    type: DataTypes.STRING(100),
    field: 'wallet_transaction_id',
  },
  
  // Status
  status: {
    type: DataTypes.ENUM('pending', 'completed', 'failed', 'cancelled', 'refunded'),
    defaultValue: 'completed',
    field: 'status',
  },
  
  // Reference Information
  referenceNumber: {
    type: DataTypes.STRING(100),
    field: 'reference_number',
  },
  invoiceNumber: {
    type: DataTypes.STRING(50),
    field: 'invoice_number',
  },
  
  // Notes
  notes: {
    type: DataTypes.TEXT,
    field: 'notes',
  },
  
  // IRD Compliance
  irdVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'ird_verified',
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
  tableName: 'payments',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'payments_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'payments_transaction_id_idx',
      fields: ['transaction_id'],
    },
    {
      name: 'payments_contact_id_idx',
      fields: ['contact_id'],
    },
    {
      name: 'payments_type_idx',
      fields: ['type'],
    },
    {
      name: 'payments_payment_number_idx',
      fields: ['payment_number'],
      unique: true,
      where: {
        payment_number: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'payments_date_idx',
      fields: ['date'],
    },
    {
      name: 'payments_status_idx',
      fields: ['status'],
    },
    {
      name: 'payments_method_idx',
      fields: ['method'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (payment, options) => {
      // Generate payment number if not provided
      if (!payment.paymentNumber) {
        const companyId = payment.companyId;
        const count = await Payment.count({ where: { companyId } });
        payment.paymentNumber = `PAY-${(count + 1).toString().padStart(6, '0')}`;
      }
      
      // Set invoice number from transaction if available
      if (payment.transactionId && !payment.invoiceNumber) {
        const transaction = await sequelize.models.Transaction.findByPk(payment.transactionId);
        if (transaction) {
          payment.invoiceNumber = transaction.transactionNumber;
        }
      }
    },
    
    afterCreate: async (payment, options) => {
      // Update transaction payment status if transaction exists
      if (payment.transactionId) {
        const transaction = await sequelize.models.Transaction.findByPk(payment.transactionId);
        if (transaction) {
          await transaction.updatePaymentStatus(payment.amount);
        }
      }
      
      // Update contact balance if contact exists
      if (payment.contactId) {
        const contact = await sequelize.models.Contact.findByPk(payment.contactId);
        if (contact) {
          await contact.updateBalance(
            payment.amount,
            payment.type === 'receipt' ? 'receipt' : 'payment'
          );
        }
      }
    },
    
    afterUpdate: async (payment, options) => {
      // Update transaction payment status if transaction exists and amount changed
      if (payment.changed('amount') && payment.transactionId) {
        const transaction = await sequelize.models.Transaction.findByPk(payment.transactionId);
        if (transaction) {
          await transaction.updatePaymentStatus();
        }
      }
    },
    
    afterDestroy: async (payment, options) => {
      // Update transaction payment status if transaction exists
      if (payment.transactionId) {
        const transaction = await sequelize.models.Transaction.findByPk(payment.transactionId);
        if (transaction) {
          await transaction.updatePaymentStatus(-payment.amount);
        }
      }
      
      // Update contact balance if contact exists
      if (payment.contactId) {
        const contact = await sequelize.models.Contact.findByPk(payment.contactId);
        if (contact) {
          await contact.updateBalance(
            -payment.amount,
            payment.type === 'receipt' ? 'receipt' : 'payment'
          );
        }
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
    byMethod: (method) => {
      return {
        where: { method, deletedAt: null },
      };
    },
    byTransaction: (transactionId) => {
      return {
        where: { transactionId, deletedAt: null },
        order: [['date', 'ASC'], ['created_at', 'ASC']],
      };
    },
    byContact: (contactId) => {
      return {
        where: { contactId, deletedAt: null },
        order: [['date', 'DESC'], ['created_at', 'DESC']],
      };
    },
    payments: {
      where: { type: 'payment', deletedAt: null },
    },
    receipts: {
      where: { type: 'receipt', deletedAt: null },
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
            { paymentNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { referenceNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { invoiceNumber: { [sequelize.Op.iLike]: `%${query}%` } },
            { notes: { [sequelize.Op.iLike]: `%${query}%` } },
            { transactionReference: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          companyId,
          deletedAt: null,
        },
      };
    },
  },
});

// Instance methods
Payment.prototype.getDisplayNumber = function() {
  return this.paymentNumber;
};

Payment.prototype.getTypeDisplay = function() {
  const types = {
    payment: 'Payment',
    receipt: 'Receipt',
    refund: 'Refund',
    adjustment: 'Adjustment',
  };
  return types[this.type] || this.type;
};

Payment.prototype.getMethodDisplay = function() {
  const methods = {
    cash: 'Cash',
    bank: 'Bank Transfer',
    cheque: 'Cheque',
    online: 'Online Payment',
    credit_card: 'Credit Card',
    debit_card: 'Debit Card',
    mobile_banking: 'Mobile Banking',
    wallet: 'Digital Wallet',
    other: 'Other',
  };
  return methods[this.method] || this.method;
};

Payment.prototype.getStatusDisplay = function() {
  const statuses = {
    pending: 'Pending',
    completed: 'Completed',
    failed: 'Failed',
    cancelled: 'Cancelled',
    refunded: 'Refunded',
  };
  return statuses[this.status] || this.status;
};

Payment.prototype.getChequeStatusDisplay = function() {
  const statuses = {
    pending: 'Pending',
    cleared: 'Cleared',
    bounced: 'Bounced',
    cancelled: 'Cancelled',
  };
  return statuses[this.chequeStatus] || this.chequeStatus;
};

Payment.prototype.isCleared = function() {
  if (this.method !== 'cheque') return this.status === 'completed';
  return this.chequeStatus === 'cleared';
};

Payment.prototype.cancel = async function() {
  await this.update({ status: 'cancelled' });
  
  // Update transaction payment status
  if (this.transactionId) {
    const transaction = await sequelize.models.Transaction.findByPk(this.transactionId);
    if (transaction) {
      await transaction.updatePaymentStatus(-this.amount);
    }
  }
  
  // Update contact balance
  if (this.contactId) {
    const contact = await sequelize.models.Contact.findByPk(this.contactId);
    if (contact) {
      await contact.updateBalance(
        -this.amount,
        this.type === 'receipt' ? 'receipt' : 'payment'
      );
    }
  }
  
  return this;
};

Payment.prototype.complete = async function() {
  await this.update({
    status: 'completed',
    chequeStatus: this.method === 'cheque' ? 'cleared' : this.chequeStatus,
  });
  
  return this;
};

// Class methods
Payment.getNextNumber = async function(companyId) {
  const count = await this.count({ where: { companyId } });
  return `PAY-${(count + 1).toString().padStart(6, '0')}`;
};

Payment.getTotalPayments = async function(companyId, startDate, endDate) {
  return this.sum('amount', {
    where: {
      companyId,
      type: 'payment',
      status: 'completed',
      date: {
        [sequelize.Op.gte]: startDate,
        [sequelize.Op.lte]: endDate,
      },
      deletedAt: null,
    },
  });
};

Payment.getTotalReceipts = async function(companyId, startDate, endDate) {
  return this.sum('amount', {
    where: {
      companyId,
      type: 'receipt',
      status: 'completed',
      date: {
        [sequelize.Op.gte]: startDate,
        [sequelize.Op.lte]: endDate,
      },
      deletedAt: null,
    },
  });
};

Payment.getOutstandingPayments = async function(companyId) {
  return this.sum('amount', {
    where: {
      companyId,
      type: 'payment',
      status: { [sequelize.Op.or]: ['pending', 'completed'] },
      chequeStatus: { [sequelize.Op.ne]: 'cleared' },
      deletedAt: null,
    },
  });
};

Payment.getOutstandingReceipts = async function(companyId) {
  return this.sum('amount', {
    where: {
      companyId,
      type: 'receipt',
      status: { [sequelize.Op.or]: ['pending', 'completed'] },
      deletedAt: null,
    },
  });
};

module.exports = Payment;
