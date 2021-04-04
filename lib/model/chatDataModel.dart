import 'package:firebase_database/firebase_database.dart';

ChatDataModel chatDataModelFromSnapShot(DataSnapshot data) =>
    ChatDataModel.fromSnapshot(data);

class ChatDataModel {
  String sendUserName;
  DateTime date;
  String message;
  bool isImage;
  String imageUrl;
  String iconName;

  ChatDataModel({
    this.sendUserName,
    this.date,
    this.message,
    this.isImage = false,
    this.imageUrl,
    this.iconName,
  });

  //ChatDataModel(sendUserName: userName, message: sendMessage, date: DateTime.now());



  //Json形で登録
  /*{
  'sendUserName': "hirose",
  'dateTime': "2021/03/25"  JsonFile
  左がkey,右がvalue
  }*/
  Map<String, dynamic> toJson() => <String, dynamic>{
        "sendUserName": sendUserName,
        "dateTime": date.toLocal().toIso8601String(),
        "message": message,
        "isImage": isImage,
        "imageUrl": imageUrl,
        "iconName": iconName,
      };


  //Jsonデータからデータの取得
  factory ChatDataModel.fromSnapshot(DataSnapshot snapshot) => ChatDataModel(
        sendUserName: snapshot.value["sendUserName"],
        date: DateTime.parse(snapshot.value["dateTime"]),
        message: snapshot.value["message"],
        isImage: snapshot.value["isImage"] ?? false,
        imageUrl: snapshot.value["imageUrl"],
        iconName: snapshot.value["iconName"],
      );

}
