import 'dart:async';
import 'package:charts2_app/calender/calender_model.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CalenderBloc {
  final StreamController<List<QueryDocumentSnapshot>> streamController = StreamController<List<QueryDocumentSnapshot>>();
  final LoadingModel loadingModel;

  CalenderBloc({@required this.loadingModel});

  uploadEvent(CalenderModel model){
    loadingModel.startLoading();
    FirebaseFirestore.instance
      ..collection('schedule').add(
      model.toJson(),
      );
    loadingModel.endLoading();

}



}
