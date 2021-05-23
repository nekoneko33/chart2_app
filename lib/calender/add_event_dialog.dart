import 'dart:ffi';

import 'package:charts2_app/bloc/calender_bloc.dart';
import 'package:charts2_app/calender/calender_model.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/PickerLocalizations.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEventDialog extends StatefulWidget {
  final initDate;

  const AddEventDialog({Key key, this.initDate}) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  DateTime selectedDate;
  var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  double redValue = 0.0;
  double greenValue = 0.0;
  double blueValue = 0.0;
  DateTime start;
  DateTime end;
  String title = '';
  String note = '';
  CalenderBloc bloc ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedDate = widget.initDate;
    start=selectedDate;
    end=selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    bloc = CalenderBloc(loadingModel: Provider.of<LoadingModel>(context, listen: false));
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 600,
        child: Column(
          children: [
            Text('予定を登録'),
            Column(
              children: [
                _calenderArea(),
                Text("開始時刻"),
                Container(
                    color: Colors.transparent,
                    height: 50,
                    width: 300,
                    child: buildPicker(true)),
                Text("終了時刻"),
                Container(
                    color: Colors.white,
                    height: 50,
                    width: 300,
                    child: buildPicker(false)),
                Material(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Title'),
                    controller: titleController,
                    onChanged: (text) {
                      title = text;
                    },
                  ),
                ),
                Material(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'note'),
                    controller: noteController,
                    onChanged: (text) {
                      note = text;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      color: Color.fromARGB(255, redValue.toInt(),
                          greenValue.toInt(), blueValue.toInt()),
                    ),
                    Column(
                      children: [
                        CupertinoSlider(
                          min: 0,
                          max: 255,
                          onChanged: (double value) {
                            setState(() {
                              redValue = value;
                            });
                          },
                          value: redValue,
                        ),
                        CupertinoSlider(
                          min: 0,
                          max: 255,
                          onChanged: (double value) {
                            setState(() {
                              greenValue = value;
                            });
                          },
                          value: greenValue,
                        ),
                        CupertinoSlider(
                          min: 0,
                          max: 255,
                          onChanged: (double value) {
                            setState(() {
                              blueValue = value;
                            });
                          },
                          value: blueValue,
                        ),
                      ],
                    )
                  ],
                ),

                //Container(color:Colors.white,height:50,width:100,child: showPickerDateRange(context)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  child: Text("Delete"),
                  onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                  child: Text("OK"),
                  onPressed: ()  async {
                    await bloc.uploadEvent(CalenderModel(
                        uid: FirebaseAuth.instance.currentUser.uid,
                        targetDate: selectedDate,
                        startTime: start,
                        endTime: end,
                        color: EventColorModel(
                            red: redValue.toInt(),
                            green: greenValue.toInt(),
                            blue: blueValue.toInt()),
                        title: title,
                        note: note));
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
    /*return CupertinoAlertDialog(
      title: Text('予定を登録'),
      content: Container(
          width: 450,
          height: 550,
          child: Column(
            children: [
              _calenderArea(),
              Text("開始時刻"),
              Container(
                  color: Colors.transparent,
                  height: 50,
                  width: 300,
                  child: buildPicker()),
              Text("終了時刻"),
              Container(
                  color: Colors.white,
                  height: 50,
                  width: 300,
                  child: buildPicker()),
              Material(
                child: TextField(
                  decoration: InputDecoration(hintText: 'exsample@neco.com'),
                  controller: EventController,
                  onChanged: (text) {},
                ),
              ),
             Row(children: [
               Container(width:55,height:55,color: Color.fromARGB(255, redValue.toInt(), greenValue.toInt(), blueValue.toInt()),),
               Column(children: [
                 CupertinoSlider(
                   min: 0,
                   max: 255,
                   onChanged: (double value) {
                     setState(() {
                       redValue = value;
                     });
                   },
                   value: redValue,
                 ),
                 CupertinoSlider(
                   min: 0,
                   max: 255,
                   onChanged: (double value) {
                     setState(() {
                       greenValue = value;
                     });
                   },
                   value: greenValue,
                 ),
                 CupertinoSlider(
                   min: 0,
                   max: 255,
                   onChanged: (double value) {
                     setState(() {
                       blueValue = value;
                     });
                   },
                   value: blueValue,
                 ),
               ],)
             ],),
              RaisedButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/addeventpage')}),
              //Container(color:Colors.white,height:50,width:100,child: showPickerDateRange(context)),
            ],
          )),
      actions: [
        CupertinoDialogAction(
          child: Text("Delete"),
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("OK"),
          onPressed: () => {Navigator.pushNamed(context, '/addeventpage')},
        ),
      ],
    );*/
  }

  Widget _calenderArea() {
    return TextButton(
        onPressed: () async {
          var calenderSelectedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
          );

          // 選択がキャンセルされた場合はNULL
          if (calenderSelectedDate == null) return;

          // 選択されて日付で更新
          setState(() {
            selectedDate = calenderSelectedDate;
          });
        },
        child: Text(formatter.format(selectedDate)));
  }

  Widget buildPicker(bool isStart) {
    Picker picker = Picker(
        height: 50,
        itemExtent: 30,
        selecteds: isStart?[start.hour,start.minute]:[end.hour,end.minute],
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 23),
          NumberPickerColumn(begin: 0, end: 59),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 15.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onSelect: (picker, index, list) {
          if (isStart) {
            var dDay = DateTime.utc(selectedDate.year, selectedDate.month,
                selectedDate.day, picker.selecteds[0], picker.selecteds[1]);
            start = dDay;
          } else {
            var dDay = DateTime.utc(selectedDate.year, selectedDate.month,
                selectedDate.day, picker.selecteds[0], picker.selecteds[1]);
            end = dDay;
          }
          print(picker.selecteds);
        });

    return picker.makePicker();
  }

/*
  showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    Picker pe = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        }
    );

    List<Widget> actions = [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(PickerLocalizations.of(context).cancelText)),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
          },
          child: Text(PickerLocalizations.of(context).confirmText))
    ];


          return AlertDialog(
            title: Text("Select Date Range"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Begin:"),
                  ps.makePicker(),
                  Text("End:"),
                  pe.makePicker()
                ],
              ),
            ),
          );

  }*/

}
