import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:pts/const.dart';

// containers with blue shadow

// Clickable container
class ClickableContainer extends StatelessWidget {
  final Widget? child;
  final Widget? to;
  final Color color;
  final Color focusColor;
  final bool containerShadow;
  final bool cupertino;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  ClickableContainer({
    Key? key,
    this.child,
    this.color = const Color(0xffffffff),
    this.focusColor = FOCUS_COLOR,
    this.cupertino = true,
    this.containerShadow = false,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(0),
    this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                to != null ? to! : new Container(color: Colors.white),
          ),
        ),
      },
      child: containerShadow
          ? PTSBox(
              color: color,
              padding: padding,
              child: child,
            )
          : AnimatedContainer(
              padding: padding,
              margin: margin,
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: color,
              ),
              child: child,
            ),
    );
  }
}

class PTSBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color color;

  const PTSBox({
    Key? key,
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.only(top: 40),
      padding: padding,
      duration: Duration(milliseconds: 100),
      child: child,
    );
  }
}

const kDemoText = Center(
  child: Text(
    'Child will be here.',
    style: TextStyle(
      fontSize: 25,
      color: Colors.white,
      letterSpacing: 2,
    ),
    textAlign: TextAlign.center,
  ),
);
const double kBlur = 1.0;
const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(16);
const Color kDefaultColor = Colors.transparent;
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(20));
const double kColorOpacity = 0.0;

class BlurryContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double? height, width;
  final EdgeInsetsGeometry padding;
  final Color? bgColor;

  final BorderRadius borderRadius;

  //final double colorOpacity;

  BlurryContainer({
    this.child = kDemoText,
    this.blur = 5,
    this.height,
    this.width,
    this.padding = kDefaultPadding,
    this.bgColor = kDefaultColor,
    this.borderRadius = kBorderRadius,
    //this.colorOpacity = kColorOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          color: bgColor == Colors.transparent
              ? bgColor
              : bgColor!.withOpacity(0.5),
          child: child,
        ),
      ),
    );
  }
}
