import 'package:flutter/material.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';

import 'package:pts/const.dart';
import 'package:pts/pages/search/search_form_page.dart';

class DatePage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const DatePage({Key? key, this.onNext, this.onPrevious}) : super(key: key);
  @override
  _DateHourPageState createState() => _DateHourPageState();
}

class _DateHourPageState extends State<DatePage> {
  late DateTime date;

  @override
  Widget build(BuildContext context) {
    return BackgroundForm(
      heroTag: "date",
      onPrevious: () => widget.onPrevious!(),
      onPressedFAB: () {
        widget.onNext!();
      },
      children: [
        HeaderText1Form(
          text: "Quand est-ce que la soirée aura-t-elle lieu ?",
          padding: EdgeInsets.only(left: 34, right: 34, top: 60, bottom: 20),
        ),
        CalendarWidget(
          onSelectedDay: (selected) => date = selected,
          themeColor: ICONCOLOR,
          backgroundColor: PRIMARY_COLOR,
          shadow: true,
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 75)
      ],
    );
    // return Scaffold(
    //   backgroundColor: FORMBACKGROUNDCOLOR,
    //   appBar: PreferredSize(
    //     preferredSize: Size.fromHeight(50),
    //     child: BackAppBar(
    //       onPressed: () {
    //         widget.onPrevious!();
    //       },
    //     ),
    //   ),
    //   floatingActionButton: FABForm(
    //     tag: 'date',
    //     onPressed: () {
    //       if (!_formKey.currentState!.validate()) {
    //         return;
    //       }

    //       var date = _date;

    //       DateTime datedebut = DateTime(date.year, date.month, date.day,
    //           _heuredebut.hour, _heuredebut.minute);
    //       DateTime datefin = DateTime(date.year, date.month, date.day,
    //           _heurefin.hour, _heurefin.minute);

    //       if (datefin.isBefore(datedebut)) {
    //         datefin = datefin.add(Duration(days: 1));
    //       }

    //       BlocProvider.of<BuildPartiesCubit>(context)
    //         ..addItem("date", _date)
    //         ..addItem("startTime", datedebut)
    //         ..addItem("endTime", datefin);

    //       widget.onNext!();

    //       // Soiree.setDataDateHourPage(_date, datedebut, datefin);
    //       // Navigator.push(
    //       //     context, MaterialPageRoute(builder: (context) => LocationPage()));
    //     },
    //   ),
    //   body: SingleChildScrollView(
    //     child: Form(
    //       key: _formKey,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           HeaderText1(text: "Quand est-ce que la soirée aura lieu ?"),
    //           TFFText(
    //             readOnly: true,
    //             controller: dateCtl,
    //             onTap: () {
    //               showModalBottomSheet(
    //                 context: context,
    //                 constraints: BoxConstraints(maxHeight: 600),
    //                 builder: (context) => CalendarScreen(
    //                   titleButton: "Valider",
    //                   // currentDay: _selectedDate,
    //                   // focusedDay: _selectedDate,
    //                   onClose: (date) {
    //                     setState(() {
    //                       dateCtl.text =
    //                           DateFormat.MMMMEEEEd('fr').format(date);
    //                       _date = date;
    //                     });
    //                   },
    //                 ),
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(10),
    //                     topRight: Radius.circular(10),
    //                   ),
    //                 ),
    //                 clipBehavior: Clip.antiAlias,
    //                 isScrollControlled: true,
    //               );
    //             },
    //             hintText: 'Choisir une date',
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return 'Tu dois rentrer une date';
    //               } else {
    //                 return null;
    //               }
    //             },
    //             maxLength: 20,
    //           ),
    //           HeaderText2(
    //             text: "Heure d'arrivée",
    //             padding: EdgeInsets.only(top: 40, bottom: 20),
    //           ),
    //           DateHourPicker(
    //             onTap: () async {
    //               FocusScope.of(context).requestFocus(new FocusNode());
    //               await _selectionHeureArrivee();
    //               heuredebutctl.text = 'De ${_heuredebut.format(context)} ';
    //             },
    //             hintText: 'Choisir une heure',
    //             controller: heuredebutctl,
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return "Vous devez choisir une heure d'arrivée";
    //               } else {
    //                 return null;
    //               }
    //             },
    //           ),
    //           HeaderText2(
    //             text: "Heure de départ",
    //             padding: EdgeInsets.only(top: 40, bottom: 20),
    //           ),
    //           DateHourPicker(
    //             onTap: () async {
    //               FocusScope.of(context).requestFocus(new FocusNode());
    //               await _selectionHeureDepart();
    //               heurefinctl.text = 'A ${_heurefin.format(context)} ';
    //             },
    //             hintText: 'Choisir une heure',
    //             controller: heurefinctl,
    //             validator: (value) {
    //               if (value == null || value.isEmpty) {
    //                 return "Vous devez choisir une heure de départ";
    //               } else {
    //                 return null;
    //               }
    //             },
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Future<Null> _selectionHeureArrivee() async {
  //   TimeOfDay? _heureChoisieArrivee = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //             data: ThemeData.light().copyWith(
  //               colorScheme: ColorScheme.light().copyWith(
  //                   primary: SECONDARY_COLOR, onPrimary: PRIMARY_COLOR),
  //             ),
  //             child: child!);
  //       });

  //   if (_heureChoisieArrivee != null && _heureChoisieArrivee != _heuredebut) {
  //     setState(() {
  //       _heuredebut = _heureChoisieArrivee;
  //     });
  //   }
  // }

  // Future<Null> _selectionHeureDepart() async {
  //   TimeOfDay? _heureChoisieDepart = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //             data: ThemeData.light().copyWith(
  //               colorScheme: ColorScheme.light().copyWith(
  //                   primary: SECONDARY_COLOR, onPrimary: PRIMARY_COLOR),
  //             ),
  //             child: child!);
  //       });

  //   if (_heureChoisieDepart != null && _heureChoisieDepart != _heurefin) {
  //     setState(() {
  //       _heurefin = _heureChoisieDepart;
  //     });
  //   }
  // }
}
