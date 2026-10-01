import 'package:logger/logger.dart';
import 'package:nkount/core/models/tax_rate_model.dart';
import 'package:nkount/core/models/unit_model.dart';
import 'package:nkount/core/models/category_model.dart';
import 'package:nkount/core/models/setting_model.dart';
import 'hive_service.dart';

/// Database Initializer for nKount
/// Creates default data and ensures database is ready for use
class DatabaseInitializer {
  static final DatabaseInitializer _instance = DatabaseInitializer._internal();
  static final Logger _logger = Logger();
  
  // Initialization flag
  bool _isInitialized = false;
  
  // Private constructor
  DatabaseInitializer._internal();
  
  // Factory constructor
  factory DatabaseInitializer() => _instance;
  
  /// Initialize the database with default data
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.i('Database already initialized');
      return;
    }
    
    try {
      _logger.i('Initializing database...');
      
      // Initialize Hive
      await hiveService.initialize();
      
      // Check if we need to create default data
      await _createDefaultData();
      
      _isInitialized = true;
      _logger.i('Database initialized successfully');
    } catch (e) {
      _logger.e('Error initializing database: $e');
      rethrow;
    }
  }
  
  /// Create default data if not exists
  Future<void> _createDefaultData() async {
    _logger.i('Creating default data...');
    
    // Create default units
    await _createDefaultUnits();
    
    // Create default categories
    await _createDefaultCategories();
    
    // Create default tax rates (including 13% VAT for Nepal)
    await _createDefaultTaxRates();
    
    // Create default settings
    await _createDefaultSettings();
    
    _logger.i('Default data created');
  }
  
  /// Create default units of measurement
  Future<void> _createDefaultUnits() async {
    final units = [
      UnitModel.createBaseUnit(
        name: 'Unit',
        code: 'UNIT',
        description: 'Default unit of measurement',
      ),
      UnitModel.createBaseUnit(
        name: 'Piece',
        code: 'PCS',
        description: 'Individual piece or item',
      ),
      UnitModel.createBaseUnit(
        name: 'Kilogram',
        code: 'KG',
        description: 'Kilogram weight unit',
      ),
      UnitModel.createBaseUnit(
        name: 'Gram',
        code: 'GM',
        description: 'Gram weight unit',
      ),
      UnitModel.createBaseUnit(
        name: 'Liter',
        code: 'LTR',
        description: 'Liter volume unit',
      ),
      UnitModel.createBaseUnit(
        name: 'Milliliter',
        code: 'ML',
        description: 'Milliliter volume unit',
      ),
      UnitModel.createBaseUnit(
        name: 'Meter',
        code: 'MTR',
        description: 'Meter length unit',
      ),
      UnitModel.createBaseUnit(
        name: 'Centimeter',
        code: 'CM',
        description: 'Centimeter length unit',
      ),
      UnitModel.create(
        name: 'Dozen',
        code: 'DZN',
        description: '12 units',
        baseUnitMultiplier: 12.0,
        baseUnitId: '', // Will be set after creating base unit
      ),
      UnitModel.create(
        name: 'Gross',
        code: 'GROSS',
        description: '144 units (12 dozen)',
        baseUnitMultiplier: 144.0,
        baseUnitId: '',
      ),
    ];
    
    // Check if units already exist
    if (hiveService.unitsBox.isEmpty) {
      for (final unit in units) {
        await hiveService.unitsBox.add(unit);
      }
      _logger.i('Default units created');
    } else {
      _logger.i('Default units already exist, skipping creation');
    }
  }
  
  /// Create default product categories
  Future<void> _createDefaultCategories() async {
    final categories = [
      CategoryModel.create(
        name: 'Electronics',
        description: 'Electronic devices and components',
        sortOrder: 1,
      ),
      CategoryModel.create(
        name: 'Clothing',
        description: 'Apparel and fashion items',
        sortOrder: 2,
      ),
      CategoryModel.create(
        name: 'Food & Beverages',
        description: 'Food and drink products',
        sortOrder: 3,
      ),
      CategoryModel.create(
        name: 'Groceries',
        description: 'Daily grocery items',
        sortOrder: 4,
      ),
      CategoryModel.create(
        name: 'Stationery',
        description: 'Office and school supplies',
        sortOrder: 5,
      ),
      CategoryModel.create(
        name: 'Hardware',
        description: 'Construction and hardware materials',
        sortOrder: 6,
      ),
      CategoryModel.create(
        name: 'Furniture',
        description: 'Home and office furniture',
        sortOrder: 7,
      ),
      CategoryModel.create(
        name: 'Services',
        description: 'Service-related items',
        sortOrder: 8,
      ),
      CategoryModel.create(
        name: 'Miscellaneous',
        description: 'Other items not categorized elsewhere',
        sortOrder: 9,
      ),
    ];
    
    // Check if categories already exist
    if (hiveService.categoriesBox.isEmpty) {
      for (final category in categories) {
        await hiveService.categoriesBox.add(category);
      }
      _logger.i('Default categories created');
    } else {
      _logger.i('Default categories already exist, skipping creation');
    }
  }
  
  /// Create default tax rates for Nepal
  Future<void> _createDefaultTaxRates() async {
    final taxRates = [
      TaxRateModel.createVatRate(),
      TaxRateModel.create(
        name: 'VAT (0%)',
        code: 'VAT0',
        rate: 0.0,
        description: 'Zero-rated VAT',
        isVat: true,
        isActive: true,
      ),
      TaxRateModel.create(
        name: 'Service Charge',
        code: 'SERVICE',
        rate: 10.0,
        description: 'Service charge',
        isVat: false,
        isActive: true,
      ),
      TaxRateModel.create(
        name: 'Excise Duty',
        code: 'EXCISE',
        rate: 5.0,
        description: 'Excise duty on specific goods',
        isVat: false,
        isActive: true,
      ),
    ];
    
    // Check if tax rates already exist
    if (hiveService.taxRatesBox.isEmpty) {
      for (final taxRate in taxRates) {
        await hiveService.taxRatesBox.add(taxRate);
      }
      _logger.i('Default tax rates created');
    } else {
      _logger.i('Default tax rates already exist, skipping creation');
    }
  }
  
  /// Create default settings
  Future<void> _createDefaultSettings() async {
    // Check if settings already exist
    if (hiveService.settingsBox.isNotEmpty) {
      _logger.i('Default settings already exist, skipping creation');
      return;
    }
    
    // Create default settings for the application
    final settings = SettingModel.createDefaultSettings();
    
    for (final setting in settings) {
      await hiveService.settingsBox.add(setting);
    }
    
    _logger.i('Default settings created');
  }
  
  /// Check if database is initialized
  bool get isInitialized => _isInitialized;
  
  /// Reset database (clear all data and recreate defaults)
  Future<void> resetDatabase() async {
    try {
      _logger.i('Resetting database...');
      
      // Close existing boxes
      await hiveService.close();
      
      // Clear all data
      await hiveService.clearAllData();
      
      // Reinitialize
      _isInitialized = false;
      await initialize();
      
      _logger.i('Database reset completed');
    } catch (e) {
      _logger.e('Error resetting database: $e');
      rethrow;
    }
  }
  
  /// Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final stats = hiveService.getBoxStats();
    
    return {
      'boxes': stats,
      'total_records': stats.values.fold(0, (sum, count) => sum + count),
      'is_initialized': _isInitialized,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

// Singleton instance
final databaseInitializer = DatabaseInitializer();
