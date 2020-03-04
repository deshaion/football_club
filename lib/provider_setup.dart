import 'package:football_club/model/game_edit_model.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/model/score_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'model/season_model.dart';


List<SingleChildWidget> providers = [
  ChangeNotifierProvider<SeasonModel>(create: (context) => SeasonModel()),
  ChangeNotifierProxyProvider<SeasonModel, PlayersModel>(
    create: (context) => PlayersModel(),
    update: (context, seasons, players) {
      players.updateActiveSeason(seasons.activeSeason);
      return players;
    },
  ),
  ChangeNotifierProxyProvider<SeasonModel, GamesModel>(
    create: (context) => GamesModel(),
    update: (context, seasons, games) {
      if (seasons == null) {
        print("seasons is null");
        return games;
      }
      games.updateActiveSeason(seasons.activeSeason);
      return games;
    },
  ),
  ChangeNotifierProxyProvider<GamesModel, ScoreModel>(
    create: (context) => ScoreModel(),
    update: (context, games, score) {
      score.updateGames(games.getGames());
      return score;
    },
  ),
  ChangeNotifierProvider<GameEditModel>(create: (context) => GameEditModel()),
];