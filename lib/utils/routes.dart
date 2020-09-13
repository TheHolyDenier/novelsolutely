import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//WIDGETS
import '../screens/character_screen.dart';
import '../screens/elements_screen.dart';
import '../screens/main_screen.dart';
import '../screens/milestone_screen.dart';
import '../screens/new_element_screen.dart';

//MODELS
import '../models/item_navigation.dart';

//UTILS
import '../utils/strings.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    MainScreen.route: (context) => MainScreen(),
    ElementsScreen.route: (context) => ElementsScreen(),
    CharacterScreen.route: (context) => CharacterScreen(),
    MilestoneScreen.route: (context) => MilestoneScreen(),
    NewElementScreen.route: (context) => NewElementScreen(),
  };

  static const box = 'dictionaries';

  static final navigation = [
    ItemNavigation(Strings.characters, Icons.people_alt_outlined),
    ItemNavigation(Strings.places, Icons.location_city_outlined),
    ItemNavigation(Strings.objects, Icons.architecture_outlined),
    ItemNavigation(Strings.others, Icons.art_track_outlined),
  ];
}
