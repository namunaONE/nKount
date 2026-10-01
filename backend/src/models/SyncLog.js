/**
 * SyncLog Model
 * Tracks synchronization between local and server data
 */

const { DataTypes } = require('sequelize');
const { sequelize } = require('../database/connection');

const SyncLog = sequelize.define('SyncLog', {
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
  
  // Sync Type
  type: {
    type: DataTypes.ENUM('full', 'partial', 'manual', 'automatic'),
    defaultValue: 'automatic',
    field: 'type',
  },
  
  // Entity Type
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
      'all'
    ),
    field: 'entity_type',
  },
  
  // Entity ID
  entityId: {
    type: DataTypes.UUID,
    field: 'entity_id',
  },
  
  // Action
  action: {
    type: DataTypes.ENUM('create', 'read', 'update', 'delete', 'sync'),
    field: 'action',
  },
  
  // Direction
  direction: {
    type: DataTypes.ENUM('push', 'pull', 'both'),
    field: 'direction',
  },
  
  // Status
  status: {
    type: DataTypes.ENUM('pending', 'in_progress', 'completed', 'failed', 'conflict'),
    defaultValue: 'pending',
    field: 'status',
  },
  
  // Data
  localData: {
    type: DataTypes.JSONB,
    field: 'local_data',
  },
  serverData: {
    type: DataTypes.JSONB,
    field: 'server_data',
  },
  mergedData: {
    type: DataTypes.JSONB,
    field: 'merged_data',
  },
  
  // Timestamps
  localTimestamp: {
    type: DataTypes.DATE,
    field: 'local_timestamp',
  },
  serverTimestamp: {
    type: DataTypes.DATE,
    field: 'server_timestamp',
  },
  
  // Error Information
  error: {
    type: DataTypes.TEXT,
    field: 'error',
  },
  errorCode: {
    type: DataTypes.STRING(100),
    field: 'error_code',
  },
  
  // Retry Count
  retryCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    field: 'retry_count',
  },
  
  // Conflict Resolution
  conflictResolved: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    field: 'conflict_resolved',
  },
  conflictResolution: {
    type: DataTypes.ENUM('server_wins', 'client_wins', 'manual', 'merged'),
    field: 'conflict_resolution',
  },
  
  // Batch Information
  batchId: {
    type: DataTypes.UUID,
    field: 'batch_id',
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
  tableName: 'sync_logs',
  underscored: true,
  timestamps: true,
  paranoid: true,
  
  // Indexes
  indexes: [
    {
      name: 'sync_logs_company_id_idx',
      fields: ['company_id'],
    },
    {
      name: 'sync_logs_entity_type_idx',
      fields: ['entity_type'],
    },
    {
      name: 'sync_logs_entity_id_idx',
      fields: ['entity_id'],
    },
    {
      name: 'sync_logs_status_idx',
      fields: ['status'],
    },
    {
      name: 'sync_logs_action_idx',
      fields: ['action'],
    },
    {
      name: 'sync_logs_batch_id_idx',
      fields: ['batch_id'],
    },
    {
      name: 'sync_logs_created_at_idx',
      fields: ['created_at'],
    },
  ],
  
  // Scopes
  scopes: {
    pending: {
      where: { status: 'pending', deletedAt: null },
      order: [['created_at', 'ASC']],
    },
    failed: {
      where: { status: 'failed', deletedAt: null },
      order: [['created_at', 'ASC']],
    },
    conflicts: {
      where: { status: 'conflict', deletedAt: null },
      order: [['created_at', 'ASC']],
    },
    byBatch: (batchId) => {
      return {
        where: { batchId, deletedAt: null },
        order: [['created_at', 'ASC']],
      };
    },
    byEntity: (entityType, entityId) => {
      return {
        where: { entityType, entityId, deletedAt: null },
        order: [['created_at', 'ASC']],
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
  },
});

// Instance methods
SyncLog.prototype.markCompleted = async function() {
  await this.update({
    status: 'completed',
    conflictResolved: true,
  });
  return this;
};

SyncLog.prototype.markFailed = async function(error, errorCode) {
  await this.update({
    status: 'failed',
    error,
    errorCode,
    retryCount: this.retryCount + 1,
  });
  return this;
};

SyncLog.prototype.markConflict = async function() {
  await this.update({
    status: 'conflict',
    conflictResolved: false,
  });
  return this;
};

SyncLog.prototype.resolveConflict = async function(resolution, mergedData = null) {
  await this.update({
    status: 'completed',
    conflictResolved: true,
    conflictResolution: resolution,
    mergedData,
  });
  return this;
};

// Class methods
SyncLog.getPendingCount = async function(companyId) {
  return this.count({
    where: { companyId, status: 'pending', deletedAt: null },
  });
};

SyncLog.getFailedCount = async function(companyId) {
  return this.count({
    where: { companyId, status: 'failed', deletedAt: null },
  });
};

SyncLog.getConflictCount = async function(companyId) {
  return this.count({
    where: { companyId, status: 'conflict', deletedAt: null },
  });
};

SyncLog.getLastSyncTime = async function(companyId) {
  const log = await this.findOne({
    where: { companyId, status: 'completed', deletedAt: null },
    order: [['created_at', 'DESC']],
  });
  
  return log?.createdAt || null;
};

SyncLog.getBatch = async function(batchId) {
  return this.findAll({
    where: { batchId, deletedAt: null },
    order: [['created_at', 'ASC']],
  });
};

SyncLog.createBatch = async function(companyId, type = 'automatic') {
  const batchId = DataTypes.UUIDV4();
  
  return {
    batchId,
    companyId,
    type,
    createdAt: new Date(),
  };
};

module.exports = SyncLog;
