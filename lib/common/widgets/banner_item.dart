import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/common/models/music.dart';

class BannerItem extends StatelessWidget {
  const BannerItem({
    required this.musicItem,
    super.key,
  });

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
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          image: DecorationImage(
              image: (appState.connectivity != ConnectivityResult.none &&
                      musicItem.albumArt.isNotEmpty)
                  ? NetworkImage(musicItem.albumArt)
                  : const AssetImage('assets/music_disc.png') as ImageProvider,
              fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    musicItem.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    musicItem.artist,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
