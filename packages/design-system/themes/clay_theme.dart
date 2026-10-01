import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

/// ============================================
/// CLAYMORPHISM THEME
/// Complete Flutter theme implementation
/// ============================================

class ClayThemeData {
  /// Light Claymorphism Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme (Claymorphism adapted to Material 3)
      colorScheme: ColorScheme.light(
        // Primary Palette (Lavender - Premium feel)
        primary: _hexToColor(ClayColors.lavender500),
        primaryContainer: _hexToColor(ClayColors.lavender100),
        onPrimary: _hexToColor(ClayColors.white),
        onPrimaryContainer: _hexToColor(ClayColors.lavender900),
        
        // Secondary Palette (Clay - Warmth)
        secondary: _hexToColor(ClayColors.clay500),
        secondaryContainer: _hexToColor(ClayColors.clay100),
        onSecondary: _hexToColor(ClayColors.white),
        onSecondaryContainer: _hexToColor(ClayColors.clay900),
        
        // Tertiary Palette (Mint - Growth)
        tertiary: _hexToColor(ClayColors.mint500),
        tertiaryContainer: _hexToColor(ClayColors.mint100),
        onTertiary: _hexToColor(ClayColors.white),
        onTertiaryContainer: _hexToColor(ClayColors.mint900),
        
        // Surface Colors (Claymorphism surfaces)
        surface: _hexToColor(ClayColors.clay50),
        surfaceVariant: _hexToColor(ClayColors.clay100),
        onSurface: _hexToColor(ClayColors.clay900),
        onSurfaceVariant: _hexToColor(ClayColors.clay700),
        
        // Background Colors
        background: _hexToColor(ClayColors.clay50),
        onBackground: _hexToColor(ClayColors.clay900),
        
        // Error Colors
        error: _hexToColor(ClayColors.error500),
        errorContainer: _hexToColor(ClayColors.error100),
        onError: _hexToColor(ClayColors.white),
        onErrorContainer: _hexToColor(ClayColors.error700),
        
        // Outline
        outline: _hexToColor(ClayColors.clay300),
        outlineVariant: _hexToColor(ClayColors.clay200),
        
        // Shadows (Claymorphism dual shadows)
        shadow: _hexToColor('#000000').withOpacity(0.1),
        scrim: _hexToColor('#000000').withOpacity(0.4),
        
        // Surface Tint
        surfaceTint: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: ClayTextStyles.display4Xl,
        displayMedium: ClayTextStyles.display3Xl,
        displaySmall: ClayTextStyles.display2Xl,
        headlineLarge: ClayTextStyles.heading3Xl,
        headlineMedium: ClayTextStyles.heading2Xl,
        headlineSmall: ClayTextStyles.headingXl,
        titleLarge: ClayTextStyles.headingLg.clayBold,
        titleMedium: ClayTextStyles.headingMd.clayBold,
        titleSmall: ClayTextStyles.headingSm.clayBold,
        bodyLarge: ClayTextStyles.bodyXl,
        bodyMedium: ClayTextStyles.bodyBase,
        bodySmall: ClayTextStyles.bodySm,
        labelLarge: ClayTextStyles.labelLg.clayMedium,
        labelMedium: ClayTextStyles.labelBase.clayMedium,
        labelSmall: ClayTextStyles.labelSm.clayMedium,
      ),
      
