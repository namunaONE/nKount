import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../database/hive_service.dart';
import '../models/sync_log_model.dart';
import '../constants/app_constants.dart';

/// Sync Service
/// Handles offline-first synchronization between local and server data
class SyncService {
  static final SyncService _instance = SyncService._internal();
  static final Logger _logger = Logger();
  static final Uuid _uuid = Uuid();
  
  // Sync configuration
  final Duration _syncInterval = const Duration(seconds: 30);
  final int _batchSize = 100;
  final int _maxRetries = 3;
  
  // Sync state
  bool _isSyncing = false;
  bool _isOnline = true;
  Timer? _syncTimer;
  DateTime? _lastSyncTime;
  
  // API configuration
  String _apiUrl = AppConstants.apiUrl;
  String? _authToken;
  String? _deviceId;
  
  // Private constructor
  SyncService._internal() {
    _deviceId = _generateDeviceId();
  }
  
  // Factory constructor
  factory SyncService() => _instance;
  
  /// Generate a unique device ID
  String _generateDeviceId() {
    return 'device-${_uuid.v4()}';
  }
  
  /// Initialize sync service
  void initialize({
    String? apiUrl,
    String? authToken,
    Duration? syncInterval,
    int? batchSize,
  }) {
    if (apiUrl != null) {
      _apiUrl = apiUrl;
    }
    if (authToken != null) {
      _authToken = authToken;
    }
    
    // Start periodic sync
    startPeriodicSync();
    
    // Check online status
    _checkOnlineStatus();
    
    _logger.i('Sync service initialized');
  }
  
  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
    _logger.i('Auth token set');
  }
  
  /// Clear authentication token
  void clearAuthToken() {
    _authToken = null;
    _logger.i('Auth token cleared');
  }
  
  /// Check if online
  bool get isOnline => _isOnline;
  
  /// Check if syncing
  bool get isSyncing => _isSyncing;
  
  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;
  
  /// Check online status
  Future<void> _checkOnlineStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      );
      _isOnline = response.statusCode == 200;
      _logger.i('Online status: $_isOnline');
    } catch (e) {
      _isOnline = false;
      _logger.e('Error checking online status: $e');
    }
  }
  
  /// Start periodic sync
  void startPeriodicSync() {
    if (_syncTimer != null) {
      _syncTimer!.cancel();
    }
    
    _syncTimer = Timer.periodic(_syncInterval, (timer) {
      if (_isOnline && !_isSyncing) {
        syncAll();
      }
    });
    
    _logger.i('Periodic sync started (every ${_syncInterval.inSeconds} seconds)');
  }
  
  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _logger.i('Periodic sync stopped');
  }
  
  /// Sync all data
  Future<void> syncAll() async {
    if (_isSyncing) {
      _logger.i('Sync already in progress, skipping...');
      return;
    }
    
    try {
      _isSyncing = true;
      _logger.i('Starting full sync...');
      
      // Check if online
      await _checkOnlineStatus();
      if (!_isOnline) {
        _logger.i('Offline, skipping sync');
        return;
      }
      
      // Create batch ID
      final batchId = _uuid.v4();
      final startTime = DateTime.now();
      
      // Get pending sync logs
      final pendingLogs = hiveService.syncLogsBox.values
          .where((log) => log.status == SyncStatus.pending)
          .toList();
      
      _logger.i('Found ${pendingLogs.length} pending sync items');
      
      // Process in batches
      final batches = _splitIntoBatches(pendingLogs, _batchSize);
      
      for (final batch in batches) {
        await _processSyncBatch(batch, batchId);
      }
      
      // Pull changes from server
      await _pullServerChanges();
      
      _lastSyncTime = DateTime.now();
      _logger.i('Full sync completed in ${_lastSyncTime!.difference(startTime).inMilliseconds}ms');
      
    } catch (e) {
      _logger.e('Error during full sync: $e');
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Process a batch of sync items
  Future<void> _processSyncBatch(List<SyncLogModel> batch, String batchId) async {
    try {
      final updates = <SyncLogModel>[];
      
      for (final log in batch) {
        try {
          await _processSyncItem(log);
          log.status = SyncStatus.completed;
          log.batchId = batchId;
          updates.add(log);
        } catch (e) {
          _logger.e('Error processing sync item ${log.entityId}: $e');
          log.status = SyncStatus.failed;
          log.error = e.toString();
          log.retryCount++;
          updates.add(log);
        }
      }
      
      // Update sync logs
      for (final log in updates) {
        await hiveService.syncLogsBox.put(log.id, log);
      }
      
      _logger.i('Processed batch of ${batch.length} items');
      
    } catch (e) {
      _logger.e('Error processing sync batch: $e');
    }
  }
  
  /// Process a single sync item
  Future<void> _processSyncItem(SyncLogModel log) async {
    try {
      switch (log.entityType) {
        case 'company':
          await _syncCompany(log);
          break;
        case 'contact':
          await _syncContact(log);
          break;
        case 'product':
          await _syncProduct(log);
          break;
        case 'category':
          await _syncCategory(log);
          break;
        case 'brand':
          await _syncBrand(log);
          break;
        case 'unit':
          await _syncUnit(log);
          break;
        case 'tax_rate':
          await _syncTaxRate(log);
          break;
        case 'transaction':
          await _syncTransaction(log);
          break;
        case 'transaction_item':
          await _syncTransactionItem(log);
          break;
        case 'payment':
          await _syncPayment(log);
          break;
        case 'setting':
          await _syncSetting(log);
          break;
        default:
          _logger.w('Unknown entity type: ${log.entityType}');
      }
      
    } catch (e) {
      _logger.e('Error syncing ${log.entityType} ${log.entityId}: $e');
      rethrow;
    }
  }
  
  /// Sync company
  Future<void> _syncCompany(SyncLogModel log) async {
    // Implementation depends on your API endpoints
    // This is a placeholder - implement based on your backend API
    _logger.i('Syncing company: ${log.entityId}');
  }
  
  /// Sync contact
  Future<void> _syncContact(SyncLogModel log) async {
    _logger.i('Syncing contact: ${log.entityId}');
  }
  
  /// Sync product
  Future<void> _syncProduct(SyncLogModel log) async {
    _logger.i('Syncing product: ${log.entityId}');
  }
  
  /// Sync category
  Future<void> _syncCategory(SyncLogModel log) async {
    _logger.i('Syncing category: ${log.entityId}');
  }
  
  /// Sync brand
  Future<void> _syncBrand(SyncLogModel log) async {
    _logger.i('Syncing brand: ${log.entityId}');
  }
  
  /// Sync unit
  Future<void> _syncUnit(SyncLogModel log) async {
    _logger.i('Syncing unit: ${log.entityId}');
  }
  
  /// Sync tax rate
  Future<void> _syncTaxRate(SyncLogModel log) async {
    _logger.i('Syncing tax rate: ${log.entityId}');
  }
  
  /// Sync transaction
  Future<void> _syncTransaction(SyncLogModel log) async {
    _logger.i('Syncing transaction: ${log.entityId}');
  }
  
  /// Sync transaction item
  Future<void> _syncTransactionItem(SyncLogModel log) async {
    _logger.i('Syncing transaction item: ${log.entityId}');
  }
  
  /// Sync payment
  Future<void> _syncPayment(SyncLogModel log) async {
    _logger.i('Syncing payment: ${log.entityId}');
  }
  
  /// Sync setting
  Future<void> _syncSetting(SyncLogModel log) async {
    _logger.i('Syncing setting: ${log.entityId}');
  }
  
  /// Pull changes from server
  Future<void> _pullServerChanges() async {
    try {
      _logger.i('Pulling server changes...');
      
      // Get last sync time
      final lastSync = _lastSyncTime ?? DateTime(1970);
      
      // Fetch changes from server since last sync
      final response = await http.get(
        Uri.parse('$_apiUrl/api/v1/sync/changes?since=${lastSync.toIso8601String()}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'X-Device-ID': _deviceId!,
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final changes = data['data'] as List? ?? [];
        
        _logger.i('Found ${changes.length} changes from server');
        
        // Process changes
        for (final change in changes) {
          await _processServerChange(change);
        }
        
        _logger.i('Server changes pulled successfully');
      } else {
        _logger.e('Error pulling server changes: ${response.statusCode} - ${response.body}');
      }
      
    } catch (e) {
      _logger.e('Error pulling server changes: $e');
    }
  }
  
  /// Process a change from server
  Future<void> _processServerChange(Map<String, dynamic> change) async {
    try {
      final entityType = change['entityType'] as String;
      final action = change['action'] as String;
      final data = change['data'];
      
      _logger.i('Processing server change: $entityType $action');
      
      switch (entityType) {
        case 'company':
          await _processCompanyChange(action, data);
          break;
        case 'contact':
          await _processContactChange(action, data);
          break;
        case 'product':
          await _processProductChange(action, data);
          break;
        case 'category':
          await _processCategoryChange(action, data);
          break;
        case 'brand':
          await _processBrandChange(action, data);
          break;
        case 'unit':
          await _processUnitChange(action, data);
          break;
        case 'tax_rate':
          await _processTaxRateChange(action, data);
          break;
        case 'transaction':
          await _processTransactionChange(action, data);
          break;
        case 'transaction_item':
          await _processTransactionItemChange(action, data);
          break;
        case 'payment':
          await _processPaymentChange(action, data);
          break;
        case 'setting':
          await _processSettingChange(action, data);
          break;
        default:
          _logger.w('Unknown entity type: $entityType');
      }
      
    } catch (e) {
      _logger.e('Error processing server change: $e');
    }
  }
  
  /// Process company change
  Future<void> _processCompanyChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert company
        break;
      case 'delete':
        // Delete company
        break;
    }
  }
  
  /// Process contact change
  Future<void> _processContactChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert contact
        break;
      case 'delete':
        // Delete contact
        break;
    }
  }
  
  /// Process product change
  Future<void> _processProductChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert product
        break;
      case 'delete':
        // Delete product
        break;
    }
  }
  
  /// Process category change
  Future<void> _processCategoryChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert category
        break;
      case 'delete':
        // Delete category
        break;
    }
  }
  
  /// Process brand change
  Future<void> _processBrandChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert brand
        break;
      case 'delete':
        // Delete brand
        break;
    }
  }
  
  /// Process unit change
  Future<void> _processUnitChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert unit
        break;
      case 'delete':
        // Delete unit
        break;
    }
  }
  
  /// Process tax rate change
  Future<void> _processTaxRateChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert tax rate
        break;
      case 'delete':
        // Delete tax rate
        break;
    }
  }
  
  /// Process transaction change
  Future<void> _processTransactionChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert transaction
        break;
      case 'delete':
        // Delete transaction
        break;
    }
  }
  
  /// Process transaction item change
  Future<void> _processTransactionItemChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert transaction item
        break;
      case 'delete':
        // Delete transaction item
        break;
    }
  }
  
  /// Process payment change
  Future<void> _processPaymentChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert payment
        break;
      case 'delete':
        // Delete payment
        break;
    }
  }
  
  /// Process setting change
  Future<void> _processSettingChange(String action, Map<String, dynamic>? data) async {
    if (data == null) return;
    
    switch (action) {
      case 'create':
      case 'update':
        // Upsert setting
        break;
      case 'delete':
        // Delete setting
        break;
    }
  }
  
  /// Add a sync log entry
  Future<void> addSyncLog({
    required String entityType,
    required String entityId,
    required SyncAction action,
    required SyncDirection direction,
    Map<String, dynamic>? localData,
    Map<String, dynamic>? serverData,
    String? batchId,
  }) async {
    try {
      final log = SyncLogModel(
        id: _uuid.v4(),
        companyId: '', // Will be set based on entity
        entityType: entityType,
        entityId: entityId,
        action: action,
        direction: direction,
        status: SyncStatus.pending,
        localData: localData,
        serverData: serverData,
        localTimestamp: DateTime.now(),
        serverTimestamp: null,
        retryCount: 0,
        error: null,
        conflictResolved: false,
        conflictResolution: null,
        mergedData: null,
        batchId: batchId,
        deviceId: _deviceId,
        deviceName: 'Flutter Web',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await hiveService.syncLogsBox.add(log);
      _logger.i('Sync log added: ${log.entityType} ${log.entityId}');
      
    } catch (e) {
      _logger.e('Error adding sync log: $e');
      rethrow;
    }
  }
  
  /// Split list into batches
  List<List<T>> _splitIntoBatches<T>(List<T> list, int batchSize) {
    final batches = <List<T>>[];
    
    for (var i = 0; i < list.length; i += batchSize) {
      final end = i + batchSize > list.length ? list.length : i + batchSize;
      batches.add(list.sublist(i, end));
    }
    
    return batches;
  }
  
  /// Force sync a specific entity
  Future<void> syncEntity({
    required String entityType,
    required String entityId,
  }) async {
    try {
      // Create sync log
      await addSyncLog(
        entityType: entityType,
        entityId: entityId,
        action: SyncAction.sync,
        direction: SyncDirection.both,
      );
      
      // Trigger sync
      await syncAll();
      
      _logger.i('Entity sync requested: $entityType $entityId');
      
    } catch (e) {
      _logger.e('Error syncing entity: $e');
      rethrow;
    }
  }
  
  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    final pending = hiveService.syncLogsBox.values
        .where((log) => log.status == SyncStatus.pending)
        .length;
    final failed = hiveService.syncLogsBox.values
        .where((log) => log.status == SyncStatus.failed)
        .length;
    final conflicts = hiveService.syncLogsBox.values
        .where((log) => log.status == SyncStatus.conflict)
        .length;
    
    return {
      'isOnline': _isOnline,
      'isSyncing': _isSyncing,
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'pending': pending,
      'failed': failed,
      'conflicts': conflicts,
      'deviceId': _deviceId,
    };
  }
  
  /// Resolve a conflict
  Future<void> resolveConflict({
    required String syncLogId,
    required ConflictResolution resolution,
    Map<String, dynamic>? mergedData,
  }) async {
    try {
      final log = hiveService.syncLogsBox.get(syncLogId);
      if (log == null) {
        throw Exception('Sync log not found');
      }
      
      log.status = SyncStatus.completed;
      log.conflictResolved = true;
      log.conflictResolution = resolution;
      log.mergedData = mergedData;
      log.updatedAt = DateTime.now();
      
      await hiveService.syncLogsBox.put(syncLogId, log);
      
      _logger.i('Conflict resolved: $syncLogId');
      
    } catch (e) {
      _logger.e('Error resolving conflict: $e');
      rethrow;
    }
  }
  
  /// Retry failed sync items
  Future<void> retryFailedItems() async {
    try {
      final failedLogs = hiveService.syncLogsBox.values
          .where((log) => log.status == SyncStatus.failed && log.retryCount < _maxRetries)
          .toList();
      
      _logger.i('Retrying ${failedLogs.length} failed sync items');
      
      for (final log in failedLogs) {
        log.status = SyncStatus.pending;
        await hiveService.syncLogsBox.put(log.id, log);
      }
      
      // Trigger sync
      await syncAll();
      
    } catch (e) {
      _logger.e('Error retrying failed items: $e');
      rethrow;
    }
  }
  
  /// Dispose sync service
  void dispose() {
    stopPeriodicSync();
    _logger.i('Sync service disposed');
  }
}

// Enums
enum SyncAction {
  create,
  read,
  update,
  delete,
  sync,
}

enum SyncDirection {
  push,
  pull,
  both,
}

enum SyncStatus {
  pending,
  inProgress,
  completed,
  failed,
  conflict,
}

enum ConflictResolution {
  serverWins,
  clientWins,
  merged,
  manual,
}

// Singleton instance
final syncService = SyncService();
