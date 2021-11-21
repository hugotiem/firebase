import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:pts/components/back_appbar.dart';

// Les class sont dans l'ordre des pages pour la création de soirée

// 1ère page : Choisir un nom

class Creer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Comment voulez-vous appeler votre soirée ?'
                ),
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Container( 
                  child: ElevatedButton( 
                    child: new Text( 
                      'Suivant',
                    style: 
                      TextStyle(  
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Theme())
                    ); 
                  },
                  
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
} 

// 2ème page : Choissir le thème

class Theme extends StatefulWidget {
  @override
  _ThemeState createState() => _ThemeState();
}

class _ThemeState extends State<Theme> {

  List<String> chipList = [
  "Classique",
  "Gaming",
  "Jeux de société",
  "Thème", 
  "Etudiant",
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(50),
        child: BackAppBar()
        ),
      body: Center(
        child: Material(
          color: Colors.white,
          elevation: 5,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Colors.white, 
          child: Container(
            width: 380,
            height: 280,
            child: Column(
              children: <Widget> [
                Container(  
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.amber
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Choisissez le thème qui vous plaît',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                )
                ),
                Container(
                  child: Wrap(  
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: [
                      choiceChipWidget(chipList),
                    ],
                  ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container( 
                    child: ElevatedButton( 
                      child: new Text('Suivant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                    primary: Colors.amber, 
                    shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(30.0),
                    ),
                    ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Nombre()),
                        );
                      },
                      
                      ),
                      )
                  ),
              ],
              )
          ),
          )
      ),
    );
  }
}


// ignore: camel_case_types
class choiceChipWidget extends StatefulWidget {
  final List<String> reportList;

  choiceChipWidget(this.reportList);

  @override
  _choiceChipWidgetState createState() => new _choiceChipWidgetState();
}

// ignore: camel_case_types
class _choiceChipWidgetState extends State<choiceChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    // ignore: deprecated_member_use
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Colors.amber,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}


// 3ème page : Combien de personne max 

class Nombre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      body: Center(
        child: Container( 
          padding: const EdgeInsets.all(50.0),
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              TextField(
                autofocus: true,
                decoration: InputDecoration(  
                  labelText: 'Combien de personnes voulez-vous inviter ?'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter> [
                  FilteringTextInputFormatter.digitsOnly
                ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Container( 
                  child: ElevatedButton( 
                    child: new Text('Suivant',
                    style: TextStyle(  
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber, 
                      shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrancheAge())
                      );
                    },
                    ),
                  ),
                ),
            ])
          )
        )
      );
  }
}


// 4ème page : la tranche d'age des invités 
// impossible de récupérer les données car déja une fonction super est déjà utilisé


class TrancheAge extends StatefulWidget {
  @override
  _TrancheAgeState createState() => _TrancheAgeState();
}

class _TrancheAgeState extends State<TrancheAge> {
  RangeValues _rangeValues = const RangeValues(20, 30);

  @override
  Widget build(BuildContext context) {

    final double min = 18;
    final double max = 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      body: Center(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Quelle est la tranche d'âge des personnes que vous voulez inviter ?",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                buildSideLabel(min),
                Expanded(
                  child: RangeSlider( 
                    values: _rangeValues,
                    min: min,
                    max: max,
                    divisions: 20,
                    labels: RangeLabels(
                      _rangeValues.start.round().toString(),
                      _rangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      print('START: ${values.start}, END: ${values.end}');
                      setState(() {
                        _rangeValues = values;
                      });
                    },
                  )
                ),
                buildSideLabel(max),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container( 
                child: ElevatedButton( 
                  child: new Text(
                    'Suivant',
                    style: TextStyle(  
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber, 
                      shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Heure())
                    );
                  },
                  ),
                ),
              ),
          ]
        )
      ),
    );
  }

  Widget buildSideLabel(double value) => Container( 
    width: 30,
    child: Text(
      value.round().toString(),
      style: TextStyle(  
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

// 5ème page : date et heure d'arriver 
// reste a récupérer les données

class Heure extends StatefulWidget {
  @override
  _HeureState createState() => _HeureState();
}

class _HeureState extends State<Heure> {
  final minDate = DateTime.now();
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      body: Center(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            SizedBox( 
              height: 200,
              child: CupertinoDatePicker( 
                initialDateTime: _dateTime,
                use24hFormat: true,
                minimumDate: minDate,
                onDateTimeChanged: (dateTime) {
                  print(dateTime);
                  setState(() {
                    _dateTime = dateTime;
                  });
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container( 
                child: ElevatedButton( 
                  child: new Text(
                    'Suivant',
                    style: TextStyle(  
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                      ),
                      ),
                      style: ElevatedButton.styleFrom(
                      primary: Colors.amber, 
                      shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Fin())
                        );
                    },
                  ),
                ),
              ),
          ]
        )
      )
    );
  }
}

// 6ème page : fin de la création de la soirée

class Fin extends StatefulWidget {
  @override
  _FinState createState() => _FinState();
}

class _FinState extends State<Fin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), 
        child: BackAppBar(),
        ),
      body: Center(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Nous vous remercions de votre confiance pour l'organisation de votre soirée !",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container( 
                child: ElevatedButton( 
                  child: new Text(
                    'Fin',
                    style: TextStyle(  
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber, 
                      shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                    onPressed: () {
                      // save data to firebase
                      
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ),
          ]
        )
      ),
    );
  }
}