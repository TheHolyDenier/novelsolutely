import 'package:flutter/material.dart';

//LIBRARIES
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//MODELS
import './models/category.dart';
import './models/dictionary.dart';
import './models/enum/kinship.dart';
import './models/enum/ownership.dart';
import './models/item.dart';
import './models/milestone.dart';
import './models/other.dart';
import './models/owned.dart';
import './models/character.dart';
import './models/relationship.dart';

//UTILS
import './utils/colors.dart';
import './utils/routes.dart';
import './utils/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DictionaryAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(MilestoneAdapter());
  Hive.registerAdapter(OwnedAdapter());
  Hive.registerAdapter(RelationshipAdapter());
  Hive.registerAdapter(KinshipAdapter());
  Hive.registerAdapter(OwnershipAdapter());
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(OtherAdapter());
  await Hive.openBox(Routes.box);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.app_name,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Palette.green,
        accentColor: Palette.purple,
        errorColor: Palette.pink,
        backgroundColor: Palette.white,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Ribeye', color: Colors.black),
          headline2: TextStyle(fontFamily: 'Ribeye', color: Colors.black),
          headline3: TextStyle(fontFamily: 'Ribeye', color: Colors.black),
          headline4: TextStyle(fontFamily: 'Ribeye', color: Colors.black),
          headline5: TextStyle(fontFamily: 'Ribeye', color: Colors.black),
          headline6:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Palette.green),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: Routes.routes,
      initialRoute: '/',
    );
  }
}
