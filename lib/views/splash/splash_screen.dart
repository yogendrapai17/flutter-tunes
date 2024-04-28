import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/consts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _preCacheImage();
    });
  }

  /// Pre cache splash logo for better experience
  void _preCacheImage() {
    final images = <ImageProvider>[
      const AssetImage(StringConsts.appLogo),
    ];

    for (final image in images) {
      precacheImage(image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (p, c) => c.status != AuthStatus.unknown,
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 1500)).then(
          (value) {
            if (state.status == AuthStatus.authenticated) {
              Navigator.of(context).pushReplacementNamed(AppRouteNames.home);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRouteNames.login);
            }
          },
        );
      },
      child: Scaffold(
        body: Container(
          decoration:
              BoxDecoration(gradient: AppTheme.getScaffoldBackground(context)),
          child: Center(
            child: Hero(
              tag: 'logo',
              child: Image.asset(StringConsts.appLogo, width: 180),
            ),
          ),
        ),
      ),
    );
  }
}
