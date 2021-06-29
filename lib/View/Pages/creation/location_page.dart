import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

import 'guest_number.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _adresse;
  String _ville;
  String _codepostal;

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
          Soiree.setDataLocationPage(
            _adresse,
            _ville,
            _codepostal
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => GuestNumber())
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
                  "Où se déroulera-t'elle ?",
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
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only( bottom: 20),
                child: Text(
                  "Adresse",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 22,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: HEIGHTCONTAINER,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: TextFormField(  
                      onChanged: (value) {
                        _adresse = value;
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: 7 avenue des champs élysés', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  "Ville",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 22,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: HEIGHTCONTAINER,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: TextFormField(  
                      onChanged: (value) {
                        _ville = value;
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: Paris', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  "Code postal",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 22,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: HEIGHTCONTAINER,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: TextFormField(  
                      onChanged: (value) {
                        _codepostal = value;
                      },
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration( 
                        hintText: 'ex: 75008', 
                        border: InputBorder.none,
                      )
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50
            )
          ],
        ),
      ),
    );
  }
}