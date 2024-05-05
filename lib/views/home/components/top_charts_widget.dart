import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/common/widgets/banner_item.dart';

class TopChartsWidget extends StatelessWidget {
  const TopChartsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Shuffle and display top 3 songs
    final music = [...BlocProvider.of<AppBloc>(context).state.musicList];
    music.shuffle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 8, 8),
          child: Text(
            'Top Charts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2,
            enlargeCenterPage: true,
          ),
          items:
              music.sublist(0, 3).map((e) => BannerItem(musicItem: e)).toList(),
        ),
      ],
    );
  }
}
