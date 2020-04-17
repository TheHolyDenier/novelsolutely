import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User user = User();

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  Future<FirebaseUser> getUId() async {
    final FirebaseUser user = await getUser();
    return user;
  }

  login() {
    getUId().then((value) => user = User(
        id: value.uid,
        name: value.displayName,
        imageUrl: value.photoUrl ?? ''));
  }

  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    user = User();
    notifyListeners();
    return result;
  }

  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return result.user;
    } catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }
}
