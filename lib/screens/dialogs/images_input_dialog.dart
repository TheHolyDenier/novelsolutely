import 'package:flutter/material.dart';
//LIBRARIES
import 'package:string_validator/string_validator.dart';
//VIEWS
import '../widgets/image_widget.dart';

//MODELS
import '../../models/generic.dart';

//UTILS
import '../../utils/strings.dart';

class ImagesInputDialog extends StatefulWidget {
  final Generic generic;

  ImagesInputDialog(this.generic);

  @override
  _ImagesInputDialogState createState() => _ImagesInputDialogState(generic);
}

class _ImagesInputDialogState extends State<ImagesInputDialog> {
  Generic _generic;

  _ImagesInputDialogState(this._generic) {
    for (var i = 0; i < _generic.imagePath.length; i++) {
      _imageControllers[i] = TextEditingController(text: _generic.imagePath[i]);
    }
  }

  var _imageControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.add_images),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < _imageControllers.length; i++)
              ListTile(
                title: TextFormField(
                  controller: _imageControllers[i],
                  decoration: InputDecoration(labelText: Strings.add_image),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                trailing: _imageControllers[i].text.trim().isNotEmpty &&
                        isURL(_imageControllers[i].text.trim())
                    ? ImageWidget(url: _imageControllers[i].text.trim())
                    : null,
              ),
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Strings.cancel.toUpperCase())),
        FlatButton(
            onPressed:  _saveImages,
            child: Text(Strings.save.toUpperCase())),
      ],
    );
  }

  void _saveImages() {
    List<String> images = [];
    for (final controller in _imageControllers) {
      if (controller.text.trim().isNotEmpty && isURL(controller.text.trim()))
        images.add(controller.text.trim());
    }
    print('tmp envía $images');
    Navigator.pop(context, images);
  }
}
