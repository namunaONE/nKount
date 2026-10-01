/**
 * Category Model
 * Represents product categories for organization
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Category = sequelize.define('Category', {
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
  
  // Parent Category (for hierarchical categories)
  parentId: {
    type: DataTypes.UUID,
    field: 'parent_id',
    references: {
      model: 'categories',
      key: 'id',
    },
    onDelete: 'SET NULL',
  },
  
  // Display Order
  displayOrder: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    field: 'display_order',
  },
  
  // Color for visual identification
  color: {
    type: DataTypes.STRING(20),
    field: 'color',
  },
  
  // Icon
  icon: {
    type: DataTypes.STRING(50),
    field: 'icon',
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
  tableName: 'categories',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'categories_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'categories_parent_id_idx',
      fields: ['parent_id'],
    },
    {
      name: 'categories_code_idx',
      fields: ['code'],
      unique: true,
      where: {
        code: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'categories_name_idx',
      fields: ['name'],
    },
    {
      name: 'categories_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (category, options) => {
      // Ensure Nepali name is set if not provided
      if (!category.nepaliName && category.name) {
        category.nepaliName = category.name;
      }
      
      // Generate code if not provided
      if (!category.code) {
        const companyId = category.companyId;
        const count = await Category.count({ where: { companyId } });
        category.code = `CAT-${(count + 1).toString().padStart(4, '0')}`;
      }
      
      // Set display order if not provided
      if (!category.displayOrder) {
        const count = await Category.count({ where: { companyId: category.companyId } });
        category.displayOrder = count + 1;
      }
    },
    
    beforeUpdate: async (category, options) => {
      // Update Nepali name if name is changed
      if (category.changed('name') && !category.nepaliName) {
        category.nepaliName = category.name;
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
    root: {
      where: { parentId: null, deletedAt: null },
    },
    byParent: (parentId) => {
      return {
        where: { parentId, deletedAt: null },
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
Category.prototype.getFullPath = async function() {
  const parts = [];
  let current = this;
  
  while (current) {
    parts.unshift(current.name);
    if (current.parentId) {
      current = await Category.findByPk(current.parentId);
    } else {
      current = null;
    }
  }
  
  return parts.join(' / ');
};

Category.prototype.getChildren = async function() {
  return Category.findAll({
    where: { parentId: this.id, deletedAt: null },
    order: [['display_order', 'ASC'], ['name', 'ASC']],
  });
};

Category.prototype.hasChildren = async function() {
  const count = await Category.count({
    where: { parentId: this.id, deletedAt: null },
  });
  return count > 0;
};

Category.prototype.getProductCount = async function() {
  return sequelize.models.Product.count({
    where: { categoryId: this.id, deletedAt: null },
  });
};

// Class methods
Category.getRootCategories = async function(companyId) {
  return this.findAll({
    where: { companyId, parentId: null, deletedAt: null },
    order: [['display_order', 'ASC'], ['name', 'ASC']],
  });
};

Category.getAllWithHierarchy = async function(companyId, parentId = null, level = 0) {
  const categories = await this.findAll({
    where: { companyId, parentId, deletedAt: null },
    order: [['display_order', 'ASC'], ['name', 'ASC']],
  });
  
  const withHierarchy = [];
  
  for (const category of categories) {
    const children = await this.getAllWithHierarchy(companyId, category.id, level + 1);
    withHierarchy.push({
      ...category.toJSON(),
      level,
      children,
    });
  }
  
  return withHierarchy;
};

Category.getNextDisplayOrder = async function(companyId, parentId = null) {
  const count = await this.count({
    where: { companyId, parentId, deletedAt: null },
  });
  return count + 1;
};

module.exports = Category;
