import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingBloc {
  String userId;
  final StreamController<Map<String, dynamic>> streamController =
      StreamController<Map<String, dynamic>>();

  UserSettingBloc(String uid) {
    userId = uid;
  }

  void getUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
          print(value.data());
      streamController.add(value.data());
    });
  }

  void updateData(Map<String, dynamic> data) {
    FirebaseFirestore.instance.collection('users').doc(userId).set(data).then((value) => getUserData());
  }
}
