import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) bool inClub = false;

  Player(this.name);
}