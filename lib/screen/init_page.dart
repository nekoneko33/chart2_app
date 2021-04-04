import 'package:charts2_app/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'スタート画面',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () => {Navigator.pushNamed(context, '/signup')},
              child: Text('新規登録'),
            ),
            RaisedButton(
              onPressed: () => {Navigator.pushNamed(context, '/login')},
              child: Text('ログイン'),
            ),

          ],
        ),
      ),
    );
  }
}
