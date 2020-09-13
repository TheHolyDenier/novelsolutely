// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../other.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OtherAdapter extends TypeAdapter<Other> {
  @override
  final int typeId = 4;

  @override
  Other read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Other(
      id: fields[0] as String,
      name: fields[1] as String,
      summary: fields[2] as String,
      tags: (fields[3] as List)?.cast<String>(),
      imagePath: (fields[4] as List)?.cast<String>(),
      milestones: (fields[9] as List)?.cast<Category>(),
    )..appearance = fields[5] as Category;
  }

  @override
  void write(BinaryWriter writer, Other obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.appearance)
      ..writeByte(9)
      ..write(obj.milestones);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
