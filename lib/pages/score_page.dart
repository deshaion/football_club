import 'package:flutter/material.dart';
import 'package:football_club/model/player.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/model/score_model.dart';
import 'package:football_club/model/score_row.dart';
import 'package:football_club/pages/base_page.dart';
import 'package:provider/provider.dart';

const double DEFAULT_HEIGHT = 20;
const double WIDTH_POSITION = 20;
const double WIDTH_CHANGE = 25;
const double WIDTH_NAME = 125;
const double WIDTH_POINTS = 50;
const double WIDTH_GAMES = 25;
const double WIDTH_RATING = 45;
const double WIDTH_LAST_GAME = 30;

class ScorePage extends PageContainerBase {
  Widget get body => Score();
  String get pageTitle => "Score";
  Widget get actionButton => Container();
}

class Score extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Consumer2<ScoreModel, PlayersModel>(builder: (context, score, players, child) {
          score.calcScore(players.getPlayers());
          return Column(children: <Widget>[
            Header(score.lastGames),
            Expanded(child:
              ListView.builder(
                itemCount: score.scoreList.length,
                itemBuilder: (context, index) {
                  ScoreRow row = score.scoreList[index];

                  if (row.type == 3) {
                    return Footer(score.lastGamesScores);
                  }

                  return ScoreItem(row, index, players.getPlayers()[row.playerId]);
                }
              )
            )
          ]);
        })
    );
  }
}

class Header extends StatelessWidget {
  List<String> _lastGames;

  Header(this._lastGames);

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = [
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_POSITION),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_CHANGE),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_NAME),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_POINTS, child: Text("🏅", textAlign: TextAlign.right)),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_GAMES, child: Text("🏃", textAlign: TextAlign.right)),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_RATING)
    ];

    for (var lastGame in _lastGames.reversed) {
      cells.add(SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_LAST_GAME, child: Align(alignment: Alignment.bottomCenter, child: Text(lastGame, style: TextStyle(fontSize: 8)))));
    }

    return Row(children: cells);
  }
}

class Footer extends StatelessWidget {
  List<String> _lastGames;

  Footer(this._lastGames);

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = [
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_POSITION),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_CHANGE),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_NAME),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_POINTS),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_GAMES),
      SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_RATING)
    ];

    for (var lastGame in _lastGames.reversed) {
      cells.add(SizedBox(height: DEFAULT_HEIGHT, width: WIDTH_LAST_GAME, child: Align(alignment: Alignment.topCenter, child: Text(lastGame, style: TextStyle(fontSize: 8)))));
    }

    return Row(children: cells);
  }
}

class ScoreItem extends StatelessWidget {
  ScoreRow row;
  int index;
  Player player;

  Border defaultBorder = Border(left: BorderSide(color: Colors.black12),bottom: BorderSide(color: Colors.black12));
  Border borderWithRoof = Border(left: BorderSide(color: Colors.black12),bottom: BorderSide(color: Colors.black12),top: BorderSide(color: Colors.black12));

  ScoreItem(this.row, this.index, this.player);

  @override
  Widget build(BuildContext context) {
    String textChange;
    if (row.change != null && row.change > 0) {
      textChange = "↑${row.change}";
    } else if (row.change != null && row.change < 0) {
      textChange = "↓${-row.change}";
    }
    Color changeColor = Colors.white;
    if (row.change != null) {
      if (row.change <= -3) {
        changeColor = Color.fromRGBO(255, 60, 0, 0.3);
      } else if (-2 <= row.change && row.change < 0) {
        changeColor = Color.fromRGBO(255, 153, 0, 0.4);
      } else if (0 < row.change && row.change <= 2) {
        changeColor = Color.fromRGBO(116, 245, 73, 0.5);
      } else if (3 <= row.change) {
        changeColor = Color.fromRGBO(62, 201, 16, 1);
      }
    }

    Border border = index == 0 ? borderWithRoof : defaultBorder;

    Widget changeCell = Container(height: DEFAULT_HEIGHT, width: WIDTH_CHANGE, decoration: BoxDecoration(border: border));
    if (textChange != null) {
      changeCell = Container(height: DEFAULT_HEIGHT, width: WIDTH_CHANGE, child: Text(textChange, textAlign: TextAlign.center), decoration: BoxDecoration(color: changeColor, border: border));
    }

    Color ratingColor = Colors.green;
    if (row.type == 1) {
      ratingColor = Colors.greenAccent;
    } else if (row.type == 2) {
      ratingColor = Colors.black26;
    }
    Decoration ratingDecor = BoxDecoration(color: ratingColor, border: border);

    TextStyle posStyle = row.position <= 4 ? TextStyle(fontWeight: FontWeight.bold) : null;
    TextStyle nameStyle = row.position == 1 ? TextStyle(fontWeight: FontWeight.bold) : null;

    Widget posText = player.inClub ? Text(row.position.toString(), textAlign: TextAlign.right, style: posStyle) : null;

    Decoration posDecor = BoxDecoration(color: Color.fromRGBO(212, 210, 210, 100), border: border);

    List<Widget> cells = [
      Container(height: DEFAULT_HEIGHT, width: WIDTH_POSITION, child: posText,
          padding: EdgeInsets.only(right: 1), decoration: posDecor),
      changeCell,
      Container(height: DEFAULT_HEIGHT, width: WIDTH_NAME, child: Text(player.name, style: nameStyle),
          padding: EdgeInsets.only(left: 1), decoration: BoxDecoration(color: changeColor, border: border)),
      Container(height: DEFAULT_HEIGHT, width: WIDTH_POINTS, child: Text(row.points.toString(), textAlign: TextAlign.right),
          padding: EdgeInsets.only(right: 1), decoration: BoxDecoration(border: border)),
      Container(height: DEFAULT_HEIGHT, width: WIDTH_GAMES, child: Text(row.gameAmount.toString(), textAlign: TextAlign.right),
          padding: EdgeInsets.only(right: 1), decoration: BoxDecoration(border: border)),
      Container(height: DEFAULT_HEIGHT, width: WIDTH_RATING, child: Text(row.rating.toStringAsFixed(2), textAlign: TextAlign.center),
          decoration: ratingDecor)
    ];

    for (var lastGame in row.lastGames.reversed) {
      if (lastGame == null) {
        cells.add(Container(height: DEFAULT_HEIGHT, width: WIDTH_LAST_GAME, decoration: BoxDecoration(border: border)));
      } else {
        cells.add(
            Container(height: DEFAULT_HEIGHT, width: WIDTH_LAST_GAME, child: Text(lastGame.toString(), textAlign: TextAlign.center),
                decoration: BoxDecoration(border: border)));
      }
    }

    return Row(children: cells);
  }
}

