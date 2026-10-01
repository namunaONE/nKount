/**
 * Accounting Service
 * Core accounting business logic and calculations
 */

const { Transaction, TransactionItem, Payment, Contact, Product, Company } = require('../models');
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
    new createLogger.transports.File({ filename: 'logs/accounting-service.log' })
  ]
});

class AccountingService {
  /**
   * Calculate VAT for a transaction
   */
  static calculateVAT(subtotal, vatRate = config.ird.vatRate) {
    return subtotal * (vatRate / 100);
  }
  
  /**
   * Calculate total amount for a transaction
   */
  static calculateTransactionTotal(transaction) {
    let subtotal = transaction.subtotal || 0;
    
    // Apply discount
    if (transaction.discount && transaction.discount > 0) {
      if (transaction.discountType === 'percentage') {
        subtotal -= subtotal * (transaction.discount / 100);
      } else {
        subtotal -= transaction.discount;
      }
    }
    
    // Add tax
    const taxAmount = this.calculateVAT(subtotal, transaction.taxRate || config.ird.vatRate);
    
    // Add shipping cost
    const shippingCost = transaction.shippingCost || 0;
    
    return subtotal + taxAmount + shippingCost;
  }
  
  /**
   * Calculate item total with tax
   */
  static calculateItemTotal(item) {
    const quantity = item.quantity || 0;
    const unitPrice = item.unitPrice || 0;
    const discount = item.discount || 0;
    const discountType = item.discountType || 'percentage';
    const taxRate = item.taxRate || 0;
    
    // Calculate subtotal
    let subtotal = quantity * unitPrice;
    
    // Apply discount
    if (discount > 0) {
      if (discountType === 'percentage') {
        subtotal -= subtotal * (discount / 100);
      } else {
        subtotal -= discount * quantity;
      }
    }
    
    // Calculate tax
    const taxAmount = subtotal * (taxRate / 100);
    
    return subtotal + taxAmount;
  }
  
  /**
   * Calculate profit for a transaction item
   */
  static calculateItemProfit(item) {
    const quantity = item.quantity || 0;
    const unitPrice = item.unitPrice || 0;
    const costPrice = item.costPrice || 0;
    
    return (unitPrice - costPrice) * quantity;
  }
  
  /**
   * Calculate profit margin percentage
   */
  static calculateProfitMargin(costPrice, sellingPrice) {
    if (costPrice === 0) return 0;
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }
  
