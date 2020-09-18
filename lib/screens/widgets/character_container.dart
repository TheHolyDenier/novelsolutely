import 'package:flutter/material.dart';

import './image_widget.dart';
import './tag_widget.dart';

//MODELS
import '../../models/character.dart';
import '../../models/dictionary.dart';
import '../../models/enum/novel_event_type.dart';
import '../../models/path_id.dart';
import '../../utils/colors.dart';

//UTILS
import '../../utils/data.dart';
import '../../utils/dialog_anim.dart';
import '../../utils/dimens.dart';
import '../character_screen.dart';
import '../dialogs/delete_dialog.dart';

typedef GenericContainerCallback = void Function(NovelEventType novelEventType);

class CharacterContainerWidget extends StatefulWidget {
  final String id;
  final key;
  final GenericContainerCallback callback;

  CharacterContainerWidget(this.id,
      {@required this.key, @required this.callback});

  @override
  CharacterContainerWidgetState createState() =>
      CharacterContainerWidgetState(id, key: key, callback: callback);
}

class CharacterContainerWidgetState extends State<CharacterContainerWidget> {
  List<Character> _characters;
  List<Character> _filtered;
  List<String> _tags = [];
  List<String> _selected = [];
  final String _idDictionary;
  final Key key;
  final GenericContainerCallback callback;

  CharacterContainerWidgetState(this._idDictionary, {this.key, this.callback});

  void _filter() {
    _characters = (Data.box.get(_idDictionary) as Dictionary).characters;
    print('tmp personajes total: ${_characters.length}');
    if (_characters != null && _characters.length > 0) {
      _characters.sort((a, b) => a.name.compareTo(b.name));
      _filtered = List.from(_characters);
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

      _selected = [];

      var _tagsSorted = tagMap.entries.toList()
        ..sort((a, b) {
          var diff = b.value.compareTo(a.value);
          if (diff == 0) diff = a.key.compareTo(b.key);
          return diff;
        });
      _tags = [];
      _tagsSorted.forEach((key) => _tags.add(key.key));
    }
  }

  @override
  Widget build(BuildContext context) {
    _filter();
    return _characters != null
        ? Column(
            children: [
              if (_tags.isNotEmpty)
              TagWidget(_tags, callback: (selected) {
                _filtered = List.from(_characters
                    .where((character) =>
                        selected.any((tag) => character.tags.contains(tag)))
                    .toList());
                setState(() {});
              }),
              Expanded(
                child: _filtered != null
                    ? ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          Character character = _filtered[index];
                          return Column(
                            children: [
                              if (index == 0 ||
                                  character.name[0] !=
                                      _filtered[index - 1].name[0])
                                Column(
                                  children: [
                                    if (index != 0)
                                      Container(
                                        height: 20,
                                      ),
                                    Text(character.name[0],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                  ],
                                ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: Dimens.small_vertical_margin),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: Hero(
                                            tag: character.name,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: ClipOval(
                                                child: ImageWidget(
                                                    url: character.imagePath !=
                                                                null &&
                                                            character.imagePath
                                                                    .length >
                                                                0
                                                        ? character.imagePath[0]
                                                        : ''),
                                              ),
                                            ),
                                          ),
                                          title: Text(character.name),
                                          subtitle: Text(
                                            character.summary,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing:
                                              Icon(Icons.keyboard_arrow_right),
                                          onTap: () => _onTapItem(character),
                                          onLongPress: () =>
                                              _selectDeselect(character),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                color: _selected.contains(character.id)
                                    ? Palette.purple
                                    : null,
                              )
                            ],
                          );
                        },
                      )
                    : Container(),
              )
            ],
          )
        : Container();
  }

  void _onTapItem(Character character) {
    if (_selected.isEmpty) {
      Navigator.pushNamed(context, CharacterScreen.route,
          arguments:
              PathId(dictionaryId: _idDictionary, elementId: character.id));
    } else
      _selectDeselect(character);
  }

  void _selectDeselect(Character character) {
    if (_selected.contains(character.id)) {
      setState(() {
        _selected.remove(character.id);
      });
    } else {
      setState(() {
        _selected.add(character.id);
      });
    }
    callback(_selected.isEmpty
        ? NovelEventType.NO_CHAR_SELECTED
        : NovelEventType.CHAR_SELECTED);
  }

  void parentComm(NovelEventType event) {
    switch (event) {
      case NovelEventType.DESELECT_ALL_CHAR:
        _deselectAllCharacters();
        break;
      case NovelEventType.REMOVE_ALL_CHAR:
        DialogAnimation.openDialog(context, DeleteDialog())
            .then((value) => _deleteSelected(value));
        break;
      default:
        break;
    }
  }

  void _deselectAllCharacters() {
    setState(() {
      _selected = [];
    });
    callback(NovelEventType.NO_CHAR_SELECTED);
  }

  void _deleteSelected(value) {
    if (value) {
      List selected = List.from(_selected);
      selected.forEach((id) {
        Data.deleteCharacter(_idDictionary, id);
        _selected.remove(id);
      });
      Data.box.get(_idDictionary).save();
      setState(() {
        _filter();
      });
    }
  }
}
