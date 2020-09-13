// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kinship.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KinshipAdapter extends TypeAdapter<Kinship> {
  @override
  final int typeId = 10;

  @override
  Kinship read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Kinship.PARENT;
      case 1:
        return Kinship.PARENT_IN_LAW;
      case 2:
        return Kinship.CHILD;
      case 3:
        return Kinship.CHILD_IN_LAW;
      case 4:
        return Kinship.PARTNER;
      case 5:
        return Kinship.GRANDPARENT;
      case 6:
        return Kinship.GRANDCHILD;
      case 7:
        return Kinship.SIBLING;
      case 8:
        return Kinship.SIBLING_IN_LAW;
      case 9:
        return Kinship.ANCESTOR;
      case 10:
        return Kinship.OFFSPRING;
      case 11:
        return Kinship.AUNCLE;
      case 12:
        return Kinship.NIBLING;
      case 13:
        return Kinship.EX_PARTNER;
      case 14:
        return Kinship.FRIENDSHIP;
      case 15:
        return Kinship.RIVAL;
      case 16:
        return Kinship.ENEMY;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Kinship obj) {
    switch (obj) {
      case Kinship.PARENT:
        writer.writeByte(0);
        break;
      case Kinship.PARENT_IN_LAW:
        writer.writeByte(1);
        break;
      case Kinship.CHILD:
        writer.writeByte(2);
        break;
      case Kinship.CHILD_IN_LAW:
        writer.writeByte(3);
        break;
      case Kinship.PARTNER:
        writer.writeByte(4);
        break;
      case Kinship.GRANDPARENT:
        writer.writeByte(5);
        break;
      case Kinship.GRANDCHILD:
        writer.writeByte(6);
        break;
      case Kinship.SIBLING:
        writer.writeByte(7);
        break;
      case Kinship.SIBLING_IN_LAW:
        writer.writeByte(8);
        break;
      case Kinship.ANCESTOR:
        writer.writeByte(9);
        break;
      case Kinship.OFFSPRING:
        writer.writeByte(10);
        break;
      case Kinship.AUNCLE:
        writer.writeByte(11);
        break;
      case Kinship.NIBLING:
        writer.writeByte(12);
        break;
      case Kinship.EX_PARTNER:
        writer.writeByte(13);
        break;
      case Kinship.FRIENDSHIP:
        writer.writeByte(14);
        break;
      case Kinship.RIVAL:
        writer.writeByte(15);
        break;
      case Kinship.ENEMY:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KinshipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
