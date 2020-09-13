//LIBRARIES
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//WIDGETS
import '../screens/dialogs/title_dialog.dart';

//MODELS
import '../models/dictionary.dart';

//UTILS
import '../utils/routes.dart';
import 'dialog_anim.dart';

class Data {
  static Box _box;

  static Box get box {
    if (_box == null) _box = Hive.box(Routes.box);

    return _box;
  }

  static int orderFavorite(Dictionary a, Dictionary b) {
    if (b.favorite && a.favorite) {
      return a.name.compareTo(b.name);
    }
    if (b.favorite) {
      return 1;
    }
    if (!b.favorite && !a.favorite) {
      return a.name.compareTo(b.name);
    }
    return -1;
  }

  static void _addDictionary(String name, {String image}) async {
    final dictionary =
        Dictionary(name, id: Uuid().v1(), imagePath: image ?? null);
    await Data.box.put(dictionary.id, dictionary);
  }

  static void add(BuildContext context) =>
      DialogAnimation.openDialog(context, TitleInputDialog())
          .then((value) => _addDictionary(value[0], image: value[1]));

  static void delete(String id) => Data.box.delete(id);
}
