import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// Primary Color
  static const Color primaryColor = Color(0xff15AB90);

  /// Dark Background
  static const Color darkBackground = Color(0xff090B0D);

  /// Dark theme gradient
  static LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.blueGrey,
      Colors.grey.shade900,
    ],
  );

  /// Light theme gradient
  static LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryColor.withOpacity(0.05),
      AppColors.primaryColor.withOpacity(0.25),
      Colors.white
    ],
  );
}
