import 'package:charts2_app/bloc/group_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forth_page.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupBloc bloc = GroupBloc();

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
        //appBar: AppBar(title: Text("グループ一覧"),),
        body: StreamBuilder<List<DocumentSnapshot>>(
          stream: bloc.streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            if (snapshot.hasError) return Container(child: Text("error!!"),);
            return MyHomePage(documentid:snapshot.data.first.id);
          },
        ),
      ),
    );
  }
}
