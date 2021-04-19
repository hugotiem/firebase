import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PanelController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new PanelController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: size.height,
              width: size.width,
              child: Container(
                child: Column(
                  children: <Widget>[],
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
                  color: PRIMARY_COLOR,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.open();
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
              onPanelSlide: (position) => {
                //print(position),
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
                  color: PRIMARY_COLOR,
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
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      GestureDetector(
                        child: Container(
                          width: size.width - 100,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: SECONDARY_COLOR,
                            borderRadius: BorderRadius.all(
                              Radius.circular(200),
                            ),
                          ),
                          child: Align(
                            child: Text(
                              "connexion".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.close();
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
    );
  }
}
