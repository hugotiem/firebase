import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/circular_slider/double_slider_paint.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';

class HourPage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;
  final Party? party;
  const HourPage({Key? key, this.onNext, this.onPrevious, this.party})
      : super(key: key);

  @override
  State<HourPage> createState() => _HourPageState();
}

class _HourPageState extends State<HourPage> {
  int initTime = 0;
  int endTime = 50;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.85;
    return BackgroundForm(
      heroTag: " hour",
      onPrevious: () => widget.onPrevious!(),
      onPressedFAB: () {
        late DateTime? date = widget.party?.date;
        print(date);
        DateTime heureDebut = DateFormat('h : m').parse(_formatTime(initTime));
        DateTime heureFin = DateFormat('h : m').parse(_formatTime(endTime));
        print(heureDebut);
        print(heureFin);
        // DateTime dateDebut = DateTime(date!.year, date.month, date.day, heureDebut.hour, heureDebut.minute);
        // DateTime dateFin = DateTime(date.year, date.month, date.day, heureFin.hour, heureFin.minute);
        // print(dateDebut);
        // print(dateFin);
        // widget.onNext!();
      },
      children: [
        HeaderText1Form(
          text: "Horaires",
          padding: EdgeInsets.only(left: 34, right: 34, top: 60, bottom: 20),
        ),
        Center(
          child: DoubleCircularSlider(
            288,
            initTime,
            endTime,
            width: size,
            height: size,
            baseColor: Colors.grey.withOpacity(0.2),
            handlerColor: PRIMARY_COLOR,
            selectionColor: ICONCOLOR,
            showHandlerOutter: true,
            sliderStrokeWidth: 45,
            handlerOutterRadius: 10,
            onSelectionChange: (init, end, laps) {
              setState(() {
                initTime = init;
                endTime = end;
              });
            },
            child: Container(
              margin: EdgeInsets.all(55),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PRIMARY_COLOR,
                image: DecorationImage(
                  image: AssetImage("assets/clock.png"),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: ICONCOLOR, width: 3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                text(_formatTime(initTime)),
                Icon(
                  Ionicons.caret_down,
                  color: ICONCOLOR,
                  size: 40,
                ),
                text(_formatTime(endTime)),
              ],
            ),
          ),
        ),
        SizedBox(height: 100)
      ],
    );
  }

  Widget text(String str) {
    return Text(
      str,
      style: TextStyle(
        color: SECONDARY_COLOR,
        fontWeight: FontWeight.w900,
        fontSize: 50,
      ),
    );
  }

  String _formatTime(int? time) {
    late String hoursstr;
    late String minutesstr;
    if (time == 0 || time == null) return '00 : 00';

    int hours = time ~/ 12;
    int minutes = (time % 12) * 5;

    if (hours == 24) return "00 : 00";

    hoursstr = hours.toString();
    minutesstr = minutes.toString();

    if (hours < 10) hoursstr = "0" + hours.toString();
    if (minutes < 10) minutesstr = "0" + minutes.toString();
    return "$hoursstr : $minutesstr";
  }
}
