

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_firebase_notification/message_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:salon_app_userside/screens/home/home_screen.dart';
import 'package:http/http.dart'  as http;
// import '../screens/home/appointments_screen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //============Function for getting User Permission========================//
  void getNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      carPlay: true,
      criticalAlert: true,
      announcement: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Granted");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("Permission Provisional Granted");
    } else {
      print("Permission Denied");
    }
  }

  //===========Initialization of Local Notification For Receiving Notification In Foreground============//
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      //payload is actually data
      handleMessage(context, message);
    });
  }

  //==================Main Notification Section================//
  void firebaseInit(BuildContext context) {
    //1.notification in foreground (we will use local notification to receive notification in foreground)
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(context, message);
      } else {
        showNotification(context, message);
      }
    });

    //the above code is enough to handle all the notification

    //2. background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { });

    //3. terminated state

    // messaging.getInitialMessage().then((message){});
  }

  //===========Show Notification Function Only From Local Notification Plugin For Foreground===========//

  Future<void> showNotification(BuildContext context, RemoteMessage message) async {
    initLocalNotifications(context, message);
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  //===========Get Device Token============================//
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  //=================Refreshing Token================//
  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {});
  }

  //===============Redirect User to Specific Screen When App is in Background or Terminated==========//
  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  // Redirect User When App is in Foreground==========//
  void handleMessage(BuildContext context, RemoteMessage message) {
    //fetching from data key from server
    if (message.data['type'] == 'newProducts') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            // id: message.data['id'],
          ),
        ),
      );
    }
  }

  sendNotification(
      String deviceToken,
      // String notification
      )async{
    var data = {
      'to': deviceToken,
      'priority':'high',

      'notification':{
        'title': 'Nail Technician',
        'body' : 'You have got new Appointment'
      },
      'data':{
        'type':'appointment',
        'id': 'Nail-Technician'
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
    body: jsonEncode(data),
      headers: {
      'Content-Type':'application/json; charset=UTF-8',
        'Authorization':'key=AAAA--kIXNo:APA91bGJIHQE2_MI7MtXX6AFY9Ze63Vk3E1HVc1mghB6yh_gVupLjTXPJq5hqt3n-3sUcG_UuoaqtnXjMIIoejeA30qdGpYJrAVJDQu-8BjcQv29bqgkK3juwhfkKzvgnYMdQnP9OTM_'
      }
    );

  }


}