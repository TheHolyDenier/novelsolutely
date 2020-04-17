import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import './screens/landing_page.dart';
import './screens/login_page.dart';
import './services/routing.dart';
import './providers/logged-user.dart';

void main() {
  FluroRouter.setupRouter();
  runApp(
    ChangeNotifierProvider<AuthService>(
      child: MyApp(),
      create: (BuildContext context) {
        return AuthService();
      },
    ),
  );
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
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context)
            .getUser(), //Comprueba si existe un usuario conectado
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              print("error");
              return Text('Ha habido un error: ${snapshot.error}');
            }
            Provider.of<AuthService>(context, listen: false).login();
            return snapshot.hasData ? HomePage() : LoginPage();
          } else {
            return Scaffold(
              body: Center(
                child: Container(
                  child: SpinKitChasingDots(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  ),
                  alignment: Alignment(0.0, 0.0),
                ),
              ),
            );
          }
        },
      ),
      onGenerateRoute: FluroRouter.router.generator,
    );
  }
}
