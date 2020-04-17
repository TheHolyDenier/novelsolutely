import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:novelsolutely/providers/logged-user.dart';
import '../screens/landing_page.dart';

import '../screens/project_page.dart';
import '../screens/login_page.dart';

class FluroRouter {
  static Router router = Router();

//  static Handler _storyhandler = Handler(
//      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
//          HomeView(id: params['id'][0]));
  static Handler _homehandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());

  static Handler _projecthandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          AuthService.user.id != null
              ? ProjectPage(id: params['id'][0])
              : LoginPage());

  static void setupRouter() {
    router.define(
      '/',
      handler: _homehandler,
    );
    router.define(
      '${ProjectPage.route}/:id',
      handler: _projecthandler,
    );
//    router.define(
//      '/story/:id',
//      handler: _storyhandler,
//    );
  }
}
