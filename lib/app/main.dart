import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/common/consts.dart';
import 'package:flutter_tunes/firebase_options.dart';

import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FlutterTunesApp());
}

class FlutterTunesApp extends StatelessWidget {
  const FlutterTunesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (BuildContext context) =>
          AppBloc()..add(AppStartedEvent(themeMode: AppThemeMode.dark)),
      child: MaterialApp(
        title: StringConsts.appTitle,
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouteNames.splash,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
