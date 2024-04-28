import 'package:flutter/material.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/widgets/audio_player.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.musicItem});

  final Music musicItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getScaffoldBackground(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(musicItem.title,
                style: const TextStyle(
                    fontSize: 32.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            Text(musicItem.artist,
                style: const TextStyle(
                    fontSize: 28.0, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12.0),
            Image.network(musicItem.albumArt),
            const SizedBox(height: 12.0),
            Text(
              "${musicItem.genre} - ${musicItem.year}",
              style:
                  const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12.0),
            AudioPlayer(audioURL: musicItem.audioUrl)
          ],
        ),
      ),
    );
  }
}
