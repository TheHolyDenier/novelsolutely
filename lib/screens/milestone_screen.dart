import 'package:flutter/material.dart';

//VIEWS
import './dialogs/new_milestone_dialog.dart';

//Models
import '../models/category.dart';
import '../models/milestone.dart';

//UTILS
import '../utils/dimens.dart';
import '../utils/colors.dart';
import '../utils/dialog_anim.dart';

class MilestoneScreen extends StatefulWidget {
  static final route = '/milestone';

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  Category _category;
  List<Milestone> _milestones;
  List<bool> _selected;

  @override
  Widget build(BuildContext context) {
    if (_category == null) {
      _category = ModalRoute.of(context).settings.arguments;
      _milestones = _category.milestones ?? [];
      _fillRange();
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
                          ListTile(
                            leading: Text(_milestones[index].date ?? ''),
                            title: Text(_milestones[index].description),
                            trailing: _selected[index]
                                ? IconButton(
                                    icon: Icon(Icons.delete_forever_outlined,
                                        color: Palette.pink),
                                    onPressed: () {
                                      setState(() {
                                        //TODO: dialog yes/no
                                        _milestones.removeAt(index);
                                      });
                                    },
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                _selected[index] = !_selected[index];
                              });
                            },
                          ),
                          if (index == _milestones.length - 1) _setDivider(index),
                        ],
                      );
                    },
                  ),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex--;
                      }
                      final Milestone milestone = _milestones.removeAt(oldIndex);
                      _milestones.insert(newIndex, milestone);
                      _alterIds();
                    });
                  },
                ),
        ),
      ),
    );
  }

  void _fillRange() => _selected = List.filled(_milestones.length, false);

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
