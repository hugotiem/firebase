import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// docs :
// https://github.com/SyncfusionExamples/appointments-to-firestore-database-flutter-calendar/blob/main/lib/main.dart

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  MeetingDataSource events;
  final databaseReference = FirebaseFirestore.instance;

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
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      monthViewSettings: MonthViewSettings(
        navigationDirection: MonthNavigationDirection.vertical,
        showAgenda: true,
        agendaViewHeight: MediaQuery.of(context).size.height * 0.2,
        agendaStyle: AgendaStyle(
          appointmentTextStyle: TextStyle(
            color: ICONCOLOR
          ),
        ), 
        agendaItemHeight: 50,
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
    );
  }
}
