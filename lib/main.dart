import 'package:charts2_app/add_book/add_book_model.dart';
import 'package:charts2_app/calender/add_event_page.dart';
import 'package:charts2_app/screen/chatpage.dart';
import 'package:charts2_app/screen/forth_page.dart';
import 'package:charts2_app/screen/group_serch_page.dart';
import 'package:charts2_app/screen/home_page.dart';
import 'package:charts2_app/screen/init_page.dart';
import 'package:charts2_app/screen/next_page.dart';
import 'package:charts2_app/screen/splash_page.dart';
import 'package:charts2_app/screen/third_page.dart';
import 'package:provider/provider.dart';
import 'Layout/layout_page.dart';
import 'add_book/add_book_page.dart';
import 'package:charts2_app/book_list/book_list_page.dart';
import 'package:charts2_app/user_preference/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:charts2_app/signup/signup_page.dart';
import 'package:charts2_app/login/login_page.dart';
import 'calender/calender_page.dart';
import 'loading/loading_model.dart';
import 'package:charts2_app/calender/add_event_page.dart';

import 'model/screen_arguments.dart';

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
      home: ChangeNotifierProvider<LoadingModel>(
          create: (_) => LoadingModel(),
          //Provider.of<LoadModel>(context).startLoading();
          child: Stack(
            children: [
              MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Animated Charts App',
                theme: ThemeData(
                  primaryColor: Colors.red,
                ),
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  // If you push the PassArguments route
                  print(settings.name);
                  if (settings.name == "/forth") {
                    // Cast the arguments to the correct
                    // type: ScreenArguments.
                    final args = settings.arguments as ScreenArguments;

                    // Then, extract the required data from
                    // the arguments and pass the data to the
                    // correct screen.
                    print(args.value);

                    return MaterialPageRoute(
                      builder: (context) {
                        return ChatPage(
                          documentid: args.value,
                        );
                      },
                    );
                  }
                  // The code only supports
                  // PassArgumentsScreen.routeName right now.
                  // Other values need to be implemented if we
                  // add them. The assertion here will help remind
                  // us of that higher up in the call stack, since
                  // this assertion would otherwise fire somewhere
                  // in the framework.

                  return null;
                },
                routes: {
                  //'/': (context) => HomePage(),
                  '/': (context) => SplashPage(),
                  '/next': (context) => NextPage(),
                  '/third': (context) => ThirdPage(),
                  //'/forth': (context) => MyHomePage(),
                  '/signup': (context) => SignUpPage(),
                  '/login': (context) => LoginPage(),
                  '/userpreference': (context) => UserPreferencePage(),
                  '/init': (context) => InitPage(),
                  '/booklist': (context) => BookListPage(),
                  '/addbook': (context) => AddBookPage(),
                  '/calender': (context) => CalenderPage(),
                  '/addeventpage': (context) => AddEventPage(),
                  '/home': (context) => LayoutPage(),
                  '/groupserch': (context) => GroupSerchPage(),
                },
              ),
              Consumer<LoadingModel>(
                builder:
                    (BuildContext context, LoadingModel model, Widget child) {
                  if (model.isLoading)
                    return Container(
                      color: Colors.grey.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  return Container();
                },
              ),
            ],
          )),
    );
  }
}
