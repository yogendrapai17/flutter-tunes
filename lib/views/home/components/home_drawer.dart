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
    return Column(
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(height: 16),
              Text(
                'Hello, ${bloc.state.loggedInUser?.name}',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favourites'),
          onTap: () {
            Navigator.of(context).popAndPushNamed(AppRouteNames.favourites);
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
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            bloc.add(UserLogoutEvent());
            Navigator.of(context).pushReplacementNamed(AppRouteNames.login);
          },
        ),
        const Spacer(),
        const Text(
          'Version 1.0.1',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        const Text(
          'Made with ❤️ in India',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
