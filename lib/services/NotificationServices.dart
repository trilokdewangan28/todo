import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:todo/services/NotificationServiceMethod.dart';


class NotificationServices{
  //=============================================REQUEST NOTIFICATION PERMISSION
  static requestNotificationPermission()async{
    bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
    if(!isAllowedToSendNotification){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }
  
  
  //==============================================NOTIFICATION INITIALIZATION
  static ReceivedAction? initialAction;
  static initialiszeNotification()async{
    await AwesomeNotifications().initialize(
        'resource://drawable/ic_launcher',
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
    AwesomeNotifications()
        .setListeners(
        onActionReceivedMethod: NotificationServiceMethod.onActionReceivedMethod,
        onDismissActionReceivedMethod: NotificationServiceMethod.onDismissActionReceivedMethod,
        onNotificationCreatedMethod: NotificationServiceMethod.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationServiceMethod.onNotificationDisplayedMethod
    );
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    // do something when tap
  }
  
}