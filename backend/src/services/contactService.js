/**
 * Contact Service
 * Business logic for contact operations
 */

const { Contact, Transaction, Payment, Company } = require('../models');
const { createLogger } = require('winston');
const config = require('../config/env');

const logger = createLogger({
  level: config.logging.level,
  format: createLogger.format.combine(
    createLogger.format.timestamp(),
    createLogger.format.json()
  ),
  transports: [
    new createLogger.transports.Console(),
    new createLogger.transports.File({ filename: 'logs/contact-service.log' })
  ]
});

class ContactService {
  /**
   * Create a new contact
   */
  static async createContact(contactData, userId) {
    try {
      // Set default values
      contactData.type = contactData.type || 'customer';
      contactData.country = contactData.country || 'Nepal';
      contactData.openingBalance = contactData.openingBalance || 0;
      contactData.isActive = contactData.isActive !== false;
      
      const contact = await Contact.create(contactData);
      
      // Log the creation
      await this._logAudit(userId, contact.companyId, 'contact', contact.id, 'create', null, contact.toJSON(), 'Contact created');
      
      return contact;
    } catch (error) {
      logger.error(`Error creating contact: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Create multiple contacts
   */
  static async createContactsBulk(contactsData, userId, companyId) {
    try {
      const contacts = [];
      const auditLogs = [];
      
      for (const contactData of contactsData) {
        contactData.companyId = companyId;
        contactData.type = contactData.type || 'customer';
        contactData.country = contactData.country || 'Nepal';
        contactData.openingBalance = contactData.openingBalance || 0;
        contactData.isActive = contactData.isActive !== false;
        
        const contact = await Contact.create(contactData);
        contacts.push(contact);
        
        // Log audit
        auditLogs.push(this._logAudit(userId, companyId, 'contact', contact.id, 'create', null, contact.toJSON(), 'Contact created (bulk)'));
      }
      
      await Promise.all(auditLogs);
      
      return contacts;
    } catch (error) {
      logger.error(`Error creating contacts bulk: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get contact by ID
   */
  static async getContactById(id, include = []) {
    try {
      const options = { include };
      
      const contact = await Contact.findByPk(id, options);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      if (contact.deletedAt) {
        throw new Error('Contact has been deleted');
      }
      
      return contact;
    } catch (error) {
      logger.error(`Error fetching contact: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get all contacts
   */
  static async getAllContacts(options = {}) {
    try {
      const { companyId, page = 1, limit = 10, search, type, isActive } = options;
      const offset = (page - 1) * limit;
      
      const where = { deletedAt: null };
      
      if (companyId) {
        where.companyId = companyId;
      }
      
      if (search) {
        where[Contact.sequelize.Op.or] = [
          { firstName: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { lastName: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { fullName: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { nepaliName: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { phone: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { mobile: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { email: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { panNumber: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
          { vatNumber: { [Contact.sequelize.Op.iLike]: `%${search}%` } },
        ];
      }
      
      if (type) {
        where.type = type;
      }
      
      if (isActive !== undefined) {
        where.isActive = isActive === true || isActive === 'true';
      }
      
      const contacts = await Contact.findAndCountAll({
        where,
        offset: parseInt(offset),
        limit: parseInt(limit),
        order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      });
      
      return {
        data: contacts.rows,
        pagination: {
          total: contacts.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(contacts.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error fetching all contacts: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Update contact
   */
  static async updateContact(id, contactData, userId) {
    try {
      const contact = await Contact.findByPk(id);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      if (contact.deletedAt) {
        throw new Error('Cannot update deleted contact');
      }
      
      const oldValues = contact.toJSON();
      await contact.update(contactData);
      const newValues = contact.toJSON();
      
      // Log audit
      await this._logAudit(userId, contact.companyId, 'contact', contact.id, 'update', oldValues, newValues, 'Contact updated');
      
      return contact;
    } catch (error) {
      logger.error(`Error updating contact: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Delete contact (soft delete)
   */
  static async deleteContact(id, userId) {
    try {
      const contact = await Contact.findByPk(id);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      if (contact.deletedAt) {
        throw new Error('Contact already deleted');
      }
      
      const oldValues = contact.toJSON();
      await contact.destroy();
      
      // Log audit
      await this._logAudit(userId, contact.companyId, 'contact', contact.id, 'delete', oldValues, null, 'Contact deleted');
      
      return true;
    } catch (error) {
      logger.error(`Error deleting contact: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Delete multiple contacts
   */
  static async deleteContactsBulk(ids, userId) {
    try {
      const contacts = await Contact.findAll({
        where: { id: ids, deletedAt: null },
      });
      
      if (contacts.length !== ids.length) {
        const foundIds = contacts.map(c => c.id);
        const missingIds = ids.filter(id => !foundIds.includes(id));
        throw new Error(`Some contacts not found: ${missingIds.join(', ')}`);
      }
      
      const auditLogs = [];
      
      for (const contact of contacts) {
        const oldValues = contact.toJSON();
        await contact.destroy();
        
        // Log audit
        auditLogs.push(this._logAudit(userId, contact.companyId, 'contact', contact.id, 'delete', oldValues, null, 'Contact deleted (bulk)'));
      }
      
      await Promise.all(auditLogs);
      
      return true;
    } catch (error) {
      logger.error(`Error deleting contacts bulk: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Calculate balance for a contact
   */
  static async calculateBalance(contactId) {
    try {
      const contact = await Contact.findByPk(contactId);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      // Get all transactions for this contact
      const transactions = await Transaction.findAll({
        where: { contactId, deletedAt: null },
      });
      
      // Get all payments for this contact
      const payments = await Payment.findAll({
        where: { contactId, deletedAt: null },
      });
      
      let totalSales = 0;
      let totalPurchases = 0;
      let totalReceipts = 0;
      let totalPayments = 0;
      
      transactions.forEach(txn => {
        if (txn.type === 'sale' || txn.type === 'quote') {
          totalSales += txn.total || 0;
        } else if (txn.type === 'purchase' || txn.type === 'purchase_order') {
          totalPurchases += txn.total || 0;
        }
      });
      
      payments.forEach(payment => {
        if (payment.type === 'receipt') {
          totalReceipts += payment.amount || 0;
        } else if (payment.type === 'payment') {
          totalPayments += payment.amount || 0;
        }
      });
      
      // Calculate balance based on contact type
      let balance = contact.openingBalance || 0;
      
      if (contact.type === 'customer' || contact.type === 'both') {
        balance += totalSales - totalReceipts;
      }
      
      if (contact.type === 'supplier' || contact.type === 'both') {
        balance += totalPurchases - totalPayments;
      }
      
      return {
        balance,
        openingBalance: contact.openingBalance || 0,
        totalSales,
        totalPurchases,
        totalReceipts,
        totalPayments,
      };
    } catch (error) {
      logger.error(`Error calculating contact balance: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get contact statistics
   */
  static async getContactStats(contactId, startDate, endDate) {
    try {
      const contact = await Contact.findByPk(contactId);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      // Get transaction counts
      const [saleCount, purchaseCount, paymentCount, receiptCount] = await Promise.all([
        Transaction.count({
          where: { contactId, type: { [Contact.sequelize.Op.or]: ['sale', 'quote'] }, deletedAt: null },
        }),
        Transaction.count({
          where: { contactId, type: { [Contact.sequelize.Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null },
        }),
        Payment.count({
          where: { contactId, type: 'payment', deletedAt: null },
        }),
        Payment.count({
          where: { contactId, type: 'receipt', deletedAt: null },
        }),
      ]);
      
      // Get financial totals
      const [totalSales, totalPurchases, totalPayments, totalReceipts] = await Promise.all([
        Transaction.sum('total', {
          where: { contactId, type: { [Contact.sequelize.Op.or]: ['sale', 'quote'] }, deletedAt: null },
        }),
        Transaction.sum('total', {
          where: { contactId, type: { [Contact.sequelize.Op.or]: ['purchase', 'purchase_order'] }, deletedAt: null },
        }),
        Payment.sum('amount', {
          where: { contactId, type: 'payment', deletedAt: null },
        }),
        Payment.sum('amount', {
          where: { contactId, type: 'receipt', deletedAt: null },
        }),
      ]);
      
      // Calculate balance
      const balanceData = await this.calculateBalance(contactId);
      
      return {
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
      };
    } catch (error) {
      logger.error(`Error fetching contact stats: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get transactions for a contact
   */
  static async getContactTransactions(contactId, options = {}) {
    try {
      const { page = 1, limit = 10, type, status, paymentStatus } = options;
      const offset = (page - 1) * limit;
      
      const contact = await Contact.findByPk(contactId);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      const where = { contactId, deletedAt: null };
      
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
      
      return {
        data: transactions.rows,
        pagination: {
          total: transactions.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(transactions.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error fetching contact transactions: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get payments for a contact
   */
  static async getContactPayments(contactId, options = {}) {
    try {
      const { page = 1, limit = 10, type, status, method } = options;
      const offset = (page - 1) * limit;
      
      const contact = await Contact.findByPk(contactId);
      
      if (!contact) {
        throw new Error('Contact not found');
      }
      
      const where = { contactId, deletedAt: null };
      
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
      
      return {
        data: payments.rows,
        pagination: {
          total: payments.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(payments.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error fetching contact payments: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Search contacts
   */
  static async searchContacts(query, options = {}) {
    try {
      const { companyId, type, page = 1, limit = 10 } = options;
      const offset = (page - 1) * limit;
      
      if (!query) {
        throw new Error('Search query is required');
      }
      
      const where = { deletedAt: null };
      
      if (companyId) {
        where.companyId = companyId;
      }
      
      if (type) {
        where.type = type;
      }
      
      where[Contact.sequelize.Op.or] = [
        { firstName: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { lastName: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { fullName: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { nepaliName: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { phone: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { mobile: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { email: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { panNumber: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
        { vatNumber: { [Contact.sequelize.Op.iLike]: `%${query}%` } },
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
      
      return {
        data: contacts.rows,
        pagination: {
          total: contacts.count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(contacts.count / limit),
        },
      };
    } catch (error) {
      logger.error(`Error searching contacts: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get customer count for a company
   */
  static async getCustomerCount(companyId) {
    try {
      return await Contact.count({
        where: { companyId, type: { [Contact.sequelize.Op.or]: ['customer', 'both'] }, deletedAt: null },
      });
    } catch (error) {
      logger.error(`Error getting customer count: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get supplier count for a company
   */
  static async getSupplierCount(companyId) {
    try {
      return await Contact.count({
        where: { companyId, type: { [Contact.sequelize.Op.or]: ['supplier', 'both'] }, deletedAt: null },
      });
    } catch (error) {
      logger.error(`Error getting supplier count: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get total outstanding for customers
   */
  static async getTotalOutstanding(companyId, type = 'customer') {
    try {
      const contacts = await Contact.findAll({
        where: {
          companyId,
          type: type === 'customer' ? { [Contact.sequelize.Op.or]: ['customer', 'both'] } : { [Contact.sequelize.Op.or]: ['supplier', 'both'] },
          deletedAt: null,
        },
        attributes: ['id', 'type', 'openingBalance', 'totalPurchases', 'totalSales', 'totalPayments', 'totalReceipts'],
      });
      
      let total = 0;
      
      contacts.forEach(contact => {
        if (type === 'customer') {
          total += (contact.openingBalance || 0) + (contact.totalSales || 0) - (contact.totalReceipts || 0);
        } else {
          total += (contact.openingBalance || 0) + (contact.totalPurchases || 0) - (contact.totalPayments || 0);
        }
      });
      
      return total;
    } catch (error) {
      logger.error(`Error getting total outstanding: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Get contacts with outstanding balance
   */
  static async getContactsWithBalance(companyId, balanceType = 'positive') {
    try {
      const contacts = await Contact.findAll({
        where: {
          companyId,
          [Contact.sequelize.Op.and]: [
            {
              [Contact.sequelize.Op.or]: [
                { type: 'customer' },
                { type: 'both' },
              ],
            },
            {
              [Contact.sequelize.Op[balanceType === 'positive' ? 'gt' : 'lt']]: Contact.sequelize.literal(`
                (opening_balance + COALESCE(total_sales, 0) - COALESCE(total_receipts, 0)) 
                ${balanceType === 'positive' ? '>' : '<'} 0
              `),
            },
          ],
          deletedAt: null,
        },
        order: [['firstName', 'ASC'], ['lastName', 'ASC']],
      });
      
      return contacts;
    } catch (error) {
      logger.error(`Error getting contacts with balance: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Log audit
   */
  static async _logAudit(userId, companyId, entityType, entityId, action, oldValues, newValues, description) {
    const AuditLogModel = require('../models/AuditLog');
    
    await AuditLogModel.log({
      userId,
      companyId,
      entityType,
      entityId,
      action,
      oldValues,
      newValues,
      description,
    });
  }
}

module.exports = ContactService;
