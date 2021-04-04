import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/pts_components.dart';

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
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    new CupertinoNavigator(
                      child: new Container(color: Colors.white),
                    ),
                  ),
                },
                onTapDown: (_) {
                  setState(() {
                    _color = Color(0xFFE7E7E7);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _color = Colors.white;
                  });
                },
                onTapCancel: () => {
                  setState(() {
                    _color = Colors.white;
                  }),
                },
                child: new ContainerShadow(
                  color: _color,
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

// Class non utlisée, à revoir
class ClickableContainer extends StatefulWidget {
  final Widget child;
  ClickableContainer({Key key, this.child}) : super(key: key);

  @override
  _ClickableContainerState createState() =>
      _ClickableContainerState(child: child);
}

class _ClickableContainerState extends State<ClickableContainer> {
  final Widget child;

  _ClickableContainerState({this.child});

  // ignore: unused_field
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
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
          _color = Color(0xFFE7E7E7);
        });
      },
      onTapUp: (_) {
        setState(() {
          _color = Colors.white;
        });
      },
      onTapCancel: () {
        setState(() {
          _color = Colors.white;
        });
      },
      child: child,
    );
  }
}
