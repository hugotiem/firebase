import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/pages/creation/date_hour_page.dart';
import 'package:pts/pages/creation/description_page.dart';
import 'package:pts/pages/creation/end_page.dart';
import 'package:pts/pages/creation/guestnumber_price_page.dart';
import 'package:pts/pages/creation/location_page.dart';
import 'package:pts/pages/creation/name_page.dart';
import 'package:pts/pages/creation/theme_page.dart';
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
      KeepPageAlive(child: NamePage(onNext: onNext)),
      KeepPageAlive(child: ThemePage(onNext: onNext, onPrevious: onPrevious)),
      KeepPageAlive(child: DateHourPage(onNext: onNext, onPrevious: onPrevious)),
      KeepPageAlive(child: LocationPage(onNext: onNext, onPrevious: onPrevious)),
      KeepPageAlive(child: GuestNumber(onNext: onNext, onPrevious: onPrevious)),
      KeepPageAlive(child: DescriptionPage(onNext: onNext, onPrevious: onPrevious)),
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
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
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

class KeepPageAlive extends StatefulWidget {
  final Widget? child;
  KeepPageAlive({Key? key, this.child}) : super(key: key);

  @override
  _KeepPageAliveState createState() => _KeepPageAliveState();
}

class _KeepPageAliveState extends State<KeepPageAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child ?? Container();
  }

  @override
  bool get wantKeepAlive => true;
}
