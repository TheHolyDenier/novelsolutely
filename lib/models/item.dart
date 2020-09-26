import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import './category.dart';
import './generic.dart';

//MODELS
import './milestone.dart';
import './owned.dart';

//UTILS
import '../utils/strings.dart';

part 'item.g.dart';

@HiveType(typeId: 3)
class Item {
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
  @HiveField(7)
  String creationDate;
  @HiveField(8)
  List<Owned> owners;
  @HiveField(9)
  List<Category> milestones;

  Item(
      {@required this.id,
      @required this.name,
      @required this.summary,
      @required this.tags,
      this.imagePath,
      List<Milestone> appearance,
      this.creationDate,
      this.owners,
      this.milestones}) {
    this.appearance = Category(
        id: Uuid().v1(),
        title: Strings.appearance,
        milestones: appearance ?? []);
  }

  Generic toGeneric() {
    return Generic(
        id: id,
        name: name,
        summary: summary,
        tags: tags,
        imagePath: imagePath ?? '');
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'summary': summary,
        'tags': jsonEncode(tags),
        'imagePath': jsonEncode(imagePath),
        'appearance': appearance.toJson(),
        'creationDate': creationDate,
        'owners':
            owners != null ? owners.map((i) => i.toJson()).toList() : null,
        'milestones': milestones != null
            ? milestones.map((i) => i.toJson()).toList()
            : null,
      };
}