      // Primary Text Theme
      primaryTextTheme: TextTheme(
        displayLarge: ClayTextStyles.display4Xl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        displayMedium: ClayTextStyles.display3Xl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        displaySmall: ClayTextStyles.display2Xl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        headlineLarge: ClayTextStyles.heading3Xl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        headlineMedium: ClayTextStyles.heading2Xl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        headlineSmall: ClayTextStyles.headingXl.copyWith(color: _hexToColor(ClayColors.lavender900)),
        titleLarge: ClayTextStyles.headingLg.clayBold.copyWith(color: _hexToColor(ClayColors.lavender900)),
        titleMedium: ClayTextStyles.headingMd.clayBold.copyWith(color: _hexToColor(ClayColors.lavender900)),
        titleSmall: ClayTextStyles.headingSm.clayBold.copyWith(color: _hexToColor(ClayColors.lavender900)),
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: _hexToColor(ClayColors.clay700),
        size: 24,
        fill: 0.0,
        weight: 400,
        grade: 0,
        opticalSize: 48,
      ),
      
      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: _hexToColor(ClayColors.lavender600),
        size: 24,
        fill: 0.0,
        weight: 700,
      ),
      
      // Card Theme (Claymorphism specific)
      cardTheme: CardTheme(
        color: _hexToColor(ClayColors.clay200),
        shadowColor: _hexToColor('#000000').withOpacity(0.1),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          side: BorderSide(
            color: _hexToColor(ClayColors.clay300),
            width: 1,
          ),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _hexToColor(ClayColors.lavender600),
          foregroundColor: _hexToColor(ClayColors.white),
          shadowColor: _hexToColor('#000000').withOpacity(0.2),
          surfaceTintColor: _hexToColor(ClayColors.lavender700),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          ),
          textStyle: ClayTextStyles.labelBase.clayBold.copyWith(
            color: _hexToColor(ClayColors.white),
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableFeedback: true,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _hexToColor(ClayColors.lavender600),
          backgroundColor: _hexToColor(ClayColors.clay200),
          surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
          shadowColor: _hexToColor('#000000').withOpacity(0.1),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          ),
          side: BorderSide(
            color: _hexToColor(ClayColors.clay300),
            width: 1,
          ),
          textStyle: ClayTextStyles.labelBase.clayBold,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _hexToColor(ClayColors.lavender600),
          textStyle: ClayTextStyles.labelBase.clayBold,
        ),
      ),
      
      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _hexToColor(ClayColors.lavender600),
          foregroundColor: _hexToColor(ClayColors.white),
          shadowColor: _hexToColor('#000000').withOpacity(0.2),
          surfaceTintColor: _hexToColor(ClayColors.lavender700),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          ),
          textStyle: ClayTextStyles.labelBase.clayBold.copyWith(
            color: _hexToColor(ClayColors.white),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _hexToColor(ClayColors.white),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.clay300),
            width: 1,
          ),
          gapPadding: 8,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.clay300),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.lavender500),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.error500),
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.error500),
            width: 2,
          ),
        ),
        labelStyle: ClayTextStyles.labelBase.clayMedium,
        floatingLabelStyle: ClayTextStyles.labelBase.clayMedium.copyWith(
          color: _hexToColor(ClayColors.lavender600),
        ),
        hintStyle: ClayTextStyles.bodySm.clayMuted,
        errorStyle: ClayTextStyles.bodySm.copyWith(
          color: _hexToColor(ClayColors.error600),
        ),
        prefixIconColor: _hexToColor(ClayColors.clay600),
        suffixIconColor: _hexToColor(ClayColors.clay600),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _hexToColor(ClayColors.lavender600),
        foregroundColor: _hexToColor(ClayColors.white),
        focusColor: _hexToColor(ClayColors.lavender700),
        hoverColor: _hexToColor(ClayColors.lavender700),
        splashColor: _hexToColor(ClayColors.lavender800),
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: const CircleBorder(),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _hexToColor(ClayColors.clay200),
        foregroundColor: _hexToColor(ClayColors.clay900),
        elevation: 4,
        shadowColor: _hexToColor('#000000').withOpacity(0.1),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        centerTitle: true,
        titleTextStyle: ClayTextStyles.headingLg.clayBold.copyWith(
          color: _hexToColor(ClayColors.clay900),
        ),
        iconTheme: IconThemeData(
          color: _hexToColor(ClayColors.clay700),
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: _hexToColor(ClayColors.clay700),
          size: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _hexToColor(ClayColors.clay200),
        selectedItemColor: _hexToColor(ClayColors.lavender600),
        unselectedItemColor: _hexToColor(ClayColors.clay600),
        selectedLabelStyle: ClayTextStyles.labelSm.clayMedium,
        unselectedLabelStyle: ClayTextStyles.labelSm.clayMedium,
        selectedIconTheme: IconThemeData(
          color: _hexToColor(ClayColors.lavender600),
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: _hexToColor(ClayColors.clay600),
          size: 24,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: _hexToColor(ClayColors.lavender600),
        unselectedLabelColor: _hexToColor(ClayColors.clay600),
        labelStyle: ClayTextStyles.labelSm.clayMedium,
        unselectedLabelStyle: ClayTextStyles.labelSm.clayMedium,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          color: _hexToColor(ClayColors.lavender500).withOpacity(0.2),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: _hexToColor(ClayColors.clay300),
        overlayColor: MaterialStateProperty.all(
          _hexToColor(ClayColors.lavender500).withOpacity(0.1),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _hexToColor(ClayColors.clay200),
        labelStyle: ClayTextStyles.labelSm.clayMedium,
        secondaryLabelStyle: ClayTextStyles.labelSm.clayMedium,
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusFull),
        ),
        side: BorderSide.none,
        checkmarkColor: _hexToColor(ClayColors.lavender600),
        deleteIconColor: _hexToColor(ClayColors.clay600),
        selectedColor: _hexToColor(ClayColors.lavender100),
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 8,
        shadowColor: _hexToColor('#000000').withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
        titleTextStyle: ClayTextStyles.headingLg.clayBold,
        contentTextStyle: ClayTextStyles.bodyBase,
      ),
      
      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _hexToColor(ClayColors.clay900),
        actionTextColor: _hexToColor(ClayColors.lavender400),
        contentTextStyle: ClayTextStyles.bodyBase.copyWith(
          color: _hexToColor(ClayColors.white),
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _hexToColor(ClayColors.lavender600),
        linearTrackColor: _hexToColor(ClayColors.lavender200),
        circularTrackColor: _hexToColor(ClayColors.lavender200),
        refreshBackgroundColor: _hexToColor(ClayColors.lavender100),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender600);
          }
          return _hexToColor(ClayColors.clay400);
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender200);
          }
          return _hexToColor(ClayColors.clay300);
        }),
        trackOutlineColor: MaterialStateProperty.all(
          _hexToColor(ClayColors.clay400),
        ),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender500).withOpacity(0.2);
          }
          return _hexToColor(ClayColors.clay400).withOpacity(0.2);
        }),
        splashRadius: 24,
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender600);
          }
          return _hexToColor(ClayColors.clay400);
        }),
        checkColor: MaterialStateProperty.all(
          _hexToColor(ClayColors.white),
        ),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender500).withOpacity(0.2);
          }
          return _hexToColor(ClayColors.clay400).withOpacity(0.2);
        }),
        side: BorderSide(
          color: _hexToColor(ClayColors.clay400),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusXs),
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender600);
          }
          return _hexToColor(ClayColors.clay400);
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _hexToColor(ClayColors.lavender500).withOpacity(0.2);
          }
          return _hexToColor(ClayColors.clay400).withOpacity(0.2);
        }),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: _hexToColor(ClayColors.clay300),
        thickness: 1,
        space: 1,
        indent: 0,
        endIndent: 0,
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        horizontalTitleGap: 16,
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        ),
        selectedColor: _hexToColor(ClayColors.lavender100),
        selectedTileColor: _hexToColor(ClayColors.lavender50),
        iconColor: _hexToColor(ClayColors.clay700),
        textColor: _hexToColor(ClayColors.clay900),
        tileColor: _hexToColor(ClayColors.clay200),
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _hexToColor(ClayColors.clay900),
          borderRadius: BorderRadius.circular(ClayTheme.radiusXs),
        ),
        textStyle: ClayTextStyles.bodySm.copyWith(
          color: _hexToColor(ClayColors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.all(8),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 3),
      ),
      
      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: _hexToColor(ClayColors.lavender600),
        labelStyle: ClayTextStyles.labelXs.copyWith(
          color: _hexToColor(ClayColors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusFull),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 8,
        shadowColor: _hexToColor('#000000').withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusXl),
        ),
        modalBackgroundColor: _hexToColor(ClayColors.clay100),
        modalElevation: 8,
      ),
      
      // Navigation Drawer Theme
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 4,
        shadowColor: _hexToColor('#000000').withOpacity(0.1),
        indicatorColor: _hexToColor(ClayColors.lavender500).withOpacity(0.2),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        ),
        labelTextStyle: MaterialStateProperty.all(
          ClayTextStyles.labelBase.clayMedium,
        ),
        iconTheme: MaterialStateProperty.all(
          IconThemeData(
            color: _hexToColor(ClayColors.clay700),
            size: 24,
          ),
        ),
        selectedIconTheme: MaterialStateProperty.all(
          IconThemeData(
            color: _hexToColor(ClayColors.lavender600),
            size: 24,
          ),
        ),
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 4,
        selectedIconTheme: IconThemeData(
          color: _hexToColor(ClayColors.lavender600),
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: _hexToColor(ClayColors.clay600),
          size: 24,
        ),
        selectedLabelTextStyle: ClayTextStyles.labelSm.clayMedium.copyWith(
          color: _hexToColor(ClayColors.lavender600),
        ),
        unselectedLabelTextStyle: ClayTextStyles.labelSm.clayMedium.copyWith(
          color: _hexToColor(ClayColors.clay600),
        ),
        indicatorColor: _hexToColor(ClayColors.lavender500).withOpacity(0.2),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        ),
      ),
      
      // Popover Theme
      popoverTheme: PopoverThemeData(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 8,
        shadowColor: _hexToColor('#000000').withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
        ),
      ),
      
      // Menu Theme
      menuTheme: MenuThemeData(
        backgroundColor: _hexToColor(ClayColors.clay100),
        surfaceTintColor: _hexToColor(ClayColors.lavender500).withOpacity(0.3),
        elevation: 8,
        shadowColor: _hexToColor('#000000').withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        ),
        textStyle: ClayTextStyles.bodyBase,
      ),
      
      // Segmented Button Theme
      segmentedButtonTheme: SegmentedButtonThemeData(
        backgroundColor: _hexToColor(ClayColors.clay200),
        foregroundColor: MaterialStateProperty.all(
          _hexToColor(ClayColors.clay900),
        ),
        selectedBackgroundColor: _hexToColor(ClayColors.lavender600),
        selectedForegroundColor: _hexToColor(ClayColors.white),
        borderColor: MaterialStateProperty.all(
          _hexToColor(ClayColors.clay300),
        ),
        borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: ClayTextStyles.labelSm.clayMedium,
        selectedTextStyle: ClayTextStyles.labelSm.clayBold.copyWith(
          color: _hexToColor(ClayColors.white),
        ),
      ),
    );
  }

  /// Dark Claymorphism Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme for Dark Mode
      colorScheme: ColorScheme.dark(
        primary: _hexToColor(ClayColors.lavender400),
        primaryContainer: _hexToColor(ClayColors.lavender900),
        onPrimary: _hexToColor(ClayColors.clay950),
        onPrimaryContainer: _hexToColor(ClayColors.lavender200),
        
        secondary: _hexToColor(ClayColors.clay400),
        secondaryContainer: _hexToColor(ClayColors.clay900),
        onSecondary: _hexToColor(ClayColors.clay950),
        onSecondaryContainer: _hexToColor(ClayColors.clay200),
        
        tertiary: _hexToColor(ClayColors.mint400),
        tertiaryContainer: _hexToColor(ClayColors.mint900),
        onTertiary: _hexToColor(ClayColors.mint950),
        onTertiaryContainer: _hexToColor(ClayColors.mint200),
        
        surface: _hexToColor(ClayColors.clay900),
        surfaceVariant: _hexToColor(ClayColors.clay800),
        onSurface: _hexToColor(ClayColors.clay100),
        onSurfaceVariant: _hexToColor(ClayColors.clay300),
        
        background: _hexToColor(ClayColors.clay950),
        onBackground: _hexToColor(ClayColors.clay100),
        
        error: _hexToColor(ClayColors.error400),
        errorContainer: _hexToColor(ClayColors.error900),
        onError: _hexToColor(ClayColors.error100),
        onErrorContainer: _hexToColor(ClayColors.error300),
        
        outline: _hexToColor(ClayColors.clay600),
        outlineVariant: _hexToColor(ClayColors.clay700),
        
        shadow: _hexToColor('#000000').withOpacity(0.3),
        scrim: _hexToColor('#000000').withOpacity(0.6),
        
        surfaceTint: _hexToColor(ClayColors.lavender400).withOpacity(0.3),
      ),
      
      // Text Theme for Dark Mode
      textTheme: TextTheme(
        displayLarge: ClayTextStyles.display4Xl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        displayMedium: ClayTextStyles.display3Xl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        displaySmall: ClayTextStyles.display2Xl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        headlineLarge: ClayTextStyles.heading3Xl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        headlineMedium: ClayTextStyles.heading2Xl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        headlineSmall: ClayTextStyles.headingXl.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        titleLarge: ClayTextStyles.headingLg.clayBold.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        titleMedium: ClayTextStyles.headingMd.clayBold.copyWith(
          color: _hexToColor(ClayColors.clay100),
        ),
        titleSmall: ClayTextStyles.headingSm.clayBold.copyWith(
          color: _hexToColor(ClayColors.clay200),
        ),
        bodyLarge: ClayTextStyles.bodyXl.copyWith(
          color: _hexToColor(ClayColors.clay200),
        ),
        bodyMedium: ClayTextStyles.bodyBase.copyWith(
          color: _hexToColor(ClayColors.clay200),
        ),
        bodySmall: ClayTextStyles.bodySm.copyWith(
          color: _hexToColor(ClayColors.clay300),
        ),
        labelLarge: ClayTextStyles.labelLg.clayMedium.copyWith(
          color: _hexToColor(ClayColors.clay200),
        ),
        labelMedium: ClayTextStyles.labelBase.clayMedium.copyWith(
          color: _hexToColor(ClayColors.clay200),
        ),
        labelSmall: ClayTextStyles.labelSm.clayMedium.copyWith(
          color: _hexToColor(ClayColors.clay300),
        ),
      ),
      
      // Update other themes for dark mode similarly...
      // (For brevity, key components are shown. In production, update all themes)
      
      cardTheme: CardTheme(
        color: _hexToColor(ClayColors.clay800),
        shadowColor: _hexToColor('#000000').withOpacity(0.3),
        surfaceTintColor: _hexToColor(ClayColors.lavender400).withOpacity(0.3),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusLg),
          side: BorderSide(
            color: _hexToColor(ClayColors.clay600),
            width: 1,
          ),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _hexToColor(ClayColors.lavender500),
          foregroundColor: _hexToColor(ClayColors.clay950),
          shadowColor: _hexToColor('#000000').withOpacity(0.4),
          surfaceTintColor: _hexToColor(ClayColors.lavender400),
          elevation: 4,
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: _hexToColor(ClayColors.clay800),
        foregroundColor: _hexToColor(ClayColors.clay100),
        elevation: 4,
        shadowColor: _hexToColor('#000000').withOpacity(0.3),
        surfaceTintColor: _hexToColor(ClayColors.lavender400).withOpacity(0.3),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _hexToColor(ClayColors.clay800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.clay600),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ClayTheme.radiusMd),
          borderSide: BorderSide(
            color: _hexToColor(ClayColors.lavender400),
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Nepali (Devanagari) Specific Theme
  static ThemeData get nepaliTheme {
    return lightTheme.copyWith(
      textTheme: lightTheme.textTheme.copyWith(
        bodyLarge: ClayTextStyles.nepaliBody,
        bodyMedium: ClayTextStyles.nepaliBody.copyWith(
          fontSize: ClayTypography.sizeSm,
        ),
        headlineSmall: ClayTextStyles.nepaliHeading,
        titleLarge: ClayTextStyles.nepaliHeading.copyWith(
          fontSize: ClayTypography.sizeLg,
        ),
      ),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        titleTextStyle: ClayTextStyles.nepaliHeading.copyWith(
          fontSize: ClayTypography.sizeLg,
          color: _hexToColor(ClayColors.clay900),
        ),
      ),
    );
  }

  /// Helper to convert hex string to Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Get theme by name
  static ThemeData getTheme(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'dark':
      case 'dark-clay':
        return darkTheme;
      case 'nepali':
      case 'nepali-clay':
        return nepaliTheme;
      default:
        return lightTheme;
    }
  }
}

