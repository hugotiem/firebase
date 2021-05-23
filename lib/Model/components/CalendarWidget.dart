import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
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
