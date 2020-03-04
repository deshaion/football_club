class ScoreRow {
  int position;
  int playerId;
  num points;
  int gameAmount;
  double get rating => gameAmount == 0 ? 0 : points / gameAmount;

  int change;
  List<num> lastGames;

  int type;

  ScoreRow(this.playerId, bool inClub) {
    points = 0;
    gameAmount = 0;
    lastGames = [];

    type = inClub ? 0 : 2;
  }
}