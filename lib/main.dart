// import 'package:audio_manager/audio_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:islamic_ringtoon/controller/controller.dart';
import 'package:islamic_ringtoon/pages/splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_FirebasePushHandler);
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'islamic',
        channelDescription: 'Notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true),
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Controller>(
      create: (context) => Controller(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Aref"),
        debugShowCheckedModeBanner: false,
        home: Splash_screen(),
      ),
    );
  }
}

Future<void> _FirebasePushHandler(RemoteMessage message) async {
  print("message is ${message.data}");
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}
