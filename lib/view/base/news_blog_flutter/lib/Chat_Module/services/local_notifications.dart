// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  // singleton stuff
  LocalNotificationsService._();
  static final instance = LocalNotificationsService._();
  // singleton stuff end

  static const _chatNotificationChannel = AndroidNotificationDetails(
    'chat_messages',
    'Chat messages',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );

  late final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    final iosSettings = IOSInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future selectNotification(String? payload) {
    // ignore: todo
    // TODO: handle this and redirect to the correct page
    throw UnimplementedError();
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: _chatNotificationChannel,
      ),
    );
  }
}
