import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pts/blocs/app_bloc_delegate.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/managers/analytics_manager.dart';
import 'package:pts/services/notification_service.dart';
import 'custom_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main({bool isTesting = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isTesting) await NotificationService.initFirebaseMessaging();

  await Firebase.initializeApp();

  runZonedGuarded<Future<void>>(() async {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    BlocOverrides.runZoned(() => runApp(MyApp()),
        blocObserver: AppBlocDelegate());

    runApp(MyApp());
  }, (error, stacktrace) => FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  static final String title = "Upload Flutter To GitHub";

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  final AnalyticsInterface _analyticsInterface = FirebaseAnalyticsImplementation();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AnalyticsManager(
      analyticsInterface: _analyticsInterface,
      child: MaterialApp(
        title: "PTS",
        home: FutureBuilder<void>(
          future: AnalyticsManager.of(context).init(),
          builder: (context, _) {
            return FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("ERROR");
                  return Text("ERROR");
                } else if (snapshot.hasData) {
                  return FutureBuilder<bool>(
                    future: Future.value(true), // AuthService().hasValue("new"),
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
                            bool isConnected = state.user != null;
                          
                            return CustomBottomBar(isConnected);
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
            );
          }
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
      ),
    );
  }
}
