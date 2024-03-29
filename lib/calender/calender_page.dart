import 'package:charts2_app/bloc/calender_bloc.dart';
import 'package:charts2_app/calender/calender_model.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:provider/provider.dart';

import 'add_event_dialog.dart';

class CalenderPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Calendar Demo',
      home: CalenderScreen(),
    );
  }
}

class CalenderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalenderScreenState();
  }
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime selectedDate;
  DateTime selectedMonth;
  CalenderBloc bloc;

  String userName = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    selectedDate = DateTime.now();
    selectedMonth = DateTime.now();
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => bloc.getRecord(userName, selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    if(bloc==null)
    bloc = CalenderBloc(
        loadingModel: Provider.of<LoadingModel>(context, listen: false));

    return Scaffold(
      body: SafeArea(
        child: _buildBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (con) {
                return AddEventDialog (
                  context2: context,
                  initDate: selectedDate,
                  username: userName,
                  isUpdate: false,
                );
              });
          bloc.getRecord(userName, selectedDate);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleNewDate(date) {
    selectedDate = date;
    print('Date selected: $date');
  }

  void _handleNewMonth(DateTime date) {
    selectedDate = date;

    if ((date.year == selectedMonth.year &&
            date.month != selectedMonth.month) ||
        (date.year != selectedMonth.year)) {
      selectedMonth = date;
      bloc.getRecord(userName, selectedMonth);
      print('Date selected: $date');
    }
  }

  void _eventChange(event)async {
    await showDialog(
        context: context,
        builder: (con) {
          return AddEventDialog (
            context2: context,
            initDate: selectedDate,
            username: userName,
            isUpdate: true,
            eventData: event,

          );
        });
    bloc.getRecord(userName, selectedDate);
}


  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: bloc.streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Container(
            child: Text("error!!"),
          );
        if (!snapshot.hasData) return Container();

        //final scheduleList=CalenderModel.fromSnapshot(snapshot.data.first);
        final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};
        snapshot.data.forEach((e) {
          final scheduleList = CalenderModel.fromSnapshot(e,reference:e.reference);
          if (_events.containsKey(DateTime(scheduleList.targetDate.year,
              scheduleList.targetDate.month, scheduleList.targetDate.day))) {
            _events[DateTime(scheduleList.targetDate.year,
                    scheduleList.targetDate.month, scheduleList.targetDate.day)]
                .add(NeatCleanCalendarEvent(
              scheduleList.title,
              startTime: scheduleList.startTime,
              endTime: scheduleList.endTime,
              description: scheduleList.note,
              color: Color.fromARGB(255, scheduleList.color.red,
                  scheduleList.color.green, scheduleList.color.blue),
              reference: e.reference,
            ));
          } else
            _events[DateTime(scheduleList.targetDate.year,
                scheduleList.targetDate.month, scheduleList.targetDate.day)] = [
              NeatCleanCalendarEvent(
                scheduleList.title,
                startTime: scheduleList.startTime,
                endTime: scheduleList.endTime,
                description: scheduleList.note,
                color: Color.fromARGB(255, scheduleList.color.red,
                    scheduleList.color.green, scheduleList.color.blue),
                reference: e.reference,
              )
            ];
        });

        return Calendar(
          startOnMonday: true,
          weekDays: ['月', '火', '水', '木', '金', '土', '日'],
          events: _events,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          todayColor: Colors.blue,
          eventColor: Colors.grey,
          locale: 'ja_JP',
          todayButtonText: '',
          isExpanded: true,
          expandableDateFormat: 'yyyy年　MM月　dd日　EEEE',
          dayOfWeekStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          onDateSelected: _handleNewDate,
          onMonthChanged: _handleNewMonth,
          onEventSelected: _eventChange,
        );
      },
    );
  }
}
