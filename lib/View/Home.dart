import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/view/Pages/profil/profil_page.dart';
import 'Pages/Planning/calendar_page.dart';
import 'Pages/search/search_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Search(),
    CalendarPage(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: ICONCOLOR,
        unselectedItemColor: SECONDARY_COLOR,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.search,
              size: 30,
            ),
            label: "Rechercher",
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.calendar_today_outlined,
              size: 30,
            ),
            label: "Calendrier",
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.account_circle_outlined,
              size: 30,
            ),
            label: "Profil",
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
