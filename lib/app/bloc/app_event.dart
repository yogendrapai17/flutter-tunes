part of 'app_bloc.dart';

abstract class AppEvent {}

class AppStartedEvent extends AppEvent {}

class UserLoginEvent extends AppEvent {
  final User? user;

  UserLoginEvent({required this.user});
}

class UserLogoutEvent extends AppEvent {}

class ToggleSongFavouriteEvent extends AppEvent {
  final String songId;

  ToggleSongFavouriteEvent({required this.songId});
}

class ConnectivityChangedEvent extends AppEvent {
  final ConnectivityResult currentConnectivity;

  ConnectivityChangedEvent({required this.currentConnectivity});
}
