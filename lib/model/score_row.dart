class ScoreRow {
  int position = 0;
  int? playerId;
  num points = 0;
  int gameAmount = 0;
  double get rating => gameAmount == 0 ? 0 : points / gameAmount;

  int change = 0;
  List<num?> lastGames = [];

  int type = 0;

  ScoreRow(this.playerId, bool inClub) {
    type = inClub ? 0 : 2;
  }
}