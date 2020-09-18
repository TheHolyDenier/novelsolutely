//LIBRARIES
import 'package:hive/hive.dart';

//MODELS
import './character.dart';
import './item.dart';
import './other.dart';

part 'dictionary.g.dart';

@HiveType(typeId: 2)
class Dictionary extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  bool favorite;

  @HiveField(4)
  List<Character> characters;

  @HiveField(5)
  List<Item> places;

  @HiveField(6)
  List<Item> items;

  @HiveField(7)
  List<Other> others;

  Dictionary(this.name,
      {this.id,
      this.imagePath,
      this.characters,
      this.favorite = false,
      this.places,
      this.items,
      this.others});

  Map toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'characters': characters != null
            ? characters.map((i) => i.toJson()).toList()
            : null,
        'places':
            places != null ? places.map((i) => i.toJson()).toList() : null,
        'items': items != null ? items.map((i) => i.toJson()).toList() : null,
        'others':
            others != null ? others.map((i) => i.toJson()).toList() : null,
      };
}
