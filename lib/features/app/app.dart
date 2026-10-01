import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/database_initializer.dart';
import 'package:nkount/packages/design-system/design_system.dart';
import 'package:nkount/features/dashboard/presentation/dashboard_screen.dart';
import 'package:nkount/features/contacts/presentation/contacts_screen.dart';
import 'package:nkount/features/products/presentation/products_screen.dart';
import 'package:nkount/features/transactions/presentation/transactions_screen.dart';
import 'package:nkount/features/payments/presentation/payments_screen.dart';
import 'package:nkount/features/reports/presentation/reports_screen.dart';
import 'package:nkount/features/settings/presentation/settings_screen.dart';

/// App Router Configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/contacts',
      builder: (context, state) => const ContactsScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsScreen(),
    ),
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);

/// Main application widget with Claymorphism design
class NKountApp extends ConsumerWidget {
  const NKountApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch database initialization status
    final dbStatus = ref.watch(databaseInitializerProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Apply Claymorphism theme
      theme: ClayTheme.lightTheme,
      darkTheme: ClayTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Localization
      locale: const Locale('en', 'NP'),
      supportedLocales: const [
        Locale('en', 'NP'),
        Locale('ne', 'NP'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Router
      routerConfig: _router,
      
      // Builder with Claymorphism background
      builder: (context, child) {
        return ClayThemeBuilder(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

/// Provider for database initializer status
final databaseInitializerProvider = Provider<DatabaseInitializer>((ref) {
  return databaseInitializer;
});
