/// Claymorphism Color Tokens for nKount
/// 
/// Color System:
/// - Primitive Tokens: Raw color values (Level 1)
/// - Semantic Tokens: Purpose-based colors (Level 2)
/// - Component Tokens: Specific usage colors (Level 3)
///
/// Claymorphism Palette:
/// - Soft pastels with high contrast
/// - Dual shadows for depth
/// - Friendly, approachable colors

/// ============================================
/// LEVEL 1: PRIMITIVE COLOR TOKENS
/// Raw color values - the foundation
/// ============================================

class ClayColors {
  // Pastel Primaries (Claymorphism base)
  static const String clay50 = '#FDFBF8';
  static const String clay100 = '#FBEFE5';
  static const String clay200 = '#F7E0CE';
  static const String clay300 = '#F2CBBF';
  static const String clay400 = '#ECA594';
  static const String clay500 = '#E47961';
  static const String clay600 = '#D95A42';
  static const String clay700 = '#C8422E';
  static const String clay800 = '#B03528';
  static const String clay900 = '#8C2C24';
  static const String clay950 = '#431610';

  // Soft Blues (Trust & Professionalism)
  static const String sky50 = '#F0F9FF';
  static const String sky100 = '#E0F2FE';
  static const String sky200 = '#BAE6FD';
  static const String sky300 = '#7DD3FC';
  static const String sky400 = '#38BDF8';
  static const String sky500 = '#0EA5E9';
  static const String sky600 = '#0284C7';
  static const String sky700 = '#0369A1';
  static const String sky800 = '#075985';
  static const String sky900 = '#0C4A6E';
  static const String sky950 = '#082F49';

  // Mint Greens (Growth & Success)
  static const String mint50 = '#F0FDF4';
  static const String mint100 = '#E0F9E9';
  static const String mint200 = '#CFF3D9';
  static const String mint300 = '#A7E8BC';
  static const String mint400 = '#6EE792';
  static const String mint500 = '#34D399';
  static const String mint600 = '#10B981';
  static const String mint700 = '#059669';
  static const String mint800 = '#047857';
  static const String mint900 = '#065F46';
  static const String mint950 = '#02362D';

  // Lavender Purples (Premium & Luxury)
  static const String lavender50 = '#F5F3FF';
  static const String lavender100 = '#EDE9FE';
  static const String lavender200 = '#DDD6FE';
  static const String lavender300 = '#C4B5FD';
  static const String lavender400 = '#A78BFA';
  static const String lavender500 = '#8B5CF6';
  static const String lavender600 = '#7C3AED';
  static const String lavender700 = '#6D28D9';
  static const String lavender800 = '#5B21B6';
  static const String lavender900 = '#4C1D95';
  static const String lavender950 = '#2E1065';

  // Peach Oranges (Warmth & Energy)
  static const String peach50 = '#FFF7ED';
  static const String peach100 = '#FFEDD5';
  static const String peach200 = '#FED7AA';
  static const String peach300 = '#FDBA74';
  static const String peach400 = '#FB923C';
  static const String peach500 = '#F97316';
  static const String peach600 = '#EA580C';
  static const String peach700 = '#C2410C';
  static const String peach800 = '#9A3412';
  static const String peach900 = '#7C2D12';
  static const String peach950 = '#431407';

  // Neutral Grays (Balance)
  static const String gray50 = '#FAFAFA';
  static const String gray100 = '#F5F5F5';
  static const String gray200 = '#E5E5E5';
  static const String gray300 = '#D4D4D4';
  static const String gray400 = '#A3A3A3';
  static const String gray500 = '#737373';
  static const String gray600 = '#525252';
  static const String gray700 = '#404040';
  static const String gray800 = '#262626';
  static const String gray900 = '#171717';
  static const String gray950 = '#0A0A0A';

  // Semantic Neutrals
  static const String white = '#FFFFFF';
  static const String black = '#000000';
}

/// ============================================
/// LEVEL 2: SEMANTIC COLOR TOKENS
/// Purpose-based colors for theming
/// ============================================

class ClaySemanticColors {
  // Background Colors
  static const String backgroundPrimary = ClayColors.clay50;
  static const String backgroundSecondary = ClayColors.clay100;
  static const String backgroundTertiary = ClayColors.clay200;
  static const String backgroundElevated = ClayColors.white;
  static const String backgroundOverlay = 'rgba(0, 0, 0, 0.5)';

  // Surface Colors (Claymorphism surfaces)
  static const String surfacePrimary = ClayColors.clay200;
  static const String surfaceSecondary = ClayColors.clay300;
  static const String surfaceTertiary = ClayColors.clay400;
  static const String surfaceHover = ClayColors.clay300;
  static const String surfaceActive = ClayColors.clay400;

  // Text Colors
  static const String textPrimary = ClayColors.clay900;
  static const String textSecondary = ClayColors.clay700;
  static const String textTertiary = ClayColors.clay500;
  static const String textInverse = ClayColors.white;
  static const String textLink = ClayColors.lavender600;

