import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/pts_components.dart';

import '../../Constant.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar pour eviter certains bug d'affichage avec le haut de l'écran
      appBar: new AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              ClickableWhithContainerShadow(
                child: Row(
                  children: <Widget>[
                    new Container(
                      height: 60,
                      width: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Name",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          new Text("show profile"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new ContainerShadow(
                // creer une list avec tous les elements
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("Paramètres du compte"),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.23),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Informations personnelles",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.perm_identity)
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.23),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Paiements",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.payment)
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.23),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Notifications",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.notifications_outlined)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ContainerShadow(
                child: Text(
                  "Se deconnecter",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
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

// to move to the pts_components file
class ClickableWhithContainerShadow extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color focusColor;
  final bool cupertino;
  ClickableWhithContainerShadow({
    Key key,
    this.child,
    this.color = const Color(0xffffffff),
    this.focusColor = FOCUS_COLOR,
    this.cupertino = true,
  }) : super(key: key);

  @override
  _ClickableWhithContainerShadowState createState() => cupertino == true
      ? _ClickableWhithContainerShadowState(
          child: child, color: color, focusColor: focusColor)
      : null;
}

class _ClickableWhithContainerShadowState
    extends State<ClickableWhithContainerShadow> {
  final Widget child;
  final Color color;
  final Color focusColor;

  _ClickableWhithContainerShadowState(
      {this.child, this.color, this.focusColor});

  Color _color;

  @override
  Widget build(BuildContext context) {
    print(color);
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          new CupertinoNavigator(
            child: new Container(color: Colors.white),
          ),
        ),
      },
      onTapDown: (_) {
        setState(() {
          _color = focusColor;
        });
      },
      onTapUp: (_) {
        setState(() {
          _color = color;
        });
      },
      onTapCancel: () {
        setState(() {
          _color = color;
        });
      },
      child: ContainerShadow(
        color: _color == null ? color : _color,
        child: child,
      ),
    );
  }
}
