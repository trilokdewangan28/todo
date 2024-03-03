import 'package:awesome_notifications/awesome_notifications.dart';

import '../models/task.dart';

class NotificationCreationMethod{
  //==========================================RAISING A SIMPLE NOTIFICATION
  static Future<void> raiseSimpleNotification({required String? title, required String? body})async{
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "test_channel",
        title: title,
        body: body,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'theme_changed',
          label: 'theme changed',
        ),
      ],
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
          payload: {
            'page_title':'Your Task',
            'task_id':task.id.toString(),
            'task_title':task.title,
            'task_note':task.note
          }
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        repeats: isRepeat,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'view_task',
          label: 'View Task',
        ),
      ],
    );
  }
  
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


}