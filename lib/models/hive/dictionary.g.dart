// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dictionary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DictionaryAdapter extends TypeAdapter<Dictionary> {
  @override
  final int typeId = 0;

  @override
  Dictionary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dictionary(
      fields[1] as String,
      id: fields[0] as String,
      imagePath: fields[2] as String,
      characters: (fields[4] as List)?.cast<Character>(),
      favorite: fields[3] as bool,
      places: (fields[5] as List)?.cast<Place>(),
      items: (fields[6] as List)?.cast<Item>(),
      others: (fields[7] as List)?.cast<Other>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dictionary obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.favorite)
      ..writeByte(4)
      ..write(obj.characters)
      ..writeByte(5)
      ..write(obj.places)
      ..writeByte(6)
      ..write(obj.items)
      ..writeByte(7)
      ..write(obj.others);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictionaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
