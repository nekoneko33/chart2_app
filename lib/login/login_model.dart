
import 'package:charts2_app/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  //FirebaseAuth auth = FirebaseAuth.instance;

  Future login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      print(userCredential.user.email);
      print(userCredential.user.uid);
      //Navigator.pushNamed(context, '/forth');
      Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName("/"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}