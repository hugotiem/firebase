import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pts/blocs/app_bloc_delegate.dart';
import 'package:pts/blocs/application/application_cubit.dart';
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

  await Firebase.initializeApp();

  if (!isTesting) await NotificationService.initFirebaseMessaging();

  runZonedGuarded<Future<void>>(() async {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    BlocOverrides.runZoned(
        () => runApp(BlocProvider(
              create: (context) => ApplicationCubit()..launch(),
              child: MyApp(),
            )),
        blocObserver: AppBlocDelegate());

    // runApp(MyApp());
  }, (error, stacktrace) => FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  static final String title = "Upload Flutter To GitHub";

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AnalyticsInterface _analyticsInterface =
      FirebaseAnalyticsImplementation();

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocListener<ApplicationCubit, ApplicationState>(
      listener: (context, state) {
        if (state.status == ApplicationStatus.login) {
          // _navigator?.pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => CustomBottomBar()),
          //     (route) => false);
        }
      },
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
        var user = state.user;
        if (user != null && user.banned == true) {
          return Banned(user.id);
        }
        return AnalyticsManager(
          analyticsInterface: _analyticsInterface,
          child: MaterialApp(
            title: "PTS",
            navigatorKey: _navigatorKey,
            home: CustomBottomBar(),
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
      }),
    );
  }
}
