import 'package:flutter/material.dart';
import 'package:novelsolutely/models/character.dart';
import 'package:novelsolutely/models/dictionary.dart';
import 'package:novelsolutely/models/id_path.dart';
import 'package:novelsolutely/utils/data.dart';
import 'package:novelsolutely/utils/strings.dart';

//VIEWS
import './dialogs/new_milestone_dialog.dart';

//Models
import '../models/category.dart';
import '../models/milestone.dart';

//UTILS
import '../utils/dimens.dart';
import '../utils/colors.dart';
import '../utils/dialog_anim.dart';
import 'dialogs/delete_dialog.dart';

class MilestoneScreen extends StatefulWidget {
  static final route = '/milestone';

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  Category _category;
  List<Milestone> _milestones;
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
          child: _milestones == null || _milestones.isEmpty
              ? _setDivider(0)
              : ReorderableListView(
                  children: List.generate(
                    _milestones.length,
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
                          if (index == _milestones.length - 1)
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
                          _milestones.removeAt(oldIndex);
                      _milestones.insert(newIndex, milestone);
                      _alterIds();
                    });
                  },
                ),
        ),
      ),
    );
  }

  void _setInitialElements(BuildContext context) {
    Dictionary dictionary = Data.box.get(_idPath.idDictionary);
    if (_idPath.typeElementCategory != null) {
      switch (_idPath.typeElementCategory) {
        case Strings.characters:
          Character character = dictionary.characters
              .firstWhere((element) => element.id == _idPath.idElement);
          if (character.appearance.id == _idPath.idCategory) {
            _category = character.appearance;
          } else if (character.personality.id == _idPath.idCategory) {
            _category = character.personality;
          } else {
            if (character.milestones != null) {
              for (Category category in character.milestones) {
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
    _milestones = _category.milestones ?? [];
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
                    _milestones.removeAt(index);
                    _selected.removeAt(index);
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
                    milestone: _milestones[index],
                  )).then((value) {
                if (value is Milestone) {
                  setState(() {
                    print(
                        'tmp ${value.id} ${value.date ?? ''} ${value.description}');
                    _milestones[_milestones.indexWhere(
                        (element) => element.id == value.id)] = value;
                    _selected[index] = false;
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
                  _milestones[index].date ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            Expanded(
                child: Text(
              _milestones[index].description,
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

  void _fillRange() =>
      _selected = List.filled(_milestones.length, false, growable: true);

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
            }
          }),
          icon: Icon(Icons.add_circle_outline_outlined),
        ),
      ],
    );
  }

  void _add(Milestone milestone) {
    if (_milestones.isEmpty) {
      setState(() {
        _milestones = [milestone];
      });
    } else {
      _milestones.insert(milestone.id, milestone);
      _alterIds();
    }
    _fillRange();
  }

  void _alterIds() {
    for (var i = 0; i < _milestones.length; i++) {
      _milestones[i].id = i;
    }
    setState(() {});
  }

  Future<bool> _saveAndExit(BuildContext context) async {
    _category.milestones = _milestones;
    Navigator.pop(context, _category);
    return false;
  }
}
