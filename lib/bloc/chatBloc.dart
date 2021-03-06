import 'dart:async';

import 'package:charts2_app/model/chatDataModel.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatBloc {
  final _notesReference = FirebaseDatabase.instance.reference().child('1-2');

  final StreamController<ChatDataModel> _sendStream = StreamController<ChatDataModel>();
  final StreamController<ChatDataModel> sendResultStream = StreamController<ChatDataModel>();

  ChatBloc(String userName) {

    _notesReference.onChildAdded.listen((Event event) {
      print("aaaaaaaaaaaaaa");
      print(event.snapshot.value);
      //if (event.snapshot.value != null  && userName != event.snapshot.value["sendUserName"])
        sendResultStream.sink.add(chatDataModelFromSnapShot(event.snapshot));
    });
  }

  send(ChatDataModel data) {
    _notesReference.push().set(data.toJson()).then((_) {
      //sendResultStream.sink.add(data);
    });
  }

  dispose() {
    _sendStream.close();
    sendResultStream.close();
  }
}