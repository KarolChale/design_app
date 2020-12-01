import 'package:flutter/material.dart';
import 'package:design_app/src/widgets/calendar/horizontal_calendar.dart';
import 'package:design_app/src/models/task_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:design_app/src/widgets/sliding_up_panel_widget.dart';
import 'package:design_app/src/widgets/menu_options.dart';
import 'package:design_app/src/widgets/container_slidable/slidable.dart';
import 'package:design_app/src/widgets/container_slidable/slide_action.dart';
import 'package:design_app/src/widgets/container_slidable/slidable_action_pane.dart';
import 'dart:async';

class Todo extends StatefulWidget {
  Todo({Key key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<Tasks> tasksMarked = [
    (Tasks("2020-12-05", "08:00 PM", "Buy pizza", null)),
    (Tasks("2020-12-05", "10:00 PM", "Clean the dishes", null)),
    (Tasks("2020-12-02", "12:35 PM", "Fix computer", null)),
    (Tasks("2020-12-01", "03:30 PM", "Deliver Flutter App", null)),
  ];

  final iconList = <IconData>[
    Icons.arrow_back_rounded,
    Icons.dehaze_rounded,
  ];

  List<Tasks> _selectedDayTasks;
  String dateSelected;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    dateSelected = DateTime.now().toString().substring(0, 10);
    _selectedDayTasks = tasksMarked.where((i) => i.dateTask.contains(dateSelected)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Color(0xff473E43),
              //color: Colors.red,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: HorizontalCalendar(
                lastDate: DateTime.now().add(Duration(days: 14)),
                date: DateTime.now(),
                textColor: Color(0xff68463E),
                backgroundColor: Colors.white,
                selectedColor: Color(0xff15040D),
                //onDateSelected: (date) => print(date.toString()),
                onDateSelected: (date) {
                  setState(() {
                    dateSelected = date.toString();
                    _selectedDayTasks = tasksMarked.where((i) => i.dateTask.contains(dateSelected)).toList();
                    _selectedDayTasks.forEach((element) {
                      //print(element.descTask);
                    });
                  });
                  //print("onDateSelected: " + date.toString());
                  return dateSelected;
                },
              ),
            ),
          ),
          w_SelectedDateTasks(dateSelected),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add, size: 40.0),
          backgroundColor: Color(0xffF16E45),
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          backgroundColor: Color(0xff2D2529),
          inactiveColor: Color(0xff6C6669),
          activeColor: Colors.white,
          leftCornerRadius: 25,
          rightCornerRadius: 25,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              Timer(Duration(seconds: 1), () {
                if (index == 1) {
                  panelController.anchor();
                } else {
                  Navigator.pop(context);
                }
              });
            });
          },
          //onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
      ),
      SlidingUpPanelWidget(
        child: w_MenuOptions(),
        controlHeight: 0.0,
        anchor: 0.4,
        panelStatus: SlidingUpPanelStatus.hidden,
        panelController: panelController,
        enableOnTap: false,
      )
    ]);
  }

  Widget w_SelectedDateTasks(String date) {
    //print("Widget: " + date);
    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          //Text("Selected day: '" + date + "'"),
          //Text(tasksMarked.where((w) => w.dateTask.contains(date)).join(" ")),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: getTextWidgets(_selectedDayTasks),
          ),
        ]),
      ),
    );
  }

  Widget getTextWidgets(List<Tasks> strings) {
    Path customPath = Path()
      ..moveTo(3, 63)
      ..lineTo(370, 63);

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var item in strings)
          Slidable(
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.15,
            child: DottedBorder(
              customPath: (size) => customPath,
              color: Color(0xff993030),
              dashPattern: [8, 4],
              strokeWidth: 2,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(width: 15.0, color: Color(0xffEE6B42)),
                    SizedBox(width: 10.0),
                    Text(item.descTask, style: TextStyle(fontSize: 15, fontFamily: "Calibri")),
                    Spacer(),
                    Text(item.timeTask, style: TextStyle(fontSize: 12, fontFamily: "Calibri")),
                    SizedBox(width: 15.0),
                  ],
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                height: 60.0,
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                foregroundColor: Colors.green,
                color: Colors.transparent,
                icon: Icons.check_circle,
                //onTap: () => _showSnackBar('Archive'),
              ),
              IconSlideAction(
                color: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.cancel,
                //onTap: () => _showSnackBar('Share'),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                color: Colors.transparent,
                foregroundColor: Colors.black45,
                icon: Icons.more_horiz,
                //onTap: () => _showSnackBar('More'),
              ),
              IconSlideAction(
                color: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                //onTap: () => _showSnackBar('Delete'),
              ),
            ],
          ),
      ],
    );
  }
}
