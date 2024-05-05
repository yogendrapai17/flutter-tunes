import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/widgets/music_info_tile.dart';
import 'package:flutter_tunes/views/home/components/filter_search_widget.dart';
import 'package:flutter_tunes/views/home/components/top_charts_widget.dart';

import 'components/home_drawer.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
            ),
          ),
        );
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      width: 36,
                      height: 36,
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouteNames.favourites);
                  },
                  icon: const Icon(Icons.favorite_outline),
                ),
                const SizedBox(width: 8),
              ],
            ),
            drawer: const Drawer(
              child: HomeDrawer(),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.getScaffoldBackground(context),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 60),
                children: [
                  const TopChartsWidget(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Discover',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const FilterSearchWidget(),
                        const SizedBox(height: 16),
                        BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                            if (state.filters.isNotEmpty ||
                                (state.searchKey?.isNotEmpty ?? false)) {
                              if (state.searchResult?.isEmpty ?? true) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 24),
                                    child:
                                        Text('No items that match the search'),
                                  ),
                                );
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: state.searchResult!.length,
                                itemBuilder: (context, index) {
                                  return MusicInfoTile(
                                      musicItem: state.searchResult![index]);
                                },
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1.5),
                              );
                            } else {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: state.musicList.length,
                                itemBuilder: (context, index) {
                                  return MusicInfoTile(
                                      musicItem: state.musicList[index]);
                                },
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1.5),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  dispose() {
    connectivityStream.cancel();
    super.dispose();
  }
}
