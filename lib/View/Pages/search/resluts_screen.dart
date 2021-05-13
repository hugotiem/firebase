import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _value = 0;
  double _factor = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _controller.forward();

    _controller.addListener(() {
      setState(() {
        _value = _controller.value;
        _factor = _value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SlidingUpPanel(
      minHeight:
          (_size.height / 2) + ((1 - _value) * ((_size.height / 2) - 150)),
      maxHeight: _size.height - 150,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(36 * _factor),
        topRight: Radius.circular(36 * _factor),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          blurRadius: 8.0 * _factor,
          color: Color.fromRGBO(0, 0, 0, 0.25),
        ),
      ],
      collapsed: Container(
        color: Colors.transparent,
      ),
      panelBuilder: (ScrollController sc) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36 * _factor),
            topRight: Radius.circular(36 * _factor),
          ),
          color: PRIMARY_COLOR,
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(20),
              color: Colors.red,
            );
          },
        ),
      ),
      onPanelSlide: (position) {
        setState(() {
          _factor = 1 - position;
        });
      },
    );
  }
}
