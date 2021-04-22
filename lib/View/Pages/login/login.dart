import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/services/auth.dart';
import 'package:pts/View/Home.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PanelController _controller;
  TextEditingController _editingController;
  double _slideUp;

  String _name;
  String _email;
  String _password;

  // Firebase auth
  AuthService _auth;

  @override
  void initState() {
    super.initState();
    _controller = new PanelController();
    _editingController = new TextEditingController();
    _slideUp = 0;
    _name = "";
    _email = "";
    _password = "";
    _auth = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //FocusScopeNode currentFocus = FocusScope.of(context);

    _auth.auth.authStateChanges().listen((User user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    });

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 150 + (100 * _slideUp),
                height: size.height,
                width: size.width,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "sign-up".toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Nom d'utilisateur :",
                              border: InputBorder.none,
                              //icon: Icon(Icons.create_outlined),
                            ),
                            onChanged: (value) {
                              _name = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Email :",
                              border: InputBorder.none,
                              //icon: Icon(Icons.create_outlined),
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Mot de passe :",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        child: Container(
                          width: size.width - 100,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                          ),
                          child: Align(
                            child: Text(
                              "s'inscrire".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _auth.register(_email, _password);
                          _auth.auth.currentUser
                              .updateProfile(displayName: _name);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SlidingUpPanel(
                controller: _controller,
                collapsed: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    color: SECONDARY_COLOR,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _controller.open();
                          _editingController.clear();

                          _email = "";
                          _password = "";
                        },
                        child: Container(
                          width: size.width - 100,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                          ),
                          child: Align(
                            child: Text(
                              "déjà un compte ? clique ici".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // PANEL CONTENT
                onPanelSlide: (position) {
                  setState(() {
                    _slideUp = position;
                  });
                },
                maxHeight: size.height - 150,
                minHeight: 150,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                panel: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    color: SECONDARY_COLOR,
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: "Email :",
                                      border: InputBorder.none,
                                      //icon: Icon(Icons.create_outlined),
                                    ),
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Mot de passe :",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          child: Container(
                            width: size.width - 100,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                            ),
                            child: Align(
                              child: Text(
                                "connexion".toUpperCase(),
                                style: TextStyle(
                                  //color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            _auth.signIn(_email, _password);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.close();
                            _editingController.clear();
                            _email = "";
                            _password = "";
                          },
                          child: Container(
                            width: size.width - 100,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                            ),
                            child: Align(
                              child: Text(
                                "pas de compte ? s'inscrire".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