  // Border Colors
  static const String borderPrimary = ClayColors.clay300;
  static const String borderSecondary = ClayColors.clay200;
  static const String borderTertiary = ClayColors.clay400;

  // Status Colors
  static const String success50 = ClayColors.mint50;
  static const String success100 = ClayColors.mint100;
  static const String success500 = ClayColors.mint500;
  static const String success600 = ClayColors.mint600;
  static const String success700 = ClayColors.mint700;

  static const String warning50 = ClayColors.peach50;
  static const String warning100 = ClayColors.peach100;
  static const String warning500 = ClayColors.peach500;
  static const String warning600 = ClayColors.peach600;
  static const String warning700 = ClayColors.peach700;

  static const String error50 = '#FEF2F2';
  static const String error100 = '#FEE2E2';
  static const String error500 = '#EF4444';
  static const String error600 = '#DC2626';
  static const String error700 = '#B91C1C';

  static const String info50 = ClayColors.sky50;
  static const String info100 = ClayColors.sky100;
  static const String info500 = ClayColors.sky500;
  static const String info600 = ClayColors.sky600;
  static const String info700 = ClayColors.sky700;

  // Brand Colors
  static const String brandPrimary = ClayColors.lavender600;
  static const String brandSecondary = ClayColors.clay500;
  static const String brandTertiary = ClayColors.mint500;
  static const String brandGradient = 'linear-gradient(135deg, ${ClayColors.lavender500} 0%, ${ClayColors.clay500} 100%)';
}

/// ============================================
/// LEVEL 3: COMPONENT COLOR TOKENS
/// Specific colors for UI components
/// ============================================

class ClayComponentColors {
  // Buttons
  static const String buttonPrimaryBg = ClaySemanticColors.brandPrimary;
  static const String buttonPrimaryText = ClaySemanticColors.white;
  static const String buttonPrimaryHover = ClayColors.lavender700;
  static const String buttonPrimaryActive = ClayColors.lavender800;

  static const String buttonSecondaryBg = ClaySemanticColors.surfaceSecondary;
  static const String buttonSecondaryText = ClaySemanticColors.textPrimary;
  static const String buttonSecondaryHover = ClaySemanticColors.surfaceHover;
  static const String buttonSecondaryActive = ClaySemanticColors.surfaceActive;

  static const String buttonTertiaryBg = ClaySemanticColors.white;
  static const String buttonTertiaryText = ClaySemanticColors.textPrimary;
  static const String buttonTertiaryBorder = ClaySemanticColors.borderPrimary;

  static const String buttonGhostBg = 'transparent';
  static const String buttonGhostText = ClaySemanticColors.textPrimary;
  static const String buttonGhostHover = ClaySemanticColors.surfacePrimary;

  // Cards (Claymorphism specific)
  static const String cardBg = ClaySemanticColors.surfacePrimary;
  static const String cardBorder = ClaySemanticColors.borderSecondary;
  static const String cardHover = ClaySemanticColors.surfaceHover;
  static const String cardActive = ClaySemanticColors.surfaceActive;

  // Form Elements
  static const String inputBg = ClaySemanticColors.white;
  static const String inputBorder = ClaySemanticColors.borderPrimary;
  static const String inputText = ClaySemanticColors.textPrimary;
  static const String inputPlaceholder = ClaySemanticColors.textTertiary;
  static const String inputFocusBorder = ClaySemanticColors.brandPrimary;
  static const String inputErrorBorder = ClaySemanticColors.error500;

  // Navigation
  static const String navBg = ClaySemanticColors.backgroundPrimary;
  static const String navText = ClaySemanticColors.textPrimary;
  static const String navTextHover = ClaySemanticColors.textSecondary;
  static const String navTextActive = ClaySemanticColors.brandPrimary;
  static const String navIndicator = ClaySemanticColors.brandPrimary;

  // Status Indicators
  static const String badgeSuccessBg = ClaySemanticColors.success100;
  static const String badgeSuccessText = ClaySemanticColors.success700;
  static const String badgeWarningBg = ClaySemanticColors.warning100;
  static const String badgeWarningText = ClaySemanticColors.warning700;
  static const String badgeErrorBg = ClaySemanticColors.error100;
  static const String badgeErrorText = ClaySemanticColors.error700;
  static const String badgeInfoBg = ClaySemanticColors.info100;
  static const String badgeInfoText = ClaySemanticColors.info700;

  // Shadows (Claymorphism dual shadows)
  static const String shadowSm = '0 2px 4px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.05)';
  static const String shadowMd = '0 4px 6px rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.05)';
  static const String shadowLg = '0 10px 15px rgba(0, 0, 0, 0.1), 0 4px 6px rgba(0, 0, 0, 0.05)';
  static const String shadowXl = '0 20px 25px rgba(0, 0, 0, 0.15), 0 10px 10px rgba(0, 0, 0, 0.05)';
  
