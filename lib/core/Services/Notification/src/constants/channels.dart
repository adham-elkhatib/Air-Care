import 'package:awesome_notifications/awesome_notifications.dart';

List<NotificationChannel> channels() {
  return [
    //
    //---
    NotificationChannel(
      channelKey: 'general_channel',
      channelName: 'General Notifications',
      channelDescription: 'Notification channel for General Usage',
      //
      channelGroupKey: 'general_channel_group',
      //
      playSound: true,
      importance: NotificationImportance.Max,
    ),
    //---
    //
  ];
}
