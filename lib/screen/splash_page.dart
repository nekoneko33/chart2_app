import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget
{
  @override
  _SplashPageState createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5))
          .then((_) {
        if(FirebaseAuth.instance.currentUser != null)
          Navigator.pushNamedAndRemoveUntil(context, '/home',(Route<dynamic> route) => false);
        else
          Navigator.pushNamedAndRemoveUntil(context, '/login',(Route<dynamic> route) => false);
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(child:Text('splashPage'));

  }
}