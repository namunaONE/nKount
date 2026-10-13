import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/theme_provider.dart';
import '../../packages/design-system/design_system.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/gallery/presentation/gallery_screen.dart';
import '../features/contacts/presentation/contacts_screen.dart';
import '../features/products/presentation/products_screen.dart';
import '../features/transactions/presentation/transactions_screen.dart';
import '../features/sales/presentation/sales_screen.dart';
import '../features/purchases/presentation/purchases_screen.dart';
import '../features/income/presentation/income_screen.dart';
import '../features/expenses/presentation/expenses_screen.dart';
import '../features/receipts/presentation/receipts_screen.dart';
import '../features/payments/presentation/payments_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

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
      path: '/sales',
      builder: (context, state) => const SalesScreen(),
    ),
    GoRoute(
      path: '/purchases',
      builder: (context, state) => const PurchasesScreen(),
    ),
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: '/income',
      builder: (context, state) => const IncomeScreen(),
    ),
    GoRoute(
      path: '/expenses',
      builder: (context, state) => const ExpensesScreen(),
    ),
    GoRoute(
      path: '/receipts',
      builder: (context, state) => const ReceiptsScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/design-system',
      builder: (context, state) => const GalleryScreen(),
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
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Apply Claymorphism theme
      theme: ClayTheme.lightTheme,
      darkTheme: ClayTheme.darkTheme,
      themeMode: themeMode,

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
      builder: (context, child) => ClayThemeBuilder(
        child: child ?? const SizedBox(),
      ),
    );
  }
}
