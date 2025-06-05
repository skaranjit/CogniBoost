// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_stat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStatModelAdapter extends TypeAdapter<GameStatModel> {
  @override
  final int typeId = 0;

  @override
  GameStatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStatModel(
      gameName: fields[0] as String,
      score: fields[1] as int,
      tries: fields[2] as int,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameStatModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gameName)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.tries)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
