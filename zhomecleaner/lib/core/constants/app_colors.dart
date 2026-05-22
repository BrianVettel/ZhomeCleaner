import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color primaryCyan = Color(0xFF00BCD4);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);

  static const Color bgLight = Color(0xFFF8FAFF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgGrey = Color(0xFFF0F4FF);

  static const Color textPrimary = Color(0xFF1C2B4A);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFFB0BEC5);
  static const Color textWhite = Color(0xFFFFFFFF);

  static const Color statusPending = Color(0xFFFF9800);
  static const Color statusConfirmed = Color(0xFF2196F3);
  static const Color statusOngoing = Color(0xFF9C27B0);
  static const Color statusDone = Color(0xFF4CAF50);
  static const Color statusCancelled = Color(0xFFF44336);
  static const Color error = Color(0xFFF44336);
  static const Color divider = Color(0xFFE8EEF8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFFE8F1FF), Color(0xFFE0F7FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primaryBlue.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryBlue.withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}