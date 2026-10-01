import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/database_initializer.dart';
import 'package:nkount/core/services/sync_service.dart';
import 'package:nkount/features/app/app.dart';
import 'package:path_provider/path_provider.dart';

/// Logger setup
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 100,
    colors: true,
    printEmojis: false,
    printTime: true,
  ),
);

/// Main entry point for the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Set system UI overlay style
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  try {
    // Initialize Hive for web (IndexedDB)
    // Note: For Flutter web, we don't need path_provider
    // Hive will automatically use IndexedDB
    
    // Initialize database
    await databaseInitializer.initialize();
    
    // Initialize sync service (offline-first)
    syncService.initialize();
    
    logger.i('nKount initialized successfully');
    
    runApp(
      const ProviderScope(
        child: NKountApp(),
      ),
    );
  } catch (e) {
    logger.e('Failed to initialize nKount: $e');
    
    // Fallback to basic app if initialization fails
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize application. Please try again.'),
          ),
        ),
      ),
    );
  }
}