  // Claymorphism-specific shadows (dual: outer + inner)
  static const String clayShadowSm = '0 4px 8px rgba(0, 0, 0, 0.1), inset 0 2px 4px rgba(255, 255, 255, 0.5)';
  static const String clayShadowMd = '0 8px 16px rgba(0, 0, 0, 0.12), inset 0 4px 8px rgba(255, 255, 255, 0.4)';
  static const String clayShadowLg = '0 12px 24px rgba(0, 0, 0, 0.15), inset 0 6px 12px rgba(255, 255, 255, 0.3)';
  static const String clayShadowPressed = '0 2px 4px rgba(0, 0, 0, 0.1), inset 0 2px 4px rgba(0, 0, 0, 0.1)';
}

/// ============================================
/// CLAYMORPHISM THEME EXTENSION
/// Custom theme for Claymorphism design
/// ============================================

class ClayTheme {
  // Border Radius (Claymorphism uses oversized rounded corners)
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  static const double radius2Xl = 48.0;
  static const double radiusFull = 9999.0;

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2Xl = 48.0;

  // Typography
  static const String fontFamilyPrimary = 'Inter';
  static const String fontFamilySecondary = 'Noto Sans Devanagari';
  static const String fontFamilyMono = 'JetBrains Mono';

  // Font Weights
  static const int fontWeightNormal = 400;
  static const int fontWeightMedium = 500;
  static const int fontWeightSemiBold = 600;
  static const int fontWeightBold = 700;

  // Font Sizes
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2Xl = 24.0;
  static const double fontSize3Xl = 32.0;
  static const double fontSize4Xl = 48.0;

  // Line Heights
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // Transitions (bouncy for Claymorphism)
  static const String transitionFast = '200ms cubic-bezier(0.4, 0, 0.2, 1)';
  static const String transitionNormal = '300ms cubic-bezier(0.4, 0, 0.2, 1)';
  static const String transitionSlow = '400ms cubic-bezier(0.4, 0, 0.2, 1)';
  static const String transitionBounce = '300ms cubic-bezier(0.68, -0.55, 0.265, 1.55)';

  // Z-Index Scale
  static const int zIndexDropdown = 100;
  static const int zIndexSticky = 200;
  static const int zIndexFixed = 300;
  static const int zIndexModalBackdrop = 400;
  static const int zIndexModal = 500;
  static const int zIndexPopover = 600;
  static const int zIndexTooltip = 700;
  static const int zIndexToast = 800;

  // Opacity
  static const double opacityFull = 1.0;
  static const double opacityHigh = 0.8;
  static const double opacityMedium = 0.6;
  static const double opacityLow = 0.4;
  static const double opacityDisabled = 0.5;

  // Gradients for Claymorphism
  static const String gradientClayPrimary = 'linear-gradient(145deg, ${ClayColors.clay200} 0%, ${ClayColors.clay400} 100%)';
  static const String gradientClaySecondary = 'linear-gradient(145deg, ${ClayColors.lavender200} 0%, ${ClayColors.lavender400} 100%)';
  static const String gradientClayTertiary = 'linear-gradient(145deg, ${ClayColors.mint200} 0%, ${ClayColors.mint400} 100%)';
}

/// ============================================
/// THEME MANAGER
/// Handles theme switching and token resolution
/// ============================================

class ClayThemeManager {
  static String currentTheme = 'clay-light';

  static Map<String, dynamic> getTokens() {
    return {
      'colors': {
        'primary': ClaySemanticColors.brandPrimary,
        'secondary': ClaySemanticColors.brandSecondary,
        'background': ClaySemanticColors.backgroundPrimary,
        'surface': ClaySemanticColors.surfacePrimary,
        'text': ClaySemanticColors.textPrimary,
        'success': ClaySemanticColors.success500,
        'warning': ClaySemanticColors.warning500,
        'error': ClaySemanticColors.error500,
        'info': ClaySemanticColors.info500,
      },
      'spacing': {
        'xs': ClayTheme.spacingXs,
        'sm': ClayTheme.spacingSm,
        'md': ClayTheme.spacingMd,
        'lg': ClayTheme.spacingLg,
        'xl': ClayTheme.spacingXl,
      },
      'radius': {
        'xs': ClayTheme.radiusXs,
        'sm': ClayTheme.radiusSm,
        'md': ClayTheme.radiusMd,
        'lg': ClayTheme.radiusLg,
        'xl': ClayTheme.radiusXl,
        'full': ClayTheme.radiusFull,
      },
      'shadows': {
        'sm': ClayComponentColors.clayShadowSm,
        'md': ClayComponentColors.clayShadowMd,
        'lg': ClayComponentColors.clayShadowLg,
      },
    };
  }

  static void switchTheme(String theme) {
    currentTheme = theme;
    // In Flutter, this would trigger a rebuild
    // In web, this would update CSS variables
  }
}
