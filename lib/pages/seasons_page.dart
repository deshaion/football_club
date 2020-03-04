import 'package:flutter/material.dart';
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
                    onTap: () {
                      print('Tap on ${index}');
                      model.setActiveSeason(model.seasons[index]);
                    },
                    active: model.seasons[index] == model.activeSeason,
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
  final bool active;

  SeasonItem({this.name, this.onTap, this.active});

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
        child: Text(name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0),),
      ),
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