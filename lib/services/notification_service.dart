import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationService =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get instance => _notificationService;

  static Future<void> initFirebaseMessaging() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: false,
    );

    await _initLocalNotifications();
    _lookForMessagingToken();

    FirebaseMessaging.onMessage
        .listen((message) => _onMessage(message, onForeground: true));
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpenedApp);
  }

  static Future<void> _initLocalNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onNotificationClicked,
    );
  }

  static void _onNotificationClicked(String? payload) {
    print("Local notification clicked !");
  }

  static void _onMessage(RemoteMessage message,
      {bool onForeground = false}) async {
    final AndroidNotification? android = message.notification?.android;
    final RemoteNotification? notification = message.notification;

    print("_onMessage: $message");
    if (notification != null && android != null && onForeground) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      flutterLocalNotificationsPlugin.show(notification.hashCode,
          notification.title, notification.body, _notificationDetail());
    }
  }

  static void _onNotificationOpenedApp(RemoteMessage message) async {
    print(
        "Une notification a ouvert l'application ! ${message.notification?.title}");
  }

  static void _lookForMessagingToken() async {
    final String? token = await FirebaseMessaging.instance.getToken();
    print("Firebase Messaging Token : $token");
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      print("Firebase Messaging Token : $token");
    });
  }

  static NotificationDetails _notificationDetail() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notificationService.show(
        id,
        title,
        body,
        await _notificationDetail(),
        payload: payload,
      );
}
