import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:push_notifation/firebase_options.dart';
import 'dart:html' as html;

// Define a high-importance notification channel for Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // Unique ID for the channel
  'High Importance Notifications', // Channel name displayed to the user
  description: 'This channel is used for important notifications.', // Description for the channel
  importance: Importance.high, // Ensures high priority for notifications
  playSound: true, // Enables sound for notifications
);

// Create a plugin instance for local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();

// Background notification handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // This handler is called when the app is in the background or terminated
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  ); // Ensure Firebase is initialized
  print('Handling a background message: ${message.messageId}'); // Log the message ID

   // Extract notification and Android-specific data
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      
       if(kIsWeb)
      {
         debugPrint("message from web+++ in back");
        //  _showWebNotification(message.notification!.body.toString(),message.notification!.title.toString());
        
      }
      else{
        if (notification != null && android != null) {
        // Show the notification in the app
        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // Unique ID for the notification
          notification.title, // Notification title
          notification.body, // Notification body
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // Use the created channel ID
              channel.name, // Channel name
              channelDescription: channel.description, // Channel description
              importance: Importance.high, // High priority
              priority: Priority.high, // High priority
              playSound: true, // Enable sound
            ),
          ),
        );
      }
      }


      
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is fully initialized

   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Firebase.initializeApp(); // Initialize Firebase

  // Android-specific notification initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // App launcher icon for notifications

  // iOS/macOS-specific notification initialization settings
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(); // Basic iOS/macOS settings

  // Combine platform-specific initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, // Android settings
    iOS: initializationSettingsDarwin, // iOS settings
  );

  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings, // Pass the combined settings
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle notification clicks
      print('Notification clicked with payload: ${response.payload}');
    },
  );

  // Create the notification channel for Android
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>() // Get platform-specific implementation
 ?.createNotificationChannel(channel); // Create the notification channel

  // Set the background notification handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp()); // Start the Flutter application
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set up the MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'FCM', // Application title
      theme: ThemeData(primarySwatch: Colors.blue), // Set the app's theme
      home: const Messaging(), // Set the home screen
    );
  }
}

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  void initState() {
    super.initState();

    // Request notification permissions (iOS only)
    FirebaseMessaging.instance.requestPermission();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Extract notification and Android-specific data
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(kIsWeb)
      {
         debugPrint("message from web+++");
         _showWebNotification(message.notification!.body.toString(),message.notification!.title.toString());
        
      }
      else{
        if (notification != null && android != null) {
        // Show the notification in the app
        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // Unique ID for the notification
          notification.title, // Notification title
          notification.body, // Notification body
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // Use the created channel ID
              channel.name, // Channel name
              channelDescription: channel.description, // Channel description
              importance: Importance.high, // High priority
              priority: Priority.high, // High priority
              playSound: true, // Enable sound
            ),
          ),
        );
      }
      }

      
    });
    getFcmToken();
   
  }

  /// Show a web notification using the browser API
  void _showWebNotification(String title, String body) {
    if (html.Notification.supported) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(title, body: body);
        } else {
          debugPrint('Notification permission not granted.');
        }
      });
    } else {
      debugPrint('Browser does not support notifications.');
    }
  }

  // // to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
     debugPrint("here is web notifcation comming");
}

  static Future getFcmToken({int maxRetires=3})async{
   try {
    String? token;
      if(kIsWeb)
    {
      token= await FirebaseMessaging.instance.getToken(vapidKey: "BEq1rSlq5NyB0WIcY8DVaS8m9JXsHKKJ9KkBMXi8d4AnY34Szp-k6CzGtGEmHnWWH2MFCAE6Dod9vDwFpNm7EqA").then((token) {
        token=token;
      print('Web FCM Token: $token'); // Print the token to the console
    });
    }
    else{
       FirebaseMessaging.instance.getToken().then((token) {
      print('FCM Token: $token'); // Print the token to the console
    });
    }
    return token;
   } catch (e) {
     print("error in getting token $e");
     if(maxRetires>0){
      print("try after 10 seconds");
      await Future.delayed(Duration(seconds: 10));
      return getFcmToken(maxRetires: maxRetires-1);
     }
     else{
      return null;
     }
   }
  }

  @override
  Widget build(BuildContext context) {
    // Create the main UI of the Messaging screen
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')), // AppBar title
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            _sendLocalNotification(); // Trigger a local notification
          },
          child: const Text('Send Local Notification'), // Button label
        ),
      ),
    );
  }

  void _sendLocalNotification() async {
    // Define Android-specific notification details
    const AndroidNotificationDetails androidNotificationDetails =AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      channelDescription: 'This channel is used for important notifications.', // Description
      importance: Importance.high, // High priority
      priority: Priority.high, // High priority
      playSound: true, // Enable sound
    );

    // Combine platform-specific notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, // Android-specific settings
    );

    // Show the local notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Local Notification', // Notification title
      'This is a local notification body', // Notification body
      notificationDetails, // Notification details
    );
  }
}





// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:push_notifation/push_notification_example.dart';
// import 'package:push_notifation/pushnotification.dart';

// import 'firebase_options.dart';
// import 'home.dart';

// final navigatorKey = GlobalKey<NavigatorState>();

// // function to lisen to background changes
// Future _firebaseBackgroundMessage(RemoteMessage message) async {
  
//   if (message.notification != null) {
//     showNotification(body:  message.notification!.body!,title: message.notification!.title! );
//     print("Some notification Received");
//   }
// }

// // to handle notification on foreground on web platform
// void showNotification({required String title, required String body}) {
//   showDialog(
//     context: navigatorKey.currentContext!,
//     builder: (context) => AlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: [
//         TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Ok"))
//       ],
//     ),
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // on background notification tapped
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     if (message.notification != null) {
//       print("Background Notification Tapped");
//       navigatorKey.currentState!.pushNamed("/message", arguments: message);
//     }
//   });

//   PushNotifications.init();
//   // only initialize if platform is not web
//   if (!kIsWeb) {
//     PushNotifications.localNotiInit();
//   }
//   // Listen to background notifications
//   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

//   // to handle foreground notifications
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     String payloadData = jsonEncode(message.data);
//     print("Got a message in foreground");
//     if (message.notification != null) {
//       if (kIsWeb) {
//         showNotification(
//             title: message.notification!.title!,
//             body: message.notification!.body!);
//       } else {
//         PushNotifications.showSimpleNotification(
//             title: message.notification!.title!,
//             body: message.notification!.body!,
//             payload: payloadData);
//       }
//     }
//   });

//   // for handling in terminated state
//   final RemoteMessage? message =
//       await FirebaseMessaging.instance.getInitialMessage();

//   if (message != null) {
//     print("Launched from terminated state");
//     Future.delayed(Duration(seconds: 1), () {
//       navigatorKey.currentState!.pushNamed("/message", arguments: message);
//     });
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       title: 'Push Notifications',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       routes: {
//         '/': (context) => const HomePage(),
//         '/message': (context) => const Message()
//       },
//     );
//   }
// }