import 'package:fcmapp/handler/image_download_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fcmapp/utils/string_extensions.dart';

@pragma('vm:entry-point')
Future<void> _fcmBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('background message ${message.notification?.body}');
}

///This class for handling FCM (Firebase Cloud Messaging)
class FcmHandler {
  static final FcmHandler _singleton = FcmHandler._internal();

  FcmHandler._internal();

  factory FcmHandler() {
    return _singleton;
  }

  late FirebaseMessaging _messaging;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin plugin;

  ///Handling and creating the [_channel_] of the app.
  Future<void> initializeApp() async {
    _messaging = FirebaseMessaging.instance;

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        "high_importance_channel",
        "High Importance Notifications",
        description: "This channel used for important notifications.",
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      );
    }

    plugin = FlutterLocalNotificationsPlugin();

    // Creating Android Notification Channel
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _messaging.setAutoInitEnabled(true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///This for handling [_messages_] when the app is run in background or closed fully.
  static void onBackgroundMsg() {
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundMessageHandler);
  }

  ///This for handling [_messages_] when the app is opened.
  void onMsg() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigPictureStyleInformation? bigPictureStyleInformation;
      String? picture;
      var data = message.data;

      debugPrint('$data');
      final RemoteNotification? notification = message.notification;

      if (notification != null) {
        final int timeStamp = DateTime.now().millisecondsSinceEpoch;
        picture = await ImageDownloadHandler().downloadAndSaveFile(
          notification.android?.imageUrl,
          "Images-${timeStamp.fileNameFormatter()}",
        );

        if (picture != null) {
          bigPictureStyleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(picture),
            contentTitle: notification.title,
          );
        }

        plugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              onlyAlertOnce: true,
              importance: channel.importance,
              priority: Priority.max,
              channelShowBadge: true,
              color: Colors.blue,
              colorized: true,
              playSound: true,
              ticker: 'ticker',
              enableLights: true,
              icon: "@mipmap/ic_launcher",
              enableVibration: true,
              when: timeStamp,
              styleInformation: bigPictureStyleInformation,
              largeIcon: bigPictureStyleInformation?.bigPicture,
              visibility: NotificationVisibility.public,
            ),
          ),
          // payload: message.data['type'],
        );
      }
    });
  }

  ///Handling [_messages_] when it clicked by the user.
  void onMessageOpenTheApp(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint("A new onMessageOpenApp event was opened!");
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('${notification.title}'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!.toString())],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<String?> get fcmToken async => await _messaging.getToken();
}
