/**
 * Unit Model
 * Represents units of measurement for products
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const Unit = sequelize.define('Unit', {
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
    type: DataTypes.STRING(10),
    field: 'code',
  },
  name: {
    type: DataTypes.STRING(50),
    allowNull: false,
    field: 'name',
  },
  nepaliName: {
    type: DataTypes.STRING(50),
    field: 'nepali_name',
  },
  
  // Short Name
  shortName: {
    type: DataTypes.STRING(10),
    field: 'short_name',
  },
  
  // Unit Type
  type: {
    type: DataTypes.ENUM('weight', 'volume', 'length', 'area', 'count', 'time', 'other'),
    defaultValue: 'count',
    field: 'type',
  },
  
  // Conversion Factor (to base unit)
  conversionFactor: {
    type: DataTypes.DECIMAL(10, 6),
    defaultValue: 1,
    field: 'conversion_factor',
  },
  
  // Base Unit (for conversion)
  baseUnitId: {
    type: DataTypes.UUID,
    field: 'base_unit_id',
    references: {
      model: 'units',
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
  tableName: 'units',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'units_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'units_code_idx',
      fields: ['code'],
      unique: true,
      where: {
        code: { [sequelize.Op.ne]: null },
        company_id: { [sequelize.Op.ne]: null },
      },
    },
    {
      name: 'units_name_idx',
      fields: ['name'],
    },
    {
      name: 'units_type_idx',
      fields: ['type'],
    },
    {
      name: 'units_is_active_idx',
      fields: ['is_active'],
    },
  ],
  
  // Hooks
  hooks: {
    beforeCreate: async (unit, options) => {
      // Ensure Nepali name is set if not provided
      if (!unit.nepaliName && unit.name) {
        unit.nepaliName = unit.name;
      }
      
      // Generate code if not provided
      if (!unit.code) {
        const companyId = unit.companyId;
        const count = await Unit.count({ where: { companyId } });
        unit.code = `UNIT-${(count + 1).toString().padStart(4, '0')}`;
      }
      
      // Set display order if not provided
      if (!unit.displayOrder) {
        const count = await Unit.count({ where: { companyId: unit.companyId } });
        unit.displayOrder = count + 1;
      }
    },
    
    beforeUpdate: async (unit, options) => {
      // Update Nepali name if name is changed
      if (unit.changed('name') && !unit.nepaliName) {
        unit.nepaliName = unit.name;
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
    byType: (type) => {
      return {
        where: { type, deletedAt: null },
        order: [['display_order', 'ASC'], ['name', 'ASC']],
      };
    },
    search: (query, companyId) => {
      return {
        where: {
          [sequelize.Op.or]: [
            { name: { [sequelize.Op.iLike]: `%${query}%` } },
            { nepaliName: { [sequelize.Op.iLike]: `%${query}%` } },
            { shortName: { [sequelize.Op.iLike]: `%${query}%` } },
            { code: { [sequelize.Op.iLike]: `%${query}%` } },
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
Unit.prototype.getDisplayName = function() {
  return this.nepaliName || this.name;
};

Unit.prototype.getProductCount = async function() {
  return sequelize.models.Product.count({
    where: { unitId: this.id, deletedAt: null },
  });
};

Unit.prototype.convertToBase = function(value) {
  return value * (this.conversionFactor || 1);
};

Unit.prototype.convertFromBase = function(value) {
  return value / (this.conversionFactor || 1);
};

// Class methods
Unit.getCommonUnits = async function(companyId) {
  return this.findAll({
    where: { companyId, deletedAt: null },
    order: [['display_order', 'ASC'], ['name', 'ASC']],
    limit: 20,
  });
};

Unit.getNextDisplayOrder = async function(companyId) {
  const count = await this.count({
    where: { companyId, deletedAt: null },
  });
  return count + 1;
};

// Predefined units for Nepal
Unit.predefinedUnits = [
  { code: 'PCS', name: 'Piece', nepaliName: 'वटा', shortName: 'pcs', type: 'count', conversionFactor: 1 },
  { code: 'KG', name: 'Kilogram', nepaliName: 'किलोग्राम', shortName: 'kg', type: 'weight', conversionFactor: 1 },
  { code: 'GM', name: 'Gram', nepaliName: 'ग्राम', shortName: 'gm', type: 'weight', conversionFactor: 0.001 },
  { code: 'LTR', name: 'Litre', nepaliName: 'लीटर', shortName: 'ltr', type: 'volume', conversionFactor: 1 },
  { code: 'ML', name: 'Millilitre', nepaliName: 'मिलिलिटर', shortName: 'ml', type: 'volume', conversionFactor: 0.001 },
  { code: 'MTR', name: 'Metre', nepaliName: 'मिटर', shortName: 'm', type: 'length', conversionFactor: 1 },
  { code: 'CM', name: 'Centimetre', nepaliName: 'सेन्टिमिटर', shortName: 'cm', type: 'length', conversionFactor: 0.01 },
  { code: 'MM', name: 'Millimetre', nepaliName: 'मिलिमिटर', shortName: 'mm', type: 'length', conversionFactor: 0.001 },
  { code: 'SQM', name: 'Square Metre', nepaliName: 'वर्ग मिटर', shortName: 'sqm', type: 'area', conversionFactor: 1 },
  { code: 'BOX', name: 'Box', nepaliName: 'बक्स', shortName: 'box', type: 'count', conversionFactor: 1 },
  { code: 'PACK', name: 'Pack', nepaliName: 'प्याक', shortName: 'pack', type: 'count', conversionFactor: 1 },
  { code: 'DOZEN', name: 'Dozen', nepaliName: 'डजन', shortName: 'dozen', type: 'count', conversionFactor: 12 },
  { code: 'GROSS', name: 'Gross', nepaliName: 'ग्रस', shortName: 'gross', type: 'count', conversionFactor: 144 },
];

module.exports = Unit;
