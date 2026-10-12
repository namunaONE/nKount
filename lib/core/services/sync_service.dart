import 'package:logger/logger.dart';
import '../database/hive_service.dart';
import '../models/sync_log_model.dart';

/// Sync Service (offline-first, queue-only).
///
/// P1 scope: the app is offline-only (see production plan). There is no
/// backend yet, so this service only records outgoing operations in the local
/// [SyncLogModel] queue. A future backend (Supabase/PowerSync) will drain the
/// queue; until then [syncAll] is a no-op that reports pending counts.
///
/// Write path must use immutable `copyWith` – [SyncLogModel] is freezed.
class SyncService {
  factory SyncService() => _instance;

  SyncService._internal();
  static final SyncService _instance = SyncService._internal();
  static final Logger _logger = Logger();

  /// Initialize sync service (no-op offline; kept for API stability).
  void initialize() {
    _logger.i('Sync service initialized (offline queue mode)');
  }

  /// Queue an outgoing operation for future upload.
  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String action,
    Map<String, dynamic>? requestData,
    String? createdBy,
  }) async {
    try {
      final log = SyncLogModel.create(
        entityType: entityType,
        entityId: entityId,
        action: action,
        requestData: requestData,
        createdBy: createdBy,
      );
      await hiveService.syncLogsBox.add(log);
      _logger.i('Queued sync: $entityType $entityId ($action)');
    } on Exception catch (_) {
      _logger.e('Error queueing sync');
      rethrow;
    }
  }

  /// Number of operations waiting for a future backend.
  int get pendingCount {
    try {
      return hiveService.syncLogsBox.values
          .where((log) => log.isPending)
          .length;
    } on Exception catch (_) {
      return 0;
    }
  }

  /// Offline status snapshot for UI/diagnostics.
  Map<String, dynamic> getSyncStatus() {
    try {
      final logs = hiveService.syncLogsBox.values.toList();
      return {
        'isOnline': false,
        'isSyncing': false,
        'pending': logs.where((log) => log.isPending).length,
        'failed': logs.where((log) => log.isFailed).length,
        'conflicts': logs.where((log) => log.hasConflict).length,
      };
    } on Exception catch (_) {
      return {
        'isOnline': false,
        'isSyncing': false,
        'pending': 0,
        'failed': 0,
        'conflicts': 0,
      };
    }
  }

  /// No-op until a backend exists. Kept so callers don't branch on mode.
  Future<void> syncAll() async {
    _logger.i(
      'syncAll skipped: offline queue mode ($pendingCount pending)',
    );
  }

  /// Dispose sync service (no timers in offline mode).
  void dispose() {
    _logger.i('Sync service disposed');
  }
}

// Singleton instance
final syncService = SyncService();
