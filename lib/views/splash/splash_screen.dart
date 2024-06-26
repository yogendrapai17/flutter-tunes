import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
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
    return BlocConsumer<AppBloc, AppState>(
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
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: (state.selectedTheme == ThemeMode.dark)
                  ? AppColors.darkGradient
                  : AppColors.lightGradient,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Hero(
                  tag: 'logo',
                  child: Image.asset(StringConsts.appLogo, width: 180),
                ),
                const SizedBox(height: 80),
                const CircularProgressIndicator(),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    "Your personalized music universe",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
