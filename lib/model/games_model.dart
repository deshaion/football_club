import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:hive/hive.dart';

class GamesModel with ChangeNotifier {
  String _activeSeason;
  String _key;

  updateActiveSeason(String newActiveSeason) async {
    print("Update active season for Games Model on $newActiveSeason");

    if (newActiveSeason != _activeSeason) {
      _activeSeason = newActiveSeason;
      _key = "games_$_activeSeason";
      await Hive.openBox<Game>(_key);
      notifyListeners();
    }
  }

  List<Game> getGames() {
    if (_key == null) {
      return [];
    } else {
      var box = Hive.box<Game>(_key);
      return box.values.toList().reversed.toList();
      // sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void update(int idx, Game game) {
    var box = Hive.box<Game>(_key);
    if (idx == -1) {
      box.add(game);
    } else {
      box.putAt(idx, Game.clone(game));
    }
    notifyListeners();
  }

  remove(int index, Game game) {
    game.delete();
    notifyListeners();
  }
}