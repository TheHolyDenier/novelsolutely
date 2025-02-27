import 'package:flutter/material.dart';

//WIDGETS
import '../milestone_screen.dart';

//MODELS
import '../../models/category.dart';
import '../../models/id_path.dart';

//UTILS
import '../../utils/dimens.dart';

typedef MilestoneCallback = void Function(Category category);

class MilestoneWidget extends StatelessWidget {
  final Category _category;
  final MilestoneCallback callback;
  final IdPath _idPath;
  MilestoneWidget(this._idPath, this._category, {@required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Dimens.small_vertical_margin,
          horizontal: Dimens.horizontal_margin),
      child: ListTile(
        leading: Text(_category.title),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.pushNamed(context, MilestoneScreen.route,
              arguments: _idPath).then((value) {
                if (value is Category) {
                  callback(value);
                }
          });
        },
      ),
    );
  }
}
