import 'package:flutter/material.dart';

//VIEWS

//MODELS
import '../../models/milestone.dart';

//UTILS
import '../../utils/strings.dart';
import '../../utils/colors.dart';
import '../../utils/dimens.dart';

class MilestoneInputDialog extends StatefulWidget {
  final String title;
  final int index;

  MilestoneInputDialog(this.title, {this.index});

  @override
  _MilestoneInputDialogState createState() =>
      _MilestoneInputDialogState(this.title, this.index);
}

class _MilestoneInputDialogState extends State<MilestoneInputDialog> {
  final String _title;
  final int _index;

  _MilestoneInputDialogState(this._title, this._index);

  final _dateController = TextEditingController();
  final _milestoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${Strings.add} ${_title.toLowerCase()}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dateController,
              maxLines: 1,
              decoration: InputDecoration(labelText: Strings.date),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _milestoneController,
              maxLines: null,
              maxLength: 500,
              decoration: InputDecoration(
                  labelText: _title,
                  errorText: _milestoneController.text.trim().isEmpty
                      ? Strings.error_empty
                      : null),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: Dimens.small_vertical_margin,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: Palette.green,
                  onPressed: () => Navigator.pop(context),
                  child: Text(Strings.cancel.toUpperCase()),
                ),
                FlatButton(
                  textColor: Palette.green,
                  onPressed: () => _save(context),
                  child: Text(Strings.save.toUpperCase()),
                ),
              ],
            )
          ],
        ),
      ),
      elevation: 20.0,
    );
  }

  void _save(BuildContext context) {
    if (_milestoneController.text.trim().isNotEmpty) {
      Navigator.pop(
          context,
          Milestone(
              id: _index,
              description: _milestoneController.text.trim(),
              date: _dateController.text.trim() ?? null));
    }
  }
}
