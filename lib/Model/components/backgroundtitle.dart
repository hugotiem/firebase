import 'dart:ui';

import 'package:flutter/material.dart ';
import 'package:pts/Constant.dart';

class BackGroundtitle extends StatefulWidget {
  @override
  _BackGroundtitleState createState() => _BackGroundtitleState();
}

class _BackGroundtitleState extends State<BackGroundtitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Soirée proche',
        style: TextStyle(
          color: BLUE_BACKGROUND,
          fontSize: 60,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
