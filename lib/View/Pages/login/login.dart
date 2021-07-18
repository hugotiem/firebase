import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/login/register_form_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //controllers
  PanelController _controller;
  TextEditingController _editingController;

  SystemUiOverlayStyle _brightness;

  double _slideUp;

  // strings variables
  String _email;
  String _password;

  // Firebase auth
  AuthService _auth;

  @override
  void initState() {
    super.initState();
    _controller = new PanelController();
    _editingController = new TextEditingController();
    _brightness = SystemUiOverlayStyle.dark;
    _slideUp = 0;
    _email = "";
    _password = "";
    _auth = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        systemOverlayStyle: _brightness,
        leading: Container(
          margin: EdgeInsets.only(top: 40),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ICONCOLOR,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: size.height - 300,
                margin: EdgeInsets.only(top: 150 + (100 * _slideUp)),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "sign-up".toUpperCase(),
                          style: TextStyle(
                            color: SECONDARY_COLOR,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 70,
                    // ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: TextField(
                              // controller: _editingController,
                              keyboardAppearance: Brightness.light,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                suffix: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child:
                                      Icon(Icons.person, color: Colors.black),
                                ),
                                labelText: "Email :",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                _email = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: TextField(
                              // controller: _editingController,
                              obscureText: true,
                              keyboardAppearance: Brightness.light,
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
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: TextField(
                              // controller: _editingController,
                              obscureText: true,
                              keyboardAppearance: Brightness.light,
                              decoration: InputDecoration(
                                labelText: "Confirmation du mot de passe :",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                _password = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: size.width - 100,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: ICONCOLOR,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                              ),
                              child: Text(
                                "s'inscrire".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              _auth
                                  .register(_email, _password)
                                  .then((value) => {
                                        if (value.containsKey("success"))
                                          {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    RegisterFormScreen(),
                                              ),
                                            )
                                          }
                                        else
                                          {
                                            value.forEach((key, value) {
                                              print(key);
                                            })
                                          }
                                      });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: size.width - 100,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(200),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "se connecter avec".toUpperCase(),
                                    style: TextStyle(
                                      color: ICONCOLOR,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    child: Image.asset(
                                      "assets/images/google-logo.png",
                                      height: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              _auth
                                  .signInWithGoogle()
                                  .then(
                                    (value) =>
                                        Navigator.of(context).pushReplacement(
                                      CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            RegisterFormScreen(
                                          user: value.user,
                                        ),
                                      ),
                                    ),
                                  )
                                  .catchError((onError) => print(onError));
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text:
                                  "*En cliquant sur \"S'inscrire\" je déclare avoir accepté les ",
                            ),
                            TextSpan(
                              text: "Conditions Générales d'Utilisations ",
                              style: TextStyle(color: ICONCOLOR),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            "Conditions Générales d'Utilisations",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: "et avoir pris connaissance de la ",
                            ),
                            TextSpan(
                              text: "Politique de confidentialité ",
                              style: TextStyle(color: ICONCOLOR),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            "Politique de confidentialité",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: "de PTS.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SlidingUpPanel(
                renderPanelSheet: false,

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
                        child: Column(
                          children: <Widget>[
                            Container(
                              //padding: EdgeInsets.only(bottom: 50),
                              child: Align(
                                child: Text(
                                  "déjà un compte ? clique ici".toUpperCase(),
                                  style: TextStyle(
                                    color: ICONCOLOR,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: ICONCOLOR,
                                ),
                              ),
                            ),
                          ],
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
                minHeight: 120,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                backdropEnabled: true,
                backdropColor: SECONDARY_COLOR,
                backdropOpacity: 1,
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: TextField(
                                    // controller: _editingController,
                                    keyboardType: TextInputType.emailAddress,
                                    keyboardAppearance: Brightness.dark,
                                    decoration: InputDecoration(
                                      labelText: "Email :",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: TextField(
                                    // controller: _editingController,
                                    obscureText: true,
                                    keyboardAppearance: Brightness.dark,
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
                          height: 60,
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
                          onTap: () async {
                            _auth.signIn(_email, _password).then(
                                  (value) => {
                                    if (value.containsKey("success"))
                                      {
                                        Navigator.of(context).pop(),
                                      }
                                    else
                                      {
                                        value.forEach((key, value) {
                                          print(key);
                                        }),
                                      }
                                  },
                                );
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
                            child: Align(
                              child: Text(
                                "pas de compte ? s'inscrire".toUpperCase(),
                                style: TextStyle(
                                  color: ICONCOLOR,
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
                onPanelOpened: () {
                  _brightness = SystemUiOverlayStyle.light;
                  _editingController.clear();
                  _email = "";
                  _password = "";
                },
                onPanelClosed: () {
                  _brightness = SystemUiOverlayStyle.dark;
                  _editingController.clear();
                  _email = "";
                  _password = "";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
