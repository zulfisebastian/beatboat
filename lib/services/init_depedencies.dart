import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class InitDepedencies {
  FlutterLocalNotificationsPlugin localNotif =
      FlutterLocalNotificationsPlugin();

  Future initPlatformState() async {
    await initLocalNotif();
  }

  cancelAllNotification() {
    localNotif.cancelAll();
  }

  Future<void> showNotification(
    String title,
    String body, {
    Map<String, dynamic>? message,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "BeatBoat",
      "BeatBoat",
      channelDescription: "BeatBoat Notification",
      color: Colors.green,
      priority: Priority.high,
      importance: Importance.max,
      groupKey: "com.BeatBoatsecretariat.org.WORK_EMAIL",
      setAsGroupSummary: true,
    );
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await localNotif.show(
      Random().nextInt(10000),
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );
  }

  Future initLocalNotif() async {
    var initializationSettingsAndroid = new AndroidInitializationSettings(
      'mipmap/ic_launcher',
    );
    var initializationSettingsIOS = new DarwinInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    localNotif = new FlutterLocalNotificationsPlugin();
    await localNotif.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
    );
  }

  Future onDidReceiveLocalNotification(NotificationResponse e) async {
    try {
      var _data = jsonDecode(e.payload ?? '');
      // print("${e.payload} clicked");
      // print("${_data['type']} clicked");
      clickNotification(_data);
    } catch (e) {
      // print("error click notif");
      // print(e);
    }
  }

  Future clickNotification(Map<String, dynamic> payload) async {
    // BaseController _base = Get.find(tag: "BaseController");
    // String _token = await SharedPref.getAccessToken();
    // print("apa nih $payload");

    // if (_token.isNotEmpty) {
    //   var type = payload['type'];
    //   var transactionCode = payload['transaction_code'];
    //   var commentCode = payload['comment_code'];
    //   var postCode = payload['post_code'];
    //   var file = payload['file'] ?? "";

    //   if (type == "open") {
    //     OpenFilex.open(file);
    //   } else {
    //     _base.notificationClicked(
    //       type,
    //       transactionCode,
    //       commentCode,
    //       postCode,
    //       true,
    //       false,
    //       file,
    //     );
    //   }
    // } else {
    //   // Navigation().toLogin();
    // }
  }

  Widget? initErrorWidget() {
    // ErrorWidget.builder = (details) {
    //   return ErrorPage(
    //     error: details.stack.toString(),
    //   );
    // };
    return null;
  }

  initGoogleSignIn() {
    Get.put(GoogleSignIn());
  }

  initFToast() {
    Get.put(FToast());
  }

  getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    Get.put(version, tag: "appVersion");
  }

  getDeviceInfo() async {
    String udid = await FlutterUdid.consistentUdid;
    Get.put(udid, tag: "udid");

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
      Get.put(deviceInfo, tag: "deviceInfo");
    } else {
      final AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      Get.put(deviceInfo, tag: "deviceInfo");
    }
  }

  Future<bool> requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }

    return permission == PermissionStatus.granted;
  }

  Future<String> createFolder(subFolder) async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        await Permission.photos.request();
      }
      var path = await getApplicationSupportDirectory();
      if ((await path.exists())) {
        return path.path;
      } else {
        path.createSync(recursive: true);
        return path.path;
      }
    } else {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) {
        var path = await getApplicationSupportDirectory();
        if ((await path.exists())) {
          return path.path;
        } else {
          path.createSync(recursive: true);
          return path.path;
        }
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        var path = await getApplicationSupportDirectory();
        if ((await path.exists())) {
          return path.path;
        } else {
          path.createSync(recursive: true);
          return path.path;
        }
      }
    }
  }
}
