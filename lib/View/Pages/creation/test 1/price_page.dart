import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

import 'description_page.dart';

class PricePage extends StatefulWidget {
  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
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
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => DescriptionPage())
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 30, 
                      bottom: 40,
                      left: 20
                      ),
                    child: Text(
                      "Le prix d'entré",
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
                    padding: EdgeInsets.only(
                      top: 30, 
                      bottom: 37,
                      left: 5
                      ),
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        '(optionnel)',
                        style: TextStyle(  
                          fontSize: 18,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                )
              ],
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
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: TextFormField(  
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: 20 €', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}