import 'dart:io';

import 'package:charts2_app/bloc/user_setting_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserSetting extends StatefulWidget {

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  UserSettingBloc bloc;
  String userId = FirebaseAuth.instance.currentUser.uid;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // ユーザーデータを取得する
    bloc = UserSettingBloc(userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.getUserData();
    });
  }

  Future<void> _getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void upload(Map<String, dynamic> data) async {
    await _getCamera();
    final Reference ref = FirebaseStorage.instance.ref();
    final TaskSnapshot storedImage = await ref
        .child(userId + "_user_thumbnailPath" + DateTime.now().toLocal().toIso8601String())
        .putFile(_image);
    if (storedImage.state == TaskState.success) {
      print('storageに保存しました');
      final String downloadUrl = await storedImage.ref.getDownloadURL();
      data["thumbnailUrl"] = downloadUrl;
      bloc.updateData(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: bloc.streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.hasError) return Text("errorです");
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data;
              if (data != null && data["thumbnailUrl"] != null) {
                return Image.network(
                    snapshot.data["thumbnailUrl"]);
              }
              return IconButton(
                icon: Icon(Icons.no_sim),
                onPressed: () {
                  upload(data??{});
                },
              );
            }
            return IconButton(
              icon: Icon(Icons.no_sim),
              onPressed: () {
                upload({});
              },
            );
          },
        ),
      ),
    );
  }
}