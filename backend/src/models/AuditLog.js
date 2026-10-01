/**
 * AuditLog Model
 * Tracks all changes to data for audit purposes
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const AuditLog = sequelize.define('AuditLog', {
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
  
  // User who performed the action
  userId: {
    type: DataTypes.UUID,
    field: 'user_id',
  },
  userName: {
    type: DataTypes.STRING(100),
    field: 'user_name',
  },
  userEmail: {
    type: DataTypes.STRING(255),
    field: 'user_email',
  },
  
  // Entity Information
  entityType: {
    type: DataTypes.ENUM(
      'company',
      'contact',
      'product',
      'category',
      'brand',
      'unit',
      'tax_rate',
      'transaction',
      'transaction_item',
      'payment',
      'setting',
      'user'
    ),
    allowNull: false,
    field: 'entity_type',
  },
  entityId: {
    type: DataTypes.UUID,
    field: 'entity_id',
  },
  
  // Action
  action: {
    type: DataTypes.ENUM('create', 'read', 'update', 'delete', 'export', 'import'),
    allowNull: false,
    field: 'action',
  },
  
  // Changes
  oldValues: {
    type: DataTypes.JSONB,
    field: 'old_values',
  },
  newValues: {
    type: DataTypes.JSONB,
    field: 'new_values',
  },
  
  // Description
  description: {
    type: DataTypes.TEXT,
    field: 'description',
  },
  
  // IP Address
  ipAddress: {
    type: DataTypes.STRING(50),
    field: 'ip_address',
  },
  
  // User Agent
  userAgent: {
    type: DataTypes.TEXT,
    field: 'user_agent',
  },
  
  // Device Information
  deviceId: {
    type: DataTypes.STRING(100),
    field: 'device_id',
  },
  deviceName: {
    type: DataTypes.STRING(100),
    field: 'device_name',
  },
  
  // Location
  location: {
    type: DataTypes.TEXT,
    field: 'location',
  },
  
  // Metadata
  metadata: {
    type: DataTypes.JSONB,
    field: 'metadata',
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
  tableName: 'audit_logs',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'audit_logs_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'audit_logs_entity_type_idx',
      fields: ['entity_type'],
    },
    {
      name: 'audit_logs_entity_id_idx',
      fields: ['entity_id'],
    },
    {
      name: 'audit_logs_action_idx',
      fields: ['action'],
    },
    {
      name: 'audit_logs_user_id_idx',
      fields: ['user_id'],
    },
    {
      name: 'audit_logs_created_at_idx',
      fields: ['created_at'],
    },
  ],
  
  // Scopes
  scopes: {
    byCompany: (companyId) => {
      return {
        where: { companyId, deletedAt: null },
        order: [['created_at', 'DESC']],
      };
    },
    byEntity: (entityType, entityId) => {
      return {
        where: { entityType, entityId, deletedAt: null },
        order: [['created_at', 'DESC']],
      };
    },
    byUser: (userId) => {
      return {
        where: { userId, deletedAt: null },
        order: [['created_at', 'DESC']],
      };
    },
    byAction: (action) => {
      return {
        where: { action, deletedAt: null },
        order: [['created_at', 'DESC']],
      };
    },
    recent: {
      where: {
        createdAt: { [sequelize.Op.gte]: new Date(Date.now() - 24 * 60 * 60 * 1000) },
        deletedAt: null,
      },
      order: [['created_at', 'DESC']],
      limit: 100,
    },
    dateRange: (startDate, endDate) => {
      return {
        where: {
          createdAt: {
            [sequelize.Op.gte]: startDate,
            [sequelize.Op.lte]: endDate,
          },
          deletedAt: null,
        },
        order: [['created_at', 'DESC']],
      };
    },
  },
});

// Instance methods
AuditLog.prototype.getDisplayMessage = function() {
  const actionDisplay = {
    create: 'Created',
    read: 'Viewed',
    update: 'Updated',
    delete: 'Deleted',
    export: 'Exported',
    import: 'Imported',
  };
  
  const entityDisplay = {
    company: 'Company',
    contact: 'Contact',
    product: 'Product',
    category: 'Category',
    brand: 'Brand',
    unit: 'Unit',
    tax_rate: 'Tax Rate',
    transaction: 'Transaction',
    transaction_item: 'Transaction Item',
    payment: 'Payment',
    setting: 'Setting',
    user: 'User',
  };
  
  const action = actionDisplay[this.action] || this.action;
  const entity = entityDisplay[this.entityType] || this.entityType;
  
  return `${this.userName || 'Unknown'} ${action} ${entity} ${this.entityId || ''}`;
};

AuditLog.prototype.getChangesSummary = function() {
  const changes = {};
  
  if (this.oldValues && this.newValues) {
    for (const key in this.newValues) {
      if (this.oldValues[key] !== this.newValues[key]) {
        changes[key] = {
          old: this.oldValues[key],
          new: this.newValues[key],
        };
      }
    }
  }
  
  return changes;
};

// Class methods
AuditLog.log = async function(data) {
  const {
    companyId,
    userId,
    userName,
    userEmail,
    entityType,
    entityId,
    action,
    oldValues,
    newValues,
    description,
    ipAddress,
    userAgent,
    deviceId,
    deviceName,
    location,
    metadata,
  } = data;
  
  return this.create({
    companyId,
    userId,
    userName,
    userEmail,
    entityType,
    entityId,
    action,
    oldValues,
    newValues,
    description,
    ipAddress,
    userAgent,
    deviceId,
    deviceName,
    location,
    metadata,
  });
};

AuditLog.getChangesForEntity = async function(entityType, entityId) {
  return this.findAll({
    where: { entityType, entityId, deletedAt: null },
    order: [['created_at', 'DESC']],
  });
};

AuditLog.getTotalChanges = async function(companyId, entityType, action) {
  const where = { companyId, deletedAt: null };
  
  if (entityType) where.entityType = entityType;
  if (action) where.action = action;
  
  return this.count({ where });
};

AuditLog.getMostChangedEntities = async function(companyId, limit = 10) {
  const results = await sequelize.query(
    `SELECT entity_type, entity_id, COUNT(*) as change_count 
     FROM audit_logs 
     WHERE company_id = :companyId AND deleted_at IS NULL 
     GROUP BY entity_type, entity_id 
     ORDER BY change_count DESC 
     LIMIT :limit`,
    {
      replacements: { companyId, limit },
      type: sequelize.QueryTypes.SELECT,
    }
  );
  
  return results;
};

module.exports = AuditLog;
