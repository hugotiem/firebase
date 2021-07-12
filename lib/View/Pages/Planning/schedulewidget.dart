import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// docs :
// https://github.com/SyncfusionExamples/appointments-to-firestore-database-flutter-calendar/blob/main/lib/main.dart

class ScheduleWidget extends StatefulWidget {
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
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
      dataSource: events,
      cellBorderColor: PRIMARY_COLOR,
      view: CalendarView.schedule,
      initialSelectedDate: DateTime.now(),
      onSelectionChanged: (details) {

      },
      todayHighlightColor: SECONDARY_COLOR,
    );
  }
}
