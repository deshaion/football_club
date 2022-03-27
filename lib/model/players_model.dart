import 'package:flutter/material.dart';
import 'package:football_club/model/player.dart';
import 'package:football_club/utils/ObjectReader.dart';
import 'package:football_club/utils/ObjectWriter.dart';
import 'package:hive/hive.dart';

class PlayersModel with ChangeNotifier {
  bool _boxInitialized = false;
  String? _activeSeason;
  bool isWithNew = false;
  int? indexOfEdit;
  String? _key;

  updateActiveSeason(String newActiveSeason) {
    _boxInitialized = false;
    var initFuture = init(newActiveSeason);
    initFuture.then((voidValue){
      print("Update active season for Players Model on $newActiveSeason");
      _boxInitialized = true;
      notifyListeners();
    });
  }

  Future<void> init(String newActiveSeason) async {
    if (newActiveSeason != _activeSeason) {
      _activeSeason = newActiveSeason;
      _key = "players_$_activeSeason";
      await Hive.openBox<Player>(_key!);
    }
  }

  List<Player> getPlayers() {
    if (!_boxInitialized || _key == null) {
      return [];
    } else {
      var box = Hive.box<Player>(_key!);
      return box.values.toList();
    }
  }
  Future<String> serialize(String seasonKey) async {
    String playerKey = "players_$seasonKey";
    await Hive.openBox<Player>(playerKey);
    var box = Hive.box<Player>(playerKey);
    List<Player> players =  box.values.toList();
    ObjectWriter objectWriter = new ObjectWriter();
    objectWriter.writeInt(players.length);
    for (Player player in players) {
      Player.serialize(objectWriter, player);
    }
    return objectWriter.getValue();
  }
  Future<void> deserialize(ObjectReader objectReader, String seasonKey) async {
    String playerKey = "players_$seasonKey";
    if (playerKey != _key) {
      await Hive.openBox<Player>(playerKey);
    }
    var box = Hive.box<Player>(playerKey);
    await box.clear();

    int n = objectReader.readInt();
    for (int i = 0; i < n; i++) {
      await box.add(Player.deserialize(objectReader));
    }
    print("Restored ${box.length} players");
    if (playerKey != _key) {
      await box.close();
    }
  }

  void addNewPlayer() {
    isWithNew = true;
    notifyListeners();
  }

  void persistNewPlayer(String name) {
    if (_key == null) {
      return;
    }
    isWithNew = false;
    var box = Hive.box<Player>(_key!);
    box.add(Player(name));

    notifyListeners();
  }

  void changeName(Player player, String value) {
    if (_key == null) {
      return;
    }
    indexOfEdit = -1;
    player.name = value;
    player.save();
    notifyListeners();
  }

  void changeInClub(Player player) {
    if (_key == null) {
      return;
    }
    player.inClub = !player.inClub;
    player.save();
    notifyListeners();
  }

  setEditMode(int index) {
    indexOfEdit = index;
    notifyListeners();
  }

  remove(int index, Player player) {
    player.delete();
    notifyListeners();
  }

  String teamDescription(List<int> team) {
    if (team.isEmpty) {
      return "Empty";
    }

    var buffer = new StringBuffer();
    final players = getPlayers();
    bool first = true;
    team.forEach((playerIdx) {
      if (first) {
        first = !first;
      } else {
        buffer.write(", ");
      }
      buffer.write(players[playerIdx].name);
    });
    return buffer.toString();
  }
}