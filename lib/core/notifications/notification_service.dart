import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'whatsapp_like_channel',
    'Messages',
    description: 'Messages notifications',
    importance: Importance.max,
  );

  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.createNotificationChannel(_androidChannel);
      await android.requestNotificationsPermission();
    }

    _initialized = true;
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    await ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      Random().nextInt(1 << 31),
      title,
      body,
      details,
    );
  }

  static Future<void> showRemoteMessage(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null && message.data.isEmpty) return;

    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) return;

    // Log receipt + what will be displayed
    // (kept as runtime logging only)
    // ignore: avoid_print
    print(
      '📢 Showing local notification messageId=${message.messageId} '
      'title=$title body=$body data=${message.data}',
    );

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: android?.smallIcon,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      Random().nextInt(1 << 31),
      title,
      body,
      details,
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
