/**
 * Product Model
 * Represents products and services in the inventory
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Product = sequelize.define('Product', {
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
    type: DataTypes.STRING(50),
    field: 'code',
  },
  barcode: {
    type: DataTypes.STRING(100),
    field: 'barcode',
  },
  qrCode: {
    type: DataTypes.STRING(255),
    field: 'qr_code',
  },
  
  // Names
  name: {
    type: DataTypes.STRING(255),
    allowNull: false,
    field: 'name',
  },
  nepaliName: {
    type: DataTypes.STRING(255),
    field: 'nepali_name',
  },
  shortName: {
    type: DataTypes.STRING(50),
    field: 'short_name',
  },
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  nepaliDescription: {
    type: DataTypes.TEXT,
    field: 'nepali_description',
  },
  
  // Category
  categoryId: {
    type: DataTypes.UUID,
    field: 'category_id',
    references: {
      model: 'categories',
      key: 'id',
    },
  },
  
  // Brand
  brandId: {
    type: DataTypes.UUID,
    field: 'brand_id',
    references: {
      model: 'brands',
      key: 'id',
    },
  },
  
  // Unit
  unitId: {
    type: DataTypes.UUID,
    field: 'unit_id',
    references: {
      model: 'units',
      key: 'id',
    },
  },
  
  // Product Type
  type: {
    type: DataTypes.ENUM('product', 'service', 'raw_material', 'finished_good', 'other'),
    defaultValue: 'product',
    field: 'type',
  },
  
  // Inventory Tracking
  trackInventory: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'track_inventory',
  },
  
  // Quantity
  quantity: {
    type: DataTypes.DECIMAL(10, 3),
    defaultValue: 0,
    field: 'quantity',
  },
  minimumQuantity: {
    type: DataTypes.DECIMAL(10, 3),
    defaultValue: 0,
    field: 'minimum_quantity',
  },
  
  // Pricing
  costPrice: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'cost_price',
  },
  purchasePrice: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'purchase_price',
  },
  salePrice: {
    type: DataTypes.DECIMAL(12, 2),
    defaultValue: 0,
    field: 'sale_price',
  },
  wholesalePrice: {
    type: DataTypes.DECIMAL(12, 2),
    field: 'wholesale_price',
  },
  mrp: {
    type: DataTypes.DECIMAL(12, 2),
    field: 'mrp',
  },
  
  // Price includes tax
  priceIncludesTax: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'price_includes_tax',
  },
  
  // Tax
  taxRateId: {
    type: DataTypes.UUID,
    field: 'tax_rate_id',
    references: {
      model: 'tax_rates',
      key: 'id',
    },
  },
  taxable: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'taxable',
  },
  
  // Weight and Dimensions
  weight: {
    type: DataTypes.DECIMAL(10, 3),
    field: 'weight',
  },
  weightUnit: {
    type: DataTypes.STRING(20),
    field: 'weight_unit',
  },
  
  // Images
  image: {
    type: DataTypes.STRING(255),
    field: 'image',
  },
  images: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    field: 'images',
  },
  
  // Status
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'is_active',
  },
  isFeatured: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'is_featured',
  },
  
  // SKU and Variations
  sku: {
    type: DataTypes.STRING(100),
    field: 'sku',
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
  tableName: 'products',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'products_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'products_code_idx',
      fields: ['code'],
      unique: true,
      where: {
        code: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'products_barcode_idx',
      fields: ['barcode'],
      unique: true,
      where: {
        barcode: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'products_name_idx',
      fields: ['name'],
    },
    {
      name: 'products_category_id_idx',
      fields: ['category_id'],
    },
    {
      name: 'products_brand_id_idx',
      fields: ['brand_id'],
    },
    {
      name: 'products_is_active_idx',
      fields: ['is_active'],
    },
    {
      name: 'products_track_inventory_idx',
      fields: ['track_inventory'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (product, options) => {
      // Ensure Nepali name is set if not provided
      if (!product.nepaliName && product.name) {
        product.nepaliName = product.name;
      }
      
      // Generate code if not provided
      if (!product.code) {
        const companyId = product.companyId;
        const count = await Product.count({ where: { companyId } });
        product.code = `PROD-${(count + 1).toString().padStart(6, '0')}`;
      }
    },
    
    beforeUpdate: async (product, options) => {
      // Update Nepali name if name is changed
      if (product.changed('name') && !product.nepaliName) {
        product.nepaliName = product.name;
      }
    },
  },
  
  // Scopes
  scopes: {
    active: {
      where: { isActive: true, deletedAt: null },
    },
    byCategory: (categoryId) => {
      return {
        where: { categoryId, deletedAt: null },
      };
    },
    byBrand: (brandId) => {
      return {
        where: { brandId, deletedAt: null },
      };
    },
    trackable: {
      where: { trackInventory: true, deletedAt: null },
    },
    search: (query, companyId) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { name: { [sequelize.Op.iLike]: `%${query}%` } },
            { nepaliName: { [sequelize.Op.iLike]: `%${query}%` } },
            { code: { [sequelize.Op.iLike]: `%${query}%` } },
            { barcode: { [sequelize.Op.iLike]: `%${query}%` } },
            { sku: { [sequelize.Op.iLike]: `%${query}%` } },
            { description: { [sequelize.Op.iLike]: `%${query}%` } },
          ],
          companyId,
          deletedAt: null,
        },
      };
    },
    lowStock: (minQuantity = 5) => {
      return {
        where: {
          trackInventory: true,
          quantity: { [sequelize.Op.lte]: minQuantity },
          deletedAt: null,
        },
      };
    },
    outOfStock: {
      where: {
        trackInventory: true,
        quantity: 0,
        deletedAt: null,
      },
    },
  },
});

// Class methods
Product.getTotalCount = async function(companyId) {
  return this.count({
    where: { companyId, deletedAt: null },
  });
};

Product.getTotalValue = async function(companyId) {
  const result = await this.sum('salePrice', {
    where: { companyId, deletedAt: null },
  });
  return result || 0;
};

Product.getLowStockCount = async function(companyId, minQuantity = 5) {
  return this.count({
    where: {
      companyId,
      trackInventory: true,
      quantity: { [sequelize.Op.lte]: minQuantity },
      deletedAt: null,
    },
  });
};

Product.getOutOfStockCount = async function(companyId) {
  return this.count({
    where: {
      companyId,
      trackInventory: true,
      quantity: 0,
      deletedAt: null,
    },
  });
};

// Instance methods
Product.prototype.getStockStatus = function() {
  if (!this.trackInventory) return 'Not Tracked';
  if (this.quantity <= 0) return 'Out of Stock';
  if (this.quantity <= this.minimumQuantity) return 'Low Stock';
  return 'In Stock';
};

Product.prototype.getStockStatusColor = function() {
  if (!this.trackInventory) return 'gray';
  if (this.quantity <= 0) return 'red';
  if (this.quantity <= this.minimumQuantity) return 'orange';
  return 'green';
};

Product.prototype.getProfitMargin = function() {
  if (!this.costPrice || this.costPrice === 0) return 0;
  return ((this.salePrice - this.costPrice) / this.costPrice) * 100;
};

Product.prototype.getDisplayPrice = function() {
  return this.salePrice || this.purchasePrice || this.costPrice || 0;
};

Product.prototype.getProductTypeDisplay = function() {
  const types = {
    product: 'Product',
    service: 'Service',
    raw_material: 'Raw Material',
    finished_good: 'Finished Good',
    other: 'Other',
  };
  return types[this.type] || this.type;
};

Product.prototype.adjustStock = async function(quantity, type = 'out') {
  // type: 'in' or 'out'
  const multiplier = type === 'in' ? 1 : -1;
  const newQuantity = (this.quantity || 0) + (quantity * multiplier);
  
  if (newQuantity < 0) {
    throw new Error('Insufficient stock');
  }
  
  await this.update({ quantity: newQuantity });
  return this;
};

Product.prototype.updatePrices = async function({ costPrice, purchasePrice, salePrice, wholesalePrice, mrp }) {
  const updates = {};
  
  if (costPrice !== undefined) updates.costPrice = costPrice;
  if (purchasePrice !== undefined) updates.purchasePrice = purchasePrice;
  if (salePrice !== undefined) updates.salePrice = salePrice;
  if (wholesalePrice !== undefined) updates.wholesalePrice = wholesalePrice;
  if (mrp !== undefined) updates.mrp = mrp;
  
  await this.update(updates);
  return this;
};

module.exports = Product;
