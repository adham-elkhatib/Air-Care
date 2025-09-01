import 'package:awesome_notifications/awesome_notifications.dart';

// import '../../../Logging/logging.service.dart';

//
//t1 Notification Created
@pragma("vm:entry-point")
Future<void> onNotificationCreatedMethod(
  ReceivedNotification notification,
) async {
  print("A Notification was created!: $notification");

  // LoggingService.log("A Notification was created!: $notification",
  //     level: Level.info);
}

//
//t1 Notification Displayed
@pragma("vm:entry-point")
Future<void> onNotificationDisplayedMethod(
  ReceivedNotification notification,
) async {
  print("A Notification was displayed!: $notification");
  // LoggingService.log("A Notification was displayed!: $notification",
  //     level: Level.info);
}

//
//t1 Notification Action Received
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction action) async {
  print("A Notification's Action was received!: $action");

  // LoggingService.log("A Notification's Action was received!: $action",
  //     level: Level.info);
}

//
//t1 Notification Dismissel Recieved
@pragma("vm:entry-point")
Future<void> onDismissActionReceivedMethod(ReceivedAction action) async {
  print("A Notification's Dismissed was received!: $action");

  // LoggingService.log("A Notification's Dismissed was received!: $action",
  //     level: Level.info);
}
