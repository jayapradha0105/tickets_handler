import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HandleNotification {
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  void initiliseFCM() async {
    fcm.isAutoInitEnabled;
    // if (Platform.isIOS) iOS_Permission();

    print(await fcm.getToken());
    await fcm.getInitialMessage();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      sound: true,
      badge: true,
      alert: true,
    );

    initialiseNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received Background notification");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Background notification Opened");
    });
  }

  getFCMToken() async{
    return await fcm.getToken();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initialiseNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final channel = const AndroidNotificationChannel(
      'com.example.tickets_handler',
      'Notifications',
      importance: Importance.high,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    flutterLocalNotificationsPlugin.cancelAll();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
            ),
            iOS: IOSNotificationDetails(
              presentSound: true,
              presentAlert: true,
            ),
          ),
        );
      }
    });
  }
}
