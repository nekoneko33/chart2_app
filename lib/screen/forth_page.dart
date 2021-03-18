import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final String userName = "1";
  final ChatBloc bloc = ChatBloc("1");
  List<ChatDataModel> message = [];
  String sendMessage;
  final _controller = TextEditingController();
  File _image;
  final picker = ImagePicker();
  final _formatter = DateFormat("HH:MM");
  AnimationController _animationController;
  double height = 0;

  final Map<String, IconData> iconList = {
    "error": Icons.error,
    "camera": Icons.camera,
    "message": Icons.message,
    "add": Icons.add,
    "map": Icons.map,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 200),
    );

    _animationController.addListener(() {
      setState(() {
        height = _animationController.value * 300;
      });
    });

    bloc.sendResultStream.stream.listen((ChatDataModel event) {
      setState(() {
        message.add(event);
      });
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        upload();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        upload();
      } else {
        print('No image selected.');
      }
    });
  }

  void upload() async {
    final Reference ref = FirebaseStorage.instance.ref();
    final TaskSnapshot storedImage = await ref
        .child(userName + "_" + DateTime.now().toLocal().toIso8601String())
        .putFile(_image);
    if (storedImage.state == TaskState.success) {
      print('storageに保存しました');
      final String downloadUrl = await storedImage.ref.getDownloadURL();
      _sendImage(downloadUrl);
    }
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

  void _sendIcon(String name) {
    if (name != null) {
      ChatDataModel sendData = ChatDataModel()
        ..sendUserName = userName
        ..date = DateTime.now()
        ..iconName = name;
      bloc.send(sendData);
      _controller.clear();
      sendMessage = null;
    }
  }

  void _sendImage(String imageUrl) {
    if (imageUrl != null) {
      ChatDataModel sendData = ChatDataModel()
        ..sendUserName = userName
        ..date = DateTime.now()
        ..isImage = true
        ..imageUrl = imageUrl;
      bloc.send(sendData);
      _controller.clear();
      sendMessage = null;
    }
  }

  List<Widget> createListWidget() {
    List<IconButton> iconData = [];
    iconList.forEach((String key, IconData value) {
      iconData.add(
        IconButton(
          icon: Icon(value),
          onPressed: () {
            _sendIcon(key);
          },
        ),
      );
    });
    return iconData;
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
                  itemBuilder: (BuildContext context, int index) {
                    if (message[index].isImage) {
                      // TODO レイアウトの調整
                      if (message[index].sendUserName == userName) {
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatter.format(message[index].date),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  ConstrainedBox(
                                      constraints: BoxConstraints.expand(
                                          height: 200, width: 200),
                                      child: Image.network(
                                          message[index].imageUrl))
                                ]));
                      } else {
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [CircleAvatar()]),
                                  ConstrainedBox(
                                      constraints: BoxConstraints.expand(
                                          height: 200, width: 200),
                                      child: Image.network(
                                          message[index].imageUrl)),
                                  Text(
                                    _formatter.format(message[index].date),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ]));
                      }
                    } else if (message[index].iconName != null &&
                        message[index].iconName.isNotEmpty) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [CircleAvatar()]),
                                ConstrainedBox(
                                    constraints: BoxConstraints.expand(
                                        height: 200, width: 200),
                                    child: Icon(
                                        iconList[message[index].iconName])),
                                Text(
                                  _formatter.format(message[index].date),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ]));
                    }
                    if (message[index].sendUserName == userName)
                      return SentMessageWidget(message: message[index].message);
                    return ReceivedMessageWidget(
                        message: message[index].message);
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
                    icon: Icon(Icons.add, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () => _getCamera(),
                    icon: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () => _getImage(),
                    icon: Icon(Icons.insert_photo, color: Colors.black),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: TextField(
                            controller: _controller,
                            enabled: true,
                            maxLength: 10,
                            maxLengthEnforced: false,
                            style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                                fontSize: 20.0),
                            obscureText: false,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              hintText: 'Aa',
                              counterText: "",
                            ),
                            onChanged: (String text) {
                              sendMessage = text;
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {
                              setState(() {
                                if (height == 0) {
                                  _animationController.animateTo(
                                    1.0,
                                  );
                                } else {
                                  _animationController.animateTo(
                                    0.0,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 30,
                          child: IconButton(
                            icon: Icon(Icons.emoji_emotions_sharp),
                            onPressed: () async {
                              var result = await showModalBottomSheet<int>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.music_note),
                                        title: Text('Music'),
                                        onTap: () =>
                                            Navigator.of(context).pop(1),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.videocam),
                                        title: Text('Video'),
                                        onTap: () =>
                                            Navigator.of(context).pop(2),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Picture'),
                                        onTap: () =>
                                            Navigator.of(context).pop(3),
                                      ),
                                    ],
                                  );
                                },
                              );
                              print('bottom sheet result: $result');
                            },
                          ),
                        ),
                      ],
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
              Container(
                width: double.infinity,
                height: height,
                child: GridView.count(
                  crossAxisCount: 5,
                  children: createListWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
