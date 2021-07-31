import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'Channel ID', //Required for Android 8.0 or after
        'Channel Name', //Required for Android 8.0 or after
        'Channel Desc', //Required for Android 8.0 or after
        importance: Importance.high);
const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

class NotificationService {
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('fascia_care');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        12345,
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifcations Package",
        platformChannelSpecifics,
        payload: 'data');
  }

  Future showDayilyNotification() async {
    var time = Time(0, 0, 15);
    //flutterLocalNotificationsPlugin.showDailyAtTime(2, 'title', 'body', time, platformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(3, 'every minute', 'body',
        RepeatInterval.everyMinute, platformChannelSpecifics);
  }

  Future scheduleHourlyNotification() async {
    await flutterLocalNotificationsPlugin.periodicallyShow(1, 'It\'s time to drink water!', 'Don\'t forget to complete your daily intake!', RepeatInterval.hourly, platformChannelSpecifics);
  }

  Future scheduleDailyNotification() async {
    await flutterLocalNotificationsPlugin.periodicallyShow(2, 'It\'s time to drink water!', 'Don\'t forget to complete your daily intake', RepeatInterval.daily, platformChannelSpecifics);
  }

  Future stopNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
