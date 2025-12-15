import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';

Future<bool> checkAndRequestPermissions(BuildContext context) async {
  var notificationsStatus = await Permission.notification.status;

  if (!context.mounted) return false;

  if (notificationsStatus.isGranted) {
    log('User gave notifications permissions');
    return true;
  }

  if (notificationsStatus.isPermanentlyDenied) {
    log('Notifications permissions denied showing alert');
    await _showSettingsDialog(context);
    return false;
  }

  bool grantedPermissions = false;

  if (Platform.isIOS || Platform.isMacOS) {
    final iosImpl = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImpl != null) {
      grantedPermissions =
          await iosImpl.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
  } else if (Platform.isAndroid) {
    final androidImpl = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      grantedPermissions =
          await androidImpl.requestNotificationsPermission() ?? false;
    }
  }

  if (grantedPermissions) {
    log('Permissions given instantly');
    return true;
  }

  notificationsStatus = await Permission.notification.status;

  if (notificationsStatus.isPermanentlyDenied && context.mounted) {
    log('Permissions permanently denied, showing alert');
    await _showSettingsDialog(context);
  }

  return grantedPermissions;
}

Future<void> _showSettingsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permissions required'),
        content: const Text(
          'Per essere informato sulle scadenze, devi consentire le notifice nelle impostazioni dell\'app.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Annulla'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Impostazioni'),
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
          ),
        ],
      );
    },
  );
}
