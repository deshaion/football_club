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

  Game.empty() : this(DateTime.now().millisecondsSinceEpoch, [], [], 0, 0, 0, 0, 0);

  Game(this.date, this.team1, this.team2, this.score_team1_period1,
      this.score_team1_period2, this.score_team2_period1,
      this.score_team2_period2, this.teamWinByPenalty);

  Game.clone(Game game): this(game.date, new List<int>.from(game.team1), new List<int>.from(game.team2),
      game.score_team1_period1, game.score_team1_period2, game.score_team2_period1,
      game.score_team2_period2, game.teamWinByPenalty
  );

  String get score => "${score_team1_period1 + score_team1_period2} : ${score_team2_period1 + score_team2_period2}" + (teamWinByPenalty == 0 ? "" : " Team ${teamWinByPenalty} win");
  String get scoreShort => "${score_team1_period1 + score_team1_period2} : ${score_team2_period1 + score_team2_period2}";
}