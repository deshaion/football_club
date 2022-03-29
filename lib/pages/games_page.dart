import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:football_club/model/games_model.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/pages/base_page.dart';
import 'package:football_club/utils/date_util.dart';
import 'package:football_club/utils/routes.dart';
import 'package:provider/provider.dart';

class GamesPage extends PageContainerBase {
  Widget get body => Games();
  String get pageTitle => "Games";
  Widget get actionButton => MyActionButton();
}

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Consumer2<GamesModel, PlayersModel>(builder: (context, games, players, child) {
          return ListView.builder(
                    itemCount: games.getGames().length,
                    itemBuilder: (context, index) => DismissibleGameItem(
                      game: games.getGames()[index],
                      players: players,
                      onDismissed: (DismissDirection direction) => games.remove(index, games.getGames()[index]),
                    )
                );
        })
    );
  }
}

class DismissibleGameItem extends StatelessWidget {
  final Game game;
  final PlayersModel players;
  final void Function(DismissDirection) onDismissed;

  DismissibleGameItem({required this.game, required this.players, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      resizeDuration: null,
      onDismissed: onDismissed,
      key: new ValueKey(game),
      child: GameItem(game: game, players: players)
    );
  }
}

class GameItem extends StatelessWidget {
  final Game game;
  final PlayersModel players;

  GameItem({required this.game, required this.players});

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
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(getFormattedDate(game.date)),
                Container(margin: EdgeInsets.only(left: 10),child:Text(game.score, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0))),
                Container(margin: EdgeInsets.only(left: 10),child:Text(game.gameTypeText(), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0))),
              ],
            ),
            Text(players.teamDescription(game.team1)),
            Text(players.teamDescription(game.team2)),
          ],
        )
    );
  }
}

class MyActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, RoutePaths.gamePage, arguments: -1),
      tooltip: 'Add new game',
      child: Icon(Icons.add),
    );
  }
}