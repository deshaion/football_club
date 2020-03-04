import 'dart:async';
import 'package:flutter/material.dart';
import 'package:football_club/main.dart';
import 'package:football_club/model/season_model.dart';
import 'package:football_club/utils/routes.dart';
import 'package:provider/provider.dart';

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seasons = Provider.of<SeasonModel>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Season: ${seasons.getActiveSeasonText()}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Seasons'),
//            selected: _activeRoute == RoutePaths.seasonsPage,
            onTap: () => Navigator.pushNamed(context, RoutePaths.seasonsPage),
          ),
          ListTile(
            leading: Icon(Icons.dvr),
            title: Text('Score'),
//            selected: _activeRoute == RoutePaths.seasonsPage,
            onTap: () => Navigator.pushNamed(context, RoutePaths.scorePage),
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Games'),
//            selected: _activeRoute == RoutePaths.gamesPage,
            onTap: () => Navigator.pushNamed(context, RoutePaths.gamesPage),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Players'),
//            selected: _activeRoute == RoutePaths.playersPage,
            onTap: () => Navigator.pushNamed(context, RoutePaths.playersPage),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Rules'),
//            selected: _activeRoute == RoutePaths.rulesPage,
            onTap: () => Navigator.pushNamed(context, RoutePaths.rulesPage),
          ),
        ],
      ),
    );
  }
}