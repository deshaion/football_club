import 'package:flutter/material.dart';
import 'package:football_club/menu/app_menu_drawer.dart';

abstract class PageContainerBase extends StatelessWidget {
  Widget get body;
  String get pageTitle;
  Widget get menuDrawer => AppMenu();
  Widget get background => Container();
  Color get backgroundColor => Color(0xFFF7F7F7);
  Widget get actionButton => Container();

  const PageContainerBase({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
        ),
        background,
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.indigo,
            elevation: 0.0,
            title: Text(pageTitle),
            textTheme: Theme.of(context).primaryTextTheme,
          ),
          drawer: menuDrawer,
          body: body,
          floatingActionButton: actionButton,
        ),
      ],
    );
  }
}
