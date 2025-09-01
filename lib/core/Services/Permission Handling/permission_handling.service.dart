import 'dart:ui';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandlingService {
  //
  // static Future<void> requirementsInitializer() async {
  //   for (var p in requirements) {
  //     if (await status(p) != PermissionStatus.granted) {
  //       await request(p);
  //     }
  //   }
  // }

  //
  static Future<PermissionStatus> status(Permission permission) async =>
      await permission.status;

  //
  static Future<void> request(
    Permission permission, {
    VoidCallback? onDeny,
    VoidCallback? onPermenanytlyDenied,
  }) async {
    if (await status(permission) != PermissionStatus.granted) {
      return await permission.request().then((status) async {
        if (status.isPermanentlyDenied) {
          onPermenanytlyDenied != null
              ? onPermenanytlyDenied()
              : () async {
                  // ErrorHandlingService.handle(
                  //   "[c/permission_denied_permenanytly{${permission.toString().split('.')[1]}}]",
                  //   "PermissionHandlingService/request",
                  // );
                  await openAppSettings();
                };
        } else if (status.isDenied) {
          onDeny != null
              ? onDeny()
              : () {
                  // ErrorHandlingService.handle(
                  //   "[c/permission_denied{${permission.toString().split('.')[1]}}]",
                  //   "PermissionHandlingService/request",
                  // );
                };
        }
      });
    }
  }
}
