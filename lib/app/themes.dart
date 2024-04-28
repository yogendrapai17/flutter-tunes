import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';

enum AppThemeMode { light, dark }

class AppTheme {
  const AppTheme._();

  /// Light [ThemeData] for the app
  static ThemeData get lightTheme {
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
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  /// Dark [ThemeData] for the app
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,

      ///accentColor: Colors.tealAccent, // Accent color for dark theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Body text color
        titleLarge: TextStyle(color: Colors.white), // Headline text color
      ),
      scaffoldBackgroundColor: AppColors.darkBackground, // Background color
      appBarTheme: const AppBarTheme(elevation: 0.0, color: Colors.transparent),
    );
  }

  static LinearGradient getScaffoldBackground(BuildContext context) {
    final selectedTheme = BlocProvider.of<AppBloc>(context).state.selectedTheme;

    if (selectedTheme == AppThemeMode.light) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryColor.withOpacity(0.05),
          AppColors.primaryColor.withOpacity(0.25),
          Colors.white
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blueGrey, Colors.grey.shade900],
      );
    }
  }
}
