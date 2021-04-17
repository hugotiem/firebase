import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      backgroundColor: BLUE_BACKGROUND,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Où voulez-vous la faire ?',
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
                    labelText: "Adresse :",
                    border: InputBorder.none,
                    icon: Icon(Icons.house_outlined)
                  ),
                ),
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
                    labelText: "ville :",
                    border: InputBorder.none,
                    icon: Icon(Icons.location_city_outlined)
                  ),
                ),
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
                    labelText: "Code postal :",
                    border: InputBorder.none,
                    icon: Icon(Icons.location_on_outlined)
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container( 
              child: ElevatedButton( 
                child: new Text( 
                  'Suivant',
                  style: TextStyle(  
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Fourthpage())); 
                },
              ),
            )
          ),
        ]
      ),
    );
  }
}