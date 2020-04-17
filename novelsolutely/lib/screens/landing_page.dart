import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:novelsolutely/models/project.dart';
import 'package:novelsolutely/widgets/dialog_project.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/logged-user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  var uid = Provider.of<AuthService>(context, listen: false).getUId();
  var _uid = 'FcUE8ntyTkZWD2Juu1dklakN67t2';
  final _databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
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
      drawer: _projectWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.amber,
          child: Wrap(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }

  void _writeProject(String title) async {
    var projectUid = Uuid().v1();

    var docTitle = title.replaceAll(new RegExp(r'[^a-zA-Z0-9]'), '-');
    docTitle = docTitle.replaceAll(new RegExp(r'-{2,}'), '-');
    await _databaseReference
        .collection('users')
        .document('$_uid')
        .collection('projects')
        .document(docTitle)
        .setData({'title': title, 'id': '$projectUid'});
  }

  _getProjectsWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      Project project = Project.fromFirestore(doc);
      return ListTile(
        title: new Text(project.title),
        leading: project.imageUrl.isEmpty
            ? CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: AutoSizeText(
//                  '${project.title[0]}',
                  '${project.title.substring(0,2)}',
                  style: TextStyle(color: Colors.white, fontFamily: 'Pacifico'),
                ),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(project.imageUrl),
              ),
      );
    }).toList();
  }

  _projectWidget() {
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
              color: Theme.of(context).primaryColor,
            ),
          ),
          StreamBuilder(
              stream: _databaseReference
                  .collection('users')
                  .document('$_uid')
                  .collection('projects')
                  .orderBy('title')
                  .snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: SpinKitThreeBounce(
                      color: Colors.white,
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
}
