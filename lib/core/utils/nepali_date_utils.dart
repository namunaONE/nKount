/// Nepali Date Utilities for Bikram Sambat (BS) support
/// 
/// This provides comprehensive Nepali date handling for accounting software
/// in Nepal. The Nepali calendar (Bikram Sambat) is approximately 57 years ahead
/// of the Gregorian calendar.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Nepali Date Utility Class
class NepaliDateUtils {
  /// Nepali months in Devanagari and English
  static const List<String> nepaliMonthsDevanagari = [
    '	2c	48	36	3e	15', // बैशाख
    '	1c	47	37	4d	20', // जेठ
    '	05	38	3e	30', // असार
    '	36	4d	30	3e	26	35', // श्रावण
    '	2d	26	30', // भदौ
    '	05	38	4b	2c', // असोज
    '	15	3e	24	4d	24	3f	15', // कार्तिक
    '	2e	30	38	3f	30', // मंसिर
    '	2a	42	37', // पुष
    '	2e	3e	16', // माघ
    '	2b	3e	32	4d	17	41	33', // फागुन
    '	1a	48	24	4d	30', // चैत
  ];

  static const List<String> nepaliMonthsEnglish = [
    'Baisakh',
    'Jestha',
    'Asar',
    'Srawan',
    'Bhadra',
    'Asoj',
    'Kartik',
    'Mangsir',
    'Push',
    'Magh',
    'Falgun',
    'Chaitra',
  ];

  /// Nepali numbers in Devanagari
  static const Map<String, String> nepaliNumbers = {
    '0': '	66', // ०
    '1': '	67', // १
    '2': '	68', // २
    '3': '	69', // ३
    '4': '	6a', // ४
    '5': '	6b', // ५
    '6': '	6c', // ६
    '7': '	6d', // ७
    '8': '	6e', // ८
    '9': '	6f', // ९
  };

  /// Current Nepali year (approximate)
  /// Note: This is an approximation. For exact dates, use a proper conversion library.
  static int get currentNepaliYear {
    final now = DateTime.now();
    // Nepali year is approximately 57 years ahead
    return now.year + 57;
  }

  /// Get current Nepali month (approximate)
  static int get currentNepaliMonth {
    final now = DateTime.now();
    // This is an approximation - actual conversion is more complex
    return now.month;
  }

  /// Get current Nepali day (approximate)
  static int get currentNepaliDay {
    final now = DateTime.now();
    return now.day;
  }

  /// Format a Gregorian date to Nepali date string
  /// Format: YYYY/MM/DD (BS)
  static String formatToNepaliDate(DateTime date) {
    final nepaliYear = date.year + 57;
    final nepaliMonth = date.month;
    final nepaliDay = date.day;
    
    return '${_toNepaliNumber(nepaliYear.toString())}/${_toNepaliNumber(nepaliMonth.toString())}/${_toNepaliNumber(nepaliDay.toString())} (BS)';
  }

  /// Format a Gregorian date to Nepali date with month name
  /// Format: Day Month, Year (BS)
  static String formatToNepaliDateWithMonthName(DateTime date) {
    final nepaliYear = date.year + 57;
    final nepaliMonthIndex = date.month - 1;
    final nepaliDay = date.day;
    
    final monthName = nepaliMonthsEnglish[nepaliMonthIndex];
    
    return '${_toNepaliNumber(nepaliDay.toString())} $monthName, ${_toNepaliNumber(nepaliYear.toString())} (BS)';
  }

  /// Format a Gregorian date to Nepali date with Devanagari
  static String formatToNepaliDateDevanagari(DateTime date) {
    final nepaliYear = date.year + 57;
    final nepaliMonthIndex = date.month - 1;
    final nepaliDay = date.day;
    
    final monthName = nepaliMonthsDevanagari[nepaliMonthIndex];
    
    return '${_toNepaliNumber(nepaliDay.toString())} $monthName ${_toNepaliNumber(nepaliYear.toString())}';
  }

