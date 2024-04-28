import 'package:flutter/material.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/views/details/details_page.dart';
import 'package:flutter_tunes/views/favourites/favourites_screen.dart';
import 'package:flutter_tunes/views/home/home_page.dart';
import 'package:flutter_tunes/views/login/login_page.dart';
import 'package:flutter_tunes/views/splash/splash_screen.dart';

class AppRouteNames {
  static const splash = 'splash';
  static const login = 'login';
  static const home = 'home';
  static const details = 'details';
  static const favourites = 'favourites';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splash:
        return _buildMaterialPageRoute(const SplashPage());
      case AppRouteNames.login:
        return _buildMaterialPageRoute(const LoginPage());
      case AppRouteNames.home:
        return _buildMaterialPageRoute(const HomePage());
      case AppRouteNames.details:
        return _buildMaterialPageRoute(
            DetailsPage(musicItem: settings.arguments as Music));
      case AppRouteNames.favourites:
        return _buildMaterialPageRoute(const FavouritesPage());
      default:
        return _buildMaterialPageRoute(const Scaffold());
    }
  }

  static Route<dynamic> _buildMaterialPageRoute(Widget widget) {
    return MaterialPageRoute(
      builder: (_) => widget,
    );
  }
}
