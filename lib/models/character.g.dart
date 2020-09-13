// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 1;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as String,
      name: fields[1] as String,
      summary: fields[2] as String,
      tags: (fields[3] as List)?.cast<String>(),
      imagePath: (fields[4] as List)?.cast<String>(),
      birthDate: fields[7] as String,
      relationship: (fields[8] as List)?.cast<Relationship>(),
      milestones: (fields[9] as List)?.cast<Category>(),
    )
      ..appearance = fields[5] as Category
      ..personality = fields[6] as Category;
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(10)
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
      ..writeByte(6)
      ..write(obj.personality)
      ..writeByte(7)
      ..write(obj.birthDate)
      ..writeByte(8)
      ..write(obj.relationship)
      ..writeByte(9)
      ..write(obj.milestones);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
