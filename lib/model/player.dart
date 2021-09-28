import 'package:football_club/utils/ObjectReader.dart';
import 'package:football_club/utils/ObjectWriter.dart';
import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) bool inClub = false;

  Player(this.name);

  static void serialize(ObjectWriter objectWriter, Player player) {
    objectWriter.writeString(player.name);
    objectWriter.writeBool(player.inClub);
  }

  static Player deserialize(ObjectReader objectReader) {
    Player player = new Player(objectReader.readString());
    player.inClub = objectReader.readBool();
    return player;
  }
}