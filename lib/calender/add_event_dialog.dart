import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/PickerLocalizations.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class AddEventDialog extends StatefulWidget{
  final initDate;

  const AddEventDialog({Key key, this.initDate}) : super(key: key);
  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  DateTime selectedDate;
  var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
    selectedDate=widget.initDate;

  }
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('予定を登録'),
      content: Container(
          width: 450,
          height: 550,
          child: Column(
            children: [

              _calenderArea(),
              Text("開始時刻"),
              Container(color:Colors.white,height:50,width:100,child: buildPicker()),
              Text("終了時刻"),
              Container(color:Colors.white,height:50,width:100,child: buildPicker()),
              RaisedButton(onPressed: () => { Navigator.pushNamed(context, '/addeventpage')}),
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
          onPressed: () => { Navigator.pushNamed(context, '/addeventpage')},
        ),
      ],
    );

  }

  Widget _calenderArea(){
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


  Widget buildPicker(){
    Picker picker=Picker(
      height: 50,
      itemExtent: 30,
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 23),
          NumberPickerColumn(begin: 0, end: 59),
        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 15.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),

    );



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