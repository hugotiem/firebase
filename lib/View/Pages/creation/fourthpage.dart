import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'confirmationpage.dart';


// Dans cette quatrième page du formulaire de création on retrouve : 
// le paiement

class Fourthpage extends StatefulWidget {
  @override
  _FourthpageState createState() => _FourthpageState();
}

class _FourthpageState extends State<Fourthpage> {
  bool _paiement = true;
  String _prix;
  String _gratuit = 'gratuit';

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: BLUE_BACKGROUND,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: BackAppBar(),
            ),
          body: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    'Votre soirée sera :',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      ),
                    ),
                ),
              ),
              Switch(
                value: _paiement,
                activeColor: YELLOW_COLOR,
                inactiveTrackColor: BLUE_BACKGROUND,
                onChanged: (value) {
                  setState(() {
                     _paiement = value;
                  });
                },
              ),
              _paiement 
                ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Payante',
                        style: TextStyle(  
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
                child: Container( 
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(  
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: TextField(
                      decoration: InputDecoration(  
                        labelText: "L'entrée coutera :",
                        border: InputBorder.none,
                        icon: Icon(Icons.euro_symbol_outlined)
                        ),
                      onSubmitted: (value) {
                        setState(() {
                          _prix = value;
                        });
                      },
                      ),
                    ),
                  ),
                ),
                ]
               )
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Gratuite',
                        style: TextStyle(  
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] 
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LastPage())); 
                  },
                ),
              )
            ),
            Text('prix : ${_paiement == true ? _prix : _gratuit} ')
          ]
        )
      );
  }
}