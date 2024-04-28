part of 'app_bloc.dart';

abstract class AppEvent {}

/// Initial startup event
class AppStartedEvent extends AppEvent {
  final AppThemeMode themeMode;

  AppStartedEvent({required this.themeMode});
}

/// Event on user login
class UserLoginEvent extends AppEvent {
  final User? user;

  UserLoginEvent({required this.user});
}

/// User logout event
class UserLogoutEvent extends AppEvent {}

/// Fav button toggle event
class ToggleSongFavouriteEvent extends AppEvent {
  final String songId;

  ToggleSongFavouriteEvent({required this.songId});
}

/// When app's internet connectivity changes
class ConnectivityChangedEvent extends AppEvent {
  final ConnectivityResult currentConnectivity;

  ConnectivityChangedEvent({required this.currentConnectivity});
}

class SearchFilterSongEvent extends AppEvent {
  final String? searchKey;
  final List<String>? filter;

  SearchFilterSongEvent({this.searchKey, this.filter});
}
