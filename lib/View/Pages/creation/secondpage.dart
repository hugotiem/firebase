import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/View/Pages/creation/thirdpage.dart';

// Dans cette deuxième page du formulaire on retrouve :
// La date
// L'heure

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  var _date;
  var _heure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar()
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    '1- Quel jour voulez-vous faire votre soirée ?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      ),
                    ),
                ),
              ),
            ElevatedButton(
              child: Text('Choisir une Date'),
              onPressed: () {
                _selectiondate();
              }
            ),
            Text( 
              _date == null 
                ? 'Aucune date choisie'
                : '${_date.day}/${_date.month}/${_date.year} ',
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '2- A quelle heure commence-t\'elle ?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    ),
                  ),
              ),
            ElevatedButton(
              child: Text('choisir une heure'),
              onPressed: () {
                _selectionheure();
              },
            ),
            Text( 
              _heure == null
              ? 'Aucune heure choisie'
              : "${_heure.format(context)} "
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container( 
                  child: ElevatedButton( 
                    child: new Text( 
                      'Suivant',
                    style: 
                      TextStyle(  
                        color: BLUE_BACKGROUND,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: YELLOW_COLOR,
                    shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdPage())); 
                  },
                ),
              )
            ),
          ],
        ),
      ),
    );
  } 
  Future<Null> _selectiondate() async {
    DateTime _dateChoisie = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (_dateChoisie != null) {
      setState(() {
        _date = _dateChoisie;
      });
    }
  }

  Future<Null> _selectionheure() async {
    TimeOfDay _heureChoisie = await showTimePicker(  
      context: context,
      initialTime: TimeOfDay.now()
    );
    
    if (_heureChoisie != null) {
      setState(() {
        _heure = _heureChoisie;
      });
    }
  }
}