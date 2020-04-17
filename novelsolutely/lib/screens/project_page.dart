import 'package:flutter/material.dart';

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
  final id;

  _ProjectPageState({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'novelsolutely',
        appBar: AppBar(),
      ),
      drawer: DrawerWidget(),
    );
  }
}
