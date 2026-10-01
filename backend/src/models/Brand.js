/**
 * Brand Model
 * Represents product brands/manufacturers
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Brand = sequelize.define('Brand', {
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
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  
  // Logo
  logo: {
    type: DataTypes.STRING(255),
    field: 'logo',
  },
  
  // Website
  website: {
    type: DataTypes.STRING(255),
    field: 'website',
  },
  
  // Contact Information
  phone: {
    type: DataTypes.STRING(20),
    field: 'phone',
  },
  email: {
    type: DataTypes.STRING(255),
    validate: {
      isEmail: true,
    },
    field: 'email',
  },
  
  // Address
  address: {
    type: DataTypes.TEXT,
    field: 'address',
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
  tableName: 'brands',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'brands_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'brands_code_idx',
      fields: ['code'],
      unique: true,
      where: {
        code: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'brands_name_idx',
      fields: ['name'],
    },
    {
      name: 'brands_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (brand, options) => {
      // Ensure Nepali name is set if not provided
      if (!brand.nepaliName && brand.name) {
        brand.nepaliName = brand.name;
      }
      
      // Generate code if not provided
      if (!brand.code) {
        const companyId = brand.companyId;
        const count = await Brand.count({ where: { companyId } });
        brand.code = `BRAND-${(count + 1).toString().padStart(4, '0')}`;
      }
      
      // Set display order if not provided
      if (!brand.displayOrder) {
        const count = await Brand.count({ where: { companyId: brand.companyId } });
        brand.displayOrder = count + 1;
      }
    },
    
    beforeUpdate: async (brand, options) => {
      // Update Nepali name if name is changed
      if (brand.changed('name') && !brand.nepaliName) {
        brand.nepaliName = brand.name;
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
Brand.prototype.getProductCount = async function() {
  return sequelize.models.Product.count({
    where: { brandId: this.id, deletedAt: null },
  });
};

Brand.prototype.getDisplayName = function() {
  return this.nepaliName || this.name;
};

// Class methods
Brand.getNextDisplayOrder = async function(companyId) {
  const count = await this.count({
    where: { companyId, deletedAt: null },
  });
  return count + 1;
};

module.exports = Brand;
