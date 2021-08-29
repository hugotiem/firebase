import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  Meeting getEvent(int index) => appointments[index] as Meeting;

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});

  factory Meeting.fromSnapShot(
          QueryDocumentSnapshot<Map<String, dynamic>> data, Color color) =>
      Meeting(
        eventName: data.data()['name'],
        from: data.data()['startTime'].toDate(),
        to: data.data()['endTime'].toDate(),
        background: color,
        isAllDay: false,
      );
}
