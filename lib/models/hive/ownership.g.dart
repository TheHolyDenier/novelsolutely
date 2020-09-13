// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../enum/ownership.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnershipAdapter extends TypeAdapter<Ownership> {
  @override
  final int typeId = 11;

  @override
  Ownership read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Ownership.FIRST;
      case 1:
        return Ownership.IN_THE_MIDDLE;
      case 2:
        return Ownership.PREVIOUS;
      case 3:
        return Ownership.CURRENT;
      case 4:
        return Ownership.UNKNOWN;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Ownership obj) {
    switch (obj) {
      case Ownership.FIRST:
        writer.writeByte(0);
        break;
      case Ownership.IN_THE_MIDDLE:
        writer.writeByte(1);
        break;
      case Ownership.PREVIOUS:
        writer.writeByte(2);
        break;
      case Ownership.CURRENT:
        writer.writeByte(3);
        break;
      case Ownership.UNKNOWN:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnershipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
