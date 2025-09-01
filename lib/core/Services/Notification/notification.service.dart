//t2 Core Packages Imports
import 'package:awesome_notifications/awesome_notifications.dart';

import './src/exports.dart';
import './src/listeners/notification_listeners.dart';

//t3 Models
//t1 Exports

class NotificationService {
  //
  static final AwesomeNotifications _service = AwesomeNotifications();

  //
  static final NotificationChannel defaultChannel = channels()[0];

  //
  static Future<bool> initialize() async => await _service.initialize(
    // use a custom global icon?
    null,
    channels(),
    channelGroups: channelGroups(),
    // debug: App.env == AppEnvironment.dev,
  );

  //
  static Future initializeListeners({bool getPermission = true}) async {
    if (await checkPermission(_service)) {
      return await _service.setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );
    }
  }

  static Future show(
    NotificationContent content, {
    NotificationSchedule? schedule,
    List<NotificationActionButton>? buttons,
  }) async => await _service.createNotification(
    schedule: schedule,
    content: content,
    actionButtons: buttons,
  );

  static showBasic(
    String title,
    String body, {
    int? id,
    List<NotificationActionButton>? buttons,
  }) {
    return show(
      NotificationContent(
        id: id ?? DateTime.now().millisecond,
        channelKey: defaultChannel.channelKey!,
        title: title,
        body: body,
      ),
    );
  }

  static Future<bool> scheduleNotification({
    int? id,
    required String title,
    required String body,
    String? bigPicture,
    required DateTime scheduleTime,
  }) async {
    return await _service.createNotification(
      content: NotificationContent(
        id: id ?? DateTime.now().millisecond,
        channelKey: defaultChannel.channelKey!,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        // bigPicture: bigPicture,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime),
    );
  }
}

//////////////////////////////////////////////////
// NotificationContent(
//         id: 10,
//         channelKey: 'general_channel',
//         title: "${Emojis.animals_ant} Title!!",
//         body: "${Emojis.animals_bear} This is the bodyyyyyyyy!",
//         //t3 Displayed with BigText Layout
//         summary: "This is summery",
//         //t3 icon's color if an icon is set && is colorable.
//         // color: Colors.pink,
//         //t3 background color of the badge shown in the notification,
//         // backgroundColor: Colors.green,
//         //t3 Set an icon instead of the app's icon/default icon.,
//         // icon: "resource://drawable/logo",
//         //t3 A slighly larger icon that appears on the right.
//         // largeIcon: "asset://assets/images/twitter.png",
//         //t3 waits the image to load and is displayed on the main body beneath the title and body. [Big Picture Layout].
//         // bigPicture: "asset://assets/images/test_big.jpg",
//         //t3 Choose a custom sound for the notification.
//         // customSound: 'resource://raw/res_custom_sound.m4a',
//         // hideLargeIconOnExpand: true,
//         payload: {
//           'NAV': "thenavto",
//           "user": "Michael",
//         },
//         // criticalAlert: true,
//         // category: NotificationCategory.Message,
//         //t3 Keeps the notification from being dismissed.
//         // locked: true,
//         // progress: download,
//         showWhen: true,
//         category: NotificationCategory.Message,

//         //t2 Notification Action Type
//         actionType:
//             //
//             // ActionType
//             //     .Default, // Dismesses the notification, opens the application, and streams action recieved.
//             // ActionType
//             //     .DisabledAction, // Dismisses the notification, Doesn't do anything else
//             // ActionType.DismissAction, // Dismesses the notification, and streams dismiss recieved.
//             // ActionType.KeepOnTop, // Dismesses the notification, doesn't open the app, and streams action recieved.
//             // ActionType.SilentAction, // Dismesses the notification, doesn't open the app, and streams action recieved.
//             ActionType
//                 .SilentBackgroundAction, // Dismesses the notification, doesn't open the app, and streams action recieved.
//         //t3
//         // ActionType.DismissAction,
//         //t2 Notification Layouts
//         notificationLayout:
//             //
//             // NotificationLayout.Default,
//             //t3 Displays the big image specified.
//             // NotificationLayout.BigPicture,
//             //t3 Displays the summery text on top of the notification.
//             // NotificationLayout.BigText,
//             //t3 Displays a progress bar with the progres value, a loader if value is null.
//             // NotificationLayout.ProgressBar,
//             //t3 When displaying a message, summery is the notification top/group, title is the user sending, and body is the message.
//             NotificationLayout.Messaging,
//       ),
//       NotificationCalendar.fromDate(
//         date: DateTime.now().add(
//           const Duration(seconds: 3),
//         ),
//         preciseAlarm: false,
//       ),
//       [
//         NotificationActionButton(
//             key: 'actionKey',
//             label: 'dismiss',
//             actionType: ActionType.DismissAction),
//         NotificationActionButton(
//           key: 'actionKey234234234',
//           label: 'send',
//           //t2 uses summery as user, and the written text as the new message!
//           requireInputText: true,
//           actionType: ActionType.KeepOnTop,
//           // isDangerousOption: true,
//           // icon: "asset://assets/images/twitter.png",
//           // color: Colors.green,
//         ),
//       ],
//////////////////////////////////////////////////
