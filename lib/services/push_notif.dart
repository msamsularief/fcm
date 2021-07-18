import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotif {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    }
    FirebaseMessaging.onMessage.listen((event) {
      
    });
  }
}
