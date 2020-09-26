import 'package:flutter/material.dart';

import './new_element_screen.dart';

//WIDGETS
import './widgets/generic_list_widget.dart';
import './widgets/drawer_widget.dart';

//MODELS
import '../models/dictionary.dart';
import '../models/enum/novel_event_type.dart';
import '../models/id_path.dart';

//UTILS
import '../utils/colors.dart';
import '../utils/data.dart';
import '../utils/dimens.dart';
import '../utils/routes.dart';

//TODO: add new categories
//TODO: save categories
//TODO: export database to JSON
//TODO: quick add elements
//TODO: search by name/summary
//TODO: still doesn't pop up characters?? check
//TODO: delete categories
//TODO: new characters doesn't show up!!
//TODO: delete other
//TODO: delete items
//TODO: delete places

class DictionaryScreen extends StatefulWidget {
  static const route = "/characters";

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  int _index = 0;
  List<GlobalKey<GenericContainerWidgetState>> _keys = [
    GlobalKey(debugLabel: Routes.navigation[0].title),
    GlobalKey(debugLabel: Routes.navigation[1].title),
    GlobalKey(debugLabel: Routes.navigation[2].title),
    GlobalKey(debugLabel: Routes.navigation[3].title)
  ];
  bool _selecting = false;
  Size _size;

  IdPath _idPath;

  @override
  Widget build(BuildContext context) {
    _idPath = ModalRoute.of(context).settings.arguments;
    Dictionary dictionary = Data.box.get(_idPath.idDictionary);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: _selecting
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _keys[_index]
                    .currentState
                    .parentComm(NovelEventType.DESELECT_ALL_CHAR),
              )
            : null,
        title: Text(dictionary.name),
        actions: [
          _selecting
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _keys[_index]
                      .currentState
                      .parentComm(NovelEventType.REMOVE_ALL_CHAR),
                )
              : IconButton(
                  icon: Icon(
                    dictionary.favorite
                        ? Icons.star
                        : Icons.star_border_outlined,
                    color: dictionary.favorite ? Colors.amber : Palette.black,
                  ),
                  onPressed: () {
                    setState(() {
                      dictionary.favorite = !dictionary.favorite;
                      dictionary.save();
                    });
                  },
                ),
        ],
      ),
      drawer: DrawerWidget(dictionary),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.vertical_margin,
          horizontal: Dimens.horizontal_margin,
        ),
        child: IndexedStack(
          index: _index,
          children: [
            for (var i = 0; i < Routes.navigation.length; i++)
              GenericContainerWidget(
                _idPath,
                key: _keys[i],
                callback: (NovelEventType novelEventType) =>
                    _receiveEvent(novelEventType),
                type: Routes.navigation[i].title,
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 15.0, right: 40.0),
          height: Dimens.bottom_app_bar,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < Routes.navigation.length; i++)
                Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _index = i;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Routes.navigation[i].icon,
                          color: i == _index ? Palette.green : Palette.black,
                          size: Dimens.icon,
                        ),
                        Text(
                          Routes.navigation[i].title,
                          style: TextStyle(
                              color:
                                  i == _index ? Palette.green : Palette.black),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                width: 30,
              )
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return Navigator.pushNamed(context, NewElementScreen.route,
            arguments: _idPath);
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  _receiveEvent(NovelEventType event) {
    setState(() {
      _selecting = event == NovelEventType.CHAR_SELECTED;
    });
  }
}
