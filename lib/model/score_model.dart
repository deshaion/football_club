import 'dart:math';

import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:football_club/model/player.dart';
import 'package:football_club/model/score_row.dart';
import 'package:football_club/utils/date_util.dart';

class ScoreModel with ChangeNotifier {
  List<Game> _games = [];
  List<ScoreRow> _score = [];
  List<String> _lastGames = [];
  List<String> _lastGamesScores = [];
  List<String> get lastGames => _lastGames;
  List<String> get lastGamesScores => _lastGamesScores;
  List<ScoreRow> get scoreList => _score;

  void updateGames(List<Game> games) {
    _games = games;

    notifyListeners();
  }

  void calcScore(List<Player> players) {
    print("Players count ${players.length}");
    _score = [];

    for(var i = 0; i < players.length; i++) {
      _score.add(ScoreRow(i, players[i].inClub));
    }

    _games.sort((a, b) => b.date.compareTo(a.date));
    int lastDate;
    if (_games.length >= 1) {
      lastDate = _games[0].date;
    }

    int gamesCount = 0;
    for (Game game in _games) {
      if (game.date == lastDate) {
        continue;
      }
      gamesCount++;

      _updateScore(game, false);
    }

    int totalGamesForBeingInRating = 60; //TODO move to season settings
    int remain = gameDaysTillSeasonEnd(lastDate, totalGamesForBeingInRating) * 2 + 2;

    if (gamesCount > 17) { // check inRaiting //TODO move to season settings
      for (ScoreRow row in _score) {
        if (row.type == 0 && row.gameAmount * 100 < gamesCount * 40) { //TODO move to season settings
          row.type = 1;
        }
        if (row.type == 0 && (row.gameAmount + remain < totalGamesForBeingInRating)) {
          row.type = 1;
        }
      }
    }

    _score.sort(_scoreComparator);
    for(var i = 0; i < _score.length; i++) {
      _score[i].position = i + 1;
    }

    bool calcChange = gamesCount > 0;
    if (gamesCount > 0) {
      _score.sort((a, b) => a.playerId.compareTo(b.playerId));
    }

    _lastGames = [];
    _lastGamesScores = [];
    for (Game game in _games) {
      if (game.date != lastDate) {
        continue;
      }
      gamesCount++;

      _lastGames.add(getShortDate(game.date));
      _lastGamesScores.add(game.scoreShort);
      _updateScore(game, true);

      for(var i = 0; i < _score.length; i++) {
        if (_score[i].lastGames.length < _lastGames.length) {
          _score[i].lastGames.add(null);
        }
      }
    }

    remain -= 2;
    if (gamesCount > 17) { // check inRaiting
      for (ScoreRow row in _score) {
        if (row.type == 1) {
          row.type = 0;
        }
        if (row.type == 0 && (row.gameAmount * 100 < gamesCount * 40)) {
          row.type = 1;
        }
        if (row.type == 0 && (row.gameAmount + remain < totalGamesForBeingInRating)) {
          row.type = 1;
        }
      }
    }

    _score.sort(_scoreComparator);
    for(var i = 0; i < _score.length; i++) {
      int prevPosition = _score[i].position;
      _score[i].position = i + 1;
      if (calcChange && _score[i].type < 2) {
        _score[i].change = prevPosition - _score[i].position;
      }
    }

    ScoreRow footer = ScoreRow(null, false);
    footer.type = 3;
    _score.add(footer);
  }

  int _scoreComparator(ScoreRow a, ScoreRow b) {
    if (a.type != b.type) {
      return a.type.compareTo(b.type);
    } else if (a.gameAmount != 0 && b.gameAmount != 0 && a.points * b.gameAmount != b.points * a.gameAmount) {
      return (b.points * a.gameAmount).compareTo(a.points * b.gameAmount);
    } else if (a.gameAmount != b.gameAmount) {
      return b.gameAmount.compareTo(a.gameAmount);
    } else {
      return a.playerId.compareTo(b.playerId);
    }
  }

