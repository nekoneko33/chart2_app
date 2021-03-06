import 'package:firebase_database/firebase_database.dart';

ChatDataModel chatDataModelFromSnapShot(DataSnapshot data) => ChatDataModel.fromSnapshot(data);

class ChatDataModel {
  String sendUserName;
  DateTime date;
  String message;

  ChatDataModel({
    this.sendUserName,
    this.date,
    this.message,
  });

  //ChatDataModel(sendUserName: userName, message: sendMessage, date: DateTime.now());


  Map<String, dynamic> toJson() => <String, dynamic>{
    "sendUserName": sendUserName,
    "dateTime": date.toLocal().toIso8601String(),
    "message": message,
  };

  factory ChatDataModel.fromSnapshot(DataSnapshot  snapshot) => ChatDataModel(
    sendUserName: snapshot.value["sendUserName"],
    date: DateTime.parse(snapshot.value["dateTime"]),
    message: snapshot.value["message"],
  );
}