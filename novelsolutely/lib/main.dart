import 'package:flutter/material.dart';
import 'package:novelsolutely/screen/landing_page.dart';
import 'package:novelsolutely/screen/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novelsolutely',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Raleway',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 72.0, fontFamily: 'Pacifico', color: Colors.pink),
          headline2: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.normal,
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => LoginPage(),
//        '/': (BuildContext context) => HomePage(),
//        '/login': (BuildContext context) => LoginPage(),
      },
    );
  }
}
