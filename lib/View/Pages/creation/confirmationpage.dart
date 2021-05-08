import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/Model/soiree.dart';

class LastPage extends StatefulWidget {
  @override
  _LastPageState createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  String _name;
  String _themeValue;
  String _nombre;
  FireStoreServices _firestore = FireStoreServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: BackAppBar(),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(children: [
            Container(
                child: Text(
              'Récapitulatif',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            )),
            // premiere page
            Center(
              child: PTSBox(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Première page',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Nom: ${Soiree.nom}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                              Container(
                                  child: Icon(
                                Icons.create_outlined,
                                size: 20,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Thème: ${Soiree.theme}',
                                style: TextStyle(fontSize: 16),
                              )),
                              Container(
                                  child: Icon(
                                Icons.party_mode_outlined,
                                size: 20,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Opacity(
                      opacity: 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                            'Nombre: ${Soiree.nombre}',
                            style: TextStyle(fontSize: 16),
                          )),
                          Container(
                              child: Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 20,
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
            // deuxieme page
            Center(
              child: PTSBox(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Date et heure',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Date: ${Soiree.date.day}/${Soiree.date.month}/${Soiree.date.year} ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                              Container(
                                  child: Icon(
                                Icons.date_range_outlined,
                                size: 20,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Heure: ${Soiree.heure.format(context)}',
                                style: TextStyle(fontSize: 16),
                              )),
                              Container(
                                  child: Icon(
                                Icons.access_time_outlined,
                                size: 20,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            // third page
            Center(
              child: PTSBox(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Lieu',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Adresse: ${Soiree.adresse}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                              Container(
                                  child: Icon(
                                Icons.house_outlined,
                                size: 20,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.23)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Opacity(
                          opacity: 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                'Ville: ${Soiree.ville}',
                                style: TextStyle(fontSize: 16),
                              )),
                              Container(
                                  child: Icon(
                                Icons.location_city_outlined,
                                size: 20,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Opacity(
                      opacity: 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                            'Code Postal: ${Soiree.codepostal}',
                            style: TextStyle(fontSize: 16),
                          )),
                          Container(
                              child: Icon(
                            Icons.location_on_outlined,
                            size: 20,
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
            // forth page
            Center(
              child: PTSBox(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Prix',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Opacity(
                        opacity: 0.75,
                        child: Soiree.paiement
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Text(
                                    'Prix: ${Soiree.prix}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  Container(
                                      child: Icon(
                                    Icons.euro_symbol_outlined,
                                    size: 20,
                                  )),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Text(
                                    '${Soiree.gratuit}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  Container(
                                      child: Icon(
                                    Icons.euro_symbol_outlined,
                                    size: 20,
                                  )),
                                ],
                              )),
                  ),
                ],
              )),
            ),
            TextButton(
                onPressed: () {
                  _edit(context);
                },
                child: Text('Modifier')),
            TextButton(
                onPressed: () {
                  _firestore.add(
                    collection: "Soirée",
                    data: ({
                      'Name': Soiree.nom,
                      'Theme': Soiree.theme,
                      'Number': Soiree.nombre,
                      'Date': Soiree.date,
                      'Hour': Soiree.heure.format(context),
                      'Adress': Soiree.adresse,
                      'City': Soiree.ville,
                      'Postal dode': Soiree.codepostal,
                      'Price': Soiree.prix,
                      'free': Soiree.gratuit,
                    }),
                  );

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('valider')),
          ])),
        ));
  }

  Future<Null> _edit(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: SingleChildScrollView(
            child: Column(children: <Widget>[
              // first page
              TextFormField(
                initialValue: Soiree.nom,
                decoration: InputDecoration(
                  labelText: "Votre soirée s'appelera :",
                  border: InputBorder.none,
                  icon: Icon(Icons.create_outlined),
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: Soiree.theme,
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
              TextFormField(
                initialValue: Soiree.nombre,
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
              // second page
              ElevatedButton(
                child: new Text(
                  'Valider',
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
                  setState(() {
                    Soiree.setDataFistPage(
                      _name,
                      _themeValue,
                      _nombre,
                    );
                  });
                },
              ),
            ]),
          ));
        });
  }
}
