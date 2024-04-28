import 'package:flutter/material.dart';
import 'package:flutter_tunes/common/consts.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/utils.dart';

class HomeProvider extends ChangeNotifier {
  final List<Music> musicItems = [];

  Future<void> initialize() async {
    try {
      final itemsMap = await Utils.loadJson(StringConsts.musicData);

      for (Map<String, dynamic> item in itemsMap['data']) {
        musicItems.add(Music.fromJson(item));
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
