import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
class LocalNotification{
 static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future init()async{ 
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');
    
    
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
    );

   await _flutterLocalNotificationsPlugin.initialize(
       initializationSettings,
   );
  }
  
  //====================show a simple notification
  static Future showSimpleNotification({required String title, required String body, required String payload})async{
    print('simple notification called');
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: payload);
    
  }
  
  
}