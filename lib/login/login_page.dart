import 'package:charts2_app/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts2_app/login/login_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('サインアップ'),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'exsample@neco.com'),
                  controller: mailController,
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'パスワード'),
                  obscureText: true,
                  controller: passwordController,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                RaisedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    await model.login();
                  },
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
