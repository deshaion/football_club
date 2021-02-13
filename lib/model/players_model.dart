import 'package:flutter/material.dart';
import 'package:football_club/model/player.dart';
import 'package:hive/hive.dart';

class PlayersModel with ChangeNotifier {
  String _activeSeason;
  bool isWithNew = false;
  int indexOfEdit;
  String _key;

  updateActiveSeason(String newActiveSeason) async {
    print("Update active season for Players Model on $newActiveSeason");

    if (newActiveSeason != _activeSeason) {
      _activeSeason = newActiveSeason;
      _key = "players_$_activeSeason";
      await Hive.openBox<Player>(_key);
      notifyListeners();
    }
  }

  List<Player> getPlayers() {
    if (_key == null) {
      return [];
    } else {
      var box = Hive.box<Player>(_key);
      return box.values.toList();
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
    var box = Hive.box<Player>(_key);
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