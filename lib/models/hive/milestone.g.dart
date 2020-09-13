// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../milestone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneAdapter extends TypeAdapter<Milestone> {
  @override
  final int typeId = 7;

  @override
  Milestone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Milestone(
      id: fields[0] as int,
      date: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Milestone obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
