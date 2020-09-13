import 'package:flutter/material.dart';

//WIDGETS
import '../milestone_screen.dart';

//MODELS
import '../../models/category.dart';

//UTILS
import '../../utils/dimens.dart';

class MilestoneWidget extends StatelessWidget {
  final Category _category;

  MilestoneWidget(this._category);

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
              arguments: _category);
        },
      ),
    );
  }
}
