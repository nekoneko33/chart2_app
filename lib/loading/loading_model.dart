
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingModel extends ChangeNotifier {

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
