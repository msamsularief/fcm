import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_important_channel",
  "High Important Notification",
  "This channel used for important notification",
  importance: Importance.high,
  playSound: true,
  showBadge: true,
);

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.notification!.body}');
}

class FcmHandler {
  void onBackgroundMsg() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  Future<void> createChannel() async {
    await Firebase.initializeApp();

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMsg() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification!;

      plugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            visibility: NotificationVisibility.public,
            channelShowBadge: true,
            fullScreenIntent: true,
            onlyAlertOnce: true,
            importance: channel.importance,
            autoCancel: false,
            progress: 0,
            showWhen: true,
            priority: Priority.max,
            indeterminate: false,
            maxProgress: 100,
            // timeoutAfter: 1800,
            color: Colors.blue,
            playSound: true,
            enableLights: true,
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    }, onDone: () {
      plugin.cancelAll();
    });
  }

  void onMessageOpenTheApp(
    BuildContext context,
  ) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenApp event was opened!");
      RemoteNotification? notification = message.notification!;
      // AndroidNotification? androidNotification = message.notification!.android!;
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("This is title ${notification.title.toString()}"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(notification.body!.toString())],
              ),
            ),
          );
        },
      );
      // print(androidNotification.channelId.toString());
    });
  }
}

Future<bool> timerMsgHelper(bool value) async {
  var val;

  for (var i = 0; i < 3; i++) {
    if (i == 3) {
      val = true;
      Future.delayed(Duration(milliseconds: 1800));
      value = val;
    }
  }
  return value;
}
