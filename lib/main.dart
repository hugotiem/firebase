import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pts/blocs/app_bloc_delegate.dart';
import 'View/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:pts/.env.example.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    var initializationSettingsAndroid = new AndroidInitializationSettings("logo");
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async{});

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, 
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }    
    });
    Stripe.publishableKey = stripePublisableKey;
    Stripe.merchantIdentifier = 'pts';
    Stripe.urlScheme = 'flutterstripe';
    // await Stripe.instance.applySettings();
    Bloc.observer = AppBlocDelegate();
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  },
      (error, stacktrace) =>
          FirebaseCrashlytics.instance.recordError(error, stacktrace));
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

    return MaterialApp(
      title: "PTS",
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("ERROR");
            return Text("ERROR");
          } else if (snapshot.hasData) {
            return Home();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      theme: ThemeData(fontFamily: "MerriweatherSans"),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', 'FR'),
      ],
    );
  }
}