/// ============================================
/// CLAYMORPHISM DECORATIONS
/// Custom decorations for Claymorphism
/// ============================================

class ClayDecorations {
  /// Claymorphism Card Decoration
  static BoxDecoration clayCard({
    Color? backgroundColor,
    double? elevation,
    double borderRadius = ClayTheme.radiusLg,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? _hexToColor(ClayColors.clay200),
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder 
          ? Border.all(
              color: _hexToColor(ClayColors.clay300),
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: _hexToColor('#000000').withOpacity(0.1),
          blurRadius: elevation ?? 8,
          offset: Offset(0, elevation ?? 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: _hexToColor('#FFFFFF').withOpacity(0.4),
          blurRadius: elevation ?? 8,
          offset: Offset(0, elevation ?? 4),
          spreadRadius: 0,
          inset: true,
        ),
      ],
    );
  }

  /// Claymorphism Button Decoration
  static BoxDecoration clayButton({
    Color? backgroundColor,
    bool isPressed = false,
    double borderRadius = ClayTheme.radiusMd,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? _hexToColor(ClayColors.lavender600),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: _hexToColor('#000000').withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: _hexToColor('#000000').withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
                inset: true,
              ),
            ]
          : [
              BoxShadow(
                color: _hexToColor('#000000').withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: _hexToColor('#FFFFFF').withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
                inset: true,
              ),
            ],
      gradient: backgroundColor == null 
          ? LinearGradient(
              colors: [
                _hexToColor(ClayColors.lavender500),
                _hexToColor(ClayColors.lavender700),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
    );
  }

