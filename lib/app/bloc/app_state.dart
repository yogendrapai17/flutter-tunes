part of 'app_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState({
    this.status = AuthStatus.unknown,
    this.loggedInUser,
    this.selectedTheme = AppThemeMode.dark,
    this.musicList = const [],
    this.connectivity,
  });

  AppState copyWith({
    AuthStatus? status,
    User? loggedInUser,
    AppThemeMode? selectedTheme,
    List<Music>? musicList,
    ConnectivityResult? connectivity,
  }) {
    return AppState(
      status: status ?? this.status,
      loggedInUser: loggedInUser ?? this.loggedInUser,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      musicList: musicList ?? this.musicList,
      connectivity: connectivity ?? this.connectivity,
    );
  }

  @override
  List<Object?> get props =>
      [status, loggedInUser, selectedTheme, musicList, connectivity];

  final AuthStatus status;

  final User? loggedInUser;

  final AppThemeMode selectedTheme;

  final List<Music> musicList;

  final ConnectivityResult? connectivity;
}
