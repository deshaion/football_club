import 'package:flutter/material.dart';
import 'package:football_club/pages/empty_page.dart';
import 'package:football_club/pages/game_add_edit_page.dart';
import 'package:football_club/pages/games_page.dart';
import 'package:football_club/pages/players_page.dart';
import 'package:football_club/pages/score_page.dart';
import 'package:football_club/pages/seasons_page.dart';
import 'package:football_club/utils/routes.dart';

class FCRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.seasonsPage:
        return MaterialPageRoute(builder: (_) => SeasonsPage());
      case RoutePaths.scorePage:
        return MaterialPageRoute(builder: (_) => ScorePage());
      case RoutePaths.gamesPage:
        return MaterialPageRoute(builder: (_) => GamesPage());
      case RoutePaths.gamePage:
        var data = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => GameAddEditPage(data));
      case RoutePaths.playersPage:
        return MaterialPageRoute(builder: (_) => PlayersPage());
      case RoutePaths.rulesPage:
        return MaterialPageRoute(builder: (_) => EmptyPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            )
          )
        );
    }
  }
}