  /// Convert English number string to Nepali (Devanagari) number string
  static String toNepaliNumbers(String input) {
    return input.replaceAllMapped(
      RegExp(r'[0-9]'),
      (match) => nepaliNumbers[match.group(0)] ?? match.group(0)!
    );
  }

  /// Convert Nepali (Devanagari) number string to English number string
  static String toEnglishNumbers(String input) {
    final reversedMap = <String, String>{};
    nepaliNumbers.forEach((key, value) {
      reversedMap[value] = key;
    });
    
    return input.replaceAllMapped(
      RegExp(r'[	66-	6F]'),
      (match) => reversedMap[match.group(0)] ?? match.group(0)!
    );
  }

  /// Convert number string to Nepali
  static String _toNepaliNumber(String number) {
    return toNepaliNumbers(number);
  }

  /// Format Nepali currency
  /// Example: NPR 1,000.00 -> रू १,०००.००
  static String formatNepaliCurrency(double amount) {
    final formatted = NumberFormat('#,##0.00').format(amount);
    return '	30	42 ${toNepaliNumbers(formatted)}'; // रू
  }

  /// Format Nepali currency with symbol
  static String formatNepaliCurrencyWithSymbol(double amount) {
    final formatted = NumberFormat('#,##0.00').format(amount);
    return '	30	42 ${toNepaliNumbers(formatted)}'; // रू
  }

  /// Format number with Nepali numerals
  static String formatNumberWithNepaliNumerals(double number, {int decimalPlaces = 2}) {
    final formatted = number.toStringAsFixed(decimalPlaces);
    return toNepaliNumbers(formatted);
  }

  /// Get Nepali month name from index (0-11)
  static String getNepaliMonthName(int index, {bool devanagari = false}) {
    if (index < 0 || index > 11) {
      return 'Invalid Month';
    }
    return devanagari ? nepaliMonthsDevanagari[index] : nepaliMonthsEnglish[index];
  }

  /// Get all Nepali months
  static List<String> getNepaliMonths({bool devanagari = false}) {
    return devanagari ? nepaliMonthsDevanagari : nepaliMonthsEnglish;
  }

  /// Nepali fiscal year (starts from Baisakh 1)
  static String getNepaliFiscalYear(DateTime date) {
    final nepaliYear = date.year + 57;
    final nepaliMonth = date.month;
    
    // Fiscal year starts in Baisakh (April)
    if (nepaliMonth >= 4) {
      // After Baisakh (April), fiscal year is current year to next year
      return '${_toNepaliNumber(nepaliYear.toString())}/${_toNepaliNumber((nepaliYear + 1).toString())}';
    } else {
      // Before Baisakh, fiscal year is previous year to current year
      return '${_toNepaliNumber((nepaliYear - 1).toString())}/${_toNepaliNumber(nepaliYear.toString())}';
    }
  }

  /// Get days in Nepali month (approximate)
  /// Note: Nepali months have varying days (30-32)
  static int getDaysInNepaliMonth(int month) {
    const daysInMonth = [
      31, // Baisakh
      31, // Jestha
      32, // Asar
      32, // Srawan
      31, // Bhadra
      30, // Asoj
      30, // Kartik
      29, // Mangsir
      30, // Push
      30, // Magh
      29, // Falgun
      30, // Chaitra
    ];
    
    if (month >= 1 && month <= 12) {
      return daysInMonth[month - 1];
    }
    return 30;
  }

  /// Check if a Nepali year is a leap year (approximate)
  static bool isNepaliLeapYear(int nepaliYear) {
    // Nepali leap years occur approximately every 3-4 years
    // This is a simplified calculation
    return (nepaliYear + 57) % 4 == 0;
  }

  /// Convert approximate Gregorian date to Nepali date
  /// Note: This is an approximation. For exact conversion, use a proper library.
  static Map<String, int> gregorianToNepali(DateTime date) {
    final year = date.year + 57;
    final month = date.month;
    final day = date.day;
    
    return {
      'year': year,
      'month': month,
      'day': day,
    };
  }

