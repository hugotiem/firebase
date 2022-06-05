import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/components_export.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/Planning/manage_party_page.dart';
import 'package:pts/pages/creation/creation_page.dart';
import 'package:pts/pages/login/connect.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/pages/messaging/message_list.dart';
import 'package:pts/pages/profil/new_profile_page.dart';
import 'package:uni_links/uni_links.dart';
import 'pages/profil/profil_page.dart';
import 'pages/search/search_page.dart';

class Home extends StatefulWidget {
  final bool isConnected;

  const Home(this.isConnected, {Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late List<Widget> _children;
  // StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _children = [
      Search(),
      widget.isConnected ? ManagePartyOPage() : Connect(),
      Container(),
      widget.isConnected ? MessagePage() : Connect(),
      widget.isConnected ? Profil() : Connect(),
    ];
    BlocProvider.of<UserCubit>(context).stream.listen((event) {
      bool _isConnected = event.user != null;
      setState(() => _children = [
            Search(),
            _isConnected ? ManagePartyOPage() : Connect(),
            Container(),
            _isConnected ? MessagePage() : Connect(),
            _isConnected ? Profil() : Connect(),
          ]);
    });
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = getInitialUri();

      print("initial link = $initialLink");

      // _sub = linkStream.listen((String? link) {
      //   print("stream link = $link");
      // });
    } on FormatException {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..init(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          var user = state.user;
          if (state.user?.banned == true) {
            return Banned(state.user!.id);
          }

          return Scaffold(
            body: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: Container(color: Colors.white),
              crossFadeState: user == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: BlocListener<UserCubit, UserState>(
                listener: (context, state) {
                  if (state.user != null) {
                    if (!state.user!.hasIdChecked!) {
                      Future.delayed(const Duration(milliseconds: 200))
                          .then((value) => _showLoadingPopup());
                    }
                  }
                },
                child: BlocProvider(
                  create: (context) =>
                      PartiesCubit()..disablePartiesAfterDate(),
                  child: BlocBuilder<PartiesCubit, PartiesState>(
                    builder: (context, stateparty) {
                      return Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: Scaffold(
                              extendBodyBehindAppBar: true,
                              body: _children[_currentIndex],
                              bottomNavigationBar: BottomNavigationBar(
                                type: BottomNavigationBarType.fixed,
                                selectedFontSize: 10,
                                unselectedFontSize: 10,
                                showSelectedLabels: true,
                                showUnselectedLabels: true,
                                selectedItemColor: ICONCOLOR,
                                unselectedItemColor: SECONDARY_COLOR,
                                onTap: onTabTapped,
                                currentIndex: _currentIndex,
                                items: [
                                  BottomNavigationBarItem(
                                    icon: new Icon(
                                      Ionicons.search_outline,
                                      size: 25,
                                    ),
                                    label: "Rechercher",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: new Icon(
                                      Ionicons.calendar_clear_outline,
                                      size: 25,
                                    ),
                                    label: "Soirées",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: new Icon(
                                      Ionicons.add_circle_outline,
                                      color: Colors.transparent,
                                      size: 40,
                                    ),
                                    label: "",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: new Icon(
                                      Ionicons.chatbox_outline,
                                      size: 25,
                                    ),
                                    label: "Messages",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: new Icon(
                                      Ionicons.person_outline,
                                      size: 25,
                                    ),
                                    label: "Profil",
                                  ),
                                ],
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FloatingActionButton(
                                  heroTag: "name",
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => widget.isConnected
                                          ? CreationPage()
                                          : Connect(),
                                      fullscreenDialog: true,
                                    ),
                                  ),
                                  backgroundColor: SECONDARY_COLOR,
                                  child: Icon(Icons.add_rounded),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onTabTapped(int index) async {
    if (index == 2 && widget.isConnected) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreationPage(),
          fullscreenDialog: true,
        ),
      );
    } else if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewProfilePage(widget.isConnected),
          fullscreenDialog: true,
        ),
      );
    } else
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
                      style: AppTextStyle(
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
                        style: AppTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Envoie nous une photo d'une carte d'identité ou d'un passeport afin qu'on puisse vérifier ton identité !",
                        style: AppTextStyle(fontSize: 15),
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

class Banned extends StatelessWidget {
  final String? token;
  const Banned(this.token, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(token);
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vous êtes bannis'.toUpperCase(),
            style: AppTextStyle(
              color: Colors.red,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 22),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Opacity(
              opacity: 0.75,
              child: Text(
                "Lors de la vérification de votre compte, nous avons constasté que les informations que vous nous avez fournies lors de votre inscription ne correspondent pas avec celle de votre carte d'identité.",
                style: AppTextStyle(color: SECONDARY_COLOR, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 22),
          Center(
            child: InkWell(
              onTap: () => _delete(context),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Supprimer son compte",
                    style: AppTextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _delete(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
        _showLoadingPopup(context);
      }
    }
    FirebaseFirestore.instance.collection('user').doc(token).delete();
  }

  Future<dynamic> _showLoadingPopup(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Reauthenticate(),
    );
  }
}

class Reauthenticate extends StatefulWidget {
  const Reauthenticate({Key? key}) : super(key: key);

  @override
  _ReauthenticateState createState() => _ReauthenticateState();
}

class _ReauthenticateState extends State<Reauthenticate> {
  String? _email;
  String? _password;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController()
      ..addListener(() {
        _email = _emailController!.text.trim();
      });
    _passwordController = TextEditingController()
      ..addListener(() {
        _password = _passwordController!.text;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ttf("Email", _emailController),
          ttf('Mot de passe', _passwordController),
          ElevatedButton(
            onPressed: reauthentification,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(SECONDARY_COLOR),
            ),
            child: Text('Validez'.toUpperCase()),
          )
        ],
      ),
    );
  }

  Widget ttf(String text, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          Opacity(opacity: 0.65, child: CText(text)),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future reauthentification() async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _email!,
        password: _password!,
      );

      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException {
      print('wrong password or email');
    }
  }
}
