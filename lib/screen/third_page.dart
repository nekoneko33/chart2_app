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
      appBar: AppBar(
        title: Text('ThirdPage'),
        centerTitle: true,
      ),
      body: Padding(padding: EdgeInsets.all(30),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('円グラフ'),
                SizedBox(height: 10,),
                _buildPi(context),

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
        if (snapshot.hasError) return Container(child: Text("error!!"),);
        return _buildListPi(context, snapshot.data);
      },
    );
  }

  Widget _buildListPi(BuildContext context,QueryDocumentSnapshot snapshot) {
    final record = Record.fromSnapshot(snapshot, reference: snapshot.reference);
    List<charts.Series<Task, String>> _seriesPieData;

    return Container(
        decoration: new BoxDecoration(
        border: new Border(bottom: BorderSide(width: 5.0, color: Colors.grey))
    ),
    child: charts.PieChart(_seriesPieData,
    animate: true,
    animationDuration: Duration(seconds: 5),
    behaviors: [
    new charts.DatumLegend(
    outsideJustification:
    charts.OutsideJustification.endDrawArea,
    horizontalFirst: false,
    desiredMaxRows: 2,
    cellPadding: new EdgeInsets.only(
    right: 4.0, bottom: 4.0),
    entryTextStyle: charts.TextStyleSpec(
    color: charts
        .MaterialPalette.purple.shadeDefault,
    fontFamily: 'Georgia',
    fontSize: 11),
    )
    ],
    defaultRenderer: new charts.ArcRendererConfig(
    arcWidth: 100,
    arcRendererDecorators: [
    new charts.ArcLabelDecorator(
    labelPosition:
    charts.ArcLabelPosition.inside)
    ]
    )
    )
    ,
  }

}