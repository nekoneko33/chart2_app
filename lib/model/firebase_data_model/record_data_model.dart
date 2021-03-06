import 'package:cloud_firestore/cloud_firestore.dart';

class ListRecord {
  final List<Record> listData;

  ListRecord.fromSnapshot(List<QueryDocumentSnapshot> list)
      : listData = List<Record>.from(list.map((QueryDocumentSnapshot e) => Record.fromSnapshot(e)));
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromSnapshot(QueryDocumentSnapshot map, {DocumentReference reference})
      : assert(map['subject'] != null),
        assert(map['votes'] != null),
        name = map['subject'],
        votes = map['votes'],
        reference = reference;

  @override
  String toString() => "Record<$name:$votes>";
}
