//LIBRARIES
import 'package:hive/hive.dart';

//UTILS
import '../../utils/strings.dart';

part 'ownership.g.dart';

@HiveType(typeId: 11)
enum Ownership {
@HiveField(0)
FIRST,
@HiveField(1)
IN_THE_MIDDLE,
@HiveField(2)
PREVIOUS,
@HiveField(3)
CURRENT,
@HiveField(4)
UNKNOWN,
}

extension ParseToString on Ownership {
  String get relation {
    switch (this) {
      case Ownership.FIRST:
        return Strings.first;
      case Ownership.IN_THE_MIDDLE:
        return Strings.in_the_middle;
      case Ownership.PREVIOUS:
        return Strings.previous;
      case Ownership.CURRENT:
        return Strings.current;
      default:
        return Strings.unknown;
    }
  }
}
