import 'package:charts2_app/model/pollution_data_model.dart';
import 'package:charts2_app/model/sales_data_model.dart';
import 'package:charts2_app/model/task_data_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static var data1 = [
    new Pollution(1980, 'Math', 30),
    new Pollution(1980, 'English', 40),
    new Pollution(1980, 'Science', 10),
  ];
  static var data2 = [
    new Pollution(1985, 'Math', 80),
    new Pollution(1985, 'English', 60),
    new Pollution(1985, 'Science', 20),
  ];
  static var data3 = [
    new Pollution(1990, 'Math', 100),
    new Pollution(1990, 'English', 50),
    new Pollution(1990, 'Science', 80),
  ];

  static var piedata = [
    new Task('Study', 35.8, Color(0xff3366cc)),
    new Task('Eat', 8.3, Color(0xff990099)),
    new Task('Commute', 10.8, Color(0xff109618)),
    new Task('TV', 15.6, Color(0xfffdbe19)),
    new Task('Sleep', 19.2, Color(0xffff9900)),
    new Task('Other', 10.3, Color(0xffdc3912)),
  ];

  static var linesalesdata = [
    new Sales(0, 45),
    new Sales(1, 56),
    new Sales(2, 55),
    new Sales(3, 60),
    new Sales(4, 61),
    new Sales(5, 70),
  ];
  static var linesalesdata1 = [
    new Sales(0, 35),
    new Sales(1, 46),
    new Sales(2, 45),
    new Sales(3, 50),
    new Sales(4, 51),
    new Sales(5, 60),
  ];

  static var linesalesdata2 = [
    new Sales(0, 20),
    new Sales(1, 24),
    new Sales(2, 25),
    new Sales(3, 40),
    new Sales(4, 45),
    new Sales(5, 60),
  ];

  List<charts.Series<Pollution, String>> _seriesData = [
    charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: '2017',
      data: data1,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      fillColorFn: (Pollution pollution, _) =>
          charts.ColorUtil.fromDartColor(Color(0xff990099)),
    ),
    charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: '2018',
      data: data2,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      fillColorFn: (Pollution pollution, _) =>
          charts.ColorUtil.fromDartColor(Color(0xff109618)),
    ),
    charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: '2019',
      data: data3,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      fillColorFn: (Pollution pollution, _) =>
          charts.ColorUtil.fromDartColor(Color(0xffff9900)),
    ),
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

  List<charts.Series<Sales, int>> _seriesLineData = [
    charts.Series(
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
      id: 'Air Pollution',
      data: linesalesdata,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
    ),
    charts.Series(
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
      id: 'Air Pollution',
      data: linesalesdata1,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
    ),
    charts.Series(
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      id: 'Air Pollution',
      data: linesalesdata2,
      domainFn: (Sales sales, _) => sales.yearval,
      measureFn: (Sales sales, _) => sales.salesval,
    ),
  ];

  _generateData() {



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                Tab(icon: Icon(FontAwesomeIcons.ad)),
              ],
            ),
            title: Center(
              child: Text('Flutter Charts'),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'study level',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: false,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 5),
                          ),
                        ),
                        SizedBox(
                          height: 200.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Time spent on daily tasks',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
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
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sales for the first 5 years',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.LineChart(_seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.ChartTitle('Years',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Sales',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle(
                                  'Departments',
                                  behaviorPosition: charts.BehaviorPosition.end,
                                  titleOutsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Column(children: <Widget>[
                    Text(
                      'Sales for the first 5 years',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/next')},
                      child: Text('次のページへ'),
                    ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/third')},
                      child: Text('次のページへ'),
                    ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/signup')},
                      child: Text('新規登録'),
                    ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/login')},
                      child: Text('ログイン'),
                    ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/userpreference')},
                      child: Text('ログイン'),
                    ),
                  RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/calender')},
                      child: Text('カレンダー'),
                  ),
                    RaisedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/addeventpage')},
                      child: Text('カレンダー'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
