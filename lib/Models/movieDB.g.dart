// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movieDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDBAdapter extends TypeAdapter<MovieDB> {
  @override
  final int typeId = 1;

  @override
  MovieDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDB(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.movieName)
      ..writeByte(1)
      ..write(obj.directorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
