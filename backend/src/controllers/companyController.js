/**
 * Company Controller
 * Handles all company-related operations
 */

const { Company, Contact, Product, Transaction, Payment, Setting } = require('../models');
const AuditLog = require('../models/AuditLog');
const { createLogger } = require('winston');

const logger = createLogger({
  level: 'info',
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/company.log' })
  ]
});

// Helper function to get user info from request
const getUserInfo = (req) => ({
  userId: req.user?.id,
  userName: req.user?.name || 'System',
  userEmail: req.user?.email,
});

/**
 * GET /api/v1/companies
 * Get all companies (with optional filters)
 */
const getAllCompanies = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, search, isActive, type } = req.query;
    const offset = (page - 1) * limit;
    
    const where = { deletedAt: null };
    
    if (search) {
      where[req.Op.or] = [
        { name: { [req.Op.iLike]: `%${search}%` } },
        { nepaliName: { [req.Op.iLike]: `%${search}%` } },
        { panNumber: { [req.Op.iLike]: `%${search}%` } },
        { vatNumber: { [req.Op.iLike]: `%${search}%` } },
      ];
    }
    
    if (isActive !== undefined) {
      where.isActive = isActive === 'true';
    }
    
    if (type) {
      where.type = type;
    }
    
    const companies = await Company.findAndCountAll({
      where,
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['created_at', 'DESC']],
      include: [
        { model: Contact, attributes: ['id'] },
        { model: Product, attributes: ['id'] },
        { model: Transaction, attributes: ['id'] },
        { model: Payment, attributes: ['id'] },
      ],
    });
    
    res.success({
      data: companies.rows,
      pagination: {
        total: companies.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(companies.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error fetching companies: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id
 * Get a single company by ID
 */
const getCompanyById = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id, {
      include: [
        { model: Setting, attributes: ['key', 'value', 'type'] },
      ],
    });
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    if (company.deletedAt) {
      return res.notFound({ error: 'Company has been deleted', code: 'COMPANY_DELETED' });
    }
    
    // Add settings as a map
    const companyData = company.toJSON();
    companyData.settings = {};
    company.Settings?.forEach(setting => {
      companyData.settings[setting.key] = setting.getValue();
    });
    delete companyData.Settings;
    
    res.success({ data: companyData });
  } catch (error) {
    logger.error(`Error fetching company: ${error.message}`);
    next(error);
  }
};

/**
 * POST /api/v1/companies
 * Create a new company
 */
const createCompany = async (req, res, next) => {
  try {
    const companyData = req.body;
    const userInfo = getUserInfo(req);
    
    // Set default values
    companyData.currency = companyData.currency || 'NPR';
    companyData.country = companyData.country || 'Nepal';
    companyData.defaultVatRate = companyData.defaultVatRate || 13.0;
    
    const company = await Company.create(companyData);
    
    // Create default settings
    const defaultSettings = Setting.defaultSettings;
    for (const [key, value] of Object.entries(defaultSettings)) {
      await Setting.create({
        companyId: company.id,
        key,
        value: typeof value === 'object' ? JSON.stringify(value) : value.toString(),
        type: typeof value === 'number' ? 'number' : typeof value === 'boolean' ? 'boolean' : 'string',
        category: 'general',
      });
    }
    
    // Create predefined tax rates for Nepal
    const predefinedTaxRates = require('../models/TaxRate').predefinedRates;
    const TaxRate = require('../models/TaxRate');
    for (const taxRateData of predefinedTaxRates) {
      await TaxRate.create({
        companyId: company.id,
        ...taxRateData,
      });
    }
    
    // Create predefined units for Nepal
    const predefinedUnits = require('../models/Unit').predefinedUnits;
    const Unit = require('../models/Unit');
    for (const unitData of predefinedUnits) {
      await Unit.create({
        companyId: company.id,
        ...unitData,
      });
    }
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: company.id,
      entityType: 'company',
      entityId: company.id,
      action: 'create',
      newValues: company.toJSON(),
      description: 'Company created',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: company, 
      message: 'Company created successfully' 
    }, 201);
  } catch (error) {
    logger.error(`Error creating company: ${error.message}`);
    next(error);
  }
};

/**
 * PUT /api/v1/companies/:id
 * Update a company
 */
const updateCompany = async (req, res, next) => {
  try {
    const { id } = req.params;
    const companyData = req.body;
    const userInfo = getUserInfo(req);
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    if (company.deletedAt) {
      return res.badRequest({ error: 'Cannot update deleted company', code: 'COMPANY_DELETED' });
    }
    
    const oldValues = company.toJSON();
    await company.update(companyData);
    const newValues = company.toJSON();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: company.id,
      entityType: 'company',
      entityId: company.id,
      action: 'update',
      oldValues,
      newValues,
      description: 'Company updated',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: company, 
      message: 'Company updated successfully' 
    });
  } catch (error) {
    logger.error(`Error updating company: ${error.message}`);
    next(error);
  }
};

