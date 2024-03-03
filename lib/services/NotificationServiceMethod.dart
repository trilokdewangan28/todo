import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

import '../ui/notify_page.dart';
class NotificationServiceMethod{
  //=============================================ACTION RECIEVED METHOD
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print('on action recieve method called');
    print('Button Key: ${receivedAction.buttonKeyPressed}');
    if (receivedAction.buttonKeyPressed == 'view_task') {
      print('view task called');
      var task_info = receivedAction.payload;
      Get.to(NotifyPage(task_info: task_info));
    }else if(receivedAction.buttonKeyPressed == 'theme_changed'){
      print('theme changed called');
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
}