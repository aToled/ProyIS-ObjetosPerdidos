import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationsManager {
  static final NotificationsManager _instancia = NotificationsManager._constructorPrivado();

  factory NotificationsManager() {
    return _instancia;
  }

  NotificationsManager._constructorPrivado() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _platformDetails = NotificationDetails(
      android: _androidDetails,
      iOS: DarwinNotificationDetails(),
    );
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
  
  late NotificationDetails _platformDetails;
  
  final AndroidNotificationDetails _androidDetails = AndroidNotificationDetails(
    'canal_id_1', // ID único del canal
    'matching_canal', // Nombre del canal
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> showNotification(String title, String body) async {
    await _flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      title,
      body,
      _platformDetails,
    );
  }
}