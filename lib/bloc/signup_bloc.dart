import 'dart:async';
import 'package:charts2_app/calender/calender_model.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:charts2_app/signup/signup_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupBloc {
  final StreamController<List<QueryDocumentSnapshot>> streamController =
      StreamController<List<QueryDocumentSnapshot>>();
  final LoadingModel loadingModel;

  SignupBloc({@required this.loadingModel});

  Future uploadUser(SignUpModel model) async {
    DocumentReference data=await FirebaseFirestore.instance
      .collection('users').add(
        model.toJson(),
      );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('documentpass', data.path);
  }

  Future signUp(SignUpModel model) async {
    try {
      loadingModel.startLoading();
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: model.mail,
        password: model.password,
      );
      model.uid = userCredential.user.uid;
      await uploadUser(model);
      loadingModel.endLoading();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
