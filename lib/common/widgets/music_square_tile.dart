import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/utils.dart';
import 'package:provider/provider.dart';

class MusicSquareTile extends StatelessWidget {
  final Music item;

  const MusicSquareTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appState = BlocProvider.of<AppBloc>(context).state;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRouteNames.details, arguments: item);
      },
      child: Container(
        width: min(200.0, screenSize.width * 0.6),
        margin: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: Stack(
            children: <Widget>[
              SizedBox(
                  height: 180,
                  child: (appState.connectivity != ConnectivityResult.none &&
                          item.albumArt.isNotEmpty)
                      ? Image.network(item.albumArt, fit: BoxFit.contain)
                      : Image.asset('assets/music_disc.png')),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: (appState.selectedTheme == ThemeMode.light)
                      ? Colors.white
                      : AppColors.darkBackground,
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        item.artist,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 3.0,
                right: 3.0,
                child: Consumer<AppBloc>(
                  builder: (context, bloc, child) {
                    final isFavourite =
                        Utils.isFavouite(context, songId: item.id);
                    return Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        icon: Icon(
                          (isFavourite)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: (isFavourite) ? Colors.red : Colors.black,
                        ),
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          bloc.add(ToggleSongFavouriteEvent(songId: item.id));
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
