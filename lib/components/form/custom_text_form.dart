import 'package:flutter/material.dart';

import 'package:pts/const.dart';

class HeaderText1 extends StatelessWidget {
  final String text;
  const HeaderText1({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.only(top: 30, bottom: 40),
        child: Text(
          this.text,
          style: TextStyle(
              wordSpacing: 1.5,
              fontSize: 25,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class HeaderText2 extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  const HeaderText2({
    required this.text,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: padding == null ? EdgeInsets.only(bottom: 20) : this.padding,
        child: Text(
          this.text,
          style: TextStyle(
              wordSpacing: 1.5,
              fontSize: 22,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class HintText extends StatelessWidget {
  final String text;
  const HintText({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Container(
        child: Opacity(
          opacity: 0.7,
          child: Text(
            this.text,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class HeaderText1Form extends StatelessWidget {
  final String text;
  const HeaderText1Form({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 60),
      child: Text(
        this.text,
        style: TextStyle(
          wordSpacing: 1.5,
          fontSize: 38,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class HeaderText2Form extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  const HeaderText2Form(
    this.text, {
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 23, left: 32),
      child: Text(
        this.text,
        style: TextStyle(
          fontSize: 22,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
