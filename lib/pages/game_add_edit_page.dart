import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_club/model/game_edit_model.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/pages/base_page.dart';
import 'package:football_club/utils/date_util.dart';
import 'package:provider/provider.dart';

class GameAddEditPage extends PageContainerBase {
  int gameIdx;
  GameAddEditPage(this.gameIdx);

  Widget get body => Game(gameIdx);
  String get pageTitle => "Edit game";
  Widget get actionButton => MyActionButton();
  Widget? get menuDrawer => null;
}

class Game extends StatelessWidget {
  int gameIdx;
  Game(this.gameIdx);

  @override
  Widget build(BuildContext context) {
    var gameModel = Provider.of<GameEditModel>(context, listen: false);
    var games = Provider.of<GamesModel>(context, listen: false);
    gameModel.update(games, gameIdx);

    return Column(children: <Widget>[
      DateRow(),
      Score(),
      Flexible(fit: FlexFit.tight, child: Row(children: <Widget>[Expanded(child: Team1()), Expanded(child: Team2())])),
      Expanded(child: OtherPlayers()),
    ]);
  }
}

class DateRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Consumer<GameEditModel>(builder: (context, model, child) {
          return GestureDetector(
              child: Container(
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
                child: Row(children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(getFormattedDate(model.game.date))
                ]),
              ),
              onTap: () => _selectDate(context, model),
          );
        }
        )
    );
  }

  Future<Null> _selectDate(BuildContext context, GameEditModel model) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(now.year, now.month, now.day),
        firstDate: DateTime(2017, 1),
        lastDate: DateTime(2030));
    if (picked != null) {
      model.updateDate(picked.millisecondsSinceEpoch);
    }
  }
}

class Score extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Consumer<GameEditModel>(builder: (context, model, child) {
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
              child: Row(children: <Widget>[
                Text("Score:"),
                Container(width: 20, margin: EdgeInsets.only(left: 5), child:
                  TextField(controller: TextEditingController(text: model.scoreTeam1),
                    inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
                    onSubmitted: (String value) => model.updateScoreTeam1(value),
                    onChanged: (String value) => model.updateScoreTeam1(value),
                  )),
                Container(margin: EdgeInsets.only(left: 5), child:Text("-")),
                Container(width: 20, margin: EdgeInsets.only(left: 5), child:
                  TextField(controller: TextEditingController(text: model.scoreTeam2),
                    inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
                    onSubmitted: (String value) => model.updateScoreTeam2(value),
                    onChanged: (String value) => model.updateScoreTeam2(value),
                  )),
                Container(margin: EdgeInsets.only(left: 10), child:Text("(")),
                Container(width: 20, margin: EdgeInsets.only(left: 1), child:
                  TextField(controller: TextEditingController(text: model.scoreTeam1Period1),
                    inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
                    onSubmitted: (String value) => model.updateScoreTeam1Period1(value),
                    onChanged: (String value) => model.updateScoreTeam1Period1(value),
                  )),
                Container(margin: EdgeInsets.only(left: 7), child:Text("-")),
                Container(width: 20, margin: EdgeInsets.only(left: 7), child:
                  TextField(controller: TextEditingController(text: model.scoreTeam2Period1),
                    inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
                    onSubmitted: (String value) => model.updateScoreTeam2Period1(value),
                    onChanged: (String value) => model.updateScoreTeam2Period1(value),
                  )),
                Container(margin: EdgeInsets.only(left: 1), child:Text(")")),
                Container(margin: EdgeInsets.only(left: 2), child:Text("Pen:")),
                Container(margin: EdgeInsets.only(left: 2), child:DropdownButton<int>(
                  value: model.teamWinByPenalty,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (int? newValue) => model.updatePenaltyWinTeam(newValue),
                  items: <int>[0, 1, 2].map<DropdownMenuItem<int>>((int value) {
                    String text = "None";
                    if (value == 1) {
                      text = "Team 1";
                    } else if (value == 2) {
                      text = "Team 2";
                    }

                    return DropdownMenuItem<int>(value: value, child: Text(text));
                  }).toList(),
                )
                ),
              ]),
            );
        }
        )
    );
  }
}

class Team1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: <Widget>[
        Container(child: Text("Team 1", textAlign: TextAlign.center)),
        Expanded(child: Consumer2<GameEditModel, PlayersModel>(builder: (conext, game, players, child) {
          return ListView.builder(
              itemCount: game.team1List.length,
              itemBuilder: (context, index) => PlayerItem(players.getPlayers()[game.team1List[index]].name,
              (DismissDirection direction) => game.removeFromTeam1(game.team1List[index])
              )
          );
        }))
      ])
    );

  }
}

class Team2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: <Widget>[
        Container(child: Text("Team 2", textAlign: TextAlign.center)),
        Expanded(child: Consumer2<GameEditModel, PlayersModel>(builder: (conext, game, players, child) {
          return ListView.builder(
              itemCount: game.team2List.length,
              itemBuilder: (context, index) => PlayerItem(players.getPlayers()[game.team2List[index]].name,
                      (DismissDirection direction) => game.removeFromTeam2(game.team2List[index])
              )
          );
        }))
      ])
    );
  }
}

class OtherPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(left: 10, top: 20, right: 10),
      child: Column(children: <Widget>[
        Container(height: 15, child: Text("Players", textAlign: TextAlign.center)),
        Expanded(child:
          Consumer2<GameEditModel, PlayersModel>(builder: (context, game, players, child) {
            return ListView.builder(
              itemCount: game.getOtherPlayers(players.getPlayers()).length,
              itemBuilder: (context, index) => PlayerItem(players.getPlayers()[game.getOtherPlayers(players.getPlayers())[index]].name,
                  (DismissDirection direction) => game.addToTeam(direction, game.getOtherPlayers(players.getPlayers())[index])
              )
            );
          })
        )
      ])
    );
  }
}

class PlayerItem extends StatelessWidget {
  final String player;
  final void Function(DismissDirection) onDismissed;

  PlayerItem(this.player, this.onDismissed);

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      resizeDuration: null,
      onDismissed: onDismissed,
      key: new ValueKey(player),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 3.0,
                    offset: Offset(0.0, 2.0),
                    color: Color.fromARGB(80, 0, 0, 0))
              ]),
          child: Text(player, overflow: TextOverflow.ellipsis)
      ),
    );
  }
}

class MyActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        var gameModel = Provider.of<GameEditModel>(context, listen: false);
        var gamesModel = Provider.of<GamesModel>(context, listen: false);
        gamesModel.update(gameModel.idx, gameModel.game);
        gameModel.idx = -2;
        Navigator.pop(context);
      },
      tooltip: 'Save',
      child: Icon(Icons.save_alt),
    );
  }
}