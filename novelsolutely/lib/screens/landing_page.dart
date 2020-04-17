import 'package:flutter/material.dart';
import 'package:novelsolutely/widgets/appbar_widget.dart';
import '../widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size _mediaQuery;
  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(title: 'novelsolutely', appBar: AppBar(),),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: _mediaQuery.width,
          height: _mediaQuery.height,
          color: Colors.amber,
          child: Wrap(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
