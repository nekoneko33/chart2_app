import 'dart:async';

import 'package:charts2_app/model/chatDataModel.dart';
import 'package:charts2_app/model/userDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserBloc {
  final _notesReference = FirebaseFirestore.instance
      .collection('users');

  final StreamController<UserDataModel> _sendStream = StreamController<UserDataModel>();
  final StreamController<UserDataModel> sendResultStream = StreamController<UserDataModel>();

  UserBloc(String userName) ;




  send(UserDataModel data) {
    _notesReference.doc(data.id).set(data.toJson());
  }

  get(){
    final String uid=FirebaseAuth.instance.currentUser.uid;
    _notesReference.doc(uid).get()
        .then((DocumentSnapshot value) => userDataModelFromSnapShot(value,uid));
  }

  dispose() {
    _sendStream.close();
    sendResultStream.close();
  }
}