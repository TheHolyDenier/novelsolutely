//LIBRARIES
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//MODELS
import './enum/ownership.dart';

part 'owned.g.dart';

@HiveType(typeId: 6)
class Owned {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Ownership ownership;

  @HiveField(3)
  String obtained;

  @HiveField(4)
  String lost;

  Owned(
      {@required this.id,
      @required this.name,
      @required this.ownership,
      this.obtained,
      this.lost});

  Map toJson() => {
        'id': id,
        'name': name,
        'ownership': '$ownership',
        'obtained': obtained,
        'lost': lost
      };
}
