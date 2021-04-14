import 'package:flutter/material.dart';

class API extends StatefulWidget {
  API({Key key}) : super(key: key);

  @override
  _APIState createState() => _APIState();
}

class _APIState extends State<API> {
  double _size;
  double current;

  ScrollController _scrollController;

  @override
  void initState() {
    setState(() {
      _size = 300;
      current = 0;
      _scrollController = ScrollController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          print(notification.metrics.pixels);
          setState(() {
            if (notification.metrics.pixels <= 300 &&
                (300 - notification.metrics.pixels) >= 100) {
              _size = 300 - notification.metrics.pixels;
            }
          });
          return null;
        },
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: 30,
                controller: _scrollController,
                //physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      top: index == 0 ? 300 : 10,
                      bottom: 10,
                      left: 10,
                      right: 10,
                    ),
                    height: 100,
                    color: Colors.red,
                  );
                },
              ),
            ),
            Container(
              height: _size,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_size / 10),
                  bottomRight: Radius.circular((_size / 10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
