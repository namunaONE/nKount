/// Claymorphism Typography System for nKount
/// 
/// Typographic Scale:
/// - Based on 1.250 Major Third ratio
/// - Optimized for readability and hierarchy
/// - Supports both English and Nepali (Devanagari) scripts

import 'package:flutter/material.dart';
import 'colors.dart';

/// ============================================
/// TYPOGRAPHY TOKENS
/// ============================================

class ClayTypography {
  // Font Families
  static const String fontPrimary = ClayTheme.fontFamilyPrimary;
  static const String fontSecondary = ClayTheme.fontFamilySecondary;
  static const String fontMono = ClayTheme.fontFamilyMono;

  // Font Weights
  static const FontWeight weightNormal = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  // Font Sizes (Major Third scale: 1.250)
  static const double sizeXs = 12.0;      // 0.75rem
  static const double sizeSm = 14.0;      // 0.875rem
  static const double sizeBase = 16.0;    // 1rem
  static const double sizeLg = 18.0;      // 1.125rem
  static const double sizeXl = 20.0;      // 1.25rem
  static const double size2Xl = 24.0;     // 1.5rem
  static const double size3Xl = 30.0;     // 1.875rem
  static const double size4Xl = 36.0;     // 2.25rem
  static const double size5Xl = 48.0;     // 3rem
  static const double size6Xl = 60.0;     // 3.75rem
  static const double size7Xl = 72.0;     // 4.5rem

  // Line Heights
  static const double lineHeightTight = 1.25;  // For headings
  static const double lineHeightNormal = 1.5;  // For body text
  static const double lineHeightRelaxed = 1.75; // For large text

  // Letter Spacing
  static const double letterSpacingTight = -0.02;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.02;
  static const double letterSpacingWider = 0.05;

  // Paragraph Spacing
  static const double paragraphSpacing = 16.0;
}

/// ============================================
/// TEXT STYLES
/// Predefined text styles for consistent typography
/// ============================================

class ClayTextStyles {
  // Display Styles (Large, Bold)
  static TextStyle display4Xl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size7Xl,
    fontWeight: ClayTypography.weightExtraBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingTight,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle display3Xl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size6Xl,
    fontWeight: ClayTypography.weightExtraBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingTight,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle display2Xl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size5Xl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingTight,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle displayXl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size4Xl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  // Heading Styles
  static TextStyle heading3Xl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size3Xl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle heading2Xl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.size2Xl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle headingXl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeXl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle headingLg = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeLg,
    fontWeight: ClayTypography.weightSemiBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle headingMd = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightSemiBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle headingSm = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightSemiBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle headingXs = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeXs,
    fontWeight: ClayTypography.weightSemiBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textSecondary,
  );

  // Body Styles
  static TextStyle bodyXl = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeXl,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle bodyLg = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeLg,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle bodyBase = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle bodySm = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textSecondary,
  );

  static TextStyle bodyXs = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeXs,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textTertiary,
  );

  // Label Styles (for form labels, captions)
  static TextStyle labelLg = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeLg,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle labelBase = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle labelSm = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textSecondary,
  );

  static TextStyle labelXs = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeXs,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingWide,
    color: ClaySemanticColors.textTertiary,
  );

  // Link Styles
  static TextStyle linkLg = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeLg,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textLink,
    decoration: TextDecoration.underline,
    decorationColor: ClaySemanticColors.textLink.withOpacity(0.3),
    decorationThickness: 2,
  );

  static TextStyle linkBase = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textLink,
    decoration: TextDecoration.underline,
    decorationColor: ClaySemanticColors.textLink.withOpacity(0.3),
    decorationThickness: 1.5,
  );

  static TextStyle linkSm = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textLink,
    decoration: TextDecoration.underline,
    decorationColor: ClaySemanticColors.textLink.withOpacity(0.3),
    decorationThickness: 1,
  );

  // Code Styles
  static TextStyle codeBase = TextStyle(
    fontFamily: ClayTypography.fontMono,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textSecondary,
    backgroundColor: ClaySemanticColors.backgroundSecondary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle codeSm = TextStyle(
    fontFamily: ClayTypography.fontMono,
    fontSize: ClayTypography.sizeXs,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textTertiary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Nepali (Devanagari) Specific Styles
  static TextStyle nepaliBody = TextStyle(
    fontFamily: ClayTypography.fontSecondary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightRelaxed,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  static TextStyle nepaliHeading = TextStyle(
    fontFamily: ClayTypography.fontSecondary,
    fontSize: ClayTypography.sizeXl,
    fontWeight: ClayTypography.weightBold,
    lineHeight: ClayTypography.lineHeightTight,
    letterSpacing: ClayTypography.letterSpacingNormal,
    color: ClaySemanticColors.textPrimary,
  );

  // Status Text Styles
  static TextStyle textSuccess = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    color: ClaySemanticColors.success600,
  );

  static TextStyle textWarning = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    color: ClaySemanticColors.warning600,
  );

  static TextStyle textError = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    color: ClaySemanticColors.error600,
  );

  static TextStyle textInfo = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeSm,
    fontWeight: ClayTypography.weightMedium,
    lineHeight: ClayTypography.lineHeightTight,
    color: ClaySemanticColors.info600,
  );

  // Disabled Style
  static TextStyle textDisabled = TextStyle(
    fontFamily: ClayTypography.fontPrimary,
    fontSize: ClayTypography.sizeBase,
    fontWeight: ClayTypography.weightNormal,
    lineHeight: ClayTypography.lineHeightNormal,
    color: ClaySemanticColors.textTertiary,
    decoration: TextDecoration.lineThrough,
    decorationColor: ClaySemanticColors.textTertiary.withOpacity(0.5),
  );
}

/// ============================================
/// TYPOGRAPHY EXTENSIONS
/// Helper methods for typography
/// ============================================

extension ClayTypographyExtensions on TextStyle {
  /// Apply Claymorphism bold style
  TextStyle get clayBold => copyWith(
    fontWeight: ClayTypography.weightBold,
    letterSpacing: ClayTypography.letterSpacingNormal,
  );

  /// Apply Claymorphism medium style
  TextStyle get clayMedium => copyWith(
    fontWeight: ClayTypography.weightMedium,
    letterSpacing: ClayTypography.letterSpacingNormal,
  );

  /// Apply Claymorphism soft style (for secondary text)
  TextStyle get claySoft => copyWith(
    color: ClaySemanticColors.textSecondary,
    fontWeight: ClayTypography.weightNormal,
  );

  /// Apply Claymorphism muted style (for tertiary text)
  TextStyle get clayMuted => copyWith(
    color: ClaySemanticColors.textTertiary,
    fontWeight: ClayTypography.weightNormal,
  );

  /// Apply Nepali font
  TextStyle get nepali => copyWith(
    fontFamily: ClayTypography.fontSecondary,
  );

  /// Apply monospace font
  TextStyle get mono => copyWith(
    fontFamily: ClayTypography.fontMono,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Increase font size
  TextStyle claySize(double size) => copyWith(
    fontSize: size,
    lineHeight: size * 0.0625 + 1.0, // Maintain proportional line height
  );

  /// Apply gradient color
  TextStyle gradient(List<Color> colors) => copyWith(
    background: LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.zero),
    backgroundBlendMode: BlendMode.srcIn,
  );
}
