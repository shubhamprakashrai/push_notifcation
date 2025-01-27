// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushNotificationService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Initialize local notifications
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//     final InitializationSettings initializationSettings = const InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Request permissions for iOS and macOS
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted permission");
//     } else {
//       print("User denied or has not accepted permissions");
//     }

//     // Get the FCM token for the device
//     String? token = await _messaging.getToken();
//     print("FCM Token: $token");

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print("Foreground Notification: ${message.notification!.title}");
//         print("Body: ${message.notification!.body}");

//         _showLocalNotification(message); // Show notification in the foreground
//       }
//     });

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

//     // Handle notification taps (when the app is in the background)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Notification clicked: ${message.notification?.title}");
//     });
//   }

//   // Function to show local notifications
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your_channel_id', 'your_channel_name',
//       importance: Importance.max, priority: Priority.high,
//       ticker: 'ticker',
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       message.notification?.title, 
//       message.notification?.body, 
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   // Background message handler
//   static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
//     print("Background Notification: ${message.notification?.title}");
//     PushNotificationService()._showLocalNotification(message);
//     // You can trigger the local notification here as well
//   }
// }

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Map payload = {};
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Your Message")),
      body: Center(child: Text(payload.toString())),
    );
  }
}
