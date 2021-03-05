import 'package:flutter/material.dart';
import 'Pages/Créer.dart';
import 'Pages/Profil.dart';
import 'Pages/Rechercher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children =[
    Rechercher(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PTS"),
      ),
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton( 
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Creer())
          );
        },
        child: Icon(Icons.add_circle_outline, color: Colors.indigo,),
        elevation: 4.0,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search, size: 30,),
            label: "Rechercher"
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle_outlined, size: 30,),
            label: "Profil"
          ),
        ],
        backgroundColor: Colors.white,
        ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}