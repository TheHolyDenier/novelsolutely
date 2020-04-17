import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:novelsolutely/providers/logged-user.dart';
import 'package:novelsolutely/screens/project_page.dart';
import 'package:novelsolutely/services/routing.dart';

import '../models/project.dart';
import './dialog_project.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final _databaseReference = Firestore.instance;
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Container(
      width: 300.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              width: 300.0,
              child: Container(),
            ),
            decoration: BoxDecoration(
              color: _theme.primaryColor,
            ),
          ),
          AuthService.user.id == null
              ? SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: 50.0,
                )
              : StreamBuilder(
                  stream: _databaseReference
                      .collection('users')
                      .document('${AuthService.user.id}')
                      .collection('projects')
                      .orderBy('title')
                      .snapshots(),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: SpinKitThreeBounce(
                          color: _theme.primaryColor,
                          size: 20.0,
                        ),
                      );
                    } else {
                      return Expanded(
//                    height: 300,
                        child: ListView(
                          children: _getProjectsWidget(snapshot),
                        ),
                      );
                    }
                  }),
          ListTile(
            title: Text('Nuevo proyecto'),
            leading: Icon(Icons.add),
            onTap: () async {
              var projectName = await showDialog(
                  context: context, builder: (_) => DialogNewProject());
              if (projectName != null) _writeProject(projectName);
            },
          )
        ],
      ),
    );
  }

  _getProjectsWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      Project project = Project.fromFirestore(doc);
      return ListTile(
        title: new Text(project.title),
        leading: project.imageUrl.isEmpty
            ? CircleAvatar(
                backgroundColor: _theme.primaryColor,
                child: AutoSizeText(
                  '${project.title.substring(0, 2)}',
                  style: TextStyle(color: Colors.white, fontFamily: 'Pacifico'),
                ),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(project.imageUrl),
              ),
        onTap: () {
          FluroRouter.router.navigateTo(
              context, '${ProjectPage.route}/${project.id}',
              transition: TransitionType.fadeIn);
        },
      );
    }).toList();
  }

  void _writeProject(String title) async {
    var docTitle = title.replaceAll(' ', '-');
    docTitle =
        docTitle.replaceAll(new RegExp(r'[^a-zA-Z0-9-\-]'), '').toLowerCase();

    await _databaseReference
        .collection('users')
        .document('${AuthService.user.id}')
        .collection('projects')
        .document(docTitle)
        .setData({'title': title, 'id': '$docTitle'});
  }
}
