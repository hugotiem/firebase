import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'View/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = "Upload Flutter To GitHub";
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // if(Platform.isAndroid)
    // CupertinoApp();

    if (Platform.isIOS)
      return CupertinoApp(
        title: "PTS",
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("ERROR");
              return Text("ERROR");
            } else if (snapshot.hasData) {
              AuthService.setAuth();
              AuthService.auth.authStateChanges().listen((User user) {
                AuthService.logged = user != null;
              });
              return Home();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr', 'FR'),
        ],
      );
    else
      return MaterialApp(
        title: "PTS",
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("ERROR");
              return Text("ERROR");
            } else if (snapshot.hasData) {
              AuthService.setAuth();
              AuthService.auth.authStateChanges().listen((User user) {
                AuthService.logged = user != null;
              });
              return Home();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr', 'FR'),
        ],
      );
  }
}