  /// Claymorphism Input Decoration
  static BoxDecoration clayInput({
    Color? backgroundColor,
    bool isFocused = false,
    bool hasError = false,
    double borderRadius = ClayTheme.radiusMd,
  }) {
    final borderColor = hasError
        ? _hexToColor(ClayColors.error500)
        : (isFocused 
            ? _hexToColor(ClayColors.lavender500)
            : _hexToColor(ClayColors.clay300));
    
    return BoxDecoration(
      color: backgroundColor ?? _hexToColor(ClayColors.white),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: isFocused ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: _hexToColor('#000000').withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
        if (isFocused)
          BoxShadow(
            color: _hexToColor(ClayColors.lavender500).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 0),
            spreadRadius: 2,
          ),
      ],
    );
  }

  /// Helper to convert hex string to Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// ============================================
/// CLAYMORPHISM ANIMATIONS
/// Bouncy, playful animations
/// ============================================

class ClayAnimations {
  /// Bounce animation curve (Claymorphism signature)
  static const Curve bounceCurve = Cubic(
    0.68,
    -0.55,
    0.265,
    1.55,
  );

  /// Smooth bounce animation
  static const Curve smoothBounce = Cubic(
    0.4,
    0,
    0.2,
    1,
  );

  /// Press animation
  static Animation<double> pressAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: bounceCurve,
      ),
    );
  }

  /// Lift animation
  static Animation<double> liftAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0,
      end: -4,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: bounceCurve,
      ),
    );
  }

  /// Scale animation
  static Animation<double> scaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: bounceCurve,
      ),
    );
  }

  /// Fade animation
  static Animation<double> fadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: smoothBounce,
      ),
    );
  }

  /// Slide animation
  static Animation<Offset> slideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 16),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: smoothBounce,
      ),
    );
  }
}

/// ============================================
/// THEME EXTENSIONS
/// Helper extensions for easy theming
/// ============================================

extension ClayThemeExtensions on BuildContext {
  /// Get current theme data
  ClayThemeData get clayTheme => ClayThemeData.getTheme(
    Theme.of(this).brightness == Brightness.dark ? 'dark' : 'light',
  );

  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get color scheme
  ColorScheme get clayColorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get clayTextTheme => Theme.of(this).textTheme;
}
