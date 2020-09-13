// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owned.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnedAdapter extends TypeAdapter<Owned> {
  @override
  final int typeId = 6;

  @override
  Owned read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owned(
      id: fields[0] as String,
      name: fields[1] as String,
      ownership: fields[2] as Ownership,
      obtained: fields[3] as String,
      lost: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Owned obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ownership)
      ..writeByte(3)
      ..write(obj.obtained)
      ..writeByte(4)
      ..write(obj.lost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
