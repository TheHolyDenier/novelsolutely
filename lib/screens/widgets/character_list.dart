import 'package:flutter/material.dart';

//WIDGETS
import '../widgets/image_widget.dart';
import '../character_screen.dart';

//MODELS
import '../../models/character.dart';
import '../../models/dictionary.dart';

//UTILS
import '../../utils/strings.dart';
import '../../utils/data.dart';
import '../../utils/dimens.dart';

class CharacterList extends StatefulWidget {
  final String id;

  CharacterList(this.id);

  @override
  _CharacterListState createState() => _CharacterListState(id);
}

class _CharacterListState extends State<CharacterList> {
  List<Character> _characters, _filteredCharacters;
  List<String> _tags, _selected;
  final String _id;

  _CharacterListState(this._id);

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
    _selected = List.from(_tags);
  }

  @override
  Widget build(BuildContext context) {
    _characters = (Data.box.get(_id) as Dictionary).characters;
    if (_characters != null && _characters.length > 0 && _tags == null)
      _filter();
    return _characters != null
        ? Column(
            children: [
              ExpansionTile(
                title: Text(Strings.filters),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: _tagList(),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.select_all),
                            onPressed: () => _select(true),
                          ),
                          IconButton(
                            icon: Icon(Icons.tab_unselected),
                            onPressed: () => _select(false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: _characterList(),
              )
            ],
          )
        : Container();
  }

  Widget _characterList() {
    return ListView.builder(
      itemCount: _filteredCharacters.length,
      itemBuilder: (context, index) {
        var character = _filteredCharacters[index];
        return Column(
          children: [
            if (index == 0 ||
                character.name[0] != _filteredCharacters[index - 1].name[0])
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
              margin: EdgeInsets.symmetric(vertical: Dimens.small_vertical_margin),
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
                                  url: character.imagePath != null
                                      ? character.imagePath[0]
                                      : ''),
                            ),
                          ),
                        ),
                        title: Text(character.name),
                        subtitle: Text(character.summary),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => Navigator.pushNamed(
                            context, CharacterScreen.route,
                            arguments: character),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _tagList() {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          for (var tag in _tags)
            FilterChip(
              selectedColor: Theme.of(context).accentColor,
              showCheckmark: false,
              selected: _selected.contains(tag),
              onSelected: (bool value) {
                setState(() {
                  if (!value) {
                    _selected.removeWhere((String name) {
                      return name == tag;
                    });
                  } else {
                    _selected.add(tag);
                  }
                  _setFilteredCharacters();
                });
              },
              label: Text(tag),
            )
        ],
      ),
    );
  }

  void _setFilteredCharacters() {
    _filteredCharacters = List.from(_characters
        .where(
            (character) => _selected.any((tag) => character.tags.contains(tag)))
        .toList());
  }

  void _select(bool tagsState) {
    if (tagsState) {
      _selected = List.from(_tags);
    } else {
      _selected.length = 0;
    }
    _setFilteredCharacters();
    setState(() {});
  }
}
