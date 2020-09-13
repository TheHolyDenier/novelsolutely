//LIBRARIES
import 'package:hive/hive.dart';

//MODELS
import './character.dart';
import './item.dart';
import './other.dart';
import './place.dart';

part 'hive/dictionary.g.dart';

@HiveType(typeId: 0)
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
  List<Place> places;

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
}
