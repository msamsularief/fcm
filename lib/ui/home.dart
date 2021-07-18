import 'package:fcm/handler/fcm_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    messaging.getToken().then((value) {
      print(value);
    });
    FcmHandler().onMsg();
    FcmHandler().onMessageOpenTheApp(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Test'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text("You pressed the button for this many times: $_counter"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: Icon(
          Icons.send,
        ),
      ),
    );
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing $_counter",
      "How you doin ?",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.high,
          fullScreenIntent: true,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
