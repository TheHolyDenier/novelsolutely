import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:novelsolutely/providers/logged-user.dart';
import 'package:novelsolutely/services/routing.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;

  const AppBarWidget({this.title, this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.contain,
        child: GestureDetector(
          onTap: () => FluroRouter.router
              .navigateTo(context, '/', transition: TransitionType.fadeIn),
          child: Text(
            title,
            style: TextStyle(fontFamily: 'Pacifico'),
          ),
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
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
