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
import '../../utils/dimens.dart';
import '../character_screen.dart';

typedef SelectCallback = void Function(NovelEventType novelEventType);

class CharacterContainerWidget extends StatefulWidget {
  final String id;
  final key;
  final SelectCallback selectCallback;

  CharacterContainerWidget(this.id,
      {@required this.key, @required this.selectCallback});

  @override
  CharacterContainerWidgetState createState() =>
      CharacterContainerWidgetState(id,
          key: key, selectCallback: selectCallback);
}

class CharacterContainerWidgetState extends State<CharacterContainerWidget> {
  List<Character> _characters;
  List<Character> _filtered;
  List<String> _tags;
  List<String> _selected = [];
  final String _idDictionary;
  final Key key;
  final SelectCallback selectCallback;

  CharacterContainerWidgetState(this._idDictionary,
      {this.key, this.selectCallback});

  void _filter() {
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
    _characters = (Data.box.get(_idDictionary) as Dictionary).characters;
    if (_characters != null && _characters.length > 0 && _tags == null)
      _filter();
    return _characters != null
        ? Column(
            children: [
              TagWidget(_tags, setFilters: (selected) {
                _filtered = List.from(_characters
                    .where((character) =>
                        selected.any((tag) => character.tags.contains(tag)))
                    .toList());
                setState(() {});
              }),
              Expanded(
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    Character character = _filtered[index];
                    return Column(
                      children: [
                        if (index == 0 ||
                            character.name[0] != _filtered[index - 1].name[0])
                          Column(
                            children: [
                              if (index != 0)
                                Container(
                                  height: 20,
                                ),
                              Text(character.name[0],
                                  style: Theme.of(context).textTheme.headline3),
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
                                              url:
                                                  character.imagePath != null &&
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
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    onTap: () => Navigator.pushNamed(
                                        context, CharacterScreen.route,
                                        arguments: PathId(
                                            dictionaryId: _idDictionary,
                                            elementId: character.id)),
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
                ),
              )
            ],
          )
        : Container();
  }

  void parentComm(NovelEventType event) {
    //  TODO
    switch (event) {
      case NovelEventType.DESELECT_ALL_CHAR:
        break;
      case NovelEventType.REMOVE_ALL_CHAR:
        break;
      default:
        break;
    }
  }
}
