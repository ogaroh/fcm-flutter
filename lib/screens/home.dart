import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotif/services/notifications.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    ///
    /// setup the firebase messaging (FCM) callbacks and listeners here
    ///
    LocaLNotificationService.initialize(context);

    // wakes the app from closed / terminated state to show the notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
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

    ///
    /// end of FCM callback setup
    ///
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
