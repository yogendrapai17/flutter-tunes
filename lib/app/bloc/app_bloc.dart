import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/common/consts.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/models/user.dart';
import 'package:flutter_tunes/common/utils.dart';
import 'package:flutter_tunes/services/cache_service.dart';
import 'package:flutter_tunes/services/user_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppEvent>((event, emit) {});
    on<AppStartedEvent>(_onAppInitEvent);
    on<UserLoginEvent>(_onUserLoginEvent);
    on<UserLogoutEvent>(_onUserLogoutEvent);
    on<ToggleSongFavouriteEvent>(_onToggleFavouriteEvent);
    on<ConnectivityChangedEvent>(_onConnectivityChangedEvent);
    on<ToggleDarkModeEvent>(_onToggleDarkModeEvent);
  }

  Future<void> _onAppInitEvent(
    AppStartedEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(selectedTheme: event.themeMode));
    final connectivity = await Connectivity().checkConnectivity();

    final session = await _cacheService.readStringFromCache(StringConsts.user);

    if (session != null &&
        session.isNotEmpty &&
        !connectivity.contains(ConnectivityResult.none)) {
      final userData = await _syncUserSession(userMap: json.decode(session));
      emit(state.copyWith(
        status: (userData != null)
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        loggedInUser: userData,
        connectivity: connectivity.first,
      ));
    } else {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          connectivity: connectivity.first));
    }

    List<Music> musicItems = [];

    final itemsMap = await Utils.loadJson(StringConsts.musicData);

    for (Map<String, dynamic> item in itemsMap['data']) {
      musicItems.add(Music.fromJson(item));
    }
    emit(state.copyWith(musicList: musicItems));
  }

  Future<void> _onUserLoginEvent(
    UserLoginEvent event,
    Emitter<AppState> emit,
  ) async {
    _cacheService.saveStringToCache(
        key: StringConsts.user, value: json.encode(event.user?.toLocalJson()));

    emit(state.copyWith(
        status: AuthStatus.authenticated, loggedInUser: event.user));
  }

  Future<void> _onUserLogoutEvent(
    UserLogoutEvent event,
    Emitter<AppState> emit,
  ) async {
    _cacheService.removeValueFromCache(StringConsts.user);

    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onToggleFavouriteEvent(
    ToggleSongFavouriteEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      List<String> existingFavs =
          (state.loggedInUser?.favourites.isNotEmpty ?? false)
              ? [...state.loggedInUser!.favourites]
              : [];
      if (existingFavs.contains(event.songId)) {
        existingFavs.remove(event.songId);
      } else {
        existingFavs.add(event.songId);
      }

      final updatedUser = state.loggedInUser!
          .copyWith(favourites: existingFavs, isSynced: false);

      _cacheService.saveStringToCache(
          key: StringConsts.user,
          value: json.encode(updatedUser.toLocalJson()));

      emit(state.copyWith(loggedInUser: updatedUser));

      /// Evaluate sync result.
      final syncRes = await _syncFavouriteData(updatedUser);
      if (syncRes) {
        emit(
            state.copyWith(loggedInUser: updatedUser.copyWith(isSynced: true)));
      }
    } catch (e) {
      debugPrint("Toggle Fav error: ${e.toString()}");
    }
  }

  /// Update the connectivity status
  Future<void> _onConnectivityChangedEvent(
    ConnectivityChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(connectivity: event.currentConnectivity));
  }

  /// Enable/Disable Dark Mode
  Future<void> _onToggleDarkModeEvent(
    ToggleDarkModeEvent event,
    Emitter<AppState> emit,
  ) async {
    _cacheService.saveBoolToCache(
        key: StringConsts.darkTheme, value: event.isEnabled);
    emit(state.copyWith(
        selectedTheme: (event.isEnabled) ? ThemeMode.dark : ThemeMode.light));
  }

  /// Sync local changes with remote and fetch the latest data
  Future<User?> _syncUserSession(
      {required Map<String, dynamic> userMap}) async {
    // Unsynced data changes in local, sync with remote
    if (userMap['isSynced'] == false) {
      final result = await _userService.updateUserDetails(
          userData: User.fromJson(userMap));

      // If sync is unsuccessful return the local object.
      if (!(result ?? false)) {
        return User.fromJson(userMap);
      }
    }

    return await _userService.getUserDetails(userId: userMap['user_id']);
  }

  /// Sync the Fav data with remote asynchronously.
  /// On failure,
  Future<bool> _syncFavouriteData(User userData) async {
    try {
      final result = await _userService.updateUserDetails(userData: userData);

      // Sync success, update the local user session as synced
      if (result ?? false) {
        final updatedUser = userData.copyWith(isSynced: true);

        _cacheService.saveStringToCache(
            key: StringConsts.user,
            value: json.encode(updatedUser.toLocalJson()));
        return true;
      }
    } catch (e) {
      debugPrint("Sync Fav error: ${e.toString()}");
    }
    return false;
  }

  CacheService get _cacheService => CacheService();

  UserService get _userService => UserService();
}
