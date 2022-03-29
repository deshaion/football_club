import 'package:football_club/utils/ObjectReader.dart';
import 'package:football_club/utils/ObjectWriter.dart';
import 'package:football_club/utils/date_util.dart';
import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject {
  @HiveField(0) int date;
  @HiveField(1) List<int> team1;
  @HiveField(2) List<int> team2;
  @HiveField(3) int score_team1_period1;
  @HiveField(4) int score_team1_period2;
  @HiveField(5) int score_team2_period1;
  @HiveField(6) int score_team2_period2;
  @HiveField(7) int teamWinByPenalty;
  @HiveField(8, defaultValue: 0) int gameType; //0-None, 1-StarGame

  Game.empty() : this(today(), [], [], 0, 0, 0, 0, 0, 0);

  Game(this.date, this.team1, this.team2, this.score_team1_period1,
      this.score_team1_period2, this.score_team2_period1,
      this.score_team2_period2, this.teamWinByPenalty, this.gameType);

  Game.clone(Game game): this(game.date, new List<int>.from(game.team1), new List<int>.from(game.team2),
      game.score_team1_period1, game.score_team1_period2, game.score_team2_period1,
      game.score_team2_period2, game.teamWinByPenalty, game.gameType
  );

  String get score => "${score_team1_period1 + score_team1_period2} : ${score_team2_period1 + score_team2_period2} ($score_team1_period1 : $score_team2_period1)" + (teamWinByPenalty == 0 ? "" : " Team ${teamWinByPenalty} win");
  String get scoreShort => "${score_team1_period1 + score_team1_period2}:${score_team2_period1 + score_team2_period2}";
  String gameTypeText() {
    if (gameType == 1) {
      return "Stars";
    }
    return "";
  }

  static void serialize(ObjectWriter objectWriter, Game game) {
    objectWriter
        .writeInt(game.date)
        .writeListInt(game.team1)
        .writeListInt(game.team2)
        .writeInt(game.score_team1_period1)
        .writeInt(game.score_team1_period2)
        .writeInt(game.score_team2_period1)
        .writeInt(game.score_team2_period2)
        .writeInt(game.teamWinByPenalty)
        .writeInt(game.gameType);
  }

  static Game deserialize(ObjectReader objectReader, String version) {
    if (version == "1") {
      return new Game(
          objectReader.readInt(),
          objectReader.readListInt(),
          objectReader.readListInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          0
      );
    } else {
      return new Game(
          objectReader.readInt(),
          objectReader.readListInt(),
          objectReader.readListInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt(),
          objectReader.readInt()
      );
    }
  }
}