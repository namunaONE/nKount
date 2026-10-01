/**
 * TransactionItem Model
 * Represents individual items within a transaction (invoice, purchase order, etc.)
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const TransactionItem = sequelize.define('TransactionItem', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
    allowNull: false,
  },
  
  // Transaction relationship
  transactionId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'transaction_id',
    references: {
      model: 'transactions',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  
  // Product relationship
  productId: {
    type: DataTypes.UUID,
    field: 'product_id',
    references: {
      model: 'products',
      key: 'id',
    },
    onDelete: 'SET NULL',
  },
  
  // Line Number (for ordering within transaction)
  lineNumber: {
    type: DataTypes.INTEGER,
    field: 'line_number',
  },
  
  // Product Information (denormalized for history)
  productCode: {
    type: DataTypes.STRING(50),
    field: 'product_code',
  },
  productName: {
    type: DataTypes.STRING(255),
    field: 'product_name',
  },
  productBarcode: {
    type: DataTypes.STRING(100),
    field: 'product_barcode',
  },
  
  // Quantity
  quantity: {
    type: DataTypes.DECIMAL(10, 3),
    defaultValue: 1,
    field: 'quantity',
  },
  
  // Unit
  unit: {
    type: DataTypes.STRING(20),
    field: 'unit',
  },
  
  // Pricing
  unitPrice: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'unit_price',
  },
  costPrice: {
    type: DataTypes.DECIMAL(12, 2),
    field: 'cost_price',
  },
  
  // Discount
  discount: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'discount',
  },
  discountType: {
    type: DataTypes.ENUM('percentage', 'fixed'),
    defaultValue: 'percentage',
    field: 'discount_type',
  },
  
  // Tax
  taxRate: {
    type: DataTypes.DECIMAL(5, 2),
    defaultValue: 0,
    field: 'tax_rate',
  },
  taxAmount: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'tax_amount',
  },
  
  // Calculated Fields
  subtotal: {
    type: DataTypes.VIRTUAL,
    get() {
      return this.calculateSubtotal();
    },
  },
  total: {
    type: DataTypes.VIRTUAL,
    get() {
      return this.calculateTotal();
    },
  },
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  
  // Notes
  notes: {
    type: DataTypes.TEXT,
    field: 'notes',
  },
  
  // Serial/Lot Numbers
  serialNumbers: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    field: 'serial_numbers',
  },
  
  // Batch Information
  batchNumber: {
    type: DataTypes.STRING(50),
    field: 'batch_number',
  },
  expiryDate: {
    type: DataTypes.DATEONLY,
    field: 'expiry_date',
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
  tableName: 'transaction_items',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'transaction_items_transaction_id_idx',
      fields: ['transaction_id'],
    },
    {
      name: 'transaction_items_product_id_idx',
      fields: ['product_id'],
    },
    {
      name: 'transaction_items_line_number_idx',
      fields: ['transaction_id', 'line_number'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (item, options) => {
      // Set line number if not provided
      if (!item.lineNumber) {
        const count = await TransactionItem.count({
          where: { transactionId: item.transactionId }
        });
        item.lineNumber = count + 1;
      }
      
      // Calculate and set tax amount
      if (item.taxRate && item.unitPrice && item.quantity) {
        const subtotal = item.calculateSubtotal();
        item.taxAmount = subtotal * (item.taxRate / 100);
      }
    },
    
    beforeUpdate: async (item, options) => {
      // Recalculate tax amount if tax rate, unit price, or quantity changed
      if (
        item.changed('taxRate') ||
        item.changed('unitPrice') ||
        item.changed('quantity')
      ) {
        const subtotal = item.calculateSubtotal();
        item.taxAmount = subtotal * (item.taxRate / 100);
      }
    },
  },
  
  // Scopes
  scopes: {
    active: {
      where: { deletedAt: null },
    },
    byTransaction: (transactionId) => {
      return {
        where: { transactionId, deletedAt: null },
        order: [['line_number', 'ASC']],
      };
    },
    byProduct: (productId) => {
      return {
        where: { productId, deletedAt: null },
      };
    },
  },
});

// Instance methods
TransactionItem.prototype.calculateSubtotal = function() {
  const quantity = this.quantity || 0;
  const unitPrice = this.unitPrice || 0;
  
  // Apply discount
  let subtotal = quantity * unitPrice;
  
  if (this.discount && this.discount > 0) {
    if (this.discountType === 'percentage') {
      subtotal -= subtotal * (this.discount / 100);
    } else {
      subtotal -= this.discount * quantity;
    }
  }
  
  return subtotal;
};

TransactionItem.prototype.calculateTotal = function() {
  const subtotal = this.calculateSubtotal();
  const taxAmount = this.taxAmount || (subtotal * (this.taxRate || 0) / 100);
  
  return subtotal + taxAmount;
};

TransactionItem.prototype.getDisplayName = function() {
  return this.productName || this.productCode || `Item ${this.lineNumber || ''}`;
};

TransactionItem.prototype.getProfit = function() {
  const cost = this.costPrice || 0;
  const sellingPrice = this.unitPrice || 0;
  const quantity = this.quantity || 0;
  
  return (sellingPrice - cost) * quantity;
};

TransactionItem.prototype.getProfitMargin = function() {
  const cost = this.costPrice || 0;
  const sellingPrice = this.unitPrice || 0;
  
  if (cost === 0) return 0;
  return ((sellingPrice - cost) / cost) * 100;
};

// Class methods
TransactionItem.getItemsByTransaction = async function(transactionId) {
  return this.findAll({
    where: { transactionId, deletedAt: null },
    order: [['line_number', 'ASC']],
  });
};

TransactionItem.getTotalQuantity = async function(transactionId, productId) {
  return this.sum('quantity', {
    where: { transactionId, productId, deletedAt: null },
  });
};

TransactionItem.getTotalValue = async function(transactionId) {
  const items = await this.findAll({
    where: { transactionId, deletedAt: null },
    attributes: ['quantity', 'unitPrice', 'discount', 'discountType', 'taxAmount'],
  });
  
  let total = 0;
  items.forEach(item => {
    total += item.calculateTotal();
  });
  
  return total;
};

module.exports = TransactionItem;
