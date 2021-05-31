import 'package:cloud_firestore/cloud_firestore.dart';

class CalenderModel{
  String uid;
  DateTime targetDate;
  DateTime startTime;
  DateTime endTime;

  EventColorModel color;

  String title;
  String note;

  CalenderModel({this.uid,this.targetDate,this.startTime,this.endTime,this.color,this.title,this.note});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'uid': uid, 'targetDate': targetDate, 'startTime': startTime, 'endTime': endTime, 'color': color.toJson(), 'title': title, 'note': note};

  CalenderModel.fromSnapshot(QueryDocumentSnapshot map)
      : assert(map['uid'] != null),
        assert(map['targetDate'] != null),
        assert(map['startTime'] != null),
        assert(map['endTime'] != null),
        assert(map['title'] != null),
        assert(map['note'] != null),
        uid = map['uid'],
        targetDate = (map['targetDate'] as Timestamp).toDate(),
        startTime= (map['startTime'] as Timestamp).toDate(),
        endTime = (map['endTime'] as Timestamp).toDate(),
        title = map['title'],
        note = map['note'],
        color=EventColorModel.fromSnapshot(map['color']);

}

class EventColorModel{
  int red;
  int green;
  int blue;

  EventColorModel({this.red,this.green,this.blue});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'red': red, 'green': green, 'blue': blue};

  EventColorModel.fromSnapshot(Map<String,dynamic> map)
   : red = map['red'],
     blue = map['blue'],
     green= map['green'];




}

