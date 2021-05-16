import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/PickerLocalizations.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  void initState() {
    super.initState();
  }
  String stateText = "";

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('時間設定'),
        ),
        body: Column(
            children: [showPickerDateRange(context),
            Container(color: Colors.red),
            ]
    ));

  }

  Widget showPickerDateRange(BuildContext context) {
    //print("canceltext: ${PickerLocalizations.of(context).cancelText}");


    /*Picker ps = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        });
*/
    Picker ps =Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 24,initValue: DateTime.now().hour),
          NumberPickerColumn(begin: 0, end: 59,initValue: DateTime.now().minute),

        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
    );

    Picker pe =Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 24,initValue: DateTime.now().hour),
          NumberPickerColumn(begin: 0, end: 59,initValue: DateTime.now().minute),

        ]),
        delimiter: [
          PickerDelimiter(child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
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
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: 0,
              end: 999,
              postfix: Text("\$"),
              suffix: Icon(Icons.insert_emoticon)),
          NumberPickerColumn(begin: 200, end: 100, jump: -10),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }).showDialog(context);
  }

  showPickerDateTimeRoundBg(BuildContext context) {
    var picker = Picker(
        backgroundColor: Colors.transparent,
        headerDecoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))
        ),
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kMDYHM,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日"
        ),
        delimiter: [
          PickerDelimiter(column: 3, child: Container(
            width: 8.0,
            alignment: Alignment.center,
          )),
          PickerDelimiter(column: 5, child: Container(
            width: 12.0,
            alignment: Alignment.center,
            child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
            color: Colors.white,
          )),
        ],
        title: Text("Select DateTime"),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text);
        },
        onSelect: (Picker picker, int index, List<int> selecteds) {
          this.setState(() {
            stateText = picker.adapter.toString();
          });
        }
    );

    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) {
      return Material(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            child: picker.makePicker(null, true),
          )
      );
    });
  }




}
