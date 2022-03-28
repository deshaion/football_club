import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:football_club/utils/ObjectReader.dart';
import 'package:football_club/utils/ObjectWriter.dart';
import 'package:hive/hive.dart';

class GamesModel with ChangeNotifier {
  bool _boxInitialized = false;
  String _activeSeason = "";
  String _key = "";

  updateActiveSeason(String newActiveSeason) {
    if (newActiveSeason == "") {
      return;
    }
    _boxInitialized = false;
    var initFuture = init(newActiveSeason);
    initFuture.then((voidValue) {
      print("Update active season for Games Model on $newActiveSeason");
      _boxInitialized = true;
      notifyListeners();
    });
  }

  Future<void> init(String newActiveSeason) async {
    if (newActiveSeason != _activeSeason) {
      _activeSeason = newActiveSeason;
      _key = "games_$_activeSeason";
      await Hive.openBox<Game>(_key);
    }
  }

  List<Game> getGames() {
    if (!_boxInitialized || _key == null) {
      return [];
    } else {
      var box = Hive.box<Game>(_key);
      return box.values.toList().reversed.toList();
      // sort((a, b) => b.date.compareTo(a.date));
    }
  }

  Future<String> serialize(String seasonKey) async {
    String gameKey = "games_$seasonKey";
    await Hive.openBox<Game>(gameKey);
    var box = Hive.box<Game>(gameKey);
    List<Game> games =  box.values.toList();
    ObjectWriter objectWriter = new ObjectWriter();
    objectWriter.writeInt(games.length);
    for (Game game in games) {
      Game.serialize(objectWriter, game);
    }
    return objectWriter.getValue();
  }

  Future<void> deserialize(ObjectReader objectReader, String seasonKey) async {
    String gameKey = "games_$seasonKey";
    if (gameKey != _key) {
      await Hive.openBox<Game>(gameKey);
    }
    var box = Hive.box<Game>(gameKey);
    await box.clear();

    int n = objectReader.readInt();
    for (int i = 0; i < n; i++) {
      await box.add(Game.deserialize(objectReader));
    }

    print("Restored ${box.length} games");
    if (gameKey != _key) {
      await box.close();
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