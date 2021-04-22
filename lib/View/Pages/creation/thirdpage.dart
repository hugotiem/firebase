import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/fourthpage.dart';

// Dans cette troisième page du formualaire on retrouve :
// l'adresse
// la ville
// le code postal

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String _adresse;
  String _ville;
  String _codepostal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      backgroundColor: PRIMARY_COLOR,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Où voulez-vous la faire ?',
              style: TextStyle(
                fontSize: 20,
                color: SECONDARY_COLOR,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Adresse :",
                      border: InputBorder.none,
                      icon: Icon(Icons.house_outlined)),
                  onChanged: (value) {
                    setState(() {
                      _adresse = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "ville :",
                      border: InputBorder.none,
                      icon: Icon(Icons.location_city_outlined)),
                  onChanged: (value) {
                    setState(() {
                      _ville = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 15),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Code postal :",
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on_outlined)),
                  onChanged: (value) {
                    setState(() {
                      _codepostal = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15),
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
                    Soiree.setDataThirdPage(
                      _adresse,
                      _ville,
                      _codepostal,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Fourthpage()));
                  },
                ),
              )),
        ]),
      ),
    );
  }
}
