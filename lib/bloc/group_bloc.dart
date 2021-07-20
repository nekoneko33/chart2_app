import 'dart:async';
import 'package:charts2_app/model/userDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupBloc {
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();

  final StreamController<UserDataModel> userdataStreamController =
      StreamController<UserDataModel>();

  void getMyGroupList() {
    print('ccccccccccccccccccccccccc');
    FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get(GetOptions(source: Source.server))
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

  void getUserList(String mail) {
    FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: mail)
        .get()
        .then((QuerySnapshot value) async {
      UserDataModel userdata = UserDataModel(
          id: value.docs.first.data()['uid'],
          name: value.docs.first.data()['name'],
          reference: value.docs.first.reference);
      userdataStreamController.sink.add(userdata);
    }).catchError((onError) {
      userdataStreamController.addError(onError);
    });
  }

  Future<String> uploadGroup(UserDataModel model, String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DocumentReference data =
        await FirebaseFirestore.instance.collection('groups').add({
      'groupname': text,
      'uidlist': [
        FirebaseFirestore.instance.doc(prefs.getString('documentpass')),
        model.reference
      ]
    });
    await FirebaseFirestore.instance
        .doc(prefs.getString('documentpass'))
        .update({
      'grouplist': FieldValue.arrayUnion([data])
    });
    await model.reference.update({
      'grouplist': FieldValue.arrayUnion([data])
    });
    return data.id;
  }

  Future<DocumentSnapshot> getGroupInfo(DocumentReference reference) async {
    return await reference.get();
  }

  void dispose() {
    streamController.close();
    userdataStreamController.close();
  }
}
