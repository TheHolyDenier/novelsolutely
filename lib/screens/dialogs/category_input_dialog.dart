import 'package:flutter/material.dart';

//WIDGETS
import '../widgets/image_widget.dart';

//UTILS
import '../../utils/strings.dart';

class CategoryInputDialog extends StatefulWidget {
  final String name;

  CategoryInputDialog({this.name});

  @override
  _CategoryInputDialogState createState() =>
      _CategoryInputDialogState(name: name ?? null);
}

class _CategoryInputDialogState extends State<CategoryInputDialog> {
  bool _newCategory = true;

  _CategoryInputDialogState({String name}) {
    if (name != null) {
      _controllerName.text = name;
      _newCategory = false;
    }
  }

  final _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_newCategory ? Strings.new_category : '${Strings.edit} ${Strings.dictionary.toLowerCase()}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.instructions_new_category),
          TextField(
            autofocus: false,
            decoration: InputDecoration(labelText: Strings.new_category_name, helperText: Strings.new_category_helper, helperMaxLines: 4),
            controller: _controllerName,
            onChanged: (_) {
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Strings.cancel.toUpperCase()),
        ),
        FlatButton(
            onPressed: _controllerName.text == null ||
                    _controllerName.text.isEmpty
                ? null
                : () {
                    Navigator.pop(
                        context, _controllerName.text);
                  },
            child: Text(_newCategory
                ? Strings.create.toUpperCase()
                : Strings.save.toUpperCase())),
      ],
      elevation: 20.0,
    );
  }
}
