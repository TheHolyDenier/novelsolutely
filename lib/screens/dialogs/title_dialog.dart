import 'package:flutter/material.dart';

//WIDGETS
import '../widgets/image_widget.dart';

//UTILS
import '../../utils/strings.dart';

class TitleInputDialog extends StatefulWidget {
  final String name;
  final String image;

  TitleInputDialog({this.name, this.image});

  @override
  _TitleInputDialogState createState() =>
      _TitleInputDialogState(name: name ?? null, image: image ?? null);
}

class _TitleInputDialogState extends State<TitleInputDialog> {
  bool _newDictionary = true;

  _TitleInputDialogState({String name, String image}) {
    if (name != null) {
      _controllerName.text = name;
      _newDictionary = false;
    }
    if (image != null) _controllerImage.text = image;
  }

  final _controllerName = TextEditingController();
  final _controllerImage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_newDictionary ? Strings.new_dictionary : '${Strings.edit} ${Strings.dictionary.toLowerCase()}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_controllerImage.text != null && _controllerImage.text.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ImageWidget(url: _controllerImage.text),
            ),
          TextField(
            autofocus: false,
            decoration: InputDecoration(labelText: Strings.new_dictionary_name),
            controller: _controllerName,
            onChanged: (_) {
              setState(() {});
            },
          ),
          TextField(
            autofocus: false,
            decoration: InputDecoration(labelText: Strings.add_image),
            controller: _controllerImage,
            onChanged: (_) {
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(Strings.cancel.toUpperCase()),
        ),
        FlatButton(
            onPressed: _controllerName.text == null ||
                    _controllerName.text.isEmpty
                ? null
                : () {
                    Navigator.pop(
                        context, [_controllerName.text, _controllerImage.text]);
                  },
            child: Text(_newDictionary
                ? Strings.create.toUpperCase()
                : Strings.save.toUpperCase())),
      ],
      elevation: 20.0,
    );
  }
}
