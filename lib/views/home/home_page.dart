import 'dart:async';
import 'dart:math';

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

  final ScrollController _scrollController = ScrollController();

  /// Current page for pagination
  int _currentPage = 1;

  /// Last page of data
  late int _lastPage;

  /// Loading state
  bool _isLoading = false;

  @override
  initState() {
    super.initState();

    _lastPage =
        (BlocProvider.of<AppBloc>(context).state.musicList.length ~/ 5) + 1;

    connectivityStream = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      BlocProvider.of<AppBloc>(context)
          .add(ConnectivityChangedEvent(currentConnectivity: result.first));

      _scrollController.addListener(_onScroll);
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
                controller: _scrollController,
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
                              return Column(
                                children: [
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: min(_currentPage * 5,
                                        state.musicList.length),
                                    itemBuilder: (context, index) {
                                      return MusicInfoTile(
                                          musicItem: state.musicList[index]);
                                    },
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1.5),
                                  ),
                                  const SizedBox(height: 24),
                                  if (_isLoading)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: CircularProgressIndicator(),
                                    )
                                ],
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

  /// Check scroll position and show more data
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final delta = maxScroll - currentScroll;

    if (delta <= _scrollController.initialScrollOffset / 3 &&
        !_isLoading &&
        _currentPage <= _lastPage) {
      _fetchMoreData();
    }
  }

  /// Mocking pagination
  void _fetchMoreData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  dispose() {
    _scrollController.dispose();
    connectivityStream.cancel();
    super.dispose();
  }
}
