
import 'package:charts2_app/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      QuerySnapshot data=await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: userCredential.user.uid)
          .get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('documentpass', data.docs.first.reference.path);
      //Navigator.pushNamed(context, '/forth');
      //Navigator.pushNamedAndRemoveUntil(context, '/forth', ModalRoute.withName("/"));
      Navigator.pushNamedAndRemoveUntil(context, '/home',(Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}