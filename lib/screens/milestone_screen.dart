import 'package:flutter/material.dart';

//VIEWS
import './dialogs/new_milestone_dialog.dart';
import './dialogs/delete_dialog.dart';

//Models
import '../models/category.dart';
import '../models/milestone.dart';
import '../models/character.dart';
import '../models/dictionary.dart';
import '../models/id_path.dart';

//UTILS
import '../utils/dimens.dart';
import '../utils/colors.dart';
import '../utils/dialog_anim.dart';
import '../utils/data.dart';
import '../utils/strings.dart';

class MilestoneScreen extends StatefulWidget {
  static final route = '/milestone';

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  Dictionary _dictionary;
  Category _category;
  List<bool> _selected;

  IdPath _idPath;

  double _heightListTile = 48.0;

  @override
  Widget build(BuildContext context) {
    if (_category == null) {
      _idPath = ModalRoute.of(context).settings.arguments;
      _setInitialElements(context);
    }
    return WillPopScope(
      onWillPop: () => _saveAndExit(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _saveAndExit(context),
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: Text(_category.title),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.vertical_margin,
              horizontal: Dimens.horizontal_margin),
          child: _category.milestones == null || _category.milestones.isEmpty
              ? _setDivider(0)
              : ReorderableListView(
                  children: List.generate(
                    _category.milestones.length,
                    (index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        key: UniqueKey(),
                        children: [
                          _setDivider(index),
                          Stack(
                            children: [
                              _setListTile(index),
                              if (_selected[index])
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: _setDeleteBtn(index),
                                ),
                            ],
                          ),
                          if (index == _category.milestones.length - 1)
                            _setDivider(index + 1),
                        ],
                      );
                    },
                  ),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex--;
                      }
                      final Milestone milestone =
                          _category.milestones.removeAt(oldIndex);
                      _category.milestones.insert(newIndex, milestone);
                      _alterIds();
                    });
                  },
                ),
        ),
      ),
    );
  }

  void _setInitialElements(BuildContext context) {
    _dictionary = Data.box.get(_idPath.idDictionary);
    print('tmp _idPath.typeElementCategory ${_idPath.typeElementCategory}');
    if (_idPath.typeElementCategory != null) {
      switch (_idPath.typeElementCategory) {
        case Strings.characters:
          int index = _dictionary.characters
              .indexWhere((element) => element.id == _idPath.idElement);
          if (_dictionary.characters[index].appearance.id ==
              _idPath.idCategory) {
            _category = _dictionary.characters[index].appearance;
          } else if (_dictionary.characters[index].personality.id ==
              _idPath.idCategory) {
            _category = _dictionary.characters[index].personality;
          } else {
            if (_dictionary.characters[index].milestones != null) {
              for (Category category
                  in _dictionary.characters[index].milestones) {
                if (category.id == _idPath.idCategory) _category = category;
              }
            }
          }
          break;
        default:
          break;
      }
      if (_category == null) Navigator.of(context).pop();
    }
    print('tmp ${_category.title}');
    if (_category.milestones == null) _category.milestones = [];
    _dictionary.save();
    _fillRange();
  }

  Widget _setDeleteBtn(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: double.maxFinite,
          width: _heightListTile,
          decoration: BoxDecoration(color: Theme.of(context).errorColor),
          child: FittedBox(
            fit: BoxFit.cover,
            child: IconButton(
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,
              ),
              onPressed: () =>
                  DialogAnimation.openDialog(context, DeleteDialog())
                      .then((value) {
                if (value) {
                  setState(() {
                    _category.milestones.removeAt(index);
                    _selected.removeAt(index);
                    _save();
                  });
                }
              }),
            ),
          ),
        ),
        Container(
          height: double.maxFinite,
          width: _heightListTile,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: FittedBox(
            fit: BoxFit.cover,
            child: IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
              onPressed: () => DialogAnimation.openDialog(
                  context,
                  MilestoneInputDialog(
                    _category.title,
                    milestone: _category.milestones[index],
                  )).then((value) {
                if (value is Milestone) {
                  setState(() {
                    print(
                        'tmp ${value.id} ${value.date ?? ''} ${value.description}');
                    _category.milestones[_category.milestones
                            .indexWhere((element) => element.id == value.id)] =
                        value;
                    _selected[index] = false;
                    _save();
                  });
                }
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _setListTile(int index) {
    return Container(
      constraints: BoxConstraints(minHeight: _heightListTile),
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: 70.0,
                child: Text(
                  _category.milestones[index].date ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            Expanded(
                child: Text(
              _category.milestones[index].description,
              textAlign: TextAlign.justify,
            )),
          ],
        ),
        onTap: () {
          setState(() {
            _selected[index] = !_selected[index];
          });
        },
      ),
    );
  }

  void _fillRange() => _selected =
      List.filled(_category.milestones.length, false, growable: true);

  Widget _setDivider(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Divider()),
        IconButton(
          onPressed: () => DialogAnimation.openDialog(
                  context, MilestoneInputDialog(_category.title, index: index))
              .then((value) {
            if (value is Milestone) {
              _add(value);
              _save();
            }
          }),
          icon: Icon(Icons.add_circle_outline_outlined),
        ),
      ],
    );
  }

  void _save() {
    _dictionary.save();
  }

  void _add(Milestone milestone) {
    if (_category.milestones.isEmpty) {
      setState(() {
        _category.milestones = [milestone];
      });
    } else {
      _category.milestones.insert(milestone.id, milestone);
      _alterIds();
    }
    _fillRange();
  }

  void _alterIds() {
    for (var i = 0; i < _category.milestones.length; i++) {
      _category.milestones[i].id = i;
    }
    setState(() {});
    _save();
  }

  Future<bool> _saveAndExit(BuildContext context) async {
    _category.milestones = _category.milestones;
    Navigator.pop(context, _category);
    return false;
  }
}
