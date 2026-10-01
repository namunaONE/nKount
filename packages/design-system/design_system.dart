// Claymorphism Design System - Main Export File
// This file provides a single import for the entire design system

library design_system;

// Tokens
export 'tokens/colors.dart' show 
  ClayColors,
  ClaySemanticColors,
  ClayComponentColors,
  ClayTheme;

export 'tokens/typography.dart' show 
  ClayTypography,
  ClayFontFamilies,
  ClayFontWeights,
  ClayFontSizes,
  ClayLineHeights,
  ClayTextStyles,
  ClayNepaliTextStyles;

// Themes
export 'themes/clay_theme.dart' show 
  ClayThemeData,
  lightTheme,
  darkTheme,
  nepaliTheme,
  getClayTheme,
  ClayDecorations,
  ClayAnimations,
  ClayThemeExtensions;

// Components
export 'components/index.dart' show 
  // Buttons
  ClayButton,
  ClayIconButton,
  ClayFAB,
  ClayButtonType,
  ClayButtonSize,
  
  // Cards
  ClayCard,
  ClayCardHeader,
  ClayCardBody,
  ClayCardFooter,
  ClayCardComplete,
  ClayStatCard,
  ClayCardType,
  ClayCardSize,
  
  // Inputs
  ClayInput,
  ClayInputWithLabel,
  ClayCurrencyInput,
  ClaySearchInput,
  ClayInputType,
  ClayInputSize,
  ClayInputState,
  
  // Dialogs
  ClayDialog,
  ClayAlertDialog,
  ClayConfirmDialog,
  ClayFormDialog,
  ClayBottomSheet,
  ClayDialogAction,
  ClayDialogType,
  ClayDialogSize,
  showClayDialog,
  showClayAlert,
  showClayConfirm,
  
  // App Bars
  ClayAppBar,
  ClaySliverAppBar,
  ClayTabBar,
  ClayToolbar,
  ClayAppBarType,
  ClayAppBarSize,
  
  // Bottom Navigation
  ClayBottomNavigation,
  ClayBottomNavItem,
  ClayNavFAB,
  ClayNavigationRail,
  ClayNavigationDrawer,
  ClayDrawerHeader,
  ClayBottomNavType;

// Design System Constants
class ClayDesignSystem {
  // Version
  static const String version = '1.0.0';
  
  // Design Principles
  static const String designPhilosophy = 'Soft, tactile, and approachable UI with clay-like textures and 3D depth';
  
  // Key Characteristics
  static const double defaultBorderRadius = 24.0;
  static const double defaultElevation = 4.0;
  static const double defaultInnerShadowBlur = 8.0;
  static const double defaultOuterShadowBlur = 16.0;
  
  // Spacing System
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2Xl = 48.0;
  
  // Color System
  static const String primaryColor = '#8B5CF6'; // Lavender
  static const String secondaryColor = '#F59E0B'; // Amber
  static const String tertiaryColor = '#34D399'; // Mint
  
  // Typography System
  static const String primaryFontFamily = 'Inter';
  static const String nepaliFontFamily = 'Noto Sans Devanagari';
  static const String codeFontFamily = 'JetBrains Mono';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 200);
  static const Duration slowAnimation = Duration(milliseconds: 300);
  
  // Curves
  static const Curve fastCurve = Curves.easeOutCirc;
  static const Curve normalCurve = Curves.easeInOutCirc;
  static const Curve slowCurve = Curves.easeInOutCubic;
}

