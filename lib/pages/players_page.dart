import 'package:flutter/material.dart';
import 'package:football_club/model/player.dart';
import 'package:football_club/model/players_model.dart';
import 'package:football_club/pages/base_page.dart';
import 'package:provider/provider.dart';

class PlayersPage extends PageContainerBase {
  Widget get body => Players();
  String get pageTitle => "Players";
  Widget get actionButton => MyActionButton();
}

class Players extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Consumer<PlayersModel>(builder: (context, model, child) {
          return Column(children: <Widget>[
            NewPlayer(
              isWithNew: model.isWithNew,
              onSave: (String value) {
                model.persistNewPlayer(value);
              }
            ),
            Expanded (
              child: ListView.builder(
                itemCount: model.getPlayers().length,
                itemBuilder: (context, index) {
                  Player player = model.getPlayers()[index];
                  return DismissiblePlayerItem(
                      player: player,
                      isNameEditable: index == model.indexOfEdit,
                      onTapName: () => model.setEditMode(index),
                      onTapInClub: () => model.changeInClub(player),
                      onEditName: (String value) => model.changeName(player, value),
                      onDismissed: (DismissDirection direction) => model.remove(index, player)
                );
              })
            )
          ]);
        })
    );
  }
}

class NewPlayer extends StatelessWidget {
  final bool isWithNew;
  final Function onSave;

  NewPlayer({required this.isWithNew, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return isWithNew ?
    TextField(onSubmitted: (String value) {onSave(value);},)
        : Container(width: 0.0, height: 0.0);
  }
}

class DismissiblePlayerItem extends StatelessWidget {
  final Player player;
  final void Function() onTapName;
  final void Function() onTapInClub;
  final Function onEditName;
  final bool isNameEditable;
  final void Function(DismissDirection) onDismissed;

  DismissiblePlayerItem({required this.player, required this.isNameEditable, required this.onTapName, required this.onTapInClub, required this.onEditName, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
        resizeDuration: null,
        onDismissed: onDismissed,
        key: new ValueKey(player),
        child: PlayerItem(player: player, isNameEditable: isNameEditable, onTapName: onTapName, onTapInClub: onTapInClub, onEditName: onEditName)
    );
  }
}

class PlayerItem extends StatelessWidget {
  final Player player;
  final void Function() onTapName;
  final void Function() onTapInClub;
  final Function onEditName;
  final bool isNameEditable;

  PlayerItem({required this.player, required this.isNameEditable, required this.onTapName, required this.onTapInClub, required this.onEditName});

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
        child: Row(
          children: <Widget>[
            Expanded(child: isNameEditable ? EditablePlayerName(player.name, onEditName) : PlayerName(player.name, onTapName)),
            InClubElement(player.inClub, onTapInClub)
          ],
        )
    );
  }
}

class EditablePlayerName extends StatelessWidget {
  final String name;
  final Function onSave;

  EditablePlayerName(this.name, this.onSave);

  @override
  Widget build(BuildContext context) {
    return TextField(controller: TextEditingController(text: name), onSubmitted: (String value) {onSave(value);});
  }
}

class PlayerName extends StatelessWidget {
  final String name;
  final void Function() onTap;

  PlayerName(this.name, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0))
    );
  }
}

class InClubElement extends StatelessWidget {
  final bool inClub;
  final void Function() onTap;

  InClubElement(this.inClub, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [BoxShadow(blurRadius: 3.0, offset: Offset(0.0, 2.0), color: Color.fromARGB(80, 0, 0, 0))]),
          child: Row(
              children: <Widget> [
                Icon(inClub ? Icons.check_box : Icons.check_box_outline_blank),
                Text(inClub ? 'In club' : 'Not in club', style: TextStyle(fontSize: 12.0))
              ]
          ),
        )
    );
  }
}

class MyActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = Provider.of<PlayersModel>(context, listen: false);

    return FloatingActionButton(
      onPressed: players.addNewPlayer,
      tooltip: 'Add new player',
      child: Icon(Icons.add),
    );
  }
}