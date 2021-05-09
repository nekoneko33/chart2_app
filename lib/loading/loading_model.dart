<<<<<<< HEAD
=======

>>>>>>> 9aa87e8 (calender)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingModel extends ChangeNotifier {
<<<<<<< HEAD
=======

>>>>>>> 9aa87e8 (calender)
  bool isLoading = false;


  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  /*
  loading() {
    return isLoading
        ? Container(
            color: Colors.grey.withOpacity(0.7),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SizedBox();
  }
   */

}
