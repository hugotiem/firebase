import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/creation/firstpage.dart';
import 'Pages/profil/Profil.dart';
import 'Pages/search/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Search(),
    null,
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => FirstPage(),
      //       ),
      //     );
      //   },
      //   child: Icon(
      //     Icons.add_circle_outline,
      //     color: SECONDARY_COLOR,
      //   ),
      //   elevation: 4.0,
      //   backgroundColor: Colors.white,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ICONCOLOR,
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
            icon: GestureDetector(
              child: Icon(
                Icons.add,
                size: 30,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FirstPage(),
                ),
              ),
            ),
            label: "",
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
