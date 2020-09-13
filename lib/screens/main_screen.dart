import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//LIBRARIES
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//SCREENS && WIDGETS
import './elements_screen.dart';
import './dialogs/delete_dialog.dart';
import './dialogs/title_dialog.dart';
import './widgets/image_widget.dart';

//MODELS
import '../models/dictionary.dart';

//UTILS
import '../utils/dialog_anim.dart';
import '../utils/strings.dart';
import '../utils/routes.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/data.dart';

class MainScreen extends StatefulWidget {
  static const route = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> _selected = [];
  List<Dictionary> dictionaries;

  @override
  void initState() {
    Data.box;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Data.box != null
        ? Scaffold(
            appBar: _getAppBar(),
            body: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.vertical_margin,
                  horizontal: Dimens.horizontal_margin,
                ),
                width: MediaQuery.of(context).size.width,
                child: _getBody()),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                height: Dimens.bottom_app_bar,
              ),
              shape: CircularNotchedRectangle(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: HColors.green,
              onPressed: () {
                setState(() {
                  Data.add(context);
                });
              },
              child: const Icon(Icons.add),
            ),
          )
        : Scaffold(
            backgroundColor: HColors.white,
            body: Center(child: CircularProgressIndicator()),
          );
  }

  AppBar _getAppBar() {
    return AppBar(
      leading: _selected.length > 0
          ? IconButton(
              icon: Icon(Icons.close),
              onPressed: () => setState(() => _selected.length = 0),
            )
          : null,
      title: const Text(Strings.app_name),
      actions: [
        if (_selected.length > 0)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => DialogAnimation.openDialog(context, DeleteDialog())
                .then((value) => _deleteSelected(value)),
          )
      ],
    );
  }

  Widget _getBody() {
    dictionaries = Data.box.values.toList().cast<Dictionary>().toList();
    dictionaries.sort((a, b) => Data.orderFavorite(a, b));
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return dictionaries.length > 4
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              for (final dictionary in dictionaries)
                Card(
                  color: _selected.contains(dictionary.id)
                      ? Theme.of(context).accentColor
                      : null,
                  child: InkWell(
                    onTap: () => _onTapItem(dictionary.id),
                    onLongPress: () => _onLongClickItem(dictionary.id),
                    child: Column(
                      children: [
                        Container(
                          child: ImageWidget(url: dictionary.imagePath),
                          height: itemHeight / 3,
                          width: itemWidth,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          height: itemHeight / 9,
                          width: itemWidth,
                          child: Text(
                            dictionary.name,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          )
        : ListView.builder(
            itemCount: dictionaries.length,
            itemBuilder: (_, index) {
              Dictionary dictionary = dictionaries[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Card(
                  color: _selected.contains(dictionary.id)
                      ? Theme.of(context).accentColor
                      : null,
                  child: InkWell(
                    onTap: () => _onTapItem(dictionary.id),
                    onLongPress: () => _onLongClickItem(dictionary.id),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: ImageWidget(url: dictionary.imagePath),
                        ),
                        Text(dictionary.name,
                            style: Theme.of(context).textTheme.headline3)
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  void _onLongClickItem(String id) {
    if (_selected.contains(id)) {
      setState(() => _selected.remove(id));
    } else {
      setState(() => _selected.add(id));
    }
  }

  void _deleteSelected(value) {
    if (value) {
      List tmp = List.from(_selected);
      tmp.forEach((id) {
        setState(() {
          Data.delete(id);
          _selected.remove(id);
        });
      });
    }
  }

  void _onTapItem(String id) {
    if (_selected.isEmpty) {
      Navigator.pushReplacementNamed(context, ElementsScreen.route,
          arguments: id);
    } else {
      _onLongClickItem(id);
    }
  }
}
