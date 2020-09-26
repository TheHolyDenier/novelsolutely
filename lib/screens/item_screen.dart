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
import '../models/item.dart' as IP;
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

class ItemScreen extends StatefulWidget {
  static const route = '/item';

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _tagStateKey = GlobalKey<TagsState>();
  IP.Item _item;
  Dictionary _dictionary;
  IdPath _idPath;
  GlobalKey<HeaderWidgetState> _keyChild = GlobalKey();
  bool isItem;

  @override
  Widget build(BuildContext context) {
    _idPath = ModalRoute.of(context).settings.arguments;
    isItem = _idPath.typeElementCategory == Strings.items;

    isItem ?_setItem(_idPath):_setPlace(_idPath);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _saveItem(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () =>_saveItem(context),
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: Text(_item.name),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                GenericInputDialog(
                  _item.toGeneric(),
                ),
              ).then((value) {
                if (value is Generic) {
                  setState(() {
                    _item.name = value.name;
                    _item.summary = value.summary;
                    _dictionary.save();
                  });
                }
              }),
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                ImagesInputDialog(_item.toGeneric()),
              ).then((value) => _saveImages(value)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(
                  name: _item.name,
                  images: _item.imagePath ?? null,
                  height: size.height / 3,
                  width: size.width,
                  key: _keyChild),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimens.small_vertical_margin,
                  horizontal: Dimens.horizontal_margin,
                ),
                child: Text(
                  _item.summary,
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
                                  str, _item.tags)) _item.tags.add(str);
                              _dictionary.save();
                            });
                          },
                        ),
                        itemCount: _item.tags.length,
                        itemBuilder: (int index) {
                          final item = _item.tags[index];
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
                    idElement: _item.id,
                    typeElementCategory: _idPath.typeElementCategory,
                    idCategory: _item.appearance.id),
                _item.appearance,
                callback: (category) =>
                    _saveCategory(category, id: _item.appearance.id),
              ),
              if (_item.milestones != null)
                for (final category in _item.milestones)
                  MilestoneWidget(
                    IdPath(_idPath.idDictionary,
                        typeElementCategory: _idPath.typeElementCategory,
                        idElement: _item.id,
                        idCategory: category.id),
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
                  if (_item.milestones == null) _item.milestones = [];
                  setState(() {
                    _item.milestones
                        .add(Category(id: Uuid().v1(), title: value));
                    _dictionary.save();
                  });
                }
              });
            },
            label: Text(Strings.add_category.toUpperCase())),
      ),
    );
  }

  Future<bool> _saveItem(BuildContext context) async {
    _dictionary.save();
    Navigator.pop(context);
    return false;
  }


  void _setItem(IdPath pathId) {
    if (_item == null) {
      _dictionary = (Data.box.get(pathId.idDictionary) as Dictionary);
      _item = _dictionary.items
          .firstWhere((element) => element.id == pathId.idElement);
    }
  }

  void _setPlace(IdPath pathId) {
    if (_item == null) {
      _dictionary = (Data.box.get(pathId.idDictionary) as Dictionary);
      _item = _dictionary.places
          .firstWhere((element) => element.id == pathId.idElement);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _item.tags.removeAt(index);
      _dictionary.save();
    });
  }

  void _saveImages(List<String> images) {
    if (images != null && images.length > 0) {
      setState(() {
        _item.imagePath = [...images];
        _dictionary.save();
      });
    }
    _keyChild.currentState.updateImages(images);
  }

  _saveCategory(Category category, {@required String id}) {
    if (_item.appearance.id == id) {
      _item.appearance = category;
    } else {
      _item.milestones[_item.milestones
          .indexWhere((element) => element.id == id)] = category;
    }
    setState(() {});
  }
}
