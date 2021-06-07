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
    if(model.title==null||model.note==null)

    loadingModel.startLoading();
    FirebaseFirestore.instance
      ..collection('schedule').add(
      model.toJson(),
      );
    loadingModel.endLoading();

}

  void getRecord(String userName,DateTime selectedMonth) {
    loadingModel.startLoading();
    DateTime startDate=DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endDate=DateTime(selectedMonth.year, selectedMonth.month+1, 1);
    FirebaseFirestore.instance
        .collection('schedule')
        .where('uid',isEqualTo:userName )
        .where('targetDate',isGreaterThanOrEqualTo: startDate)
        .where('targetDate',isLessThan: endDate)
        .orderBy('targetDate')
        .get()
        .then((QuerySnapshot value) {
      streamController.add(value.docs);
    }).catchError((onError) {
      streamController.addError(onError);
    }).whenComplete(() => loadingModel.endLoading());
    
  }




}
