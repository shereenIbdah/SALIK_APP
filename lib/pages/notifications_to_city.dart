import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsInterface extends StatefulWidget {
  const NotificationsInterface({super.key});

  @override
  _NotificationsInterfaceState createState() => _NotificationsInterfaceState();
}

class _NotificationsInterfaceState extends State<NotificationsInterface> {
  // Map to manage city notifications
  final Map<String, bool> _cityNotifications = {};

  String? _userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch user ID
  }

  // Fetch the current user ID (or any unique identifier for the user)
  Future<void> _getUserId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      _userId = userId;
    });
    _loadNotificationPreferences();
  }

  // Load saved notification preferences from SharedPreferences
  void _loadNotificationPreferences() async {
    if (_userId == null) return; // If user is not yet set, exit

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var city in AppConstants.cities) {
        // Load preferences using a unique key that includes userId
        _cityNotifications[city] = prefs.getBool('$_userId-$city') ?? false;
      }
    });
  }

  // Save notification preferences to SharedPreferences
  void _saveNotificationPreferences(String city) async {
    if (_userId == null) return; // If user is not yet set, exit

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('$_userId-$city',
        _cityNotifications[city]!); // Save preferences with user ID
  }

  void _toggleNotification(String city) {
    setState(() {
      _cityNotifications[city] = !_cityNotifications[city]!;
    });
    _saveNotificationPreferences(city); // Save the updated notification status

    // Logic for subscribing/unsubscribing
    AuthService auth = AuthService();
    String cityInEnglish = auth.convertCityToEnglish(city);
    if (_cityNotifications[city]!) {
      auth.subscribeToTopic(cityInEnglish);
    } else {
      auth.unsubscribeFromTopic(cityInEnglish);
    }
  }

  Widget _buildCityTile(BuildContext context, {required String cityName}) {
    // Get the value of the notification state, default to false if null
    bool isEnabled = _cityNotifications[cityName] ?? false;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.grey[200],
      leading: IconButton(
        icon: Icon(
          isEnabled ? Icons.notifications_active : Icons.notifications_off,
          size: 30,
          color: isEnabled ? Colors.green : Colors.grey,
        ),
        onPressed: () => _toggleNotification(cityName),
      ),
      title: Text(
        cityName,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              height: 150,
              color: AppConstants.primaryColor,
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'المدن التي ترغب في تلقي الإشعارات عنها',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: AppConstants.cities.map((city) {
                            return Column(
                              children: [
                                _buildCityTile(context, cityName: city),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
