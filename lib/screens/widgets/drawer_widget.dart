import 'package:flutter/material.dart';
import 'package:novelsolutely/models/id_path.dart';

//WIDGETS
import './image_widget.dart';
import '../main_screen.dart';
import '../dictionary_screen.dart';
import '../import_text_screen.dart';
import '../dialogs/delete_dialog.dart';
import '../dialogs/dictionary_input_dialog.dart';
//MODELS
import '../../models/dictionary.dart';

//UTILS
import '../../utils/colors.dart';
import '../../utils/data.dart';
import '../../utils/dialog_anim.dart';
import '../../utils/strings.dart';


class DrawerWidget extends StatefulWidget {
  final Dictionary _active;

  DrawerWidget(this._active);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState(_active);
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Dictionary _active;

  _DrawerWidgetState(this._active);

  @override
  Widget build(BuildContext context) {
    List<Dictionary> dictionaries =
        Data.box.values.toList().cast<Dictionary>().toList();
    dictionaries.sort((a, b) => Data.orderFavorite(a, b));
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  top: 0,
                  child: ImageWidget(url: _active.imagePath),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration:
                          BoxDecoration(color: Palette.white.withOpacity(0.5)),
                      child: Text(
                        _active.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ))
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.route, (route) => false),
            leading: Icon(Icons.home),
            title: Text(Strings.home),
          ),
          ListTile(
            onTap: () {
              setState(() {
                Data.add(context);
              });
            },
            leading: Icon(Icons.add),
            title:
                Text('${Strings.add} ${Strings.new_dictionary.toLowerCase()}'),
          ),
          Divider(),
          ListTile(
            onTap: () => _edit(context),
            leading: Icon(Icons.edit),
            title: Text('${Strings.edit} ${_active.name}'),
          ),
          ListTile(
            onTap: _deleteDictionary,
            leading: Icon(Icons.delete),
            title: Text('${Strings.delete} ${_active.name}'),
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.pushNamed(context, ImportTextScreen.route, arguments: IdPath(_active.id)),
            leading: Icon(Icons.import_contacts),
            title: Text(Strings.import_from_text),
          ),
          ListTile(
            onTap: null,
            leading: Icon(Icons.attach_file_outlined),
            title: Text(Strings.import_from_file),
          ),
          ListTile(
            onTap: null,
            leading: Icon(Icons.save_alt),
            title: Text(Strings.export_file),
          ),
          Divider(),
          for (final dictionary in dictionaries)
            dictionary.id == _active.id
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, DictionaryScreen.route,
                            arguments: IdPath(_active.id));
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: ClipOval(
                          child: ImageWidget(
                              url: dictionary.imagePath != null
                                  ? dictionary.imagePath
                                  : ''),
                        ),
                      ),
                      title: Text(
                        dictionary.name,
                      ),
                    ),
                  )
        ],
      ),
    );
  }

  void _edit(BuildContext context) {
    DialogAnimation.openDialog(
        context,
        DictionaryInputDialog(
          name: _active.name,
          image: _active.imagePath ?? null,
        )).then((value) {
      _active.name = value[0];
      _active.imagePath = value[1];
      _active.save();
      setState(() {});
    });
  }

  void _deleteDictionary() {
    DialogAnimation.openDialog(context, DeleteDialog()).then((value) {
      if (value) {
        setState(() {
          Data.delete(_active.id);
        });
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.route, (route) => false);
      }
    });
  }
}
