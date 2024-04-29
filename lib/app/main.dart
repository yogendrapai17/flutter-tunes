import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/common/consts.dart';
import 'package:flutter_tunes/firebase_options.dart';
import 'package:flutter_tunes/services/cache_service.dart';

import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Fetch Dark mode data from cache
  final darkMode =
      await CacheService().readBoolFromCache(StringConsts.darkTheme);

  runApp(
    FlutterTunesApp(
      themeMode: (darkMode ?? false) ? ThemeMode.dark : ThemeMode.light,
    ),
  );
}

class FlutterTunesApp extends StatefulWidget {
  const FlutterTunesApp({super.key, required this.themeMode});

  final ThemeMode themeMode;

  @override
  State<FlutterTunesApp> createState() => _FlutterTunesAppState();

  static _FlutterTunesAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_FlutterTunesAppState>()!;
}

class _FlutterTunesAppState extends State<FlutterTunesApp> {
  late ThemeMode _themeMode;
  @override
  void initState() {
    _themeMode = widget.themeMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (BuildContext context) =>
          AppBloc()..add(AppStartedEvent(themeMode: _themeMode)),
      child: MaterialApp(
        title: StringConsts.appTitle,
        theme: (_themeMode == ThemeMode.dark)
            ? AppTheme.darkThemeData
            : AppTheme.lightThemeData,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouteNames.splash,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
