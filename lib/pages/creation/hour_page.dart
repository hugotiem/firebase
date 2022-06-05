import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/app_datetime.dart';
import 'package:pts/components/circular_slider/double_slider_paint.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';

class HourPage extends StatefulWidget {
  final void Function(BuildContext)? onNext;
  final void Function(BuildContext)? onPrevious;
  final Party? party;
  const HourPage({Key? key, this.onNext, this.onPrevious, this.party})
      : super(key: key);

  @override
  State<HourPage> createState() => _HourPageState();
}

class _HourPageState extends State<HourPage> {
  int _initTime = 0;
  int _endTime = 50;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.85;
    return BackgroundForm(
      isScrollable: false,
      heroTag: "hour",
      onPrevious: () => widget.onPrevious!(context),
      onPressedFAB: () {
        late DateTime? date = widget.party?.date;
        DateTime heureDebut = AppDateTime.from(date).copyWith(
            hour: _formatTime(_initTime)[0], minute: _formatTime(_initTime)[1]);
        DateTime heureFin = AppDateTime.from(date).copyWith(
            hour: _formatTime(_endTime)[0], minute: _formatTime(_endTime)[1]);
        DateTime dateDebut = DateTime(date!.year, date.month, date.day,
            heureDebut.hour, heureDebut.minute);
        DateTime dateFin = DateTime(
            date.year, date.month, date.day, heureFin.hour, heureFin.minute);
        if (dateFin.isBefore(dateDebut)) {
          dateFin = dateFin.add(Duration(days: 1));
        }
        BlocProvider.of<BuildPartiesCubit>(context)
          ..setStartTime(dateDebut, dateFin);
        widget.onNext!(context);
      },
      children: [
        HeaderText1Form(
          text: "Horaires",
          padding: EdgeInsets.only(left: 34, right: 34, top: 60, bottom: 20),
        ),
        Center(
          child: DoubleCircularSlider(
            288,
            _initTime,
            _endTime,
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
                _initTime = init;
                _endTime = end;
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
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitHeight,
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
                    text(
                        "${intToDate(_formatTime(_initTime)[0])} : ${intToDate(_formatTime(_initTime)[1])}"),
                    Icon(
                      Ionicons.caret_down,
                      color: ICONCOLOR,
                      size: 40,
                    ),
                    text(
                        "${intToDate(_formatTime(_endTime)[0])} : ${intToDate(_formatTime(_endTime)[1])}"),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
        )
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

  List<int> _formatTime(int? time) {
    final List<int> listTime = [];
    if (time == 0 || time == null) {
      return [0, 0];
    }

    listTime.addAll([time ~/ 12, (time % 12) * 5]);

    if (listTime[0] == 24 && listTime[1] == 24) return [0, 0];

    return [listTime[0], listTime[1]];
  }

  String intToDate(int value) {
    String time = value.toString();
    if (value < 10) return "0$time";
    return time;
  }
}
