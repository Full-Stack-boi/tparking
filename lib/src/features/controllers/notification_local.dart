import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'parking_controllers.dart';

class NotificationLocal {
  
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
  // ignore: non_constant_identifier_names
  AndroidInitializationSettings InitializationSettingsAndroid = const AndroidInitializationSettings('splash');

// ignore: non_constant_identifier_names
var InitializationSettingsIOS = DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestCriticalPermission: true,
  requestProvisionalPermission: true,
  onDidReceiveLocalNotification: 
  (int? id,String? title,String? body,String? payload) async {});
   var initializationSettings = InitializationSettings(
    android:InitializationSettingsAndroid,
    iOS:InitializationSettingsIOS
  );
  await notificationsPlugin.initialize(initializationSettings,
  onDidReceiveNotificationResponse: 
  (NotificationResponse notificationResponse) async{});
}
  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', 
    importance: Importance.max),
    iOS: DarwinNotificationDetails());
    
}


  Future showNotification(
    {int id = 0,String? title,String? body,String? payload} 
  ) async{
  return notificationsPlugin.show(id, title, body, await notificationDetails());
}  


 Future scheduleNotification(
    {int id = 0,String? title,String? body,String? payload} 
  ) async{
  return notificationsPlugin.zonedSchedule(id, title, body,tz.TZDateTime.now(tz.local).add(Duration(seconds: ParkingController().parkingHours.toInt())),await notificationDetails(), uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
}  
}