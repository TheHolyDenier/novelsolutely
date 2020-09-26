import 'package:flutter/material.dart';

//VIEWS
import './image_widget.dart';
import './tag_widget.dart';
import '../character_screen.dart';
import '../dialogs/delete_dialog.dart';

//MODELS
import '../../models/enum/novel_event_type.dart';
import '../../models/generic.dart';
import '../../models/path_id.dart';

//UTILS
import '../../utils/data.dart';
import '../../utils/dialog_anim.dart';
import '../../utils/dimens.dart';
import '../../utils/colors.dart';

typedef GenericContainerCallback = void Function(NovelEventType novelEventType);

class GenericContainerWidget extends StatefulWidget {
  final String id;
  final String type;
  final key;
  final GenericContainerCallback callback;

  GenericContainerWidget(this.id,
      {@required this.key, @required this.callback, @required this.type});

  @override
  GenericContainerWidgetState createState() => GenericContainerWidgetState(id,
      key: key, callback: callback, typeElement: type);
}

class GenericContainerWidgetState extends State<GenericContainerWidget> {
  final String typeElement;
  final String _idDictionary;
  final Key key;
  final GenericContainerCallback callback;
  final GlobalKey<TagWidgetState> _tagKey = GlobalKey();

  List<Generic> _allElements;
  List<Generic> _filteredElements;
  List<String> _tags = [];
  List<String> _selectedElements = [];

  GenericContainerWidgetState(this._idDictionary,
      {this.key, this.callback, this.typeElement});

  void _setCharacterList({bool force = false}) {
    if ((_allElements == null || _allElements.isEmpty) || force) {
      _allElements = Data.listToGeneric(_idDictionary, typeElement);
      _allElements.sort((a, b) => a.name.compareTo(b.name));
      _filteredElements = List.from(_allElements);
      _checkTags();
    }
  }

  @override
  Widget build(BuildContext context) {
    _setCharacterList();
    return _allElements != null
        ? Column(
            children: [
              if (_tags.isNotEmpty)
                TagWidget(
                    callback: (values) => _updateSelected(values),
                    key: _tagKey),
              Expanded(
                child: _filteredElements != null
                    ? ListView.builder(
                        itemCount: _filteredElements.length,
                        itemBuilder: (context, index) {
                          Generic element = _filteredElements[index];
                          return Column(
                            children: [
                              if (index == 0 ||
                                  element.name[0] !=
                                      _filteredElements[index - 1].name[0])
                                Column(
                                  children: [
                                    if (index != 0)
                                      Container(
                                        height: 20,
                                      ),
                                    Text(element.name[0],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                  ],
                                ),
                              _setElementCard(element)
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

  Widget _setElementCard(Generic element) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: Dimens.small_vertical_margin),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Hero(
                  tag: element.name,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: ImageWidget(
                          url: element.imagePath != null &&
                                  element.imagePath.isNotEmpty
                              ? element.imagePath[0]
                              : ''),
                    ),
                  ),
                ),
                title: Text(element.name),
                subtitle: Text(
                  element.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => _onTapItem(element),
                onLongPress: () => _selectDeselect(element),
              ),
            ),
          ],
        ),
      ),
      color: _selectedElements.contains(element.id) ? Palette.purple : null,
    );
  }

  void _onTapItem(Generic element) {
    if (_selectedElements.isEmpty) {
      Navigator.pushNamed(context, CharacterScreen.route,
              arguments:
                  PathId(dictionaryId: _idDictionary, elementId: element.id))
          .then((value) {
        _setCharacterList(force: true);
        _tagKey.currentState.updateTags(_tags);
        setState(() {});
      });
    } else
      _selectDeselect(element);
  }

  void _selectDeselect(Generic element) {
    if (_selectedElements.contains(element.id)) {
      setState(() {
        _selectedElements.remove(element.id);
      });
    } else {
      setState(() {
        _selectedElements.add(element.id);
      });
    }

    callback(_selectedElements.isEmpty
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
      _selectedElements = [];
    });
    callback(NovelEventType.NO_CHAR_SELECTED);
  }

  void _deleteSelected(value) {
    if (value) {
      List selected = List.from(_selectedElements);
      selected.forEach((id) {
        Data.deleteCharacter(_idDictionary, id);
        _selectedElements.remove(id);
      });
      Data.box.get(_idDictionary).save();
      setState(() {
        _setCharacterList(force: true);
      });
      callback(NovelEventType.NO_CHAR_SELECTED);
    }
  }

  void _updateSelected(List<String> selected) {
    setState(() {
      _filteredElements = [
        ...List.from(_allElements
            .where((character) =>
                selected.any((tag) => character.tags.contains(tag)))
            .toList())
      ];
    });
  }

  void _checkTags() {
    Map<String, int> tagMap = Map();
    _allElements.forEach((character) {
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
    _updateTags();
    print('$_tags');
  }

  void _updateTags() async {
    if (_tagKey.currentState == null) {
      await new Future.delayed(const Duration(seconds: 1));
      _updateTags();
    } else {
      if (_tags != null && _tags.isNotEmpty)
        _tagKey.currentState.updateTags(_tags);
    }
  }
}
