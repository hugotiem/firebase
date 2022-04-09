import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/components/app_datetime.dart';
import 'package:pts/const.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? currentDay;
  final DateTime? focusedDay;
  final void Function(DateTime) onClose;
  final String? titleButton;
  const CalendarScreen(
      {Key? key, this.currentDay, this.focusedDay, required this.onClose, this.titleButton})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late AppDateTime _currentDay;
  late AppDateTime _focusedDay;

  @override
  void initState() {
    _currentDay = AppDateTime.from(widget.currentDay).yMd();
    _focusedDay = AppDateTime.from(widget.focusedDay).yMd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Container(
            child: IconButton(
          icon: Transform.rotate(
            angle: -90 * pi / 180,
            child: Container(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: SECONDARY_COLOR,
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month),
            focusedDay: _focusedDay,
            currentDay: _currentDay,
            locale: 'fr',
            startingDayOfWeek: StartingDayOfWeek.monday,
            lastDay:
                DateTime.utc(DateTime.now().year + 1, DateTime.now().month),
            availableCalendarFormats: {CalendarFormat.month: 'Month'},
            selectedDayPredicate: (DateTime day) {
              return isSameDay(_currentDay, day);
            },
            enabledDayPredicate: (day) {
              if (day.isAfter(DateTime.now()) ||
                  isSameDay(DateTime.now(), day)) {
                return true;
              }
              return false;
            },
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              setState(() {
                _currentDay = AppDateTime.from(selectedDay).yMd();
                _focusedDay = AppDateTime.from(focusedDay).yMd();
              });
            },
          ),
          TextButton(
            onPressed: widget.currentDay != _currentDay
                ? () {
                    widget.onClose(_currentDay);
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(widget.titleButton ?? "Rechercher"),
          ),
        ],
      ),
    );
  }
}
