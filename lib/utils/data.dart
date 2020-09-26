//LIBRARIES
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import './dialog_anim.dart';

//UTILS
import './routes.dart';
import './strings.dart';
import '../models/dictionary.dart';
import '../models/generic.dart';

//VIEWS
import '../screens/dialogs/dictionary_input_dialog.dart';

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
      DialogAnimation.openDialog(context, DictionaryInputDialog())
          .then((value) => _addDictionary(value[0], image: value[1]));

  static void delete(String id) => Data.box.delete(id);

  static void deleteElement(
      String typeElement, String idDictionary, String idElement) {
    switch (typeElement) {
      case Strings.characters:
        getDictionary(idDictionary)
            .characters
            .removeWhere((element) => element.id == idElement);
        break;
      case Strings.places:
        getDictionary(idDictionary)
            .places
            .removeWhere((element) => element.id == idElement);
        break;
      case Strings.items:
        getDictionary(idDictionary)
            .items
            .removeWhere((element) => element.id == idElement);
        break;
      default:
        getDictionary(idDictionary)
            .others
            .removeWhere((element) => element.id == idElement);
        break;
    }
  }

  static Dictionary getDictionary(String id) => Data.box.get(id);

  static List<Generic> listToGeneric(String id, String type) {
    List<Generic> generics = [];
    switch (type) {
      case Strings.characters:
        if (getDictionary(id).characters != null &&
            getDictionary(id).characters.length > 0)
          generics = _charactersToGeneric(id);
        break;
      case Strings.places:
        if (getDictionary(id).places != null &&
            getDictionary(id).places.length > 0)
          generics = _placesToGeneric(id);
        break;
      case Strings.items:
        if (getDictionary(id).items != null &&
            getDictionary(id).items.length > 0) generics = _itemsToGeneric(id);
        break;
      default:
        if (getDictionary(id).others != null &&
            getDictionary(id).others.length > 0)
          generics = _othersToGeneric(id);
        break;
    }

    return generics;
  }

  static List<Generic> _charactersToGeneric(String id) {
    List<Generic> generics = [];
    (_box.get(id) as Dictionary).characters.forEach((character) {
      generics.add(character.toGeneric());
    });
    return generics;
  }

  static List<Generic> _placesToGeneric(String id) {
    List<Generic> generics = [];
    (_box.get(id) as Dictionary).places.forEach((place) {
      generics.add(place.toGeneric());
    });
    return generics;
  }

  static List<Generic> _itemsToGeneric(String id) {
    List<Generic> generics = [];
    (_box.get(id) as Dictionary).items.forEach((item) {
      generics.add(item.toGeneric());
    });
    return generics;
  }

  static List<Generic> _othersToGeneric(String id) {
    List<Generic> generics = [];
    (_box.get(id) as Dictionary).others.forEach((other) {
      generics.add(other.toGeneric());
    });
    return generics;
  }

  static bool elementExistsByName(
      String idDictionary, String type, String name) {
    Dictionary d = _box.get(idDictionary);
    switch (type) {
      case Strings.characters:
        if (d.characters != null) {
          return d.characters.indexWhere((element) => element.name == name) !=
              -1;
        }
        break;
      case Strings.places:
        if (d.places != null) {
          return d.places.indexWhere((element) => element.name == name) != -1;
        }
        break;
      case Strings.items:
        if (d.items != null) {
          return d.items.indexWhere((element) => element.name == name) != -1;
        }
        break;
      default:
        if (d.others != null) {
          return d.others.indexWhere((element) => element.name == name) != -1;
        }
        break;
    }
    return false;
  }
}
