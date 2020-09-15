import 'dart:core';

import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';

//MODELS
import './category.dart';
import './generic.dart';

//UTILS

part 'other.g.dart';

@HiveType(typeId: 5)
class Other {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String summary;
  @HiveField(3)
  List<String> tags;
  @HiveField(4)
  List<String> imagePath;
  @HiveField(5)
  Category appearance;
  @HiveField(9)
  List<Category> milestones;

  Other(
      {@required this.id,
      @required this.name,
      @required this.summary,
      @required this.tags,
      this.imagePath,
      this.milestones});

  Generic toGeneric() {
    return Generic(
        id: id,
        name: name,
        summary: summary,
        tags: tags,
        imagePath: imagePath[0] ?? '');
  }
}