// Helper Functions
class ClayHelpers {
  /// Convert hex color string to Flutter Color
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Lighten a color by a given percentage
  static Color lighten(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1, 'Percentage must be between 0 and 1');
    return Color.lerp(color, Colors.white, percentage)!;
  }

  /// Darken a color by a given percentage
  static Color darken(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1, 'Percentage must be between 0 and 1');
    return Color.lerp(color, Colors.black, percentage)!;
  }

  /// Get contrast color (black or white) based on brightness
  static Color getContrastColor(Color color) {
    final brightness = color.computeLuminance();
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  /// Create Claymorphism shadow
  static List<BoxShadow> clayShadow({
    Color outerColor = Colors.black,
    double outerBlur = 16,
    Offset outerOffset = const Offset(0, 8),
    Color innerColor = Colors.white,
    double innerBlur = 8,
    Offset innerOffset = const Offset(0, 4),
  }) {
    return [
      BoxShadow(
        color: outerColor.withOpacity(0.12),
        blurRadius: outerBlur,
        offset: outerOffset,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: innerColor.withOpacity(0.4),
        blurRadius: innerBlur,
        offset: innerOffset,
        spreadRadius: 0,
        inset: true,
      ),
    ];
  }

  /// Create Claymorphism decoration
  static BoxDecoration clayDecoration({
    Color backgroundColor = const Color(0xFFFDFBF8),
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
    double borderRadius = 24,
    List<BoxShadow>? shadows,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      gradient: gradient,
      border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows ?? clayShadow(),
    );
  }

  /// Format Nepali currency
  static String formatNepaliCurrency(double amount) {
    return 'à¤°à¥ ${amount.toStringAsFixed(2)}';
  }

  /// Format Nepali date
  static String formatNepaliDate(DateTime date) {
    // Simple format for now - can be enhanced with proper Nepali date conversion
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Design System Theme Builder
class ClayThemeBuilder {
  final BuildContext context;

  ClayThemeBuilder(this.context);

  /// Build a complete Claymorphism theme
  ThemeData build({
    ClayThemeData? clayTheme,
    bool useMaterial3 = true,
    bool useLightTheme = true,
  }) {
    final effectiveClayTheme = clayTheme ?? ClayThemeData();
    
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: useLightTheme ? Brightness.light : Brightness.dark,
      colorScheme: ColorScheme.light(
        primary: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
        secondary: ClayHelpers.hexToColor(ClaySemanticColors.brandSecondary),
        surface: ClayHelpers.hexToColor(ClaySemanticColors.surfacePrimary),
        background: ClayHelpers.hexToColor(ClaySemanticColors.backgroundPrimary),
        error: ClayHelpers.hexToColor(ClaySemanticColors.statusError),
        onPrimary: ClayHelpers.hexToColor(ClaySemanticColors.textOnPrimary),
        onSecondary: ClayHelpers.hexToColor(ClaySemanticColors.textOnSecondary),
        onSurface: ClayHelpers.hexToColor(ClaySemanticColors.textPrimary),
        onBackground: ClayHelpers.hexToColor(ClaySemanticColors.textPrimary),
        onError: ClayHelpers.hexToColor(ClaySemanticColors.textOnError),
      ),
      scaffoldBackgroundColor: ClayHelpers.hexToColor(ClaySemanticColors.backgroundPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: ClayHelpers.hexToColor(ClaySemanticColors.surfacePrimary),
        foregroundColor: ClayHelpers.hexToColor(ClaySemanticColors.textPrimary),
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
      ),
      cardTheme: CardTheme(
        color: ClayHelpers.hexToColor(ClaySemanticColors.surfacePrimary),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
          foregroundColor: ClayHelpers.hexToColor(ClaySemanticColors.textOnPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ClayHelpers.hexToColor(ClaySemanticColors.surfacePrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          borderSide: BorderSide(color: ClayHelpers.hexToColor(ClaySemanticColors.borderPrimary)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          borderSide: BorderSide(color: ClayHelpers.hexToColor(ClaySemanticColors.borderPrimary)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          borderSide: BorderSide(
            color: ClayHelpers.hexToColor(ClaySemanticColors.borderFocused),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          borderSide: BorderSide(color: ClayHelpers.hexToColor(ClaySemanticColors.borderError)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ClayHelpers.hexToColor(ClaySemanticColors.surfacePrimary),
        selectedItemColor: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
        unselectedItemColor: ClayHelpers.hexToColor(ClaySemanticColors.textSecondary),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
        foregroundColor: ClayHelpers.hexToColor(ClaySemanticColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: ClayHelpers.hexToColor(ClaySemanticColors.borderPrimary),
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: ClayTextStyles.displayLarge,
        displayMedium: ClayTextStyles.displayMedium,
        displaySmall: ClayTextStyles.displaySmall,
        headlineLarge: ClayTextStyles.headingLarge,
        headlineMedium: ClayTextStyles.headingMedium,
        headlineSmall: ClayTextStyles.headingSmall,
        titleLarge: ClayTextStyles.titleLarge,
        titleMedium: ClayTextStyles.titleMedium,
        titleSmall: ClayTextStyles.titleSmall,
        bodyLarge: ClayTextStyles.bodyLarge,
        bodyMedium: ClayTextStyles.bodyMedium,
        bodySmall: ClayTextStyles.bodySmall,
        labelLarge: ClayTextStyles.labelLarge,
        labelMedium: ClayTextStyles.labelMedium,
        labelSmall: ClayTextStyles.labelSmall,
      ),
      iconTheme: IconThemeData(
        color: ClayHelpers.hexToColor(ClaySemanticColors.textPrimary),
        size: 24,
      ),
      primaryIconTheme: IconThemeData(
        color: ClayHelpers.hexToColor(ClaySemanticColors.brandPrimary),
        size: 24,
      ),
      dividerColor: ClayHelpers.hexToColor(ClaySemanticColors.borderPrimary),
      hintColor: ClayHelpers.hexToColor(ClaySemanticColors.textHint),
      errorColor: ClayHelpers.hexToColor(ClaySemanticColors.statusError),
    );
  }

  /// Build a dark theme
  ThemeData buildDark() {
    return build(useLightTheme: false);
  }

  /// Build a Nepali-specific theme
  ThemeData buildNepali() {
    return build().copyWith(
      textTheme: Theme.of(context).textTheme.copyWith(
        // Nepali font overrides
        displayLarge: ClayNepaliTextStyles.displayLarge,
        displayMedium: ClayNepaliTextStyles.displayMedium,
        displaySmall: ClayNepaliTextStyles.displaySmall,
        headlineLarge: ClayNepaliTextStyles.headingLarge,
        headlineMedium: ClayNepaliTextStyles.headingMedium,
        headlineSmall: ClayNepaliTextStyles.headingSmall,
        titleLarge: ClayNepaliTextStyles.titleLarge,
        titleMedium: ClayNepaliTextStyles.titleMedium,
        titleSmall: ClayNepaliTextStyles.titleSmall,
        bodyLarge: ClayNepaliTextStyles.bodyLarge,
        bodyMedium: ClayNepaliTextStyles.bodyMedium,
        bodySmall: ClayNepaliTextStyles.bodySmall,
        labelLarge: ClayNepaliTextStyles.labelLarge,
        labelMedium: ClayNepaliTextStyles.labelMedium,
        labelSmall: ClayNepaliTextStyles.labelSmall,
      ),
    );
  }
}
