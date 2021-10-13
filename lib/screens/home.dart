import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotif/services/notifications.service.dart';

final FirebaseMessaging fcm = FirebaseMessaging.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // request for iOS permissions
  void requestIOSPermissions() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User permission status: ${settings.authorizationStatus}');

    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///
  /// setup the local notification service, firebase messaging (FCM) callbacks and listeners here
  ///
  void initNotifications() async {
    LocaLNotificationService.initialize(context);

    // request permissions on iOS only
    if (Platform.isIOS) {
      requestIOSPermissions();
    }

    String? token = await fcm.getToken();

    if (token != null) {
      print(token);
    }

    // wakes the app from closed / terminated state to show the notification
    fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(context, message.data['screen']);
      }
    });

    // foreground callback
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          LocaLNotificationService.dispatch(message);
        }
      },
    );

    // background callback but with the app still open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        Navigator.pushNamed(context, message.data['screen']);
      }
    });
  }

  ///
  /// end of local and FCM callback setup
  ///

  @override
  void initState() {
    super.initState();

    // initiliaze local notifications and firebase messaging
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}
