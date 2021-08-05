import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/const_soiree.dart';
import 'package:pts/Model/components/profil_photo.dart';
import 'package:pts/Model/components/back_appbar.dart';

class Rechercher extends StatefulWidget {
  @override
  _RechercherState createState() => _RechercherState();
}

class _RechercherState extends State<Rechercher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        height: 250,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        decoration: BoxDecoration(
            color: SECONDARY_COLOR,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            )),
      ),
    );
    return Container(
      color: PRIMARY_COLOR,
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Stack(
        children: [
          if (shrinkFactor <= 1) topBar,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 20,
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
  double get maxExtent => 200;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
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
  final double start = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = SOIREE_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(InkWell(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(36)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10.0,
                )
              ]),
          width: 400,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                child: Text(
                  post["nom"],
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.5),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.blueGrey.withOpacity(0.23)))),
                  child: Text(
                    post["theme"],
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                ),
              ),
              Text(
                post["date_heure"],
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
              ProfilPhoto()
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PartyDetail()));
        },
      ));
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
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.arrow_upward),
            onPressed: scrollUp,
          ),
          visible: true,
        ),
        backgroundColor: PRIMARY_COLOR,
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            child: itemsData[index]);
                      })),
            ],
          ),
        ),
      ),
    );
  }

  void scrollUp() {
    controller.animateTo(start,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}

// ce qui s'affiche quand tu cliques sur un container

class PartyDetail extends StatefulWidget {
  @override
  _PartyDetailState createState() => _PartyDetailState();
}

class _PartyDetailState extends State<PartyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: Container(),
    );
  }
}
