part of 'app_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState(
      {this.status = AuthStatus.unknown,
      this.loggedInUser,
      this.selectedTheme,
      this.musicList = const [],
      this.searchResult,
      this.connectivity,
      this.searchKey,
      this.filters = const []});

  AppState copyWith({
    AuthStatus? status,
    User? loggedInUser,
    ThemeMode? selectedTheme,
    List<Music>? musicList,
    ConnectivityResult? connectivity,
    List<Music>? searchResult,
    String? searchKey,
    List<String>? filters,
  }) {
    return AppState(
      status: status ?? this.status,
      loggedInUser: loggedInUser ?? this.loggedInUser,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      musicList: musicList ?? this.musicList,
      connectivity: connectivity ?? this.connectivity,
      searchResult: searchResult ?? this.searchResult,
      searchKey: searchKey ?? this.searchKey,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
        status,
        loggedInUser,
        selectedTheme,
        musicList,
        connectivity,
        searchKey,
        searchResult,
        filters
      ];

  final AuthStatus status;

  final User? loggedInUser;

  final ThemeMode? selectedTheme;

  final List<Music> musicList;

  final List<Music>? searchResult;

  final ConnectivityResult? connectivity;

  final String? searchKey;

  final List<String> filters;
}
