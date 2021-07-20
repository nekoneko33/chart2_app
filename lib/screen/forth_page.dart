import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:charts2_app/model/screen_arguments.dart';
import 'package:charts2_app/screen/chatpage.dart';
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

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      // Provide a function to handle named routes.
      // Use this function to identify the named
      // route being pushed, and create the correct
      // Screen.
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        print(settings.name);
        if (settings.name == "/") {
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
    );
  }

}
