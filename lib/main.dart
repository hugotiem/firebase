import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pts/blocs/app_bloc_delegate.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/notification_service.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main({bool isTesting = false}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (!isTesting) await NotificationService.init();

    Bloc.observer = AppBlocDelegate();
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  },
      (error, stacktrace) =>
          FirebaseCrashlytics.instance.recordError(error, stacktrace));
}

class MyApp extends StatefulWidget {
  static final String title = "Upload Flutter To GitHub";

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            return FutureBuilder<bool>(
              future: AuthService().hasValue("new"),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                // if (!snapshot.data!) {
                //   // AuthService().add("new", "false");
                //   return IntroScreen();
                // }
                return BlocProvider(
                  create: (context) => UserCubit()..init(),
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      bool isConnected = false;
                      if (state.user != null) isConnected = true;
                  
                        return Stack(
                          children: [
                            Home(isConnected),
                          ],
                        );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      theme: ThemeData(fontFamily: "Outfit"),
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
