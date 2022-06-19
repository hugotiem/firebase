import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';

import 'package:pts/const.dart';
import 'package:pts/pages/search/search_page.dart';

class DatePage extends StatelessWidget {
  final void Function(BuildContext)? onNext;
  final void Function(BuildContext)? onPrevious;
  final DateTime? date;
  const DatePage({Key? key, this.onNext, this.onPrevious, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? _date = date;

    return BackgroundForm(
      heroTag: "date",
      onPrevious: () => onPrevious!(context),
      onPressedFAB: () {
        if (_date == null) return;
        BlocProvider.of<BuildPartiesCubit>(context).setDate(_date!);
        onNext!(context);
      },
      children: [
        HeaderText1Form(
          text: "Quand est-ce que la soirée aura-t-elle lieu ?",
          padding: EdgeInsets.only(left: 34, right: 34, top: 60, bottom: 20),
        ),
        CalendarWidget(
          selectedDay: date,
          onSelectedDay: (selected) => _date = selected,
          themeColor: ICONCOLOR,
          backgroundColor: Colors.white,
          shadow: true,
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 75)
      ],
    );
  }
}
