import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/creation/name_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: PRIMARY_COLOR, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        title: Text(
          'Calendrier',
          style: TextStyle(
            color: SECONDARY_COLOR,
            ),
          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => NamePage())
                );
              },
              child: Icon(
                Icons.add,
                color: ICONCOLOR,
                size: 30, 
              ),
            ),
          )
        ],
      ),
      body: CalendarWidget()
    );
  }
}

// docs :
// connecter firebase firestore :
// https://github.com/SyncfusionExamples/appointments-to-firestore-database-flutter-calendar/blob/main/lib/main.dart
// custom agenda :
// https://github.com/SyncfusionExamples/custom-agenda-view-flutter-calendar/blob/master/lib/main.dart

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  MeetingDataSource events;
  final databaseReference = FirebaseFirestore.instance;
  List<Meeting> _appointmentDetails=<Meeting>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotValue = await databaseReference
        .collection("party")
        .where('UID', isEqualTo: AuthService.currentUser.uid)
        .get();
    
    List<Meeting> list = snapShotValue.docs
      .map((e) => Meeting(  
        eventName: e.data()['Name'],
        from: e.data()['StartTime'].toDate(),
        to: e.data()['EndTime'].toDate(),
        background: SECONDARY_COLOR,
        isAllDay: false ))
      .toList();
    setState(() {
      events = MeetingDataSource(list);
    });

    Map _uid = {
      'Name': AuthService.currentUser.displayName.split(' ')[0],
      'uid': AuthService.currentUser.uid
    };

    var snapShotValue1 = await databaseReference
        .collection("party")
        .where('validate guest list', arrayContains: _uid)
        .get();
    
    List<Meeting> list1 = snapShotValue1.docs
      .map((e) => Meeting(  
        eventName: e.data()['Name'],
        from: e.data()['StartTime'].toDate(),
        to: e.data()['EndTime'].toDate(),
        background: Colors.pink,
        isAllDay: false ))
      .toList();
    
    list.insertAll(list.length - 1, list1);
    
    setState(() {
      events = MeetingDataSource(list);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: SfCalendar(
              onTap: calendarTapped,
              monthViewSettings: MonthViewSettings(
                navigationDirection: MonthNavigationDirection.vertical
              ),
              dataSource: events,
              cellBorderColor: PRIMARY_COLOR,
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              todayHighlightColor: SECONDARY_COLOR,
              selectionDecoration: BoxDecoration(
                border: Border.all(
                  color: SECONDARY_COLOR,
                  width: 1.5
                )
              ),
            ),
          ),
          Expanded(  
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: _appointmentDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                OpacityText(
                                  data: '${DateFormat.E('fr_FR').format(_appointmentDetails[index].from)}',
                                  color: SECONDARY_COLOR
                                ),
                                FontText(
                                  data: '${DateFormat.d('fr_FR').format(_appointmentDetails[index].from)}',
                                  fontSize: 20,
                                  color: SECONDARY_COLOR,
                                )
                              ]
                            ),
                          )
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(  
                                color: SECONDARY_COLOR,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FontText(
                                      data: _appointmentDetails[index].eventName,
                                      color: ICONCOLOR,
                                      fontSize: 16.5
                                    ),
                                    SizedBox(
                                      height: 2
                                    ),
                                    OpacityText(
                                      data: 'De ${DateFormat.Hm('fr_FR').format(_appointmentDetails[index].from)} à ${DateFormat.Hm('fr_FR').format(_appointmentDetails[index].to)}',
                                      color: ICONCOLOR,
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  );
                }, 
                separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: 0,
                  )
              ),
            ),
          ),
        ]
      )
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails = calendarTapDetails.appointments.cast<Meeting>();
      });
    }
  }
}


class FontText extends StatelessWidget {
  final String data;
  final double fontSize;
  final Color color;

  const FontText({ 
    this.data,
    this.color,
    this.fontSize,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.data,
      style: TextStyle(  
        fontWeight: FontWeight.w500,
        fontSize: this.fontSize,
        color: this.color
      ),
    );
  }
}

class OpacityText extends StatelessWidget {
  final String data;
  final Color color;
  
  const OpacityText({ 
    this.data,
    this.color,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Text(
        this.data,
        style: TextStyle(  
          color: this.color
        ),
      ),
    );
  }
}