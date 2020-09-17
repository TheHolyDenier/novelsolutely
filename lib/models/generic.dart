//MODELS
import 'character.dart';

class Generic {
  String id;
  String name;
  String summary;
  List<String> imagePath;
  List<String> tags;

  Generic({this.id, this.name, this.summary, this.imagePath, this.tags});

  Character toCharacter() {
    return Character(
        id: id,
        name: name,
        summary: summary,
        tags: tags,
        imagePath: imagePath ?? []);
  }
}
