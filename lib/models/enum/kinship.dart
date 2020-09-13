//LIBRARIES
import 'package:hive/hive.dart';

//UTILS
import '../../utils/strings.dart';

part 'kinship.g.dart';

@HiveType(typeId: 10)
enum Kinship {
  @HiveField(0)
  PARENT,
  @HiveField(1)
  PARENT_IN_LAW,
  @HiveField(2)
  CHILD,
  @HiveField(3)
  CHILD_IN_LAW,
  @HiveField(4)
  PARTNER,
  @HiveField(5)
  GRANDPARENT,
  @HiveField(6)
  GRANDCHILD,
  @HiveField(7)
  SIBLING,
  @HiveField(8)
  SIBLING_IN_LAW,
  @HiveField(9)
  ANCESTOR,
  @HiveField(10)
  OFFSPRING,
  @HiveField(11)
  AUNCLE,
  @HiveField(12)
  NIBLING,
  @HiveField(13)
  EX_PARTNER,
  @HiveField(14)
  FRIENDSHIP,
  @HiveField(15)
  RIVAL,
  @HiveField(16)
  ENEMY,
}

extension ParseToString on Kinship {
  String get relationship {
    switch (this) {
      case Kinship.PARENT:
        return Strings.parent;
      case Kinship.PARENT_IN_LAW:
        return Strings.parent_in_law;
      case Kinship.CHILD:
        return Strings.child;
      case Kinship.CHILD_IN_LAW:
        return Strings.child_in_law;
      case Kinship.PARTNER:
        return Strings.partner;
      case Kinship.GRANDPARENT:
        return Strings.grandparent;
      case Kinship.GRANDCHILD:
        return Strings.grandchild;
      case Kinship.SIBLING:
        return Strings.sibling;
      case Kinship.SIBLING_IN_LAW:
        return Strings.sib_in_law;
      case Kinship.ANCESTOR:
        return Strings.ancestor;
      case Kinship.OFFSPRING:
        return Strings.offspring;
      case Kinship.AUNCLE:
        return Strings.auncle;
      case Kinship.NIBLING:
        return Strings.nibling;
      case Kinship.EX_PARTNER:
        return Strings.ex_partner;
      case Kinship.FRIENDSHIP:
        return Strings.friendship;
      case Kinship.RIVAL:
        return Strings.rival;
      default:
        return Strings.enemy;
    }
  }
}