/**
 * PATCH /api/v1/companies/:id
 * Partially update a company
 */
const updateCompanyPartial = async (req, res, next) => {
  try {
    const { id } = req.params;
    const companyData = req.body;
    const userInfo = getUserInfo(req);
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    if (company.deletedAt) {
      return res.badRequest({ error: 'Cannot update deleted company', code: 'COMPANY_DELETED' });
    }
    
    const oldValues = company.toJSON();
    await company.update(companyData);
    const newValues = company.toJSON();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: company.id,
      entityType: 'company',
      entityId: company.id,
      action: 'update',
      oldValues,
      newValues,
      description: 'Company partially updated',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: company, 
      message: 'Company updated successfully' 
    });
  } catch (error) {
    logger.error(`Error updating company: ${error.message}`);
    next(error);
  }
};

/**
 * DELETE /api/v1/companies/:id
 * Delete a company (soft delete)
 */
const deleteCompany = async (req, res, next) => {
  try {
    const { id } = req.params;
    const userInfo = getUserInfo(req);
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    if (company.deletedAt) {
      return res.badRequest({ error: 'Company already deleted', code: 'COMPANY_ALREADY_DELETED' });
    }
    
    const oldValues = company.toJSON();
    await company.destroy();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: company.id,
      entityType: 'company',
      entityId: company.id,
      action: 'delete',
      oldValues,
      description: 'Company deleted',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ message: 'Company deleted successfully' });
  } catch (error) {
    logger.error(`Error deleting company: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/settings
 * Get company settings
 */
const getCompanySettings = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const settings = await Setting.findAll({
      where: { companyId: id, deletedAt: null },
    });
    
    const settingsMap = {};
    settings.forEach(setting => {
      settingsMap[setting.key] = setting.getValue();
    });
    
    res.success({ data: settingsMap });
  } catch (error) {
    logger.error(`Error fetching company settings: ${error.message}`);
    next(error);
  }
};

/**
 * PUT /api/v1/companies/:id/settings
 * Update company settings
 */
const updateCompanySettings = async (req, res, next) => {
  try {
    const { id } = req.params;
    const settings = req.body;
    const userInfo = getUserInfo(req);
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const updates = [];
    
    for (const [key, value] of Object.entries(settings)) {
      const existing = await Setting.findOne({
        where: { companyId: id, key, deletedAt: null },
      });
      
      if (existing) {
        const oldValue = existing.getValue();
        existing.setValue(value);
        await existing.save();
        
        // Log audit
        updates.push(AuditLog.log({
          ...userInfo,
          companyId: id,
          entityType: 'setting',
          entityId: existing.id,
          action: 'update',
          oldValues: { [key]: oldValue },
          newValues: { [key]: value },
          description: `Setting updated: ${key}`,
          ipAddress: req.ip,
          userAgent: req.get('User-Agent'),
        }));
      } else {
        const newSetting = await Setting.create({
          companyId: id,
          key,
          value: typeof value === 'object' ? JSON.stringify(value) : value.toString(),
          type: typeof value === 'number' ? 'number' : typeof value === 'boolean' ? 'boolean' : 'string',
          category: 'general',
        });
        
        // Log audit
        updates.push(AuditLog.log({
          ...userInfo,
          companyId: id,
          entityType: 'setting',
          entityId: newSetting.id,
          action: 'create',
          newValues: { [key]: value },
          description: `Setting created: ${key}`,
          ipAddress: req.ip,
          userAgent: req.get('User-Agent'),
        }));
      }
    }
    
    await Promise.all(updates);
    
    res.success({ message: 'Settings updated successfully' });
  } catch (error) {
    logger.error(`Error updating company settings: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/ird
 * Get company IRD information
 */
const getCompanyIRDInfo = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const irdInfo = company.getIRDInfo();
    
    res.success({ data: irdInfo });
  } catch (error) {
    logger.error(`Error fetching IRD info: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/fiscal-year
 * Get company fiscal year information
 */
const getFiscalYearInfo = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id, {
      attributes: ['fiscalYearStart', 'fiscalYearEnd', 'defaultVatRate'],
    });
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    res.success({
      data: {
        fiscalYearStart: company.fiscalYearStart,
        fiscalYearEnd: company.fiscalYearEnd,
        currentFiscalYear: `${company.fiscalYearStart?.toISOString().split('T')[0]} to ${company.fiscalYearEnd?.toISOString().split('T')[0]}`,
        defaultVatRate: company.defaultVatRate,
      },
    });
  } catch (error) {
    logger.error(`Error fetching fiscal year info: ${error.message}`);
    next(error);
  }
};

/**
 * PUT /api/v1/companies/:id/fiscal-year
 * Update company fiscal year
 */
const updateFiscalYear = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { fiscalYearStart, fiscalYearEnd } = req.body;
    const userInfo = getUserInfo(req);
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const oldValues = company.toJSON();
    await company.update({ fiscalYearStart, fiscalYearEnd });
    const newValues = company.toJSON();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: company.id,
      entityType: 'company',
      entityId: company.id,
      action: 'update',
      oldValues,
      newValues,
      description: 'Fiscal year updated',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: company, 
      message: 'Fiscal year updated successfully' 
    });
  } catch (error) {
    logger.error(`Error updating fiscal year: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/invoice-number
 * Get next invoice number
 */
const getNextInvoiceNumber = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const nextNumber = await Company.getNextInvoiceNumber(id);
    
    res.success({ data: { invoiceNumber: nextNumber } });
  } catch (error) {
    logger.error(`Error getting next invoice number: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/quote-number
 * Get next quote number
 */
const getNextQuoteNumber = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const nextNumber = await Company.getNextQuoteNumber(id);
    
    res.success({ data: { quoteNumber: nextNumber } });
  } catch (error) {
    logger.error(`Error getting next quote number: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/po-number
 * Get next purchase order number
 */
const getNextPurchaseOrderNumber = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    const nextNumber = await Company.getNextPurchaseOrderNumber(id);
    
    res.success({ data: { purchaseOrderNumber: nextNumber } });
  } catch (error) {
    logger.error(`Error getting next PO number: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/:id/stats
 * Get company statistics
 */
const getCompanyStats = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { startDate, endDate } = req.query;
    
    const company = await Company.findByPk(id);
    
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    // Get counts
    const [contactCount, productCount, saleCount, purchaseCount] = await Promise.all([
      Contact.count({ where: { companyId: id, deletedAt: null } }),
      Product.count({ where: { companyId: id, deletedAt: null } }),
      Transaction.count({ where: { companyId: id, type: { [req.Op.or]: ['sale', 'quote'] }, deletedAt: null } }),
      Transaction.count({ where: { companyId: id, type: { [req.Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null } }),
    ]);
    
    // Get financial stats
    const [totalSales, totalPurchases, totalOutstanding] = await Promise.all([
      Transaction.getTotalSales(id, startDate, endDate),
      Transaction.getTotalPurchases(id, startDate, endDate),
      Contact.getTotalOutstanding(id, 'customer'),
    ]);
    
    // Get inventory stats
    const [totalProductsValue, lowStockCount, outOfStockCount] = await Promise.all([
      Product.getTotalValue(id),
      Product.getLowStockCount(id),
      Product.getOutOfStockCount(id),
    ]);
    
    res.success({
      data: {
        company: {
          id: company.id,
          name: company.name,
          nepaliName: company.nepaliName,
        },
        counts: {
          contacts: contactCount,
          products: productCount,
          sales: saleCount,
          purchases: purchaseCount,
        },
        financial: {
          totalSales: totalSales || 0,
          totalPurchases: totalPurchases || 0,
          outstandingReceivables: totalOutstanding || 0,
          inventoryValue: totalProductsValue || 0,
        },
        inventory: {
          lowStock: lowStockCount || 0,
          outOfStock: outOfStockCount || 0,
        },
      },
    });
  } catch (error) {
    logger.error(`Error fetching company stats: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/companies/search
 * Search companies
 */
const searchCompanies = async (req, res, next) => {
  try {
    const { query, page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;
    
    if (!query) {
      return res.badRequest({ error: 'Search query is required', code: 'QUERY_REQUIRED' });
    }
    
    const companies = await Company.findAndCountAll({
      where: Company.scope('search', query),
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['name', 'ASC']],
    });
    
    res.success({
      data: companies.rows,
      pagination: {
        total: companies.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(companies.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error searching companies: ${error.message}`);
    next(error);
  }
};

module.exports = {
  getAllCompanies,
  getCompanyById,
  createCompany,
  updateCompany,
  updateCompanyPartial,
  deleteCompany,
  getCompanySettings,
  updateCompanySettings,
  getCompanyIRDInfo,
  getFiscalYearInfo,
  updateFiscalYear,
  getNextInvoiceNumber,
  getNextQuoteNumber,
  getNextPurchaseOrderNumber,
  getCompanyStats,
  searchCompanies,
};
