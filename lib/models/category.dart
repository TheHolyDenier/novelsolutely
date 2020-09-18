import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//MODELS
import './milestone.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<Milestone> milestones;

  Category({@required this.id, @required this.title, this.milestones}) {
    if (milestones == null) milestones = [];
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'milestones': milestones != null
            ? milestones.map((i) => i.toJson()).toList()
            : null,
      };
}
