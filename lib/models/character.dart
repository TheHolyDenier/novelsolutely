import 'dart:core';

import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import './category.dart';
import './generic.dart';

//MODELS
import './milestone.dart';
import './relationship.dart';

//UTILS
import '../utils/strings.dart';

part 'character.g.dart';

@HiveType(typeId: 1)
class Character {
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
  @HiveField(6)
  Category personality;
  @HiveField(7)
  String birthDate;
  @HiveField(8)
  List<Relationship> relationship;
  @HiveField(9)
  List<Category> milestones;

  Character(
      {@required this.id,
      @required this.name,
      @required this.summary,
      @required this.tags,
      this.imagePath,
      List<Milestone> appearance,
      List<Milestone> personality,
      this.birthDate,
      this.relationship,
      this.milestones}) {
    this.appearance = Category(
        id: Uuid().v1(),
        title: Strings.appearance,
        milestones: milestones ?? []);
    this.personality = Category(
        id: Uuid().v1(),
        title: Strings.personality,
        milestones: milestones ?? []);
  }

  @override
  String toString() {
    return '$name';
  }

  Generic toGeneric() {
    return Generic(
        id: id,
        name: name,
        summary: summary,
        tags: tags,
        imagePath: imagePath[0] ?? '');
  }
}
