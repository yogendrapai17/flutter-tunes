import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    );
  }

  /// Dark [ThemeData] for the app
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.teal, // Primary color for dark theme
      ///accentColor: Colors.tealAccent, // Accent color for dark theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Body text color
        titleLarge: TextStyle(color: Colors.white), // Headline text color
      ),
      scaffoldBackgroundColor: Colors.black, // Background color
      appBarTheme: const AppBarTheme(
        color: Colors.teal, // App bar color
        //   textTheme: TextTheme(
        //     headline6: TextStyle(color: Colors.white), // App bar text color
        //   ),
        // ),
        // You can define styles for other UI elements
      ),
    );
  }

  static LinearGradient getScaffoldBackground(BuildContext context) {
    final selectedTheme = BlocProvider.of<AppBloc>(context).state.selectedTheme;

    if (selectedTheme == AppThemeMode.light) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue.shade200, Colors.blue.shade500],
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
