import 'dart:async';
import 'package:provider/provider.dart';
import 'package:charts2_app/bloc/chatBloc.dart';
import 'package:charts2_app/model/chatDataModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:charts2_app/model/sendMessageWidget.dart';
import 'package:charts2_app/model/receiveMessageWidget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});

  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String userName = "1";
  final ChatBloc bloc = ChatBloc("1");
  List<ChatDataModel> message = [];
  String sendMessage;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.sendResultStream.stream.listen((ChatDataModel event) {
      setState(() {
        message.add(event);
      });
    });
  }

  void _sendMessage() {
    if (sendMessage != null) {
      ChatDataModel sendData = ChatDataModel()
        ..sendUserName = userName
        ..message = sendMessage
        ..date = DateTime.now();
      bloc.send(sendData);
      _controller.clear();
      sendMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ChatBloc>(
      create: (_) => bloc,
      dispose: (_, bloc) => bloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            "グループ名",
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
            ),
            IconButton(
              icon: Icon(Icons.call, color: Colors.black),
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.cyanAccent,
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: message.length,
                    itemBuilder: (BuildContext context, int index){
                      return  _SentMessageWidget(message[index]);
                    },

                ),
                /*child: ListView(
                 //reverse: true,
                  children: message
                      .map(
                        (e) =>
                            Container(
                          color: e.sendUserName == userName
                              ? Colors.green
                              : Colors.transparent,
                          child: ListTile(
                            title: Text(
                              e.message ?? '',
                              style: TextStyle(
                                color: e.sendUserName == userName
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),*/
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add,color: Colors.black),

                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt,color: Colors.black),

                  ),
                  IconButton(
                    icon: Icon(Icons.insert_photo,color: Colors.black),

                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: true,
                      maxLength: 10,
                      maxLengthEnforced: false,
                      style: TextStyle(color: Colors.black),
                      obscureText: false,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Aa',
                        icon: Icon(Icons.emoji_emotions_outlined)
                      ),
                      onChanged: (String text) {
                        sendMessage = text;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
