import 'package:flutter/material.dart';
import 'package:football_club/model/game.dart';
import 'package:football_club/model/hive_keys.dart';
import 'package:football_club/model/player.dart';
import 'package:football_club/provider_setup.dart';
import 'package:football_club/utils/router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'utils/routes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(PlayerAdapter());

  await Hive.openBox(Hive_Settings);
  await Hive.openBox<String>(Hive_Seasons);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider (
      providers: providers,
      child: MaterialApp(
        title: 'Football Club',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        initialRoute: RoutePaths.scorePage,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
