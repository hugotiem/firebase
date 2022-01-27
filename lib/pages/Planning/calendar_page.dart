import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/horizontal_separator.dart';
import 'package:pts/components/showModalBottomSheet.dart';
import 'package:pts/const.dart';
import 'package:pts/models/calendar_data_source.dart';
import 'package:pts/blocs/calendar/calendar_cubit.dart';
import 'package:pts/pages/Planning/subpage/list_user_party_page.dart';
import 'package:pts/pages/Planning/subpage/waitlist_guest_page.dart';
import 'package:pts/pages/Planning/subpage/waitlist_party_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> manageParty() {
      return customShowModalBottomSheet(
        context,
        [
          titleText("Gère tes soirées :"),
          onTapContainer(context, "Mes soirées", MyParty()),
          onTapContainer(
            context,
            "Mes demandes pour rejoindre des soirées",
            PartyWaitList(),
          ),
          onTapContainer(
            context,
            "Les demandes pour rejoindre ma soirée",
            GuestWaitList(),
          ),
        ],
      );
    }

    return Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
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
                onTap: () => manageParty(),
                child: Icon(
                  Ionicons.calendar_clear_outline,
                  color: ICONCOLOR,
                ),
              ),
            )
          ],
        ),
        body: CalendarWidget());
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
  MeetingDataSource? events;
  final databaseReference = FirebaseFirestore.instance;
  List<Meeting> _appointmentDetails = <Meeting>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    // list.insertAll(list.length - 1, list1);

    // setState(() {
    //   events = MeetingDataSource(list);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit()..loadData(),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          if (state.status != CalendarStatus.dataLoaded) {
            return Center(child: CircularProgressIndicator());
          }
          events = MeetingDataSource(
              state.organisedParties! + state.invitedParties!);
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: SfCalendar(
                      headerStyle: CalendarHeaderStyle(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: PRIMARY_COLOR,
                      onTap: calendarTapped,
                      monthViewSettings: MonthViewSettings(
                        navigationDirection: MonthNavigationDirection.vertical,
                        monthCellStyle: MonthCellStyle(
                          textStyle: TextStyle(
                            color: SECONDARY_COLOR,
                          ),
                        ),
                      ),
                      dataSource: events,
                      cellBorderColor: PRIMARY_COLOR,
                      view: CalendarView.month,
                      initialSelectedDate: DateTime.now(),
                      todayHighlightColor: SECONDARY_COLOR,
                      selectionDecoration: BoxDecoration(
                        border: Border.all(color: SECONDARY_COLOR, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ),
                HorzontalSeparator(),
                if (_appointmentDetails.length >= 1)
                  (Expanded(
                    child: Container(
                      color: PRIMARY_COLOR,
                      child: ListView.separated(
                        itemCount: _appointmentDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          Color? textColor;

                          if (_appointmentDetails[index].background ==
                              SECONDARY_COLOR) {
                            textColor = PRIMARY_COLOR;
                          } else if (_appointmentDetails[index].background ==
                              ICONCOLOR) {
                            textColor = SECONDARY_COLOR;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, right: 22),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        OpacityText(
                                          data:
                                              '${DateFormat.E('fr_FR').format(_appointmentDetails[index].from!)}',
                                          color: SECONDARY_COLOR,
                                        ),
                                        FontText(
                                          data:
                                              '${DateFormat.d('fr_FR').format(_appointmentDetails[index].from!)}',
                                          fontSize: 20,
                                          color: SECONDARY_COLOR,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: _appointmentDetails[index]
                                              .background,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FontText(
                                              data: _appointmentDetails[index]
                                                  .eventName,
                                              color: textColor,
                                              fontSize: 16.5,
                                            ),
                                            SizedBox(height: 2),
                                            OpacityText(
                                              data:
                                                  'De ${DateFormat.Hm('fr_FR').format(_appointmentDetails[index].from!)} à ${DateFormat.Hm('fr_FR').format(_appointmentDetails[index].to!)}',
                                              color: textColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                          height: 0,
                        ),
                      ),
                    ),
                  ))
                else
                  (Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          child: CText(
                            "Rien de prévu pour le moment",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          );
        },
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails = calendarTapDetails.appointments!.cast<Meeting>();
      });
    }
  }
}

class FontText extends StatelessWidget {
  final String? data;
  final double? fontSize;
  final Color? color;

  const FontText({this.data, this.color, this.fontSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.data!,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: this.fontSize,
          color: this.color),
    );
  }
}

class OpacityText extends StatelessWidget {
  final String? data;
  final Color? color;

  const OpacityText({this.data, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Text(
        this.data!,
        style: TextStyle(color: this.color),
      ),
    );
  }
}
