import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

import 'price_page.dart';

class GuestNumber extends StatefulWidget {
  @override
  _GuestNumberState createState() => _GuestNumberState();
}

class _GuestNumberState extends State<GuestNumber> {
  var _nombre;

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
        onPressed: () {
          Soiree.setDataNumberPage(
            _nombre
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => PricePage())
          );
        },
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
                  "Combien de personnes souhaitez-vous inviter ?",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 25,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(  
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                     padding: const EdgeInsets.only(left: 16),
                      child: Center(
                        child: TextFormField(
                          onChanged: (value) {
                            _nombre = value;
                          }, 
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          decoration: InputDecoration( 
                            hintText: '20', 
                            border: InputBorder.none,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container( 
                    child: Opacity(
                      opacity: 0.7,
                      child: Text( 
                        'invités',
                        style: TextStyle(  
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}