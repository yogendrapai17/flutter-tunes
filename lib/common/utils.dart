import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';

class Utils {
  Utils._();

  /// Create a two digit number from a single digit with leading zero.
  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Get a duration string with 2 digit minutes and seconds
  static String durationString(Duration duration) {
    final String hours = twoDigits(duration.inHours.remainder(24));
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return (hours != "00") ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  /// Load a JSON from assets
  static Future<Map<String, dynamic>> loadJson(String path) async {
    String jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return jsonData;
  }

  /// Check if a given music is favourited by the user.
  static bool isFavouite(BuildContext context, {required String songId}) {
    final userFavourites =
        BlocProvider.of<AppBloc>(context).state.loggedInUser!.favourites;

    return (userFavourites.contains(songId));
  }
}
