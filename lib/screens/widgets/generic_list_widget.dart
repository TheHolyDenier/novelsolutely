import 'package:flutter/material.dart';

//VIEWS
import '../item_screen.dart';
import './image_widget.dart';
import './tag_widget.dart';
import '../character_screen.dart';
import '../dialogs/delete_dialog.dart';
import '../other_screen.dart';

//MODELS
import '../../models/enum/novel_event_type.dart';
import '../../models/generic.dart';
import '../../models/id_path.dart';
import '../../models/dictionary.dart';

//UTILS
import '../../utils/data.dart';
import '../../utils/dialog_anim.dart';
import '../../utils/dimens.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

typedef GenericContainerCallback = void Function(NovelEventType novelEventType);

class GenericContainerWidget extends StatefulWidget {
  final IdPath id;
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
  final IdPath _pathId;
  final Key key;
  final GenericContainerCallback callback;
  final GlobalKey<TagWidgetState> _tagKey = GlobalKey();

  List<Generic> _allElements;
  List<Generic> _filteredElements;
  List<String> _tags = [];
  List<String> _selectedElements = [];

  GenericContainerWidgetState(this._pathId,
      {this.key, this.callback, this.typeElement});

  void _setElementList({bool force = false}) {
    if ((_allElements == null || _allElements.isEmpty) || force) {
      _allElements = Data.listToGeneric(_pathId.idDictionary, typeElement);
      _allElements.sort((a, b) => a.name.compareTo(b.name));
      _filteredElements = List.from(_allElements);
      _checkTags();
    }
  }

  @override
  Widget build(BuildContext context) {
    _setElementList();
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
      switch (typeElement) {
        case Strings.characters:
          Navigator.pushNamed(context, CharacterScreen.route,
                  arguments: IdPath(_pathId.idDictionary,
                      typeElementCategory: typeElement, idElement: element.id))
              .then((value) => _afterElementIsClosed());
          break;
        case Strings.others:
          Navigator.pushNamed(context, OtherScreen.route,
                  arguments: IdPath(_pathId.idDictionary,
                      typeElementCategory: typeElement, idElement: element.id))
              .then((value) => _afterElementIsClosed());
          break;
        default:
          Navigator.pushNamed(context, ItemScreen.route,
              arguments: IdPath(_pathId.idDictionary,
                  typeElementCategory: typeElement, idElement: element.id))
              .then((value) => _afterElementIsClosed());
          break;
      }
    } else
      _selectDeselect(element);
  }

  void _afterElementIsClosed() {
    _setElementList(force: true);
    _tagKey.currentState.updateTags(_tags);
    setState(() {});
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
        Data.deleteElement(typeElement, _pathId.idDictionary, id);
        _selectedElements.remove(id);
      });
      Dictionary dictionary = Data.box.get(_pathId.idDictionary);
      dictionary.save();
      setState(() {
        _setElementList(force: true);
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
