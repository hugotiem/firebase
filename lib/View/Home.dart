import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/custom_text.dart';
import 'Pages/Planning/calendar_page.dart';
import 'Pages/profil/profil_page.dart';
import 'Pages/search/search_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _currentIndex = 0;
  final List<Widget> _children = [
    Search(),
    CalendarPage(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..loadData(),
      child: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.user != null) {
            if(!state.user!.hasIdChecked!) {
              _showLoadingPopup();
            }
           
          }
        },
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
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
        }),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<dynamic> _showLoadingPopup() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckIdPopup(),
    );
  }
}

class CheckIdPopup extends StatelessWidget {
  const CheckIdPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(maxHeight: 500),
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "Identité non vérifié",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Hey ! ton compte n'est pas encore vérifié. Fait le maintenant !",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Envoie nous une photo d'une carte d'identité ou d'un passeport afin qu'on puisse vérifier ton identité !",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              Platform.isIOS
                                  ? CupertinoPageRoute(
                                      builder: (context) => IdFormScreen(),
                                      fullscreenDialog: true,
                                    )
                                  : MaterialPageRoute(
                                      builder: (context) => IdFormScreen(),
                                    ),
                            );
                          },
                          child: Container(
                            //width: MediaQuery.of(context).size.width - 100,
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                              color: ICONCOLOR,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: CText(
                              "Vérifier mon identité".toUpperCase(),
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
