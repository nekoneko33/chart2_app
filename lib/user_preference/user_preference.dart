import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:charts2_app/bloc/user_bloc.dart';
import 'package:charts2_app/model/userDataModel.dart';
import 'package:charts2_app/user_preference/user_preference_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

/*
class UserPreferencePage extends StatefulWidget {
  UserPreferencePage({this.app});

  final FirebaseApp app;

  @override
  _UserPreferencePageState createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  String user;
  String displayname;
  UserBloc bloc;

  List<UserDataModel> message = [];
  String sendMessage;

  File _image;
  final picker = ImagePicker();
  final _formatter = DateFormat("HH:MM");

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser.uid;
    bloc = UserBloc(user);
    bloc.sendResultStream.stream.listen((UserDataModel event) {
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
        .child(user + "_" + DateTime.now().toLocal().toIso8601String())
        .putFile(_image);
    if (storedImage.state == TaskState.success) {
      print('storageに保存しました');
      final String downloadUrl = await storedImage.ref.getDownloadURL();
      _sendImage(downloadUrl);
    }
  }

  void _sendImage(String imageUrl) {
    if (imageUrl != null) {
      UserDataModel sendData = UserDataModel()
        ..id = user
        ..name = displayname
        ..imageUrl = imageUrl;
      bloc.send(sendData);
    }
  }
*/

class UserPreferencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserPreferenceModel>(
      create: (_) => UserPreferenceModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ユーザー設定画面'),
        ),
        body: Consumer<UserPreferenceModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 100,
              ),
              Text(model.nameText),
              RaisedButton(
                  child: Text('参考書一覧'),
                  onPressed: () {
                    //model.changeNameText();
                    Navigator.pushNamed(context, '/booklist');
                  }),
            ]),
          );
        }),
      ),
    );
  }
}
