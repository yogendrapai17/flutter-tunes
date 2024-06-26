import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';

class AppTheme {
  const AppTheme._();

  /// Light [ThemeData] for the app
  static ThemeData get lightThemeData {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      useMaterial3: false,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        },
      ),
      primaryColor: AppColors.primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primaryColor), // Set focused border color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primaryColor),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  /// Dark [ThemeData] for the app
  static ThemeData get darkThemeData {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      useMaterial3: false,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        },
      ),
      primaryColor: AppColors.primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primaryColor), // Set focused border color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primaryColor),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  static LinearGradient getScaffoldBackground(BuildContext context) {
    final selectedTheme = BlocProvider.of<AppBloc>(context).state.selectedTheme;

    return (selectedTheme == ThemeMode.light)
        ? AppColors.lightGradient
        : AppColors.darkGradient;
  }
}
