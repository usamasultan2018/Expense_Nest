// import 'dart:math'; // Provides mathematical utilities, including random number generation.
// import 'package:firebase_messaging/firebase_messaging.dart'; // Used for Firebase Cloud Messaging (FCM) integration.
// import 'package:flutter/cupertino.dart'; // Provides Flutter widgets for iOS.
// import 'package:flutter/foundation.dart'; // Provides tools for debugging and common utilities.
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // For displaying local notifications in the app.

// class NotificationServices {
//   // Create an instance of FirebaseMessaging for FCM functionality.
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   // Create an instance of FlutterLocalNotificationsPlugin to manage local notifications.
//   final FlutterLocalNotificationsPlugin plugin =
//       FlutterLocalNotificationsPlugin();

//   // Requests permission for notifications from the user.
//   void requestNotificationPermission() async {
//     // Request notification permissions and store the result in `settings`.
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true, // Allow alert notifications.
//       announcement: true, // Allow announcement notifications.
//       badge: true, // Allow app badge updates.
//       carPlay: true, // Allow notifications in CarPlay.
//       criticalAlert: true, // Allow critical alerts.
//       provisional: true, // Allow provisional (quiet) notifications.
//       sound: true, // Allow sound notifications.
//     );

//     // Check the authorization status and log the result.
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission'); // User granted full permission.
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print(
//           'User granted provisional permission'); // User granted limited permission.
//     } else {
//       print('User denied permission'); // User denied all permissions.
//     }
//   }

//   // Initializes local notifications.
//   void initLocalNotification(
//       BuildContext context, RemoteMessage message) async {
//     // Specifies settings for Android notifications, such as the app icon.
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Combines platform-specific settings into a single initialization setting.
//     final InitializationSettings initializationSetting = InitializationSettings(
//       android: androidInitializationSettings,
//     );

//     // Initializes the local notification plugin with the settings.
//     await plugin.initialize(initializationSetting,
//         onDidReceiveBackgroundNotificationResponse: (payload) {
//       // Handles background notification responses (if needed).
//     });
//   }

//   // Initializes Firebase Messaging and listens for incoming messages.
//   void initializeFirebaseMessaging() {
//     // Listen for messages received while the app is in the foreground.
//     FirebaseMessaging.onMessage.listen((msg) {
//       if (kDebugMode) {
//         // Log the notification's title and body (for debugging).
//         print(msg.notification!.title.toString());
//         print(msg.notification!.body.toString());
//       }
//       // Show the notification using the `showNotification` method.
//       showNotification(msg);
//     });
//   }

//   // Displays a local notification for a received Firebase message.
//   Future<void> showNotification(RemoteMessage message) async {
//     // Create Android-specific notification details.
//     AndroidNotificationDetails channel = AndroidNotificationDetails(
//       Random.secure()
//           .nextInt(100000)
//           .toString(), // Generate a unique channel ID.
//       'High Important Notification', // The name of the notification channel.
//       importance:
//           Importance.max, // Maximum importance for high-priority notifications.
//     );

//     // Define details for the Android notification.
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.channelId, // Use the generated channel ID.
//       channel.channelName, // Use the provided channel name.
//       channelDescription:
//           "Your Are Description", // Provide a description for the channel.
//       priority:
//           Priority.high, // High priority to display notifications immediately.
//       importance: Importance.high, // High importance to ensure visibility.
//       ticker: 'ticker', // A short description for accessibility tools.
//       icon: '@mipmap/ic_launcher', // The app icon for the notification.
//     );

//     // Wrap Android notification details in a general notification configuration.
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails, // Specify Android-specific details.
//     );

//     // Use a delayed execution to display the notification.
//     Future.delayed(Duration.zero, () {
//       plugin.show(
//         1, // Notification ID, used to update or cancel specific notifications.
//         message.notification!.title.toString(), // Title of the notification.
//         message.notification!.body.toString(), // Body of the notification.
//         notificationDetails, // Details of the notification to display.
//       );
//     });
//   }

//   // Retrieves the current device token for FCM.
//   Future<String?> getDeviceToken() async {
//     messaging.getToken(); // Requests a new token.
//     return await messaging.getToken(); // Returns the current device token.
//   }

//   // Listens for token refresh events.
//   void isTokenRefresh() {
//     // Subscribe to the `onTokenRefresh` stream.
//     messaging.onTokenRefresh.listen((event) {
//       event.toString(); // Log the new token (for debugging or use in the app).
//       print('Token refreshed'); // Indicate that the token was refreshed.
//     });
//   }
// }
