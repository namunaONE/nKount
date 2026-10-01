import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/services/local_storage_service.dart';
import 'package:nkount/core/utils/theme/app_theme.dart';
import 'package:nkount/features/dashboard/presentation/dashboard_screen.dart';

/// Main application widget
class NKountApp extends ConsumerWidget {
  const NKountApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize services
    final storageService = ref.watch(localStorageServiceProvider);
    
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light for accounting apps
      locale: const Locale('en', 'NP'), // English with Nepal context
      supportedLocales: const [
        Locale('en', 'NP'),
        Locale('ne', 'NP'), // Nepali
      ],
      localizationsDelegates: const [
        // Add localization delegates here
      ],
      home: const DashboardScreen(),
      // onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

/// Entry point for the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await LocalStorageService.instance.initialize();
  
  runApp(
    const ProviderScope(
      child: NKountApp(),
    ),
  );
}
