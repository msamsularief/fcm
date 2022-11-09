import 'package:fcmapp/handler/fcm_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  String _token = "";

  @override
  void initState() {
    super.initState();

    FcmHandler().onMsg();
    FcmHandler().onMessageOpenTheApp(context);
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    FcmHandler().plugin.show(
          _counter,
          "Testing $_counter",
          "How you doin ?",
          NotificationDetails(
            android: AndroidNotificationDetails(
                FcmHandler().channel.id, FcmHandler().channel.name,
                channelDescription: FcmHandler().channel.description,
                importance: Importance.high,
                priority: Priority.high,
                color: Colors.blue,
                playSound: true,
                ticker: 'ticker',
                icon: '@mipmap/ic_launcher',
                channelShowBadge: true,
                enableLights: true,
                when: DateTime.now().millisecondsSinceEpoch
                // styleInformation: const BigPictureStyleInformation(
                //   FilePathAndroidBitmap(
                //       '/data/user/0/com.samy/app_flutter/images/images.jpg'),
                // ),
                ),
          ),
        );
  }

  void getAppToken() async {
    String? token = await FcmHandler().fcmToken;
    debugPrint('FCM TOKEN =\n$token');
    setState(() => _token = token ?? "");
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Test'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("You have click post message for this $_counter many times"),
          const Divider(
            height: 20.0,
          ),
          Text("Your FCM Token is : $_token"),
          TextButton(
            onPressed: getAppToken,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(getColor),
              alignment: Alignment.center,
            ),
            child: const Text("Get App Token"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: const Icon(
          Icons.send,
        ),
      ),
    );
  }
}