  void _updateScore(Game game, bool addToLast) {
    int playersInTeam = min(game.team1.length, game.team2.length);
    if (playersInTeam < 2) {
      for (int playerId in game.team1) {
        _score[playerId].points += 0.5;
        if (addToLast) {
          _score[playerId].lastGames.add(0.5);
        }
      }
      for (int playerId in game.team2) {
        _score[playerId].points += 0.5;
        if (addToLast) {
          _score[playerId].lastGames.add(0.5);
        }
      }

      return;
    }

    num pointsTeam1 = _calcPoints(game.score_team1_period1 + game.score_team1_period2, game.score_team2_period1 + game.score_team2_period2, game.teamWinByPenalty == 1, playersInTeam);
    num pointsTeam2 = _calcPoints(game.score_team2_period1 + game.score_team2_period2, game.score_team1_period1 + game.score_team1_period2, game.teamWinByPenalty == 2, playersInTeam);
    num pointsTransferTeam1Begin = (
            _calcPoints(game.score_team1_period1, game.score_team2_period1, false, playersInTeam) +
            _calcPoints(game.score_team2_period2, game.score_team1_period2, false, playersInTeam)) / 2;
    num pointsTransferTeam2Begin = (
            _calcPoints(game.score_team2_period1, game.score_team1_period1, false, playersInTeam) +
            _calcPoints(game.score_team1_period2, game.score_team2_period2, false, playersInTeam)) / 2;
    if (game.date < new DateTime(2021, 2, 7).millisecondsSinceEpoch) {
      pointsTeam1 = _calcPointsOld(game.score_team1_period1 + game.score_team1_period2, game.score_team2_period1 + game.score_team2_period2, game.teamWinByPenalty == 1, playersInTeam);
      pointsTeam2 = _calcPointsOld(game.score_team2_period1 + game.score_team2_period2, game.score_team1_period1 + game.score_team1_period2, game.teamWinByPenalty == 2, playersInTeam);
      pointsTransferTeam1Begin = (
            _calcPointsOld(game.score_team1_period1, game.score_team2_period1, false, playersInTeam) +
            _calcPointsOld(game.score_team2_period2, game.score_team1_period2, false, playersInTeam)) / 2;
      pointsTransferTeam2Begin = (
            _calcPointsOld(game.score_team2_period1, game.score_team1_period1, false, playersInTeam) +
            _calcPointsOld(game.score_team1_period2, game.score_team2_period2, false, playersInTeam)) / 2;
    }

    for(var i = 0; i < playersInTeam; i++) {
      _score[game.team1[i]].gameAmount++;
      _score[game.team1[i]].points += pointsTeam1;
      if (addToLast) {
        _score[game.team1[i]].lastGames.add(pointsTeam1);
      }

      _score[game.team2[i]].gameAmount++;
      _score[game.team2[i]].points += pointsTeam2;
      if (addToLast) {
        _score[game.team2[i]].lastGames.add(pointsTeam2);
      }
    }

    if (game.team1.length > playersInTeam) {
      print("transfered in team 1 with points $pointsTransferTeam1Begin");
      _score[game.team1[playersInTeam]].gameAmount++;
      _score[game.team1[playersInTeam]].points += pointsTransferTeam1Begin;

      if (addToLast) {
        _score[game.team1[playersInTeam]].lastGames.add(pointsTransferTeam1Begin);
      }
    }

    if (game.team2.length > playersInTeam) {
      print("transfered in team 2 with points $pointsTransferTeam2Begin");
      _score[game.team2[playersInTeam]].gameAmount++;
      _score[game.team2[playersInTeam]].points += pointsTransferTeam2Begin;

      if (addToLast) {
        _score[game.team2[playersInTeam]].lastGames.add(pointsTransferTeam2Begin);
      }
    }
  }

  num _calcPoints(int score1, int score2, bool teamWinByPenalty, int playersInTeam) {
    if (score1 == score2) {
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${teamWinByPenalty ? 2 : 1.5}");
      return teamWinByPenalty ? 2 : 1.5;
    } else if (score2 > score1) {
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = 1");
      return 1;
    } else if (playersInTeam > 3) { // rule 3, 3, 4, 4, 4
      num points = 2;
      int diff = score1 - score2;
      if (diff >= 3) {
        points++;
        diff -= 3;
      }
      if (diff >= 3) {
        points++;
        diff -= 3;
      }
      points += (diff / 4).floor();
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${points}");
      return points;
    } else { // players in team are 3
      num points = 2;
      int diff = score1 - score2;
      if (diff >= 5) {
        points++;
      }
      diff -= 5;
      if (diff < 0) {
        diff = 0;
      }
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${points + (diff / 4).floor()}");
      return points + (diff / 4).floor();
    }
  }

  num _calcPointsOld(int score1, int score2, bool teamWinByPenalty, int playersInTeam) {
    if (score1 == score2) {
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${teamWinByPenalty ? 2 : 1.5}");
      return teamWinByPenalty ? 2 : 1.5;
    } else if (score2 > score1) {
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = 1");
      return 1;
    } else if (playersInTeam > 3) { // rule 3, 3, 3, 3, 3
      num points = 2;
      int diff = score1 - score2;
      points += (diff / 3).floor();
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${points}");
      return points;
    } else { // players in team are 3
      num points = 2;
      int diff = score1 - score2;
      if (diff >= 5) {
        points++;
      }
      diff -= 5;
      if (diff < 0) {
        diff = 0;
      }
      print("score $score1-$score2 win $teamWinByPenalty for $playersInTeam = ${points + (diff / 4).floor()}");
      return points + (diff / 4).floor();
    }
  }

  gameDaysTillSeasonEnd(int lastDate, int totalGamesForBeingInRating) {
    if (lastDate == null) {
      return totalGamesForBeingInRating;
    }
    int count = 0;
    DateTime nextWeek = DateTime.fromMillisecondsSinceEpoch(lastDate);
    int currentYear = nextWeek.year;
    while (true) {
      nextWeek = nextWeek.add(new Duration(days: 7));
      if (nextWeek.year > currentYear) {
        break;
      }
      count++;
    }

    return count;
  }
}