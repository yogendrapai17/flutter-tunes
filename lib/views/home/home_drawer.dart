import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/main.dart';
import 'package:flutter_tunes/app/routes.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context);
    return ListView(
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
            Navigator.of(context).pushReplacementNamed(AppRouteNames.login);
          },
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          trailing: CupertinoSwitch(
            value: (bloc.state.selectedTheme == ThemeMode.dark),
            onChanged: (value) {
              bloc.add(ToggleDarkModeEvent(isEnabled: value));
              FlutterTunesApp.of(context)
                  .changeTheme((value) ? ThemeMode.dark : ThemeMode.light);
              Navigator.of(context).pop();
            },
          ),
        ),
        ListTile(
          title: Text('Playlist 2'),
          onTap: () {
            // Navigate to playlist 2
          },
        ),
        // Add more menu items as needed
      ],
    );
  }
}
