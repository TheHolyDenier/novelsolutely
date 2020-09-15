import 'package:flutter/material.dart';

//WIDGETS
import './character_list_widget.dart';
import './tag_widget.dart';

//MODELS
import '../../models/character.dart';
import '../../models/dictionary.dart';
import '../../models/generic.dart';
import '../../utils/data.dart';


class CharacterContainerWidget extends StatefulWidget {
  final String id;

  CharacterContainerWidget(this.id);

  @override
  _CharacterContainerWidgetState createState() =>
      _CharacterContainerWidgetState(id);
}

class _CharacterContainerWidgetState extends State<CharacterContainerWidget> {
  List<Character> _characters, _filteredCharacters;
  List<String> _tags;
  final String _id;

  _CharacterContainerWidgetState(this._id);

  void _filter() {
    _characters.sort((a, b) => a.name.compareTo(b.name));
    _filteredCharacters = List.from(_characters);
    Map<String, int> tagMap = Map();
    _characters.forEach((character) {
      character.tags.forEach((tag) {
        if (tagMap.containsKey(tag)) {
          tagMap[tag]++;
        } else {
          tagMap[tag] = 1;
        }
      });
    });

    var _tagsSorted = tagMap.entries.toList()
      ..sort((a, b) {
        var diff = b.value.compareTo(a.value);
        if (diff == 0) diff = a.key.compareTo(b.key);
        return diff;
      });
    _tags = [];
    _tagsSorted.forEach((key) => _tags.add(key.key));
  }

  @override
  Widget build(BuildContext context) {
    _characters = (Data.box.get(_id) as Dictionary).characters;
    if (_characters != null && _characters.length > 0 && _tags == null)
      _filter();
    return _characters != null
        ? Column(
      children: [
        TagWidget(_tags, setFilters: (selected) {
          _filteredCharacters = List.from(_characters
              .where(
                  (character) =>
                  selected.any((tag) => character.tags.contains(tag)))
              .toList());
          setState(() {
            
          });
        }),
        Expanded(
          child: CharacterListWidget(_id, _characterToGeneric()),
        )
      ],
    )
        : Container();
  }


  List<Generic> _characterToGeneric() {
    List<Generic> generic = [];
    for (Character filtered in _filteredCharacters) {
      generic.add(filtered.toGeneric());
    }
    return generic;
  }
}
