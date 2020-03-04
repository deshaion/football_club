import 'package:flutter/material.dart';
import 'package:football_club/model/hive_keys.dart';
import 'package:hive/hive.dart';

class SeasonModel with ChangeNotifier {
  String activeSeason;
  List<String> seasons = [];
  bool isWithNew = false;


  SeasonModel() {
    var settingsBox = Hive.box(Hive_Settings);
    activeSeason = settingsBox.get("activeSeason");

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
    if (activeSeason == null) {
      return "Please, choose active season";
    } else {
      return activeSeason;
    }
  }
}