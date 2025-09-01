import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Permission Handling/permission_handling.service.dart';

Future<bool> checkPermission(AwesomeNotifications service) async {
  bool r = true;
  PermissionStatus status = await PermissionHandlingService.status(
    Permission.notification,
  );
  if (!status.isGranted) {
    if (!status.isDenied) {
      await PermissionHandlingService.request(
        Permission.notification,
        onDeny: () {
          r = false;
        },
        onPermenanytlyDenied: () {
          r = false;
        },
      );
    } else {
      // show popup!
      if (true) {
        r = await service.requestPermissionToSendNotifications();
      } else {
        r = false;
      }
    }
  }
  return r;
}
