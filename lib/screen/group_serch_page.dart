import 'package:charts2_app/bloc/group_bloc.dart';
import 'package:charts2_app/model/screen_arguments.dart';
import 'package:charts2_app/model/userDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forth_page.dart';

class GroupSerchPage extends StatefulWidget {
  @override
  _GroupSerchPageState createState() => _GroupSerchPageState();
}

class _GroupSerchPageState extends State<GroupSerchPage> {
  final GroupBloc bloc = GroupBloc();
  final mailController = TextEditingController();
  final groupNameController = TextEditingController();
  String edittext = '';
  String grouptext = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getMyGroupList();
  }

  List<Widget> getGroupList(List<DocumentSnapshot> data) {
    return data.map((e) => Text(e.data()["groupname"])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GroupBloc>(
      create: (_) => bloc,
      dispose: (_, bloc) => bloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("グループ作成"),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'exsample@neco.com'),
              controller: mailController,
              onChanged: (text) {
                edittext = text;
              },
            ),
            RaisedButton(
              child: Text('検索する'),
              onPressed: () async {
                bloc.getUserList(edittext);
              },
            ),
            StreamBuilder<UserDataModel>(
              stream: bloc.userdataStreamController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                if (snapshot.hasError)
                  return Container(
                    child: Text("error!!"),
                  );
                return Column(
                  children: [
                    MaterialButton(
                        onPressed: () async {
                         String id = await bloc.uploadGroup(snapshot.data,grouptext);
                         if(id!=null){
                           Navigator.pushReplacementNamed(context, '/forth',arguments: ScreenArguments(id));
                         }
                        }, child: Text(snapshot.data.name)),
                    TextField(
                      decoration: InputDecoration(hintText: 'exsample@neco.com'),
                      controller: groupNameController,
                      onChanged: (text) {
                        grouptext = text;
                      },
                    ),
                  ],

                );
                // return MyHomePage(documentid:snapshot.data.first.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
