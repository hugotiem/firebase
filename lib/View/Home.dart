import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/creation/firstquestion.dart';
import 'Pages/profil/Profil.dart';
import 'Pages/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Search(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDeBase(),
            ),
          );
        },
        child: Icon(
          Icons.add_circle_outline,
          color: YELLOW_COLOR,
        ),
        elevation: 4.0,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: YELLOW_COLOR,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(
                Icons.search,
                size: 30,
              ),
              label: "Rechercher"),
          BottomNavigationBarItem(
              icon: new Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              label: "Profil"),
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
