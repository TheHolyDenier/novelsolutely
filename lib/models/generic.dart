//MODELS
import 'package:novelsolutely/models/item.dart';
import 'package:novelsolutely/models/other.dart';

import 'character.dart';

class Generic {
  String id;
  String name;
  String summary;
  List<String> imagePath;
  List<String> tags;

  Generic({this.id, this.name, this.summary, this.imagePath, this.tags});

  Character toCharacter() => Character(
      id: id,
      name: name,
      summary: summary,
      tags: tags,
      imagePath: imagePath ?? []);

  Other toOther() => Other(
      id: id,
      name: name,
      summary: summary,
      tags: tags,
      imagePath: imagePath ?? []);

  Item toPlaceOrItem() => Item(
        id: id,
        name: name,
        summary: summary,
        tags: tags,
        imagePath: imagePath ?? []);
}
