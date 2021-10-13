import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/account.dart';
import 'screens/home.dart';

///
/// background notification handler
///

// receive message when the message is received in the background
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "---------------------- background handler invoked -------------------");
  print(message.messageId);
}

// main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification Example',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        "home": (_) => const HomePage(),
        "account": (_) => const AccountPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
