import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:novelsolutely/providers/logged-user.dart';

import 'package:novelsolutely/screens/landing_page.dart';
import 'package:novelsolutely/screens/login_page.dart';

import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        create: (BuildContext context) {
          return AuthService();
        },
      ),
    );

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
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context)
            .getUser(), //Comprueba si existe un usuario conectado
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              print("error");
              return Text('Ha habido un error: ${snapshot.error}');
            }
            return !snapshot.hasData ? HomePage() : LoginPage();
          } else {
            return Scaffold(
              body: Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment(0.0, 0.0),
                ),
              ),
            );
          }
        },
      ),
//      home: AuthService().handleAuth(),
//      routes: <String, WidgetBuilder>{
//        '/': (BuildContext context) => LoginPage(),
//        '/': (BuildContext context) => HomePage(),
//        '/login': (BuildContext context) => LoginPage(),
//      },
    );
  }
}
