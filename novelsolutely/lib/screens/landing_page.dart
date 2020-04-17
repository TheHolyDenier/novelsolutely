import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/logged-user.dart';
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
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'novelsolutely',
            style: TextStyle(fontFamily: 'Pacifico'),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: Provider.of<AuthService>(context, listen: false).logout,
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          )
        ],
      ),
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
