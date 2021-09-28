import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/model/season_model.dart';
import 'package:football_club/pages/base_page.dart';
import 'package:provider/provider.dart';

class SeasonsPage extends PageContainerBase {
  Widget get body => Seasons();
  String get pageTitle => "Seasons";
  Widget get actionButton => MyActionButton();
}

class Seasons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var games = Provider.of<GamesModel>(context, listen: false);
    var players = Provider.of<PlayersModel>(context, listen: false);

    return Container (
        child: Consumer<SeasonModel>(builder: (context, model, child) {
          return Column(children: <Widget>[
            NewSeason(
              isWithNew: model.isWithNew,
              onSave: (String value) {
                model.persistNewSeason(value);
              }
            ),
            Expanded (
              child: ListView.builder(
                itemCount: model.seasons.length,
                itemBuilder: (context, index) => SeasonItem(
                    name: model.seasons[index],
                    onTap: () => model.expand(index),
                    onActivate: () => model.setActiveSeason(model.seasons[index]),
                    active: model.seasons[index] == model.activeSeason,
                    expanded: index == model.expandedIndex,
                    onSavePathToBackup: (String path) => model.setBackupPath(index, path),
                    backupPath: model.backupPath,
                    onDump: () => model.doBackup(index, games.serialize(model.seasons[index]), players.serialize(model.seasons[index])),
                    onRestore: () => model.restore(index, games, players),
                ))
            )
          ]);
        })
    );
  }
}

class NewSeason extends StatelessWidget {
  final bool isWithNew;
  final Function onSave;

  NewSeason({this.isWithNew, this.onSave});

  @override
  Widget build(BuildContext context) {
    return isWithNew ?
    TextField(onSubmitted: (String value) {onSave(value);},)
        : Container(width: 0.0, height: 0.0);
  }
}

class SeasonItem extends StatelessWidget {
  final String name;
  final Function onTap;
  final Function onActivate;
  final bool active;
  final bool expanded;
  final Function onSavePathToBackup;
  final String backupPath;
  final Function onDump;
  final Function onRestore;

  SeasonItem({this.name, this.onTap, this.onActivate, this.active, this.expanded,
    this.onSavePathToBackup, this.backupPath, this.onDump, this.onRestore});

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Column(children: [
        SeasonNameItem(name: name, onTap: onTap, active: active),
        SeasonPropertiesItem(onActivate: onActivate, onSavePathToBackup: onSavePathToBackup, backupPath: backupPath, onDump: onDump, onRestore: onRestore),
      ]);
    } else {
      return SeasonNameItem(name: name, onTap: onTap, active: active,);
    }
  }
}

class SeasonNameItem extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool active;

  SeasonNameItem({this.name, this.onTap, this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: active ? Colors.greenAccent : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0,
                  offset: Offset(0.0, 2.0),
                  color: Color.fromARGB(80, 0, 0, 0))
            ]),
        child: Row(children: [Text(name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0))]),
      ),
    );
  }
}

class SeasonPropertiesItem extends StatelessWidget {
  final Function onActivate;
  final Function onSavePathToBackup;
  final String backupPath;
  final Function onDump;
  final Function onRestore;

  SeasonPropertiesItem({this.onActivate, this.onSavePathToBackup, this.backupPath, this.onDump, this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                blurRadius: 3.0,
                offset: Offset(0.0, 2.0),
                color: Color.fromARGB(80, 0, 0, 0))
          ]),
      child: Column(children: [
        Row(children: [ButtonItem("Activate", onActivate)]),
        BackupItem(onSavePathToBackup, backupPath, onDump, onRestore),
      ],)
    );
  }
}

class ButtonItem extends StatelessWidget {
  final String label;
  final Function onTap;

  ButtonItem(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [BoxShadow(blurRadius: 3.0, offset: Offset(0.0, 2.0), color: Color.fromARGB(80, 0, 0, 0))]),
          child: Text(label, style: TextStyle(fontSize: 12.0))
        ),
    );
  }
}

class BackupItem extends StatelessWidget {
  final Function onSavePathToBackup;
  final String backupPath;
  final Function onDump;
  final Function onRestore;

  BackupItem(this.onSavePathToBackup, this.backupPath, this.onDump, this.onRestore);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Text("Backup: "),
        Expanded(child: TextField(controller: TextEditingController(text: backupPath), onSubmitted: onSavePathToBackup)),
        ButtonItem("Dump", onDump),
        ButtonItem("Restore", onRestore),
      ]),
    );
  }
}

class MyActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seasons = Provider.of<SeasonModel>(context, listen: false);

    return FloatingActionButton(
      onPressed: seasons.addNewSeason,
      tooltip: 'Add new season',
      child: Icon(Icons.add),
    );
  }
}