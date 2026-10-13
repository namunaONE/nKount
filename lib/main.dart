import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'core/database/database_initializer.dart';
import 'app/app.dart';

/// Logger setup
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 100,
    colors: true,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.none,
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

    logger.i('nKount initialized successfully');

    runApp(
      const ProviderScope(
        child: NKountApp(),
      ),
    );
  } on Exception catch (e) {
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
