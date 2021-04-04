import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pts/Model/Const_soiree.dart';

class Rechercher extends StatefulWidget {
  @override
  _RechercherState createState() => _RechercherState();
}

class _RechercherState extends State<Rechercher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: SearchHeader(
              icon: Icons.search_outlined,
              title: 'Trouver une soirée',
              search: _Search(),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            fillOverscroll: true,
            child: Scroll(),
          )
        ],
      ),
    );
  }
}

class SearchHeader extends SliverPersistentHeaderDelegate {
  final double minTopBarHeight = 100;
  final double maxTopBarHeight = 250;
  final String title;
  final IconData icon;
  final Widget search;

  SearchHeader({
    @required this.title,
    this.icon,
    this.search,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    var shrinkFactor = min(1, shrinkOffset / (maxExtent - minExtent));

    var topBar = Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        alignment: Alignment.center,
        height: 250,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 0,
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
      ),
    );
    return Container(
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Stack(
        children: [
          if (shrinkFactor <= 1) topBar,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 80,
              ),
              child: Container(
                alignment: Alignment.center,
                child: search,
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 10,
                      color: Colors.green.withOpacity(0.23),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (shrinkFactor > 0.5) topBar,
        ],
      ),
    );
  }

  @override
  double get maxExtent => 330;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _Search extends StatefulWidget {
  _Search({Key key}) : super(key: key);

  @override
  __SearchState createState() => __SearchState();
}

class __SearchState extends State<_Search> {
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _editingController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Rechercher",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          _editingController.text.trim().isEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: null)
              : IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.clear, color: Colors.black.withOpacity(0.5)),
                  onPressed: () => setState(() {
                    _editingController.clear();
                  }),
                )
        ],
      ),
    );
  }
}

class Scroll extends StatefulWidget {
  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = SOIREE_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post["nom"],
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["theme"],
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      post["tranche_age"],
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${post["max"]}",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["date_heure"],
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 199;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[],
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Align(
                                heightFactor: 1.0,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
