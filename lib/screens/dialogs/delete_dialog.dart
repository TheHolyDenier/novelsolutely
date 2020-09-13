import 'package:flutter/material.dart';
//UTILS
import '../../utils/strings.dart';

class DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.delete),
      content: Text(Strings.delete_warning),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(Strings.cancel),
        ),
        FlatButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(true), child: Text(Strings.delete.toUpperCase())),
      ],
    );
  }
}
