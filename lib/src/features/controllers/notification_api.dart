import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // final fCMToken = await _firebaseMessaging.getToken();

    // print('Token: $fCMToken');
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
