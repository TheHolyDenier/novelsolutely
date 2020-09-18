import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';

part 'milestone.g.dart';

@HiveType(typeId: 4)
class Milestone {
  @HiveField(0)
  int id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String description;

  Milestone({this.id, this.date, @required this.description});

  Map toJson() => {
        'id': id,
        'date': date,
        'description': description,
      };
}
