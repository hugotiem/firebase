import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/View/Pages/creation/date_hour_page.dart';
import 'package:pts/View/Pages/creation/description_page.dart';
import 'package:pts/View/Pages/creation/end_page.dart';
import 'package:pts/View/Pages/creation/guestnumber_price_page.dart';
import 'package:pts/View/Pages/creation/location_page.dart';
import 'package:pts/View/Pages/creation/name_page.dart';
import 'package:pts/View/Pages/creation/theme_page.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';

class CreationPage extends StatefulWidget {
  CreationPage({Key key}) : super(key: key);

  @override
  _CreationPageState createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  void onNext() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuildPartiesCubit(),
      child: BlocBuilder<BuildPartiesCubit, BuildPartiesState>(
          builder: (context, state) {
        return PageView(
          controller: _controller,
          children: <Widget>[
            NamePage(onNext: onNext),
            ThemePage(onNext: onNext),
            DateHourPage(onNext: onNext),
            LocationPage(onNext: onNext),
            GuestNumber(onNext: onNext),
            DescriptionPage(onNext: onNext),
            EndPage(),
          ],
        );
      }),
    );
  }
}
