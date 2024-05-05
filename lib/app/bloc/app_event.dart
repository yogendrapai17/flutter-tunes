part of 'app_bloc.dart';

abstract class AppEvent {}

/// Initial startup event
class AppStartedEvent extends AppEvent {
  final ThemeMode themeMode;

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

/// Add/Remove filter
class ToggleFilterEvent extends AppEvent {
  final String filter;

  ToggleFilterEvent({required this.filter});
}

/// Search song with a key
class SearchSongEvent extends AppEvent {
  final String? searchKey;

  SearchSongEvent({this.searchKey});
}

/// Enable/Disable Dark Mode in application
class ToggleDarkModeEvent extends AppEvent {
  final bool isEnabled;

  ToggleDarkModeEvent({required this.isEnabled});
}
