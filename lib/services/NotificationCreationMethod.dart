import 'package:awesome_notifications/awesome_notifications.dart';

import '../models/task.dart';

class UniqueNotificationButtonKey{
  static String themeChanged = 'theme_changed';
  static String viewTask = 'view_task';
}

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
    );
  }
  
  //==========================================RAISING A SCHEDULED ACCORDING TO DATE AND TIME NOTIFICATION
  static Future<void> raiseScheduledNotification({
    required Task task , 
    int? hour, 
    int? minute, 
    int? day, 
    int? month,
    int? year,
    int? weekDay,
    bool isRepeat=false})async{
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
            'task_note':task.note,
            'task_startTime':task.startTime,
            'task_endTime':task.endTime,
            'task_repeat':task.repeat,
            'task_date':task.date
          }
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        weekday: weekDay,
        day: day,
        month: month,
        year: year,
        preciseAlarm: true,
        repeats: isRepeat,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
      actionButtons: [
        NotificationActionButton(
          key: UniqueNotificationButtonKey.viewTask,
          label: 'View Task',
        ),
      ],
    );
  }
  
  //==========================================RAISING A SCHEDULED NOTIFICATION
  static Future<void> raiseScheduledNotificationInterval({required String? title, required String? body})async{
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