  /// Convert approximate Nepali date to Gregorian date
  static DateTime nepaliToGregorian(int nepaliYear, int nepaliMonth, int nepaliDay) {
    return DateTime(nepaliYear - 57, nepaliMonth, nepaliDay);
  }

  /// Get Nepali date range for a fiscal year
  static Map<String, DateTime> getFiscalYearRange(int nepaliYear) {
    // Fiscal year starts in Baisakh (April)
    final startYear = nepaliYear - 57;
    final endYear = nepaliYear - 56;
    
    return {
      'start': DateTime(startYear, 4, 1), // Baisakh 1
      'end': DateTime(endYear, 3, 31), // Chaitra end
    };
  }

  /// Format date range in Nepali
  static String formatNepaliDateRange(DateTime start, DateTime end) {
    final startNepali = formatToNepaliDate(start);
    final endNepali = formatToNepaliDate(end);
    return '$startNepali - $endNepali';
  }

  /// Get current Nepali date as a formatted string
  static String getCurrentNepaliDate() {
    return formatToNepaliDate(DateTime.now());
  }

  /// Get current Nepali date with month name
  static String getCurrentNepaliDateWithMonthName() {
    return formatToNepaliDateWithMonthName(DateTime.now());
  }

  /// Get Nepali weekday name
  static const List<String> nepaliWeekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static const List<String> nepaliWeekdaysDevanagari = [
    '	05	3e	24	35	3e	30', // आइतबार
    '	38	4b	2e	35	3e	30', // सोमबार
    '	2e	1c	32	35	3e	30', // मंगलबार
    '	2c	41	2d	35	3e	30', // बुधबार
    '	2c	3f	1c	35	3e	30', // बिहिबार
    '	36	41	15	35	3e	30', // शुक्रबार
    '	36	28	3f	35	3e	30', // शनिबार
  ];

  static String getNepaliWeekdayName(int weekday, {bool devanagari = false}) {
    if (weekday < 1 || weekday > 7) {
      return 'Invalid Day';
    }
    return devanagari 
        ? nepaliWeekdaysDevanagari[weekday - 1]
        : nepaliWeekdays[weekday - 1];
  }
}

/// Extension methods for DateTime
extension NepaliDateTimeExtensions on DateTime {
  /// Convert to Nepali date string
  String toNepaliDate() {
    return NepaliDateUtils.formatToNepaliDate(this);
  }

  /// Convert to Nepali date with month name
  String toNepaliDateWithMonthName() {
    return NepaliDateUtils.formatToNepaliDateWithMonthName(this);
  }

  /// Convert to Nepali date with Devanagari
  String toNepaliDateDevanagari() {
    return NepaliDateUtils.formatToNepaliDateDevanagari(this);
  }

  /// Get Nepali year
  int get nepaliYear => year + 57;

  /// Get Nepali month
  int get nepaliMonth => month;

  /// Get Nepali day
  int get nepaliDay => day;
}

/// Extension methods for double (currency formatting)
extension NepaliCurrencyExtensions on double {
  /// Format as Nepali currency
  String toNepaliCurrency() {
    return NepaliDateUtils.formatNepaliCurrency(this);
  }

  /// Format as Nepali currency with symbol
  String toNepaliCurrencyWithSymbol() {
    return NepaliDateUtils.formatNepaliCurrencyWithSymbol(this);
  }

  /// Format number with Nepali numerals
  String toNepaliNumerals({int decimalPlaces = 2}) {
    return NepaliDateUtils.formatNumberWithNepaliNumerals(this, decimalPlaces: decimalPlaces);
  }
}

/// Nepali Date Picker Theme
class NepaliDatePickerTheme {
  static const Color primaryColor = Color(0xFF8B5CF6);
  static const Color backgroundColor = Color(0xFFFDFBF8);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF1F2937);
  static const Color accentColor = Color(0xFF34D399);
  static const Color errorColor = Color(0xFFD63031);
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF6B7280),
  );
  
  static const TextStyle dayStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle selectedDayStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle todayStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
}
