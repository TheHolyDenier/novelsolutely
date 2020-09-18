import 'package:flutter/material.dart';

import './new_element_screen.dart';

//WIDGETS
import './widgets/character_container.dart';
import './widgets/drawer_widget.dart';

//MODELS
import '../models/dictionary.dart';
import '../models/enum/novel_event_type.dart';

//UTILS
import '../utils/colors.dart';
import '../utils/data.dart';
import '../utils/dimens.dart';
import '../utils/routes.dart';

//TODO: fix screen not reloading when new characters are added!!
//TODO: delete characters
//TODO: add milestones
//TODO: add new categories
//TODO: add other elements
//TODO: export database to JSON
//TODO: quick add elements
//TODO: search by name/summary

class DictionaryScreen extends StatefulWidget {
  static const route = "/characters";

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  int _index = 0;
  GlobalKey<CharacterContainerWidgetState> _childKey = GlobalKey();
  bool _selecting = false;

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    Dictionary dictionary = Data.box.get(id);
    return Scaffold(
      appBar: AppBar(
        leading: _selecting
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _childKey.currentState
                    .parentComm(NovelEventType.DESELECT_ALL_CHAR),
              )
            : null,
        title: Text(dictionary.name),
        actions: [
          _selecting
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _childKey.currentState
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
            CharacterContainerWidget(
              dictionary.id,
              key: _childKey,
              selectCallback: (NovelEventType novelEventType) =>
                  _receiveEvent(novelEventType),
            ),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: Dimens.bottom_app_bar,
          child: Row(
            mainAxisSize: MainAxisSize.max,
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
        onPressed: () => Navigator.pushNamed(context, NewElementScreen.route,
            arguments: dictionary.id),
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
