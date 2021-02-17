import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBloc {
  final StreamController<List<QueryDocumentSnapshot>> streamController =
      StreamController<List<QueryDocumentSnapshot>>();

  void getRecord() {
    FirebaseFirestore.instance
        .collection('users')
        .where("english")
        .get()
        .then((QuerySnapshot value) {
      streamController.add(value.docs);
    }).catchError((onError) {
      streamController.addError(onError);
    });
  }

  void update(DocumentReference reference) {
    reference.update({'votes': FieldValue.increment(1)}).whenComplete(() => getRecord());
  }
}
