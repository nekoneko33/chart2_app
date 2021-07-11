import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupBloc {
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();

  void getMyGroupList() {
    FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((QuerySnapshot value) async {
      List<DocumentSnapshot> groupinfolist = [];
      await Future.forEach(
          value.docs.first.data()["grouplist"] as List<dynamic>,
          (element) async {
        DocumentSnapshot groupinfo = await getGroupInfo(element);
        groupinfolist.add(groupinfo);
      });
      streamController.sink.add(groupinfolist);
    }).catchError((onError) {
      streamController.addError(onError);
    });
  }

  Future<DocumentSnapshot> getGroupInfo(DocumentReference reference) async {
    return await reference.get();
  }

  void dispose() {
    streamController.close();
  }

}
