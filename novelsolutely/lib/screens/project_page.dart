import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:novelsolutely/models/project.dart';
import 'package:novelsolutely/providers/logged-user.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/drawer_widget.dart';

class ProjectPage extends StatefulWidget {
  static final route = '/story';
  final id;

  ProjectPage({this.id});

  @override
  _ProjectPageState createState() => _ProjectPageState(id: id);
}

class _ProjectPageState extends State<ProjectPage> {
  final _firestoreInstance = Firestore.instance;

//  var _uid;

//  var _uid = 'FcUE8ntyTkZWD2Juu1dklakN67t2';
  final id;

  _ProjectPageState({this.id});

  @override
  Widget build(BuildContext context) {
//    _uid = Provider.of<AuthService>(context, listen: false).getUId();
    return Scaffold(
        appBar: AppBarWidget(
          title: 'novelsolutely',
          appBar: AppBar(),
        ),
        drawer: DrawerWidget(),
        body: AuthService.user.id == null
            ? SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: _firestoreInstance
                    .collection('users')
                    .document('${AuthService.user.id}')
                    .collection('projects')
                    .document('$id')
                    .snapshots(),
                builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data != null) {
                    final project = Project.fromFirestore(snapshot.data);
                    return Wrap(
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          color: Colors.pink,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: project.imageUrl == ''
                                    ? Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                        size: 300.0,
                                      )
                                    : Image(
                                        image: NetworkImage(project.imageUrl),
                                      ),
                              ),
                              Container(
//                                color: Colors.black12,
                                child: Text(
                                  '${project.title}',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SpinKitChasingDots(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    );
                  }
                }));
  }
}
