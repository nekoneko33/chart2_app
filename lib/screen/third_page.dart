import 'package:charts2_app/bloc/data_bloc.dart';
import 'package:charts2_app/model/firebase_data_model/record_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts2_app/model/task_data_model.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final DataBloc bloc = DataBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.getRecord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(30),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                //Text('円グラフ'),
                //SizedBox(
                 // height: 10,
               // ),
                Expanded(
                  child: _buildPi(context),
                ),
              ],
            ),
          ),
        ),
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
