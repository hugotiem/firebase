import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

class FABForm extends StatelessWidget {
  final void Function() onPressed;

  const FABForm({ 
    required this.onPressed,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: PRIMARY_COLOR,
      elevation: 1,
      onPressed: this.onPressed,
      child: Icon(
        Ionicons.arrow_forward_outline,
        color: SECONDARY_COLOR,
      ),
    );
  }
}