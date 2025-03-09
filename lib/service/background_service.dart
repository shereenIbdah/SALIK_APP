import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/firebase/firebase_options.dart';
import 'package:grad_app/service/notification_service.dart';

/// Constants for configuration
const String notificationChannelId = "location_tracking_channel";
const String notificationChannelName = "Location Tracking";
const String firebaseCollectionName = "checkpoints-v2";

/// Background Service Manager
class BackgroundServiceManager {
  final FlutterBackgroundService _service = FlutterBackgroundService();
  static bool _firebaseInitialized = false;

  /// Initialize Firebase only once
  static Future<void> initializeFirebase() async {
    if (!_firebaseInitialized) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      _firebaseInitialized = true;
    }
  }

  /// Initialize background service
  Future<void> initialize() async {
    print("Initializing background service...");

    await initializeFirebase();

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        isForegroundMode: true, // Ensures it runs persistently
        autoStart: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
    );

    if (!await _service.isRunning()) {
      await _service.startService();
    }
  }

  /// Handle iOS background service
  bool _onIosBackground(ServiceInstance service) {
    return true;
  }

  /// Main background service function
  static void _onStart(ServiceInstance service) async {
    print('Background service started!');

    await initializeFirebase();

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (service is AndroidServiceInstance &&
          !(await service.isForegroundService())) {
        return;
      }

      print('Checking location...');

      try {
        if (!(await _ensureLocationPermission())) {
          print('Location permission not granted. Stopping timer.');
          timer.cancel();
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        print(
            'User location: Latitude ${position.latitude}, Longitude ${position.longitude}');

        List<Map<String, dynamic>> checkpoints =
            await _fetchCheckpointsFromFirebase();

        bool checkpointFound = false; // Flag to check if a checkpoint is found

        for (var checkpoint in checkpoints) {
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            checkpoint['latitude'],
            checkpoint['longitude'],
          );

          if (distance <= 1000) {
            print(
                'Nearby checkpoint found: ${checkpoint['name']}, the status is ${checkpoint['status']}');

            final notificationService = NotificationService();
            await notificationService.initialize();
            await notificationService.sendTopicNotification(
              'admin',
              ' انت بالقرب من حاجز ${checkpoint['name']}',
              'الحالة : سالك',
            );
            checkpointFound = true; // Set flag to true if a checkpoint is found
            break;
          }
        }

        // If no checkpoint is found within 1 km, print a message
        if (!checkpointFound) {
          print('No nearby checkpoints within 1 km.');
        }
      } catch (e) {
        print('Error in background service: $e');
      }
    });
  }

  /// Ensure location permission is granted
  static Future<bool> _ensureLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      print('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  /// Fetch checkpoints from Firebase
  static Future<List<Map<String, dynamic>>>
      _fetchCheckpointsFromFirebase() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(firebaseCollectionName)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'latitude': doc['latitude'],
                'longitude': doc['longitude'],
              })
          .where((checkpoint) =>
              checkpoint['latitude'] != 0.01 && checkpoint['longitude'] != 0.01)
          .toList();
    } catch (e) {
      print('Error fetching checkpoints: $e');
      return [];
    }
  }
}
