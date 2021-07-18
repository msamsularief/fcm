import 'package:fcm/handler/fcm_handler.dart';
import 'package:fcm/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> _messageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('background message ${message.notification!.body}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FcmHandler().onBackgroundMsg();
  await FcmHandler().createChannel();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
