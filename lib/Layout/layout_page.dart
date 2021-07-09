import 'package:charts2_app/bloc/calender_bloc.dart';
import 'package:charts2_app/bloc/data_bloc.dart';
import 'package:charts2_app/model/firebase_data_model/record_data_model.dart';
import 'package:charts2_app/model/task_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts2_app/screen/third_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts2_app/calender/calender_page.dart';

class LayoutPage extends StatefulWidget {
  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _selectedIndex = 0;
  final DataBloc bloc = DataBloc();

  DateTime selectedDate;
  DateTime selectedMonth;
  //CalenderBloc bloc;

  String userName = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedMonth = DateTime.now();
    //_handleNewDate(DateTime(
      //  DateTime.now().year, DateTime.now().month, DateTime.now().day));
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.getRecord());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page'),
        centerTitle: true,
      ),
      body: PageView(
        children: [
          _buildPi(context),
          //_buildBody(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Setting'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPi(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: bloc.streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.hasError)
          return Container(
            child: Text("error!!"),
          );
        return _buildListPi(context, snapshot.data);
      },
    );
  }

  Widget _buildListPi(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    final recordListData = ListRecord.fromSnapshot(snapshot);
    var piedata = [
      new Task(recordListData.listData[0].name,
          recordListData.listData[0].votes.toDouble(), Color(0xff3366cc)),
      new Task(recordListData.listData[1].name,
          recordListData.listData[1].votes.toDouble(), Color(0xff990099)),
      new Task(recordListData.listData[2].name,
          recordListData.listData[2].votes.toDouble(), Color(0xff109618)),
    ];

    List<charts.Series<Task, String>> _seriesPieData = [
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    ];

    return Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: BorderSide(width: 5.0, color: Colors.grey),
        ),
      ),
      child: charts.PieChart(
        _seriesPieData,
        animate: true,
        animationDuration: Duration(milliseconds: 500),
        behaviors: [
          new charts.DatumLegend(
            outsideJustification: charts.OutsideJustification.endDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 2,
            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            entryTextStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.purple.shadeDefault,
                fontFamily: 'Georgia',
                fontSize: 11),
          ),
        ],
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 100,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside)
            ]),
      ),
    );
  }




}
