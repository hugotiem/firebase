import 'package:flutter/material.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';
import 'package:pts/constant.dart';
import 'package:pts/model/soiree.dart';
import 'package:pts/view/pages/creation/description_page.dart';

class AnimalSmokePage extends StatefulWidget {
  const AnimalSmokePage({ Key key }) : super(key: key);

  @override
  _AnimalSmokePageState createState() => _AnimalSmokePageState();
}

class _AnimalSmokePageState extends State<AnimalSmokePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _smoke;
  String _animals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      floatingActionButton: FABForm(  
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          Soiree.setDataAnimalSmokePage(
            _animals, 
            _smoke
          );

          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => DescriptionPage())
          );
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(  
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: 'Pour vos invités'
              ),
              HeaderText2(
                text: 'Où peut-on fumer ?'
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
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Center(  
                      child: DropdownButtonFormField<String>(  
                        value: _smoke,
                        items: [
                          "A l'intérieur",
                          'Dans un fumoir',
                          'Dehors'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(  
                           value: value,
                           child: Text(  
                             value,
                             style: TextStyle(  
                               fontSize: TEXTFIELDFONTSIZE
                             ),
                           ), 
                          );
                        }).toList(),
                        hint: Text( 
                          'Choisissez un lieu',
                          style: TextStyle(  
                            fontSize: TEXTFIELDFONTSIZE
                          ),
                        ),
                        elevation: 0,
                        onChanged: (String value) {
                          setState(() {
                            _smoke = value;
                          });
                        },
                        decoration: InputDecoration(  
                          errorStyle: TextStyle(  
                            height: 0,
                            background: Paint()..color = Colors.transparent,
                          ),
                          errorBorder: OutlineInputBorder(  
                            borderSide: BorderSide(  
                              color: Colors.transparent
                            )
                          ),
                          border: OutlineInputBorder(  
                            borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: UnderlineInputBorder(  
                            borderSide: BorderSide(  
                              color: Colors.transparent
                            )
                          )
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Vous devez choisir un champ';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              HeaderText2(
                text: "Y aura-t'il des animaux ?",
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
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Center(  
                      child: DropdownButtonFormField<String>(  
                        value: _animals,
                        items: [
                          "Oui",
                          'Non',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(  
                           value: value,
                           child: Text(  
                             value,
                             style: TextStyle(  
                               fontSize: TEXTFIELDFONTSIZE
                             ),
                           ), 
                          );
                        }).toList(),
                        hint: Text( 
                          'Cliquer pour choisir',
                          style: TextStyle(  
                            fontSize: TEXTFIELDFONTSIZE
                          ),
                        ),
                        elevation: 0,
                        onChanged: (String value) {
                          setState(() {
                            _animals = value;
                          });
                        },
                        decoration: InputDecoration(  
                          errorStyle: TextStyle(  
                            height: 0,
                            background: Paint()..color = Colors.transparent,
                          ),
                          errorBorder: OutlineInputBorder(  
                            borderSide: BorderSide(  
                              color: Colors.transparent
                            )
                          ),
                          border: OutlineInputBorder(  
                            borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: UnderlineInputBorder(  
                            borderSide: BorderSide(  
                              color: Colors.transparent
                            )
                          )
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Vous devez choisir un champ';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}