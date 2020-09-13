
import 'package:flutter/material.dart';

//WIDGETS
import './widgets/character_list.dart';
import './widgets/drawer_widget.dart';
import './new_element_screen.dart';

//MODELS
import '../models/dictionary.dart';
//UTILS
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/data.dart';
import '../utils/routes.dart';


class ElementsScreen extends StatefulWidget {
  static const route = "/characters";

  @override
  _ElementsScreenState createState() => _ElementsScreenState();
}

class _ElementsScreenState extends State<ElementsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    Dictionary dictionary = Data.box.get(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(dictionary.name),
        actions: [
          IconButton(
            icon: Icon(
              dictionary.favorite ? Icons.star : Icons.star_border_outlined,
              color: dictionary.favorite ? Colors.amber : HColors.black,
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
            CharacterList(dictionary.id),
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
                          color: i == _index ? HColors.green : HColors.black,
                          size: Dimens.icon,
                        ),
                        Text(
                          Routes.navigation[i].title,
                          style: TextStyle(
                              color:
                                  i == _index ? HColors.green : HColors.black),
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
        backgroundColor: HColors.green,
        onPressed: () => Navigator.pushNamed(context, NewElementScreen.route,
            arguments: dictionary.id),
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
}
