import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

UserDataModel userDataModelFromSnapShot(DocumentSnapshot data,String userid) =>
    UserDataModel.fromSnapshot(data,userid);

class UserDataModel {
  String id;
  String name;
  String imageUrl;

  UserDataModel({this.id, this.name, this.imageUrl});

  //ChatDataModel(sendUserName: userName, message: sendMessage, date: DateTime.now());

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'imageUrl': imageUrl};

  factory UserDataModel.fromSnapshot(DocumentSnapshot snapshot,String userid) => UserDataModel(
        id: userid,
        name: snapshot.data()['name'],
        imageUrl: snapshot.data()['imageUrl'],
      );
}
