import 'package:flutter/material.dart';
import 'package:novelsolutely/providers/logged-user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
//    var provider = ;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            'novelsolutely',
//            style: Theme.of(context).textTheme.headline1,
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
    );
  }

}
