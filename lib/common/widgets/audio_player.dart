import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tunes/common/utils.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key, this.audioURL, this.audioFile});

  /// Path of the audio file from remote source
  final String? audioURL;

  /// Path of the audio file from local source
  final File? audioFile;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  bool _decoderSupported = true; // Assumption
  StreamSubscription? _playerSubscription;

  final Codec _codec = Codec.aacMP4;
  final int tSAMPLERATE = 8000;

  /// Sample rate used for Streams
  final int tSTREAMSAMPLERATE =
      44000; // 44100 does not work for recorder on iOS

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
    playerModule.closePlayer();
    super.dispose();
  }

  Future<void> initPlayer() async {
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    _decoderSupported = await playerModule.isDecoderSupported(_codec);
  }

  void _addListeners() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }

    _playerSubscription = playerModule.onProgress!.listen((e) {
      maxDuration = e.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;

      sliderCurrentPosition =
          min(e.position.inMilliseconds.toDouble(), maxDuration);
      if (sliderCurrentPosition < 0.0) {
        sliderCurrentPosition = 0.0;
      }
      setState(() {
        audioDuration = e.duration;
        currentPosition = e.position;
      });
    });
  }

  Future<void> startPlayer() async {
    try {
      await playerModule.startPlayer(
          fromURI: widget.audioFile?.path ?? widget.audioURL,
          codec: _codec,
          sampleRate: tSTREAMSAMPLERATE,
          whenFinished: () {
            playerModule.logger.d('Play finished');
            setState(() {});
          });
      _addListeners();
      setState(() {});
      playerModule.logger.d('<--- startPlayer');
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
  }

  void pauseResumePlayer() async {
    try {
      if (playerModule.isPlaying) {
        await playerModule.pausePlayer();
      } else {
        await playerModule.resumePlayer();
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
    setState(() {});
  }

  Future<void> seekToPlayer(int milliSecs) async {
    //playerModule.logger.d('-->seekToPlayer');
    try {
      if (playerModule.isPlaying) {
        await playerModule.seekToPlayer(Duration(milliseconds: milliSecs));
      }
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
    setState(() {});
    //playerModule.logger.d('<--seekToPlayer');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 60.0,
              child: Text(
                Utils.durationString(currentPosition),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 30.0,
                child: SliderTheme(
                  data: SliderThemeData(
                      overlayShape: SliderComponentShape.noThumb),
                  child: Slider(
                    min: 0.0,
                    max: maxDuration,
                    value: min(sliderCurrentPosition, maxDuration),
                    onChanged: (value) async {
                      await seekToPlayer(value.toInt());
                    },
                    divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt(),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 60.0,
              child: Text(
                Utils.durationString(audioDuration),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36.0),
        Container(
          height: 80.0,
          width: 80.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: IconButton(
            onPressed: () {
              if (playerModule.isStopped) {
                // Disable the button if the selected codec is not supported
                if (!(_decoderSupported || _codec == Codec.pcm16)) {
                  return;
                }
                startPlayer();
              } else if (playerModule.isPlaying || playerModule.isPaused) {
                pauseResumePlayer();
              }
            },
            icon: Icon(
              (playerModule.isPlaying) ? Icons.pause : Icons.play_arrow,
              size: 48.0,
            ),
          ),
        ),
      ],
    );
  }
}
