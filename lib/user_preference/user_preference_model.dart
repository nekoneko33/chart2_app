import 'package:flutter/material.dart';

class UserPreferenceModel extends ChangeNotifier{

  String nameText = 'aaa';



  void changeNameText(){
    nameText='bbb';
  notifyListeners();
  }

}