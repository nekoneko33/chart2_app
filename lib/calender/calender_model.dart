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
}

class EventColorModel{
  int red;
  int green;
  int blue;

  EventColorModel({this.red,this.green,this.blue});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'red': red, 'green': green, 'blue': blue};
}