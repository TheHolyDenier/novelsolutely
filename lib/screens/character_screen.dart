import 'package:flutter/material.dart';

//LIBRARIES
import 'package:flutter_tags/flutter_tags.dart';
import 'package:uuid/uuid.dart';

//SCREENS && WIDGETS
import './widgets/header_widget.dart';
import './widgets/milestone_widget.dart';
import './dialogs/generic_input_dialog.dart';
import './dialogs/images_input_dialog.dart';
import './dialogs/category_input_dialog.dart';

//MODELS
import '../models/character.dart';
import '../models/character_name.dart';
import '../models/dictionary.dart';
import '../models/id_path.dart';
import '../models/category.dart';
import '../models/generic.dart';

//UTILS
import '../utils/strings.dart';
import '../utils/colors.dart';
import '../utils/data.dart';
import '../utils/dialog_anim.dart';
import '../utils/dimens.dart';

class CharacterScreen extends StatefulWidget {
  static const route = '/character';

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final _tagStateKey = GlobalKey<TagsState>();
  Character _character;
  Dictionary _dictionary;
  IdPath _idPath;
  GlobalKey<HeaderWidgetState> _keyChild = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _idPath = ModalRoute.of(context).settings.arguments;
    _setCharacter(_idPath);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _saveCharacter(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _saveCharacter(context),
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: Text(
            CharacterName.readableName(_character.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                GenericInputDialog(
                  _character.toGeneric(),
                  isCharacter: true,
                ),
              ).then((value) {
                if (value is Generic) {
                  setState(() {
                    _character.name = value.name;
                    _character.summary = value.summary;
                  });
                }
              }),
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                ImagesInputDialog(_character.toGeneric()),
              ).then((value) => _saveImages(value)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(
                  name: _character.name,
                  images: _character.imagePath ?? null,
                  height: size.height / 3,
                  width: size.width,
                  key: _keyChild),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimens.small_vertical_margin,
                  horizontal: Dimens.horizontal_margin,
                ),
                child: Text(
                  _character.summary,
                ),
              ),
              Divider(),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimens.small_vertical_margin,
                  horizontal: Dimens.horizontal_margin,
                ),
                child: ExpansionTile(
                  title: Text(Strings.filters),
                  children: [
                    Tags(
                        key: _tagStateKey,
                        textField: TagsTextField(
                          autofocus: false,
                          hintText: Strings.add_tag,
                          width: size.width,
                          onSubmitted: (String str) {
                            setState(() {
                              if (!Strings.containsCaseInsensitive(
                                  str, _character.tags))
                                _character.tags.add(str);
                            });
                          },
                        ),
                        itemCount: _character.tags.length,
                        itemBuilder: (int index) {
                          final item = _character.tags[index];
                          return ItemTags(
                            activeColor: Palette.purple,
                            index: index,
                            title: item,
                            key: Key(item),
                            combine: ItemTagsCombine.withTextBefore,
                            removeButton: ItemTagsRemoveButton(
                              backgroundColor: Palette.white,
                              color: Palette.purple,
                              onRemoved: () {
                                _removeItem(index);
                                return true;
                              },
                            ),
                            onPressed: (item) => _removeItem(index), // OR null,
                          );
                        }),
                  ],
                ),
              ),
              MilestoneWidget(
                IdPath(_idPath.idDictionary,
                    idElement: _character.id,
                    idCategory: _character.personality.id),
                _character.personality,
                callback: (category) =>
                    _saveCategory(category, id: _character.personality.id),
              ),
              MilestoneWidget(
                IdPath(_idPath.idDictionary,
                    idElement: _character.id,
                    idCategory: _character.appearance.id),
                _character.appearance,
                callback: (category) =>
                    _saveCategory(category, id: _character.appearance.id),
              ),
              if (_character.milestones != null)
                for (final category in _character.milestones)
                  MilestoneWidget(
                    IdPath(_idPath.idDictionary,
                        idElement: _character.id, idCategory: category.id),
                    category,
                    callback: (category) =>
                        _saveCategory(category, id: category.id),
                  ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              DialogAnimation.openDialog(context, CategoryInputDialog())
                  .then((value) {
                if (value != null) {
                  if (_character.milestones == null) _character.milestones = [];
                  setState(() {
                    _character.milestones
                        .add(Category(id: Uuid().v1(), title: value));
                  });
                }
              });
            },
            label: Text(Strings.add_category.toUpperCase())),
      ),
    );
  }

  Future<bool> _saveCharacter(BuildContext context) async {
    _dictionary.save();
    Navigator.pop(context);
    return false;
  }

  void _setCharacter(IdPath pathId) {
    if (_character == null) {
      _dictionary = (Data.box.get(pathId.idDictionary) as Dictionary);
      _character = _dictionary.characters
          .firstWhere((element) => element.id == pathId.idElement);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _character.tags.removeAt(index);
    });
  }

  void _saveImages(List<String> images) {
    if (images != null && images.length > 0) {
      setState(() {
        _character.imagePath = [...images];
        _dictionary.save();
      });
    }
    _keyChild.currentState.updateImages(images);
  }

  _saveCategory(Category category, {@required String id}) {
    if (_character.appearance.id == id) {
      _character.appearance = category;
    } else if (_character.personality.id == id) {
      _character.personality = category;
    } else {
      _character.milestones[_character.milestones
          .indexWhere((element) => element.id == id)] = category;
    }
    setState(() {});
  }
}
