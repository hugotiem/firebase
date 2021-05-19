import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class FirsPageTest1 extends StatefulWidget {
  @override
  _FirsPageTest1State createState() => _FirsPageTest1State();
}

class _FirsPageTest1State extends State<FirsPageTest1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: Column(  
        children: [
          
        ],
      ),
    );
  }
}