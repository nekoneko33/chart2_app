import 'package:charts2_app/bloc/calender_bloc.dart';
import 'package:charts2_app/bloc/data_bloc.dart';
import 'package:charts2_app/model/firebase_data_model/record_data_model.dart';
import 'package:charts2_app/model/task_data_model.dart';
import 'package:charts2_app/screen/forth_page.dart';
import 'package:charts2_app/screen/group_page.dart';
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

class _LayoutPageState extends State<LayoutPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final DataBloc bloc = DataBloc();

  DateTime selectedDate;
  DateTime selectedMonth;
  bool showMenu = false;

  final PageController _pageController = PageController();
  AnimationController _controller;
  Animation<double> _animation;

  //CalenderBloc bloc;

  String userName = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedMonth = DateTime.now();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _controller.addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.dismissed && showMenu)
        setState(() {
          showMenu = false;
        });
    });
    //_handleNewDate(DateTime(
    //  DateTime.now().year, DateTime.now().month, DateTime.now().day));
    WidgetsBinding.instance.addPostFrameCallback((_) => bloc.getRecord());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(_selectedIndex,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Page'),
            centerTitle: true,
            leading: MaterialButton(
              onPressed: () {
                setState(() {
                  showMenu = true;
                  _controller.forward();
                });
              },
              child: Icon(Icons.menu),
            ),
            actions: [
              _selectedIndex == 1
                  ? MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/groupserch');
                      },
                      child: Icon(Icons.add),
                    )
                  : Container(),
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
                },
                child: Icon(Icons.logout),
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  Container(height: 300, child: ThirdPage()),
                  Container(height: 500, child: CalenderPage()),
                ],
              )),

              GroupPage(),
              //_buildBody(context),
            ],
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.settings),
                title: Text('Setting'),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.settings),
                title: Text('Chat'),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        showMenu
            ? Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    SizeTransition(
                        sizeFactor: _animation,
                        axis: Axis.horizontal,
                        axisAlignment: -1,
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 50,
                          child: Center(
                            child: Text(
                                'Sampleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'),
                          ),
                        )),
                    Expanded(
                        //flex: 1,
                        child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _controller.reverse();
                          });
                        },
                      ),
                    ))
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
