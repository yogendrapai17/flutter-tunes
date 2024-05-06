import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/widgets/music_square_tile.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Favourites"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close, size: 28.0),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        decoration:
            BoxDecoration(gradient: AppTheme.getScaffoldBackground(context)),
        child: Consumer<AppBloc>(
          builder: (context, bloc, child) {
            List<Music> favourites = [];

            for (String songId in bloc.state.loggedInUser!.favourites) {
              final musicItem =
                  bloc.state.musicList.firstWhereOrNull((e) => e.id == songId);
              if (musicItem != null) {
                favourites.add(musicItem);
              }
            }

            if (favourites.isEmpty) {
              return const Center(
                child: Text(
                  "Lonely here. \nStart tapping the heart icon \non your loved music",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              );
            }

            return Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0),
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  final item = favourites[index];
                  return MusicSquareTile(
                    item: item,
                  ).animate().fadeIn(duration: 2.seconds);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
