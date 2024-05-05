import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/utils.dart';
import 'package:provider/provider.dart';

class MusicInfoTile extends StatelessWidget {
  const MusicInfoTile({super.key, required this.musicItem});

  final Music musicItem;

  @override
  Widget build(BuildContext context) {
    final appState = BlocProvider.of<AppBloc>(context).state;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRouteNames.details, arguments: musicItem);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: (appState.connectivity != ConnectivityResult.none &&
                          musicItem.albumArt.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(musicItem.albumArt,
                              fit: BoxFit.contain))
                      : Image.asset('assets/music_disc.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicItem.title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      musicItem.artist,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "${musicItem.genre} - ${musicItem.year}",
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 1.5,
              child: Consumer<AppBloc>(
                builder: (context, bloc, child) {
                  final isFavourite =
                      Utils.isFavouite(context, songId: musicItem.id);
                  return Container(
                    width: 28.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      icon: Icon(
                        (isFavourite) ? Icons.favorite : Icons.favorite_outline,
                        color: (isFavourite) ? Colors.red : Colors.black,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        bloc.add(
                            ToggleSongFavouriteEvent(songId: musicItem.id));
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
