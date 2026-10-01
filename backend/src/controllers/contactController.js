/**
 * Contact Controller
 * Handles all contact-related operations
 */

const { Contact, Company, Transaction, Payment } = require('../models');
const AuditLog = require('../models/AuditLog');
const ContactService = require('../services/contactService');
const { createLogger } = require('winston');
const { Op } = require('sequelize');

const logger = createLogger({
  level: 'info',
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/contact.log' })
  ]
});

// Helper function to get user info from request
const getUserInfo = (req) => ({
  userId: req.user?.id,
  userName: req.user?.name || 'System',
  userEmail: req.user?.email,
});

/**
 * GET /api/v1/contacts
 * Get all contacts
 */
const getAllContacts = async (req, res, next) => {
  try {
    const { companyId, page = 1, limit = 10, search, type, isActive } = req.query;
    const offset = (page - 1) * limit;
    
    const where = {};
    
    if (companyId) {
      where.companyId = companyId;
    }
    
    if (search) {
      where[Op.or] = [
        { firstName: { [Op.iLike]: `%${search}%` } },
        { lastName: { [Op.iLike]: `%${search}%` } },
        { fullName: { [Op.iLike]: `%${search}%` } },
        { nepaliName: { [Op.iLike]: `%${search}%` } },
        { phone: { [Op.iLike]: `%${search}%` } },
        { mobile: { [Op.iLike]: `%${search}%` } },
        { email: { [Op.iLike]: `%${search}%` } },
        { panNumber: { [Op.iLike]: `%${search}%` } },
        { vatNumber: { [Op.iLike]: `%${search}%` } },
      ];
    }
    
    if (type) {
      where.type = type;
    }
    
    if (isActive !== undefined) {
      where.isActive = isActive === 'true';
    }
    
    where.deletedAt = null;
    
    const contacts = await Contact.findAndCountAll({
      where,
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      include: [
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    res.success({
      data: contacts.rows,
      pagination: {
        total: contacts.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(contacts.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error fetching contacts: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/:id
 * Get a single contact by ID
 */
const getContactById = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const contact = await Contact.findByPk(id, {
      include: [
        { model: Company, attributes: ['id', 'name', 'currency'] },
        { model: Transaction, attributes: ['id', 'type', 'transactionNumber', 'total', 'status', 'paymentStatus', 'date'] },
        { model: Payment, attributes: ['id', 'type', 'paymentNumber', 'amount', 'method', 'status', 'date'] },
      ],
    });
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    if (contact.deletedAt) {
      return res.notFound({ error: 'Contact has been deleted', code: 'CONTACT_DELETED' });
    }
    
    // Calculate current balance
    const balanceData = await ContactService.calculateBalance(contact.id);
    
    const contactData = contact.toJSON();
    contactData.balance = balanceData.balance;
    contactData.balanceStatus = contact.getBalanceStatus();
    
    res.success({ data: contactData });
  } catch (error) {
    logger.error(`Error fetching contact: ${error.message}`);
    next(error);
  }
};

/**
 * POST /api/v1/contacts
 * Create a new contact
 */
const createContact = async (req, res, next) => {
  try {
    const contactData = req.body;
    const userInfo = getUserInfo(req);
    
    // Set company ID from user if not provided
    if (!contactData.companyId && req.user?.companyId) {
      contactData.companyId = req.user.companyId;
    }
    
    // Ensure company exists
    if (contactData.companyId) {
      const company = await Company.findByPk(contactData.companyId);
      if (!company) {
        return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
      }
    }
    
    const contact = await Contact.create(contactData);
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: contact.companyId,
      entityType: 'contact',
      entityId: contact.id,
      action: 'create',
      newValues: contact.toJSON(),
      description: 'Contact created',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: contact, 
      message: 'Contact created successfully' 
    }, 201);
  } catch (error) {
    logger.error(`Error creating contact: ${error.message}`);
    next(error);
  }
};

/**
 * POST /api/v1/contacts/bulk
 * Create multiple contacts
 */
const createContactsBulk = async (req, res, next) => {
  try {
    const contactsData = req.body;
    const userInfo = getUserInfo(req);
    
    if (!Array.isArray(contactsData) || contactsData.length === 0) {
      return res.badRequest({ error: 'Contacts array is required', code: 'CONTACTS_ARRAY_REQUIRED' });
    }
    
    // Set company ID for all contacts
    const companyId = req.user?.companyId || contactsData[0]?.companyId;
    
    if (!companyId) {
      return res.badRequest({ error: 'Company ID is required', code: 'COMPANY_ID_REQUIRED' });
    }
    
    // Verify company exists
    const company = await Company.findByPk(companyId);
    if (!company) {
      return res.notFound({ error: 'Company not found', code: 'COMPANY_NOT_FOUND' });
    }
    
    // Create contacts
    const contacts = [];
    const auditLogs = [];
    
    for (const contactData of contactsData) {
      contactData.companyId = companyId;
      const contact = await Contact.create(contactData);
      contacts.push(contact);
      
      // Log audit
      auditLogs.push(AuditLog.log({
        ...userInfo,
        companyId,
        entityType: 'contact',
        entityId: contact.id,
        action: 'create',
        newValues: contact.toJSON(),
        description: 'Contact created (bulk)',
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
      }));
    }
    
    await Promise.all(auditLogs);
    
    res.success({ 
      data: contacts, 
      message: `${contacts.length} contacts created successfully` 
    }, 201);
  } catch (error) {
    logger.error(`Error creating contacts bulk: ${error.message}`);
    next(error);
  }
};

/**
 * PUT /api/v1/contacts/:id
 * Update a contact
 */
const updateContact = async (req, res, next) => {
  try {
    const { id } = req.params;
    const contactData = req.body;
    const userInfo = getUserInfo(req);
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    if (contact.deletedAt) {
      return res.badRequest({ error: 'Cannot update deleted contact', code: 'CONTACT_DELETED' });
    }
    
    const oldValues = contact.toJSON();
    await contact.update(contactData);
    const newValues = contact.toJSON();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: contact.companyId,
      entityType: 'contact',
      entityId: contact.id,
      action: 'update',
      oldValues,
      newValues,
      description: 'Contact updated',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: contact, 
      message: 'Contact updated successfully' 
    });
  } catch (error) {
    logger.error(`Error updating contact: ${error.message}`);
    next(error);
  }
};

/**
 * PATCH /api/v1/contacts/:id
 * Partially update a contact
 */
const updateContactPartial = async (req, res, next) => {
  try {
    const { id } = req.params;
    const contactData = req.body;
    const userInfo = getUserInfo(req);
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    if (contact.deletedAt) {
      return res.badRequest({ error: 'Cannot update deleted contact', code: 'CONTACT_DELETED' });
    }
    
    const oldValues = contact.toJSON();
    await contact.update(contactData);
    const newValues = contact.toJSON();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: contact.companyId,
      entityType: 'contact',
      entityId: contact.id,
      action: 'update',
      oldValues,
      newValues,
      description: 'Contact partially updated',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ 
      data: contact, 
      message: 'Contact updated successfully' 
    });
  } catch (error) {
    logger.error(`Error updating contact: ${error.message}`);
    next(error);
  }
};

/**
 * DELETE /api/v1/contacts/:id
 * Delete a contact (soft delete)
 */
const deleteContact = async (req, res, next) => {
  try {
    const { id } = req.params;
    const userInfo = getUserInfo(req);
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    if (contact.deletedAt) {
      return res.badRequest({ error: 'Contact already deleted', code: 'CONTACT_ALREADY_DELETED' });
    }
    
    const oldValues = contact.toJSON();
    await contact.destroy();
    
    // Log audit
    await AuditLog.log({
      ...userInfo,
      companyId: contact.companyId,
      entityType: 'contact',
      entityId: contact.id,
      action: 'delete',
      oldValues,
      description: 'Contact deleted',
      ipAddress: req.ip,
      userAgent: req.get('User-Agent'),
    });
    
    res.success({ message: 'Contact deleted successfully' });
  } catch (error) {
    logger.error(`Error deleting contact: ${error.message}`);
    next(error);
  }
};

/**
 * DELETE /api/v1/contacts/bulk
 * Delete multiple contacts
 */
const deleteContactsBulk = async (req, res, next) => {
  try {
    const { ids } = req.body;
    const userInfo = getUserInfo(req);
    
    if (!ids || !Array.isArray(ids) || ids.length === 0) {
      return res.badRequest({ error: 'IDs array is required', code: 'IDS_ARRAY_REQUIRED' });
    }
    
    const contacts = await Contact.findAll({
      where: { id: ids, deletedAt: null },
    });
    
    if (contacts.length !== ids.length) {
      const foundIds = contacts.map(c => c.id);
      const missingIds = ids.filter(id => !foundIds.includes(id));
      return res.badRequest({
        error: 'Some contacts not found',
        code: 'CONTACTS_NOT_FOUND',
        missingIds,
      });
    }
    
    const auditLogs = [];
    
    for (const contact of contacts) {
      const oldValues = contact.toJSON();
      await contact.destroy();
      
      // Log audit
      auditLogs.push(AuditLog.log({
        ...userInfo,
        companyId: contact.companyId,
        entityType: 'contact',
        entityId: contact.id,
        action: 'delete',
        oldValues,
        description: 'Contact deleted (bulk)',
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
      }));
    }
    
    await Promise.all(auditLogs);
    
    res.success({ message: `${contacts.length} contacts deleted successfully` });
  } catch (error) {
    logger.error(`Error deleting contacts bulk: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/:id/transactions
 * Get transactions for a contact
 */
const getContactTransactions = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { page = 1, limit = 10, type, status, paymentStatus } = req.query;
    const offset = (page - 1) * limit;
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    const where = { contactId: id, deletedAt: null };
    
    if (type) {
      where.type = type;
    }
    
    if (status) {
      where.status = status;
    }
    
    if (paymentStatus) {
      where.paymentStatus = paymentStatus;
    }
    
    const transactions = await Transaction.findAndCountAll({
      where,
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['date', 'DESC'], ['transaction_number', 'DESC']],
      include: [
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    res.success({
      data: transactions.rows,
      pagination: {
        total: transactions.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(transactions.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error fetching contact transactions: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/:id/payments
 * Get payments for a contact
 */
const getContactPayments = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { page = 1, limit = 10, type, status, method } = req.query;
    const offset = (page - 1) * limit;
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    const where = { contactId: id, deletedAt: null };
    
    if (type) {
      where.type = type;
    }
    
    if (status) {
      where.status = status;
    }
    
    if (method) {
      where.method = method;
    }
    
    const payments = await Payment.findAndCountAll({
      where,
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['date', 'DESC'], ['payment_number', 'DESC']],
      include: [
        { model: Transaction, attributes: ['id', 'transactionNumber', 'type'] },
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    res.success({
      data: payments.rows,
      pagination: {
        total: payments.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(payments.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error fetching contact payments: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/:id/balance
 * Get balance for a contact
 */
const getContactBalance = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    const balanceData = await ContactService.calculateBalance(contact.id);
    
    res.success({
      data: {
        contact: {
          id: contact.id,
          name: contact.fullName,
          type: contact.type,
        },
        balance: balanceData.balance,
        balanceStatus: contact.getBalanceStatus(),
        ...balanceData,
      },
    });
  } catch (error) {
    logger.error(`Error fetching contact balance: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/:id/stats
 * Get statistics for a contact
 */
const getContactStats = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { startDate, endDate } = req.query;
    
    const contact = await Contact.findByPk(id);
    
    if (!contact) {
      return res.notFound({ error: 'Contact not found', code: 'CONTACT_NOT_FOUND' });
    }
    
    // Get transaction counts
    const [saleCount, purchaseCount, paymentCount, receiptCount] = await Promise.all([
      Transaction.count({
        where: { contactId: id, type: { [Op.or]: ['sale', 'quote'] }, deletedAt: null },
      }),
      Transaction.count({
        where: { contactId: id, type: { [Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null },
      }),
      Payment.count({
        where: { contactId: id, type: 'payment', deletedAt: null },
      }),
      Payment.count({
        where: { contactId: id, type: 'receipt', deletedAt: null },
      }),
    ]);
    
    // Get financial totals
    const [totalSales, totalPurchases, totalPayments, totalReceipts] = await Promise.all([
      Transaction.sum('total', {
        where: { contactId: id, type: { [Op.or]: ['sale', 'quote'] }, deletedAt: null },
      }),
      Transaction.sum('total', {
        where: { contactId: id, type: { [Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null },
      }),
      Payment.sum('amount', {
        where: { contactId: id, type: 'payment', deletedAt: null },
      }),
      Payment.sum('amount', {
        where: { contactId: id, type: 'receipt', deletedAt: null },
      }),
    ]);
    
    // Calculate balance
    const balanceData = await ContactService.calculateBalance(contact.id);
    
    res.success({
      data: {
        contact: {
          id: contact.id,
          name: contact.fullName,
          type: contact.type,
          typeDisplay: contact.getContactTypeDisplay(),
        },
        counts: {
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
        },
        balance: balanceData,
      },
    });
  } catch (error) {
    logger.error(`Error fetching contact stats: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/types
 * Get all contact types
 */
const getContactTypes = (req, res) => {
  const types = [
    { value: 'customer', label: 'Customer' },
    { value: 'supplier', label: 'Supplier' },
    { value: 'both', label: 'Customer & Supplier' },
    { value: 'employee', label: 'Employee' },
    { value: 'other', label: 'Other' },
  ];
  
  res.success({ data: types });
};

/**
 * GET /api/v1/contacts/search
 * Search contacts
 */
const searchContacts = async (req, res, next) => {
  try {
    const { companyId, query, type, page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;
    
    if (!query) {
      return res.badRequest({ error: 'Search query is required', code: 'QUERY_REQUIRED' });
    }
    
    const where = { deletedAt: null };
    
    if (companyId) {
      where.companyId = companyId;
    }
    
    if (type) {
      where.type = type;
    }
    
    where[Op.or] = [
      { firstName: { [Op.iLike]: `%${query}%` } },
      { lastName: { [Op.iLike]: `%${query}%` } },
      { fullName: { [Op.iLike]: `%${query}%` } },
      { nepaliName: { [Op.iLike]: `%${query}%` } },
      { phone: { [Op.iLike]: `%${query}%` } },
      { mobile: { [Op.iLike]: `%${query}%` } },
      { email: { [Op.iLike]: `%${query}%` } },
      { panNumber: { [Op.iLike]: `%${query}%` } },
      { vatNumber: { [Op.iLike]: `%${query}%` } },
    ];
    
    const contacts = await Contact.findAndCountAll({
      where,
      offset: parseInt(offset),
      limit: parseInt(limit),
      order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      include: [
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    res.success({
      data: contacts.rows,
      pagination: {
        total: contacts.count,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(contacts.count / limit),
      },
    });
  } catch (error) {
    logger.error(`Error searching contacts: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/export/csv
 * Export contacts as CSV
 */
const exportContactsCSV = async (req, res, next) => {
  try {
    const { companyId } = req.query;
    
    const where = { deletedAt: null };
    
    if (companyId) {
      where.companyId = companyId;
    }
    
    const contacts = await Contact.findAll({
      where,
      order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      include: [
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    // Generate CSV
    const csv = [
      ['ID', 'Company', 'Type', 'Name', 'Nepali Name', 'Phone', 'Mobile', 'Email', 'PAN Number', 'VAT Number', 'Opening Balance', 'Total Sales', 'Total Purchases', 'Total Payments', 'Total Receipts', 'Current Balance', 'Status', 'Created At'],
      ...contacts.map(contact => [
        contact.id,
        contact.Company?.name || '',
        contact.type,
        contact.fullName,
        contact.nepaliName || '',
        contact.phone || '',
        contact.mobile || '',
        contact.email || '',
        contact.panNumber || '',
        contact.vatNumber || '',
        contact.openingBalance || 0,
        contact.totalSales || 0,
        contact.totalPurchases || 0,
        contact.totalPayments || 0,
        contact.totalReceipts || 0,
        contact.currentBalance,
        contact.isActive ? 'Active' : 'Inactive',
        contact.createdAt,
      ]),
    ].map(row => row.map(cell => `"${String(cell).replace(/"/g, '""')}"`).join(',')).join('\n');
    
    // Set headers
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename=contacts.csv');
    
    res.send(csv);
  } catch (error) {
    logger.error(`Error exporting contacts CSV: ${error.message}`);
    next(error);
  }
};

/**
 * GET /api/v1/contacts/export/excel
 * Export contacts as Excel
 */
const exportContactsExcel = async (req, res, next) => {
  try {
    const { companyId } = req.query;
    const XLSX = require('xlsx');
    
    const where = { deletedAt: null };
    
    if (companyId) {
      where.companyId = companyId;
    }
    
    const contacts = await Contact.findAll({
      where,
      order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      include: [
        { model: Company, attributes: ['id', 'name'] },
      ],
    });
    
    // Create worksheet
    const ws = XLSX.utils.json_to_sheet(contacts.map(contact => ({
      ID: contact.id,
      Company: contact.Company?.name || '',
      Type: contact.type,
      Name: contact.fullName,
      'Nepali Name': contact.nepaliName || '',
      Phone: contact.phone || '',
      Mobile: contact.mobile || '',
      Email: contact.email || '',
      'PAN Number': contact.panNumber || '',
      'VAT Number': contact.vatNumber || '',
      'Opening Balance': contact.openingBalance || 0,
      'Total Sales': contact.totalSales || 0,
      'Total Purchases': contact.totalPurchases || 0,
      'Total Payments': contact.totalPayments || 0,
      'Total Receipts': contact.totalReceipts || 0,
      'Current Balance': contact.currentBalance,
      Status: contact.isActive ? 'Active' : 'Inactive',
      'Created At': contact.createdAt,
    }));
    
    // Create workbook
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Contacts');
    
    // Generate Excel file
    const excelBuffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
    
    // Set headers
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', 'attachment; filename=contacts.xlsx');
    
    res.send(excelBuffer);
  } catch (error) {
    logger.error(`Error exporting contacts Excel: ${error.message}`);
    next(error);
  }
};

/**
 * POST /api/v1/contacts/import/csv
 * Import contacts from CSV
 */
const importContactsCSV = async (req, res, next) => {
  try {
    const { file } = req;
    const userInfo = getUserInfo(req);
    
    if (!file) {
      return res.badRequest({ error: 'No file uploaded', code: 'NO_FILE_UPLOADED' });
    }
    
    const csv = require('csv-parser');
    const fs = require('fs');
    
    const contacts = [];
    const errors = [];
    const auditLogs = [];
    
    // Process CSV file
    await new Promise((resolve, reject) => {
      fs.createReadStream(file.path)
        .pipe(csv())
        .on('data', (data) => contacts.push(data))
        .on('end', resolve)
        .on('error', reject);
    });
    
    // Process each contact
    for (const contactData of contacts) {
      try {
        // Map CSV fields to contact model
        const contact = await Contact.create({
          companyId: req.user?.companyId || contactData.CompanyId,
          type: contactData.Type || 'customer',
          firstName: contactData.Name || '',
          lastName: '',
          nepaliName: contactData['Nepali Name'] || '',
          phone: contactData.Phone || '',
          mobile: contactData.Mobile || '',
          email: contactData.Email || '',
          panNumber: contactData['PAN Number'] || '',
          vatNumber: contactData['VAT Number'] || '',
          openingBalance: parseFloat(contactData['Opening Balance']) || 0,
          isActive: contactData.Status === 'Active',
        });
        
        contacts.push(contact);
        
        // Log audit
        auditLogs.push(AuditLog.log({
          ...userInfo,
          companyId: contact.companyId,
          entityType: 'contact',
          entityId: contact.id,
          action: 'create',
          newValues: contact.toJSON(),
          description: 'Contact imported from CSV',
          ipAddress: req.ip,
          userAgent: req.get('User-Agent'),
        }));
      } catch (error) {
        errors.push({
          data: contactData,
          error: error.message,
        });
      }
    }
    
    await Promise.all(auditLogs);
    
    res.success({
      data: {
        imported: contacts.length,
        errors: errors.length,
      },
      message: `${contacts.length} contacts imported successfully`,
    }, 201);
  } catch (error) {
    logger.error(`Error importing contacts CSV: ${error.message}`);
    next(error);
  }
};

/**
 * POST /api/v1/contacts/import/excel
 * Import contacts from Excel
 */
const importContactsExcel = async (req, res, next) => {
  try {
    const { file } = req;
    const userInfo = getUserInfo(req);
    
    if (!file) {
      return res.badRequest({ error: 'No file uploaded', code: 'NO_FILE_UPLOADED' });
    }
    
    const XLSX = require('xlsx');
    
    const wb = XLSX.readFile(file.path);
    const ws = wb.Sheets[wb.SheetNames[0]];
    const data = XLSX.utils.sheet_to_json(ws);
    
    const contacts = [];
    const errors = [];
    const auditLogs = [];
    
    // Process each row
    for (const contactData of data) {
      try {
        const contact = await Contact.create({
          companyId: req.user?.companyId || contactData.CompanyId,
          type: contactData.Type || 'customer',
          firstName: contactData.Name || '',
          lastName: '',
          nepaliName: contactData['Nepali Name'] || '',
          phone: contactData.Phone || '',
          mobile: contactData.Mobile || '',
          email: contactData.Email || '',
          panNumber: contactData['PAN Number'] || '',
          vatNumber: contactData['VAT Number'] || '',
          openingBalance: parseFloat(contactData['Opening Balance']) || 0,
          isActive: contactData.Status === 'Active',
        });
        
        contacts.push(contact);
        
        // Log audit
        auditLogs.push(AuditLog.log({
          ...userInfo,
          companyId: contact.companyId,
          entityType: 'contact',
          entityId: contact.id,
          action: 'create',
          newValues: contact.toJSON(),
          description: 'Contact imported from Excel',
          ipAddress: req.ip,
          userAgent: req.get('User-Agent'),
        }));
      } catch (error) {
        errors.push({
          data: contactData,
          error: error.message,
        });
      }
    }
    
    await Promise.all(auditLogs);
    
    res.success({
      data: {
        imported: contacts.length,
        errors: errors.length,
      },
      message: `${contacts.length} contacts imported successfully`,
    }, 201);
  } catch (error) {
    logger.error(`Error importing contacts Excel: ${error.message}`);
    next(error);
  }
};

module.exports = {
  getAllContacts,
  getContactById,
  createContact,
  createContactsBulk,
  updateContact,
  updateContactPartial,
  deleteContact,
  deleteContactsBulk,
  getContactTransactions,
  getContactPayments,
  getContactBalance,
  getContactStats,
  getContactTypes,
  searchContacts,
  exportContactsCSV,
  exportContactsExcel,
  importContactsCSV,
  importContactsExcel,
};
