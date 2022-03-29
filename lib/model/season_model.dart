import 'dart:io';

import 'package:flutter/material.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/hive_keys.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/utils/ObjectReader.dart';
import 'package:football_club/utils/date_util.dart';
import 'package:hive/hive.dart';

class SeasonModel with ChangeNotifier {
  String activeSeason = "";
  int expandedIndex = -1;
  List<String> seasons = [];
  bool isWithNew = false;
  String backupPath = "";

  int totalGamesForBeingInRating = 60;
  int amountOfGamesForCheckingInRating = 17;
  int percentForBeingInRating = 40;
  int remainGamesForChecking = 16;

  SeasonModel() {
    var settingsBox = Hive.box(Hive_Settings);
    activeSeason = settingsBox.get("activeSeason", defaultValue: "");
    backupPath = settingsBox.get("backupPath", defaultValue: "");
    totalGamesForBeingInRating = settingsBox.get("totalGamesForBeingInRating", defaultValue: 60);
    amountOfGamesForCheckingInRating = settingsBox.get("amountOfGamesForCheckingInRating", defaultValue: 17);
    percentForBeingInRating = settingsBox.get("percentForBeingInRating", defaultValue: 40);
    remainGamesForChecking = settingsBox.get("remainGamesForChecking", defaultValue: 16);

    var seasonBox = Hive.box<String>(Hive_Seasons);
    seasons = seasonBox.values.toList();
  }

  void setActiveSeason(String season) {
    activeSeason = season;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("activeSeason", activeSeason);

    notifyListeners();
  }

  void addNewSeason() {
    isWithNew = true;
    notifyListeners();
  }

  void persistNewSeason(String season) {
    isWithNew = false;
    seasons.add(season);
    var seasonBox = Hive.box<String>(Hive_Seasons);
    seasonBox.add(season);

    notifyListeners();
  }

  String getActiveSeasonText() {
    if (activeSeason == "") {
      return "Please, choose active season";
    } else {
      return activeSeason;
    }
  }

  void expand(int index) {
    expandedIndex = index;
    notifyListeners();
  }

  void setBackupPath(index, String path) {
    backupPath = path;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("backupPath", backupPath);
  }

  Future<void> doBackup(index, Future<String> games, Future<String> players) async {
    print("Do backup for ${seasons[index]} in $backupPath");
    var dir = new Directory(backupPath);
    dir.exists().then((bool dirExists) => {
      if (dirExists) {
        _writeBackup(backupPath, seasons[index], games, players)
      } else {
        dir.create(recursive: true).then((dir) => {
          _writeBackup(backupPath, seasons[index], games, players)
        })
      }
    });
  }

  Future<void> _writeBackup(String path, String seasonName, Future<String> games, Future<String> players) async {
    String gamesString = await games;
    String playersString = await players;

    String version = "2#";
    int timestamp = today();
    File backupFile = File('$path/${seasonName}_backup_$timestamp.txt');
    backupFile.writeAsString(version + playersString + gamesString);
  }

  void restore(index, GamesModel games, PlayersModel players) {
    restoreAsync(seasons[index], games, players);
  }

  Future<void> restoreAsync(String seasonName, GamesModel games, PlayersModel players) async {
    print("Restore backup for $seasonName from $backupPath");
    var file = new File(backupPath);
    bool fileExists = await file.exists();
    if (fileExists) {
      _readBackup(file, seasonName, games, players);
    }
  }

  Future<void> _readBackup(File file, String season, GamesModel games, PlayersModel players) async {
    String data = await file.readAsString();
    ObjectReader objectReader = new ObjectReader(data);
    String version = objectReader.readString();

    _restoreBackupVersion(objectReader, version, season, games, players);
  }

  Future<void> _restoreBackupVersion(ObjectReader objectReader, String version, String season, GamesModel games, PlayersModel players) async {
    print("Restore version $version");
    await players.deserialize(objectReader, season, version);
    await games.deserialize(objectReader, season, version);

    if (season == activeSeason) {
      players.notifyListeners();
      games.notifyListeners();
    }
  }

  setTotalGamesForBeingInRating(int index, int value) {
    totalGamesForBeingInRating = value;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("totalGamesForBeingInRating", totalGamesForBeingInRating);
  }

  setPercentForBeingInRating(int index, int value) {
    percentForBeingInRating = value;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("percentForBeingInRating", percentForBeingInRating);
  }

  setAmountOfGamesForCheckingInRating(int index, int value) {
    amountOfGamesForCheckingInRating = value;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("amountOfGamesForCheckingInRating", amountOfGamesForCheckingInRating);
  }

  setRemainGamesForChecking(int index, int value) {
    remainGamesForChecking = value;
    var settingsBox = Hive.box(Hive_Settings);
    settingsBox.put("remainGamesForChecking", remainGamesForChecking);
  }
}