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
      backgroundColor: Colors.white,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      floatingActionButton: FloatingActionButton( 
        backgroundColor: PRIMARY_COLOR,
        elevation: 1,
        child: Icon(
          Icons.arrow_forward_outlined,
          color: SECONDARY_COLOR,
          ),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(top: 30, bottom: 40),
                child: Text(
                  "Comment s'appelera-t'elle ?",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 25,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Center(
                    child: TextFormField(  
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: La fête du roi', 
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.create_outlined
                        )
                      )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}