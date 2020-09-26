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
import '../models/character_name.dart';
import '../models/dictionary.dart';
import '../models/id_path.dart';
import '../models/category.dart';
import '../models/generic.dart';
import '../models/other.dart';

//UTILS
import '../utils/strings.dart';
import '../utils/colors.dart';
import '../utils/data.dart';
import '../utils/dialog_anim.dart';
import '../utils/dimens.dart';

class OtherScreen extends StatefulWidget {
  static const route = '/other';

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final _tagStateKey = GlobalKey<TagsState>();
  Other _other;
  Dictionary _dictionary;
  IdPath _idPath;
  GlobalKey<HeaderWidgetState> _keyChild = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _idPath = ModalRoute.of(context).settings.arguments;
    _setOther(_idPath);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _saveOther(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _saveOther(context),
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: Text(_other.name),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                GenericInputDialog(
                  _other.toGeneric(),
                ),
              ).then((value) {
                if (value is Generic) {
                  setState(() {
                    _other.name = value.name;
                    _other.summary = value.summary;
                  });
                }
              }),
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo_outlined),
              onPressed: () => DialogAnimation.openDialog(
                context,
                ImagesInputDialog(_other.toGeneric()),
              ).then((value) => _saveImages(value)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(
                  name: _other.name,
                  images: _other.imagePath ?? null,
                  height: size.height / 3,
                  width: size.width,
                  key: _keyChild),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimens.small_vertical_margin,
                  horizontal: Dimens.horizontal_margin,
                ),
                child: Text(
                  _other.summary,
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
                                  str, _other.tags)) _other.tags.add(str);
                              _dictionary.save();
                            });
                          },
                        ),
                        itemCount: _other.tags.length,
                        itemBuilder: (int index) {
                          final item = _other.tags[index];
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
              if (_other.milestones != null)
                for (final category in _other.milestones)
                  MilestoneWidget(
                    IdPath(_idPath.idDictionary,
                        typeElementCategory: Strings.others,
                        idElement: _other.id,
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
                  if (_other.milestones == null) _other.milestones = [];
                  setState(() {
                    _other.milestones
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

  Future<bool> _saveOther(BuildContext context) async {
    _dictionary.save();
    Navigator.pop(context);
    return false;
  }

  void _setOther(IdPath pathId) {
    if (_other == null) {
      _dictionary = (Data.box.get(pathId.idDictionary) as Dictionary);
      _other = _dictionary.others
          .firstWhere((element) => element.id == pathId.idElement);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _other.tags.removeAt(index);
      _dictionary.save();
    });
  }

  void _saveImages(List<String> images) {
    if (images != null && images.length > 0) {
      setState(() {
        _other.imagePath = [...images];
        _dictionary.save();
      });
    }
    _keyChild.currentState.updateImages(images);
  }

  _saveCategory(Category category, {@required String id}) {
    _other.milestones[
        _other.milestones.indexWhere((element) => element.id == id)] = category;
    setState(() {});
  }
}
