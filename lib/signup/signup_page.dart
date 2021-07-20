import 'package:charts2_app/bloc/signup_bloc.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:charts2_app/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignupBloc bloc;
  SignUpModel model=SignUpModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = SignupBloc(
          loadingModel:
          Provider.of<LoadingModel>(context, listen: false));

    });
  }

  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('新規登録'),),
      body: Padding(
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
          TextField(
            decoration: InputDecoration(hintText: 'ユーザー名'),
            obscureText: true,
            controller: usernameController,
            onChanged: (text) {
              model.username = text;
            },
          ),
          RaisedButton(
            child: Text('登録する'),
            onPressed: () async {
              await bloc.signUp(model);
              Navigator.pushNamedAndRemoveUntil(context, '/home',(Route<dynamic> route) => false);
            },
          ),
        ]),
      ),
    );
  }
}
