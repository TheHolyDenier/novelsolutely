import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String title;
  String imageUrl;

  Project({this.id, this.title, this.imageUrl});

  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Project(
      id: doc.documentID,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
