import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/headertext_one.dart';
import 'package:pts/View/Pages/creation/components/headertext_two.dart';

import 'guest_number.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _adresse;
  String _ville;
  String _codepostal;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,      
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
          if (!_formKey.currentState.validate()) {
            return;
          }
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
        child: Form(
          key: _formKey,
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: "Où se déroulera-t'elle ?",
              ),
              HeaderText2(
                text: "Adresse",
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez remplir l'adresse";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: TEXTFIELDFONTSIZE,
                        ),
                        decoration: InputDecoration( 
                          hintText: 'ex: 7 avenue des champs élysés', 
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            height: 0
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ),
              HeaderText2(
                text: "Ville",
                padding: EdgeInsets.only(bottom: 20, top: 40)
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez remplir la ville";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: TEXTFIELDFONTSIZE,
                        ),
                        decoration: InputDecoration( 
                          hintText: 'ex: Paris', 
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            height: 0
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ),
              HeaderText2(
                text: "Code postal",
                padding: EdgeInsets.only(bottom: 20, top: 40)
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez remplir le code postal";
                          } 
                          else if (value.length < 5) {
                            return "Ce code n'existe pas";
                          }
                          else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: TEXTFIELDFONTSIZE,
                        ),
                        maxLength: 5,
                        decoration: InputDecoration( 
                          hintText: 'ex: 75008', 
                          border: InputBorder.none,
                          counterText: '',
                          errorStyle: TextStyle(
                            height: 0
                          )
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[  
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
      ),
    );
  }
}