import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/player.dart';

class GameEditModel with ChangeNotifier {
  int idx = -2;
  Game _game = Game.empty();
  Game get game => _game;
  String get scoreTeam1 => "${_game.score_team1_period1 + _game.score_team1_period2}";
  String get scoreTeam2 => "${_game.score_team2_period1 + _game.score_team2_period2}";

  String get scoreTeam1Period1 => _game.score_team1_period1.toString();
  String get scoreTeam2Period1 => _game.score_team2_period1.toString();
  int get teamWinByPenalty => _game.teamWinByPenalty;

  List<int> get team1List => _game.team1;
  List<int> get team2List => _game.team2;

  void update(GamesModel games, int gameIdx) {
    print("GameEditModel update ${idx} to ${gameIdx}");

    if (idx != gameIdx) {
      idx = gameIdx;
      if (idx >= 0) {
        _game = Game.clone(games.getGames()[idx]);
      } else {
        _game = Game.empty();
      }
    }
  }

  void updateDate(int millis) {
    _game.date = millis;
    notifyListeners();
  }

  updateScoreTeam1(String value) {
    int scoreTeam1 = int.parse(value);
    _game.score_team1_period2 = scoreTeam1 - _game.score_team1_period1;

    print("${_game.score_team1_period1} - ${_game.score_team2_period1} | ${_game.score_team1_period2} - ${_game.score_team2_period2}");
  }

  updateScoreTeam1Period1(String value) {
    int team1Period1 = int.parse(value);
    _game.score_team1_period2 += _game.score_team1_period1 - team1Period1;
    _game.score_team1_period1 = team1Period1;

    print("${_game.score_team1_period1} - ${_game.score_team2_period1} | ${_game.score_team1_period2} - ${_game.score_team2_period2}");
  }

  updateScoreTeam2(String value) {
    int scoreTeam2 = int.parse(value);
    _game.score_team2_period2 = scoreTeam2 - _game.score_team2_period1;

    print("${_game.score_team1_period1} - ${_game.score_team2_period1} | ${_game.score_team1_period2} - ${_game.score_team2_period2}");
  }

  updateScoreTeam2Period1(String value) {
    int team2Period1 = int.parse(value);
    _game.score_team2_period2 += _game.score_team2_period1 - team2Period1;
    _game.score_team2_period1 = team2Period1;

    print("${_game.score_team1_period1} - ${_game.score_team2_period1} | ${_game.score_team1_period2} - ${_game.score_team2_period2}");
  }

  updatePenaltyWinTeam(int? newValue) {
    _game.teamWinByPenalty = newValue!;
    notifyListeners();
  }

  List<int> getOtherPlayers(List<Player> players) {
    Set<int> indexes = Iterable<int>.generate(players.length).toSet();

    indexes.removeAll(_game.team1);
    indexes.removeAll(_game.team2);

    return indexes.toList();
  }

  addToTeam(DismissDirection direction, int playerIdx) {
    print("onDismissed ${playerIdx} direction ${direction}");

    if (direction == DismissDirection.startToEnd) {
      _game.team2.add(playerIdx);
    } else {
      _game.team1.add(playerIdx);
    }
    notifyListeners();
  }

  removeFromTeam1(int team1Idx) {
    _game.team1.remove(team1Idx);
    notifyListeners();
  }

  removeFromTeam2(int team2Idx) {
    _game.team2.remove(team2Idx);
    notifyListeners();
  }
}