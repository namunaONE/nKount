/**
 * Company Service
 * Business logic for company operations
 */

const { Company, Contact, Product, Transaction, Payment, Setting, TaxRate, Unit, Category, Brand } = require('../models');
const AuditLog = require('../models/AuditLog');
const config = require('../config/env');
const { createLogger } = require('winston');

const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/company-service.log' })
  ]
});

class CompanyService {
  /**
   * Create a new company with initial setup
   */
  static async createCompany(companyData, userId) {
    try {
      // Create the company
      const company = await Company.create(companyData);
      
      // Create default settings
      await this._createDefaultSettings(company.id);
      
      // Create predefined tax rates for Nepal
      await this._createPredefinedTaxRates(company.id);
      
      // Create predefined units for Nepal
      await this._createPredefinedUnits(company.id);
      
      // Create default categories
      await this._createDefaultCategories(company.id);
      
      // Log the creation
      await AuditLog.log({
        userId,
        companyId: company.id,
        entityType: 'company',
        entityId: company.id,
        action: 'create',
        newValues: company.toJSON(),
        description: 'Company created with initial setup',
      });
      
      return company;
    } catch (error) {
      logger.error(`Error creating company: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Create default settings for a company
   */
  static async _createDefaultSettings(companyId) {
    const defaultSettings = Setting.defaultSettings;
    
    for (const [key, value] of Object.entries(defaultSettings)) {
      await Setting.create({
        companyId,
        key,
        value: typeof value === 'object' ? JSON.stringify(value) : value.toString(),
        type: typeof value === 'number' ? 'number' : typeof value === 'boolean' ? 'boolean' : 'string',
        category: 'general',
      });
    }
  }
  
  /**
   * Create predefined tax rates for Nepal
   */
  static async _createPredefinedTaxRates(companyId) {
    const predefinedTaxRates = TaxRate.predefinedRates;
    
    for (const taxRateData of predefinedTaxRates) {
      await TaxRate.create({
        companyId,
        ...taxRateData,
      });
    }
  }
  
  /**
   * Create predefined units for Nepal
   */
  static async _createPredefinedUnits(companyId) {
    const predefinedUnits = Unit.predefinedUnits;
    
    for (const unitData of predefinedUnits) {
      await Unit.create({
        companyId,
        ...unitData,
      });
    }
  }
  
  /**
   * Create default categories
   */
  static async _createDefaultCategories(companyId) {
    const defaultCategories = [
      { name: 'Electronics', nepaliName: 'इलेक्ट्रोनिक्स', code: 'ELEC', displayOrder: 1 },
      { name: 'Clothing', nepaliName: 'लुगाफाटा', code: 'CLOTH', displayOrder: 2 },
      { name: 'Food & Beverages', nepaliName: 'खाद्यपदार्थ', code: 'FOOD', displayOrder: 3 },
      { name: 'Furniture', nepaliName: 'फर्निचर', code: 'FURN', displayOrder: 4 },
      { name: 'Stationery', nepaliName: 'स्टेसनरी', code: 'STAT', displayOrder: 5 },
      { name: 'Services', nepaliName: 'सेवा', code: 'SERV', displayOrder: 6 },
      { name: 'Other', nepaliName: 'अन्य', code: 'OTHER', displayOrder: 7 },
    ];
    
    for (const categoryData of defaultCategories) {
      await Category.create({
        companyId,
        ...categoryData,
      });
    }
  }
  
  /**
   * Get company by ID with related data
   */
  static async getCompanyById(id) {
    try {
      const company = await Company.findByPk(id, {
        include: [
          { model: Setting, attributes: ['key', 'value', 'type'] },
          { model: Contact, attributes: ['id', 'type', 'firstName', 'lastName', 'email', 'phone'] },
          { model: Product, attributes: ['id', 'name', 'code', 'quantity'] },
          { model: Transaction, attributes: ['id', 'type', 'transactionNumber', 'total', 'status'] },
        ],
      });
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      if (company.deletedAt) {
        throw new Error('Company has been deleted');
      }
      
      // Format the response
      const companyData = company.toJSON();
      companyData.settings = {};
      company.Settings?.forEach(setting => {
        companyData.settings[setting.key] = setting.getValue();
      });
      delete companyData.Settings;
      
      return companyData;
    } catch (error) {
      logger.error(`Error fetching company: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Update company
   */
  static async updateCompany(id, companyData, userId) {
    try {
      const company = await Company.findByPk(id);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      if (company.deletedAt) {
        throw new Error('Cannot update deleted company');
      }
      
      const oldValues = company.toJSON();
      await company.update(companyData);
      const newValues = company.toJSON();
      
      // Log the update
      await AuditLog.log({
        userId,
        companyId: company.id,
        entityType: 'company',
        entityId: company.id,
        action: 'update',
        oldValues,
        newValues,
        description: 'Company updated',
      });
      
      return company;
    } catch (error) {
      logger.error(`Error updating company: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Delete company (soft delete)
   */
  static async deleteCompany(id, userId) {
    try {
      const company = await Company.findByPk(id);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      if (company.deletedAt) {
        throw new Error('Company already deleted');
      }
      
      const oldValues = company.toJSON();
      await company.destroy();
      
      // Log the deletion
      await AuditLog.log({
        userId,
        companyId: company.id,
        entityType: 'company',
        entityId: company.id,
        action: 'delete',
        oldValues,
        description: 'Company deleted',
      });
      
      return true;
    } catch (error) {
      logger.error(`Error deleting company: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get company statistics
   */
  static async getCompanyStats(companyId, startDate, endDate) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      // Get counts
      const [contactCount, productCount, saleCount, purchaseCount, paymentCount, receiptCount] = await Promise.all([
        Contact.count({ where: { companyId, deletedAt: null } }),
        Product.count({ where: { companyId, deletedAt: null } }),
        Transaction.count({ where: { companyId, type: { [Company.sequelize.Op.or]: ['sale', 'quote'] }, deletedAt: null } }),
        Transaction.count({ where: { companyId, type: { [Company.sequelize.Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null } }),
        Payment.count({ where: { companyId, type: 'payment', deletedAt: null } }),
        Payment.count({ where: { companyId, type: 'receipt', deletedAt: null } }),
      ]);
      
      // Get financial stats
      const [totalSales, totalPurchases, totalPayments, totalReceipts, outstandingReceivables, outstandingPayables] = await Promise.all([
        Transaction.getTotalSales(companyId, startDate, endDate),
        Transaction.getTotalPurchases(companyId, startDate, endDate),
        Payment.getTotalPayments(companyId, startDate, endDate),
        Payment.getTotalReceipts(companyId, startDate, endDate),
        Contact.getTotalOutstanding(companyId, 'customer'),
        Contact.getTotalOutstanding(companyId, 'supplier'),
      ]);
      
      // Get inventory stats
      const [totalProductsValue, lowStockCount, outOfStockCount] = await Promise.all([
        Product.getTotalValue(companyId),
        Product.getLowStockCount(companyId),
        Product.getOutOfStockCount(companyId),
      ]);
      
      // Get recent activity
      const [recentTransactions, recentContacts] = await Promise.all([
        Transaction.findAll({
          where: { companyId, deletedAt: null },
          order: [['created_at', 'DESC']],
          limit: 5,
          attributes: ['id', 'type', 'transactionNumber', 'total', 'status', 'created_at'],
        }),
        Contact.findAll({
          where: { companyId, deletedAt: null },
          order: [['created_at', 'DESC']],
          limit: 5,
          attributes: ['id', 'type', 'firstName', 'lastName', 'email', 'phone', 'created_at'],
        }),
      ]);
      
      return {
        company: {
          id: company.id,
          name: company.name,
          nepaliName: company.nepaliName,
          type: company.type,
          panNumber: company.panNumber,
          vatNumber: company.vatNumber,
        },
        counts: {
          contacts: contactCount,
          products: productCount,
          sales: saleCount,
          purchases: purchaseCount,
          payments: paymentCount,
          receipts: receiptCount,
        },
        financial: {
          totalSales: totalSales || 0,
          totalPurchases: totalPurchases || 0,
          totalPayments: totalPayments || 0,
          totalReceipts: totalReceipts || 0,
          outstandingReceivables: outstandingReceivables || 0,
          outstandingPayables: outstandingPayables || 0,
          netProfit: (totalSales || 0) - (totalPurchases || 0),
        },
        inventory: {
          totalValue: totalProductsValue || 0,
          lowStock: lowStockCount || 0,
          outOfStock: outOfStockCount || 0,
        },
        recentActivity: {
          transactions: recentTransactions,
          contacts: recentContacts,
        },
      };
    } catch (error) {
      logger.error(`Error fetching company stats: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get next invoice number
   */
  static async getNextInvoiceNumber(companyId) {
    try {
      return await Company.getNextInvoiceNumber(companyId);
    } catch (error) {
      logger.error(`Error getting next invoice number: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get next quote number
   */
  static async getNextQuoteNumber(companyId) {
    try {
      return await Company.getNextQuoteNumber(companyId);
    } catch (error) {
      logger.error(`Error getting next quote number: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get next purchase order number
   */
  static async getNextPurchaseOrderNumber(companyId) {
    try {
      return await Company.getNextPurchaseOrderNumber(companyId);
    } catch (error) {
      logger.error(`Error getting next PO number: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get company IRD information
   */
  static async getIRDInfo(companyId) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      return company.getIRDInfo();
    } catch (error) {
      logger.error(`Error fetching IRD info: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get fiscal year information
   */
  static async getFiscalYearInfo(companyId) {
    try {
      const company = await Company.findByPk(companyId, {
        attributes: ['fiscalYearStart', 'fiscalYearEnd', 'defaultVatRate'],
      });
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      return {
        fiscalYearStart: company.fiscalYearStart,
        fiscalYearEnd: company.fiscalYearEnd,
        currentFiscalYear: `${company.fiscalYearStart?.toISOString().split('T')[0]} to ${company.fiscalYearEnd?.toISOString().split('T')[0]}`,
        defaultVatRate: company.defaultVatRate,
      };
    } catch (error) {
      logger.error(`Error fetching fiscal year info: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Update fiscal year
   */
  static async updateFiscalYear(companyId, fiscalYearData, userId) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      const oldValues = company.toJSON();
      await company.update(fiscalYearData);
      const newValues = company.toJSON();
      
      // Log the update
      await AuditLog.log({
        userId,
        companyId: company.id,
        entityType: 'company',
        entityId: company.id,
        action: 'update',
        oldValues,
        newValues,
        description: 'Fiscal year updated',
      });
      
      return company;
    } catch (error) {
      logger.error(`Error updating fiscal year: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Search companies
   */
  static async searchCompanies(query, options = {}) {
    try {
      const { page = 1, limit = 10 } = options;
      const offset = (page - 1) * limit;
      
      const companies = await Company.findAndCountAll({
        where: Company.scope('search', query),
        offset: parseInt(offset),
        limit: parseInt(limit),
        order: [['name', 'ASC']],
      });
      
      return {
        data: companies.rows,
        pagination: {
          total: companies.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(companies.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error searching companies: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get all companies with pagination
   */
  static async getAllCompanies(options = {}) {
    try {
      const { page = 1, limit = 10, isActive, type } = options;
      const offset = (page - 1) * limit;
      
      const where = { deletedAt: null };
      
      if (isActive !== undefined) {
        where.isActive = isActive === true || isActive === 'true';
      }
      
      if (type) {
        where.type = type;
      }
      
      const companies = await Company.findAndCountAll({
        where,
        offset: parseInt(offset),
        limit: parseInt(limit),
        order: [['created_at', 'DESC']],
      });
      
      return {
        data: companies.rows,
        pagination: {
          total: companies.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(companies.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error fetching all companies: ${error.message}`);
      throw error;
    }
  }
}

module.exports = CompanyService;
