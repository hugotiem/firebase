import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/secondpage.dart';

// Dans cette première page du formulaire de création on retrouve :
// le nom
// le thème
// le nombre d'invité

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String _themeValue;
  String _name;
  String _nombre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: BackAppBar(
            leading: CupertinoButton(
              child: Icon(
                Icons.close,
                color: SECONDARY_COLOR,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              '1- Comment voulez-vous appeler votre soirée ?',
              style: TextStyle(
                fontSize: 20,
                color: SECONDARY_COLOR,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Votre soirée s'appelera :",
                    border: InputBorder.none,
                    icon: Icon(Icons.create_outlined),
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              '2- Choisissez le thème qui vous plaît :',
              style: TextStyle(
                fontSize: 20,
                color: SECONDARY_COLOR,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: DropdownButtonFormField<String>(
                  value: _themeValue,
                  items: [
                    'Classique',
                    'Gaming',
                    'Jeu de société',
                    'Thème',
                    'Etudiante'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Choisir un thème",
                  ),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  isExpanded: true,
                  onChanged: (String value) {
                    setState(() {
                      _themeValue = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  '3- Combien de personne voulez-vous inviter ?',
                  style: TextStyle(
                    fontSize: 20,
                    color: SECONDARY_COLOR,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Le nombre d'inviter sera de :",
                          border: InputBorder.none,
                          icon: Icon(Icons.person_add_alt_1_outlined)),
                      onChanged: (value) {
                        setState(() {
                          _nombre = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(),
              child: Container(
                child: ElevatedButton(
                  child: new Text(
                    'Suivant',
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Soiree.setDataFistPage(
                      _name,
                      _themeValue,
                      _nombre,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SecondPage()));
                  },
                ),
              )),
        ]),
      ),
    );
  }
}