  /**
   * Calculate outstanding balance for a contact
   */
  static async calculateContactBalance(contactId) {
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
        totalSales,
        totalPurchases,
        totalReceipts,
        totalPayments,
        openingBalance: contact.openingBalance || 0,
      };
    } catch (error) {
      logger.error(`Error calculating contact balance: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Calculate company financial position
   */
  static async calculateFinancialPosition(companyId, startDate, endDate) {
    try {
      // Get totals
      const [totalSales, totalPurchases, totalPayments, totalReceipts] = await Promise.all([
        Transaction.getTotalSales(companyId, startDate, endDate),
        Transaction.getTotalPurchases(companyId, startDate, endDate),
        Payment.getTotalPayments(companyId, startDate, endDate),
        Payment.getTotalReceipts(companyId, startDate, endDate),
      ]);
      
      // Calculate net income
      const netIncome = (totalSales || 0) - (totalPurchases || 0);
      
      // Calculate cash flow
      const cashIn = totalReceipts || 0;
      const cashOut = totalPayments || 0;
      const netCashFlow = cashIn - cashOut;
      
      // Calculate outstanding
      const [outstandingReceivables, outstandingPayables] = await Promise.all([
        Contact.getTotalOutstanding(companyId, 'customer'),
        Contact.getTotalOutstanding(companyId, 'supplier'),
      ]);
      
      // Calculate working capital
      const workingCapital = (outstandingReceivables || 0) - (outstandingPayables || 0);
      
      return {
        revenue: {
          totalSales: totalSales || 0,
          totalReceipts: totalReceipts || 0,
        },
        expenses: {
          totalPurchases: totalPurchases || 0,
          totalPayments: totalPayments || 0,
        },
        netIncome,
        cashFlow: {
          cashIn,
          cashOut,
          netCashFlow,
        },
        receivables: {
          outstanding: outstandingReceivables || 0,
        },
        payables: {
          outstanding: outstandingPayables || 0,
        },
        workingCapital,
        currentRatio: outstandingReceivables && outstandingPayables 
          ? (outstandingReceivables / outstandingPayables).toFixed(2) 
          : 0,
      };
    } catch (error) {
      logger.error(`Error calculating financial position: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate trial balance
   */
  static async generateTrialBalance(companyId, startDate, endDate) {
    try {
      // Get all accounts (simplified - in a real system, you'd have an accounts table)
      const [contacts, products] = await Promise.all([
        Contact.findAll({ where: { companyId, deletedAt: null } }),
        Product.findAll({ where: { companyId, deletedAt: null } }),
      ]);
      
      // Calculate account balances
      const trialBalance = [];
      
      // Add contact balances (receivables/payables)
      for (const contact of contacts) {
        const balanceData = await this.calculateContactBalance(contact.id);
        
        if (contact.type === 'customer' || contact.type === 'both') {
          trialBalance.push({
            account: `${contact.firstName} ${contact.lastName} - Receivable`,
            accountType: 'Asset',
            debit: balanceData.balance > 0 ? balanceData.balance : 0,
            credit: balanceData.balance < 0 ? Math.abs(balanceData.balance) : 0,
          });
        }
        
        if (contact.type === 'supplier' || contact.type === 'both') {
          trialBalance.push({
            account: `${contact.firstName} ${contact.lastName} - Payable`,
            accountType: 'Liability',
            debit: balanceData.balance < 0 ? Math.abs(balanceData.balance) : 0,
            credit: balanceData.balance > 0 ? balanceData.balance : 0,
          });
        }
      }
      
      // Add inventory (products)
      for (const product of products) {
        const value = (product.quantity || 0) * (product.costPrice || 0);
        if (value > 0) {
          trialBalance.push({
            account: `${product.name} - Inventory`,
            accountType: 'Asset',
            debit: value,
            credit: 0,
          });
        }
      }
      
      // Add sales revenue
      const totalSales = await Transaction.getTotalSales(companyId, startDate, endDate);
      if (totalSales > 0) {
        trialBalance.push({
          account: 'Sales Revenue',
          accountType: 'Revenue',
          debit: 0,
          credit: totalSales,
        });
      }
      
      // Add purchase expenses
      const totalPurchases = await Transaction.getTotalPurchases(companyId, startDate, endDate);
      if (totalPurchases > 0) {
        trialBalance.push({
          account: 'Purchase Expense',
          accountType: 'Expense',
          debit: totalPurchases,
          credit: 0,
        });
      }
      
      // Calculate totals
      const totalDebit = trialBalance.reduce((sum, item) => sum + (item.debit || 0), 0);
      const totalCredit = trialBalance.reduce((sum, item) => sum + (item.credit || 0), 0);
      
      return {
        entries: trialBalance,
        totals: {
          debit: totalDebit,
          credit: totalCredit,
          difference: totalDebit - totalCredit,
        },
        period: {
          startDate,
          endDate,
        },
      };
    } catch (error) {
      logger.error(`Error generating trial balance: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate balance sheet
   */
  static async generateBalanceSheet(companyId, asOfDate) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      // Get financial position
      const financialPosition = await this.calculateFinancialPosition(companyId, null, asOfDate);
      
      // Get inventory value
      const inventoryValue = await Product.getTotalValue(companyId);
      
      // Get cash balance (simplified - from payments)
      const [cashIn, cashOut] = await Promise.all([
        Payment.getTotalReceipts(companyId, null, asOfDate),
        Payment.getTotalPayments(companyId, null, asOfDate),
      ]);
      const cashBalance = (cashIn || 0) - (cashOut || 0);
      
      // Assets
      const totalAssets = (financialPosition.receivables.outstanding || 0) + 
        (inventoryValue || 0) + 
        (cashBalance > 0 ? cashBalance : 0);
      
      // Liabilities
      const totalLiabilities = (financialPosition.payables.outstanding || 0) + 
        (cashBalance < 0 ? Math.abs(cashBalance) : 0);
      
      // Equity (simplified)
      const equity = totalAssets - totalLiabilities;
      
      return {
        asOf: asOfDate || new Date().toISOString().split('T')[0],
        company: {
          name: company.name,
          nepaliName: company.nepaliName,
        },
        assets: {
          currentAssets: {
            cash: cashBalance > 0 ? cashBalance : 0,
            accountsReceivable: financialPosition.receivables.outstanding || 0,
            inventory: inventoryValue || 0,
            totalCurrentAssets: (cashBalance > 0 ? cashBalance : 0) + 
              (financialPosition.receivables.outstanding || 0) + 
              (inventoryValue || 0),
          },
          totalAssets,
        },
        liabilities: {
          currentLiabilities: {
            accountsPayable: financialPosition.payables.outstanding || 0,
            cashOverdraft: cashBalance < 0 ? Math.abs(cashBalance) : 0,
            totalCurrentLiabilities: (financialPosition.payables.outstanding || 0) + 
              (cashBalance < 0 ? Math.abs(cashBalance) : 0),
          },
          totalLiabilities,
        },
        equity: {
          retainedEarnings: equity,
          totalEquity: equity,
        },
        totals: {
          totalAssets,
          totalLiabilities,
          totalEquity: equity,
          balance: totalAssets - totalLiabilities - equity, // Should be 0
        },
      };
    } catch (error) {
      logger.error(`Error generating balance sheet: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate profit and loss statement
   */
  static async generateProfitAndLoss(companyId, startDate, endDate) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      // Get financial data
      const [totalSales, totalPurchases, totalPayments, totalReceipts] = await Promise.all([
        Transaction.getTotalSales(companyId, startDate, endDate),
        Transaction.getTotalPurchases(companyId, startDate, endDate),
        Payment.getTotalPayments(companyId, startDate, endDate),
        Payment.getTotalReceipts(companyId, startDate, endDate),
      ]);
      
      // Calculate gross profit
      const grossProfit = (totalSales || 0) - (totalPurchases || 0);
      
      // Calculate net income (simplified - no other expenses)
      const netIncome = grossProfit;
      
      // Calculate gross margin percentage
      const grossMarginPercentage = totalSales > 0 ? (grossProfit / totalSales) * 100 : 0;
      
      // Calculate net margin percentage
      const netMarginPercentage = totalSales > 0 ? (netIncome / totalSales) * 100 : 0;
      
      return {
        period: {
          startDate,
          endDate,
        },
        company: {
          name: company.name,
          nepaliName: company.nepaliName,
        },
        revenue: {
          totalSales: totalSales || 0,
          totalReceipts: totalReceipts || 0,
        },
        costOfGoodsSold: {
          totalPurchases: totalPurchases || 0,
          totalPayments: totalPayments || 0,
        },
        grossProfit,
        grossMarginPercentage: grossMarginPercentage.toFixed(2),
        operatingExpenses: {
          // Placeholder for future expansion
          total: 0,
        },
        netIncome,
        netMarginPercentage: netMarginPercentage.toFixed(2),
      };
    } catch (error) {
      logger.error(`Error generating profit and loss: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate VAT report
   */
  static async generateVATReport(companyId, startDate, endDate) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      // Get all sales transactions
      const salesTransactions = await Transaction.findAll({
        where: {
          companyId,
          type: { [Transaction.sequelize.Op.or]: ['sale', 'quote'] },
          status: { [Transaction.sequelize.Op.or]: ['confirmed', 'completed'] },
          date: {
            [Transaction.sequelize.Op.gte]: startDate,
            [Transaction.sequelize.Op.lte]: endDate,
          },
          deletedAt: null,
        },
        include: [
          { model: TransactionItem, attributes: ['quantity', 'unitPrice', 'taxRate', 'taxAmount'] },
        ],
      });
      
      // Calculate VAT on sales (output VAT)
      let totalSales = 0;
      let totalOutputVAT = 0;
      
      for (const txn of salesTransactions) {
        totalSales += txn.total || 0;
        
        for (const item of txn.TransactionItems || []) {
          totalOutputVAT += item.taxAmount || 0;
        }
      }
      
      // Get all purchase transactions
      const purchaseTransactions = await Transaction.findAll({
        where: {
          companyId,
          type: { [Transaction.sequelize.Op.or]: ['purchase', 'purchase_order'] },
          status: { [Transaction.sequelize.Op.or]: ['confirmed', 'completed'] },
          date: {
            [Transaction.sequelize.Op.gte]: startDate,
            [Transaction.sequelize.Op.lte]: endDate,
          },
          deletedAt: null,
        },
        include: [
          { model: TransactionItem, attributes: ['quantity', 'unitPrice', 'taxRate', 'taxAmount'] },
        ],
      });
      
      // Calculate VAT on purchases (input VAT)
      let totalPurchases = 0;
      let totalInputVAT = 0;
      
      for (const txn of purchaseTransactions) {
        totalPurchases += txn.total || 0;
        
        for (const item of txn.TransactionItems || []) {
          totalInputVAT += item.taxAmount || 0;
        }
      }
      
      // Calculate net VAT
      const netVAT = totalOutputVAT - totalInputVAT;
      
      return {
        period: {
          startDate,
          endDate,
        },
        company: {
          name: company.name,
          nepaliName: company.nepaliName,
          panNumber: company.panNumber,
          vatNumber: company.vatNumber,
          defaultVatRate: company.defaultVatRate || config.ird.vatRate,
        },
        outputVAT: {
          totalSales,
          totalOutputVAT,
          vatRate: company.defaultVatRate || config.ird.vatRate,
        },
        inputVAT: {
          totalPurchases,
          totalInputVAT,
        },
        netVAT,
        vatPayable: netVAT > 0 ? netVAT : 0,
        vatRefundable: netVAT < 0 ? Math.abs(netVAT) : 0,
      };
    } catch (error) {
      logger.error(`Error generating VAT report: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate IRD-compliant report
   */
  static async generateIRDReport(companyId, startDate, endDate) {
    try {
      const company = await Company.findByPk(companyId);
      
      if (!company) {
        throw new Error('Company not found');
      }
      
      // Get all IRD-verified transactions
      const transactions = await Transaction.findAll({
        where: {
          companyId,
          irdVerified: true,
          date: {
            [Transaction.sequelize.Op.gte]: startDate,
            [Transaction.sequelize.Op.lte]: endDate,
          },
          deletedAt: null,
        },
        order: [['date', 'ASC'], ['transaction_number', 'ASC']],
        include: [
          { model: Contact, attributes: ['id', 'firstName', 'lastName', 'panNumber', 'vatNumber'] },
          { model: TransactionItem, attributes: ['id', 'productName', 'quantity', 'unitPrice', 'taxRate', 'taxAmount'] },
        ],
      });
      
      // Calculate totals
      let totalAmount = 0;
      let totalVAT = 0;
      let invoiceCount = 0;
      
      for (const txn of transactions) {
        totalAmount += txn.total || 0;
        
        for (const item of txn.TransactionItems || []) {
          totalVAT += item.taxAmount || 0;
        }
        
        invoiceCount++;
      }
      
      return {
        period: {
          startDate,
          endDate,
          fiscalYear: company.fiscalYearStart && company.fiscalYearEnd
            ? `${company.fiscalYearStart.toISOString().split('T')[0]} to ${company.fiscalYearEnd.toISOString().split('T')[0]}`
            : null,
        },
        company: {
          name: company.name,
          nepaliName: company.nepaliName,
          panNumber: company.panNumber,
          vatNumber: company.vatNumber,
          address: company.getFullAddress(),
        },
        summary: {
          totalInvoices: invoiceCount,
          totalAmount,
          totalVAT,
          vatRate: company.defaultVatRate || config.ird.vatRate,
        },
        transactions: transactions.map(txn => ({
          invoiceNumber: txn.transactionNumber,
          irdInvoiceNumber: txn.irdInvoiceNumber,
          date: txn.date,
          nepaliDate: txn.nepaliDate,
          customer: txn.Contact ? {
            name: `${txn.Contact.firstName} ${txn.Contact.lastName}`,
            panNumber: txn.Contact.panNumber,
            vatNumber: txn.Contact.vatNumber,
          } : null,
          subtotal: txn.subtotal,
          discount: txn.discount,
          tax: txn.tax,
          total: txn.total,
          items: (txn.TransactionItems || []).map(item => ({
            description: item.productName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            amount: (item.quantity || 0) * (item.unitPrice || 0),
            taxRate: item.taxRate,
            taxAmount: item.taxAmount,
          })),
        })),
      };
    } catch (error) {
      logger.error(`Error generating IRD report: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Calculate inventory valuation
   */
  static async calculateInventoryValuation(companyId) {
    try {
      const products = await Product.findAll({
        where: { companyId, deletedAt: null },
      });
      
      let totalValue = 0;
      const inventoryItems = [];
      
      for (const product of products) {
        const value = (product.quantity || 0) * (product.costPrice || 0);
        totalValue += value;
        
        if (value > 0) {
          inventoryItems.push({
            productId: product.id,
            productName: product.name,
            productCode: product.code,
            quantity: product.quantity || 0,
            costPrice: product.costPrice || 0,
            value,
          });
        }
      }
      
      return {
        totalValue,
        itemCount: inventoryItems.length,
        items: inventoryItems,
      };
    } catch (error) {
      logger.error(`Error calculating inventory valuation: ${error.message}`);
      throw error;
    }
  }
  
  /**
   * Generate aging report for receivables
   */
  static async generateAgingReport(companyId) {
    try {
      const contacts = await Contact.findAll({
        where: {
          companyId,
          type: { [Contact.sequelize.Op.or]: ['customer', 'both'] },
          deletedAt: null,
        },
      });
      
      const agingReport = [];
      const today = new Date();
      
      for (const contact of contacts) {
        const balanceData = await this.calculateContactBalance(contact.id);
        
        if (balanceData.balance > 0) {
          // Get all unpaid invoices for this contact
          const unpaidTransactions = await Transaction.findAll({
            where: {
              contactId: contact.id,
              companyId,
              type: { [Transaction.sequelize.Op.or]: ['sale', 'quote'] },
              paymentStatus: { [Transaction.sequelize.Op.or]: ['unpaid', 'pending', 'partially_paid'] },
              deletedAt: null,
            },
          });
          
          let current = 0;
          let days30 = 0;
          let days60 = 0;
          let days90 = 0;
          let over90 = 0;
          
          for (const txn of unpaidTransactions) {
            const dueDate = txn.dueDate ? new Date(txn.dueDate) : new Date(txn.date);
            const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
            const balance = txn.total - (txn.amountPaid || 0);
            
            if (daysOverdue <= 0) {
              current += balance;
            } else if (daysOverdue <= 30) {
              days30 += balance;
            } else if (daysOverdue <= 60) {
              days60 += balance;
            } else if (daysOverdue <= 90) {
              days90 += balance;
            } else {
              over90 += balance;
            }
          }
          
          agingReport.push({
            contact: {
              id: contact.id,
              name: `${contact.firstName} ${contact.lastName}`,
              email: contact.email,
              phone: contact.phone,
            },
            totalBalance: balanceData.balance,
            aging: {
              current,
              days30,
              days60,
              days90,
              over90,
            },
          });
        }
      }
      
      // Calculate totals
      const totals = agingReport.reduce((acc, item) => {
        acc.current += item.aging.current;
        acc.days30 += item.aging.days30;
        acc.days60 += item.aging.days60;
        acc.days90 += item.aging.days90;
        acc.over90 += item.aging.over90;
        acc.total += item.totalBalance;
        return acc;
      }, {
        current: 0,
        days30: 0,
        days60: 0,
        days90: 0,
        over90: 0,
        total: 0,
      });
      
      return {
        report: agingReport,
        totals,
        period: {
          asOf: today.toISOString().split('T')[0],
        },
      };
    } catch (error) {
      logger.error(`Error generating aging report: ${error.message}`);
      throw error;
    }
  }
}

module.exports = AccountingService;
