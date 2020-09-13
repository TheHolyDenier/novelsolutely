import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';

//MODELS
import './enum/kinship.dart';

part 'relationship.g.dart';

@HiveType(typeId: 7)
class Relationship {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String idName;

  @HiveField(3)
  Kinship kinship;

  Relationship(
      {@required this.id,
      @required this.name,
      this.idName,
      @required this.kinship});
}
