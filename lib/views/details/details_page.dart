import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/utils.dart';
import 'package:flutter_tunes/common/widgets/audio_player.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.musicItem});

  final Music musicItem;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();

    isFavourite = Utils.isFavouite(context, songId: widget.musicItem.id);
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = BlocProvider.of<AppBloc>(context).state.connectivity !=
        ConnectivityResult.none;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 12, left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 28.0),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(left: 24, top: 36, right: 24, bottom: 0),
        decoration: BoxDecoration(
          gradient: AppTheme.getScaffoldBackground(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 84, bottom: 36),
                width: 260,
                height: 260,
                child: (connectivity && widget.musicItem.albumArt.isNotEmpty)
                    ? ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.network(widget.musicItem.albumArt,
                                fit: BoxFit.contain))
                        .animate()
                        .fadeIn(duration: 2.seconds)
                    : Image.asset('assets/music_disc.png')
                        .animate()
                        .fadeIn(duration: 1.5.seconds)
                        .then()
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .rotate(
                          duration: 36.seconds,
                          begin: 0,
                          end: 1,
                          curve: Curves.linear,
                        ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.musicItem.title,
                            style: const TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12.0),
                        Text(widget.musicItem.artist,
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      icon: Icon(
                        (isFavourite) ? Icons.favorite : Icons.favorite_outline,
                        color: (isFavourite) ? Colors.red : Colors.black,
                        size: 28,
                      ),
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        BlocProvider.of<AppBloc>(context).add(
                            ToggleSongFavouriteEvent(
                                songId: widget.musicItem.id));
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${widget.musicItem.genre} - ${widget.musicItem.year}",
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 36.0),
              AudioPlayer(audioURL: widget.musicItem.audioUrl),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                margin: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lyrics',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                        "Beneath a sky of twilight's hush, \nA lone crow calls, a mournful rush. \nStars begin their silent dance, \nAs shadows lengthen, given cha...")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
