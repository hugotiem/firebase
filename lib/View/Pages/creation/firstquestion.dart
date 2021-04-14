import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class QuestionDeBase extends StatefulWidget {
  @override
  _QuestionDeBaseState createState() => _QuestionDeBaseState();
}

class _QuestionDeBaseState extends State<QuestionDeBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar()
        ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 20),
            child: Container( 
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(  
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: TextField(
                  decoration: InputDecoration(  
                    labelText: "Comment voulez-vous appeler votre soirée ?",
                    border: InputBorder.none,
                    icon: Icon(Icons.create_outlined)
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}