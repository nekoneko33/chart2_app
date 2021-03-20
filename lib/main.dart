import 'package:charts2_app/screen/forth_page.dart';
import 'package:charts2_app/screen/home_page.dart';
import 'package:charts2_app/screen/next_page.dart';
import 'package:charts2_app/screen/third_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:charts2_app/signup/signup_page.dart';
import 'package:charts2_app/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animated Charts App',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/next': (context) => NextPage(),
        '/third': (context) => ThirdPage(),
        '/forth': (context) => MyHomePage(),
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
