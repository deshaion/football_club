// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final typeId = 1;

  @override
  Game read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      fields[0] as int,
      (fields[1] as List)?.cast<int>(),
      (fields[2] as List)?.cast<int>(),
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
      fields[6] as int,
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.team1)
      ..writeByte(2)
      ..write(obj.team2)
      ..writeByte(3)
      ..write(obj.score_team1_period1)
      ..writeByte(4)
      ..write(obj.score_team1_period2)
      ..writeByte(5)
      ..write(obj.score_team2_period1)
      ..writeByte(6)
      ..write(obj.score_team2_period2)
      ..writeByte(7)
      ..write(obj.teamWinByPenalty);
  }
}
