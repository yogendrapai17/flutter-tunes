import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/models/music.dart';
import 'package:flutter_tunes/common/widgets/music_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<List<ConnectivityResult>> connectivityStream;

  @override
  initState() {
    super.initState();

    connectivityStream = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      BlocProvider.of<AppBloc>(context)
          .add(ConnectivityChangedEvent(currentConnectivity: result.first));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          previous.connectivity != current.connectivity &&
          previous.connectivity != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text((state.connectivity == ConnectivityResult.none)
                ? 'You are currently offline. \nPlease check the internet connection'
                : 'Connection is back! No longer offline'),
            Icon(
                (state.connectivity == ConnectivityResult.none)
                    ? Icons.wifi_off
                    : Icons.sync,
                color: Colors.white),
          ],
        )));
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouteNames.favourites);
                },
                icon: const Icon(Icons.favorite_outline),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  child: Text('Menu'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    BlocProvider.of<AppBloc>(context).add(UserLogoutEvent());
                    Navigator.of(context)
                        .pushReplacementNamed(AppRouteNames.login);
                  },
                ),
                ListTile(
                  title: Text('Playlist 2'),
                  onTap: () {
                    // Navigate to playlist 2
                  },
                ),
                // Add more menu items as needed
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getScaffoldBackground(context),
            ),
            child: ListView(
              children: [
                _buildHorizontalSection('Top Charts',
                    _buildHorizontalTileList(context, state.musicList)),
                _buildVerticalSection('Discover',
                    _buildVerticalTileList(context, state.musicList)),
                // Add more sections as needed
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: content,
        ),
      ],
    );
  }

  Widget _buildVerticalSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildHorizontalTileList(BuildContext context, List<Music> musicList) {
    return Row(
      children: List.generate(
        musicList.length,
        (index) => MusicTile(
          item: musicList[index],
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRouteNames.details, arguments: musicList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildVerticalTileList(BuildContext context, List<Music> musicList) {
    return Column(
      children: List.generate(
        musicList.length,
        (index) => MusicTile(
          item: musicList[index],
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRouteNames.details, arguments: musicList[index]);
          },
        ),
      ),
    );
  }

  @override
  dispose() {
    connectivityStream.cancel();
    super.dispose();
  }
}
