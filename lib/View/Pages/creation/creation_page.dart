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
  CreationPage({Key? key}) : super(key: key);

  @override
  _CreationPageState createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  PageController? _controller;

  late List<Widget> _children;

  @override
  void initState() {
    _controller = PageController();
    _children = [
      NamePage(onNext: onNext),
      ThemePage(onNext: onNext, onPrevious: onPrevious),
      DateHourPage(onNext: onNext, onPrevious: onPrevious),
      LocationPage(onNext: onNext, onPrevious: onPrevious),
      GuestNumber(onNext: onNext, onPrevious: onPrevious),
      DescriptionPage(onNext: onNext, onPrevious: onPrevious),
      EndPage(),
    ];
    super.initState();
  }

  void onNext() {
    _controller!.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  void onPrevious() {
    _controller!.previousPage(
      duration: const Duration(milliseconds:  200), 
      curve: Curves.easeIn
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuildPartiesCubit(),
      child: BlocListener<BuildPartiesCubit, BuildPartiesState>(
        listener: (BuildContext context, state) {
          if (state.status == BuildPartiesStatus.loaded) {
            _controller!.animateToPage(
              _children.length - 1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          }
        },
        child: BlocBuilder<BuildPartiesCubit, BuildPartiesState>(
            builder: (context, state) {
          return PageView(
            controller: _controller,
            children: _children,
            physics: NeverScrollableScrollPhysics(),
          );
        }),
      ),
    );
  }
}
