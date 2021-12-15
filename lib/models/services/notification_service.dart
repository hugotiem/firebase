import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationService = FlutterLocalNotificationsPlugin();

  static Future _notificationDetail() async {
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