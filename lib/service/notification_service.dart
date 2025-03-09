import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grad_app/service/get_service_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> initialize() async {
    // Initialize local notifications
    // const AndroidInitializationSettings androidInitializationSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // const DarwinInitializationSettings iosInitializationSettings =
    //     DarwinInitializationSettings();

    // const InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: androidInitializationSettings,
    //   iOS: iosInitializationSettings,
    // );

    // await _flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (NotificationResponse response) {
    //     print('Notification clicked: ${response.payload}');
    //   },
    // );

    // Handle notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? topic = message.data['topic'];
      // Retrieve topic from notification payload

      if (topic != null) {
        bool isSubscribed = await checkSubscription(topic);
        if (isSubscribed) {
          print('the user is subscribed to $topic');
          await showNotification(
            topic,
            message.notification?.title ?? 'No Title',
            message.notification?.body ?? 'No Body',
          );
        }
      }
    });

    // Handle notifications when the app is in the background & clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Notification clicked when app in background: ${message.data}");
    });

    // Handle notifications when the app is terminated & opened by a notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          "🚀 App opened from terminated state by notification: ${initialMessage.data}");
    }
  }

  Future<void> showNotification(String topic, String title, String body) async {
    // Check if the user is subscribed to the topic
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subscribedTopics =
        prefs.getStringList('subscribed_topics') ?? [];

    if (!subscribedTopics.contains(topic)) {
      print('User is not subscribed to topic: $topic. Skipping notification.');
      return; // Do not show the notification
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id', // ID of the channel
      'channel_name', // Name of the channel
      channelDescription: 'This channel is for important notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Unique notification ID
      title, // Notification title
      body, // Notification body
      notificationDetails, // Notification details
    );

    print('Notification shown for topic: $topic');
  }

  // Send notification to a specific topic
  Future<void> sendTopicNotification(
      String topic, String title, String body) async {
    String serverKey = await GetServiceKey().getServerKeyToken();
    print('Server Key: $serverKey');

    try {
      // Prepare the payload for the topic
      final payload = {
        'message': {
          'topic': topic, // Send notification to the topic
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'topic': topic, // Add topic to the data for local checks
          },
        },
      };

      // Send the notification request to FCM
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/salikapp-5/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to topic: $topic');
      } else {
        print('Failed to send notification to topic $topic: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<bool> checkSubscription(String topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> topics = prefs.getStringList('subscribed_topics') ?? [];
    print('Subscribed topics: $topics');

    return topics.contains(topic);
  }
}
