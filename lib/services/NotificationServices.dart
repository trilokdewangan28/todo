import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:todo/models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices{

  static initialiszeNotification()async{
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: "test_channel_group",             // optional 
              channelKey: "test_channel",
              channelName: "Test Notification",
              channelDescription:"Test Notification Channel",
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(channelGroupKey: "test_channel_group", channelGroupName: "Test Group",)
        ],
    );
  }
  
  static requestNotificationPermission()async{
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if(!isAllowedToSendNotification){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }


  //==========================================RAISING A SIMPLE NOTIFICATION
  static Future<void> raiseSimpleNotification({required String? title, required String? body})async{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "test_channel",
          title: title,
          body: body,
        ),
        // schedule: NotificationInterval(
        //   interval:5,
        //   timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        //   repeats: true,)

    );}


  //==========================================RAISING A SCHEDULED NOTIFICATION
  static Future<void> raiseScheduledNotification({required String? title, required String? body})async{
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "test_channel",
        title: title,
        body: body,
      ),
      schedule: NotificationInterval(
        interval:5,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        repeats: false,)
    );
  }

  //==========================================RAISING A SCHEDULED ACCORDING TO DATE AND TIME NOTIFICATION
  static Future<void> raiseScheduledNotificationDateAndTime({required Task task , int? hour, int? minute, bool isRepeat=false})async{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: task.id!,
          channelKey: "test_channel",
          title: task.title,
          body: task.note,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          repeats: isRepeat,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        )
    );
  }
  
  //===================================TIME CONVERTER===========================
  _convertDateTime(){
    
  }


}