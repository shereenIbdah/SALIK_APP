import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/user/user_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:math';

class NewsAndStatisticsScreen extends StatefulWidget {
  const NewsAndStatisticsScreen({super.key});

  @override
  _NewsAndStatisticsScreenState createState() =>
      _NewsAndStatisticsScreenState();
}

class _NewsAndStatisticsScreenState extends State<NewsAndStatisticsScreen> {
  String? userRole;
  List<Map<String, dynamic>> recentAccidents = [];
  List<Map<String, dynamic>> nearestCheckpoints = [];
  int totalCheckpoints = 300;
  int cityCheckpoints = 60;
  bool isLoading = true;

  Future<void> _initializeUserRole() async {
    String? role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchCheckpointStatistics(),
      _fetchNearestCheckpoints(),
      _fetchRecentAccidents()
    ]);
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _fetchRecentAccidents() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('accidents')
  //       .orderBy('date', descending: true)
  //       .limit(3)
  //       .get();

  //   setState(() {
  //     recentAccidents = querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();
  //   });
  // }
  String? userCity; // Store user's city

  Future<void> _fetchUserCity() async {
    String? userId = await AuthService().getCurrentUserId(); // Get user ID
    if (userId == null) return;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        userCity = userDoc['location']; // Get city from Firestore
        print("User City: $userCity");
      });

      // Fetch accidents after getting the city
      _fetchRecentAccidents();
    }
  }

  Future<void> _fetchRecentAccidents() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('accidents')
        .orderBy('date', descending: true)
        .limit(5)
        .get();

    List<Map<String, dynamic>> allAccidents = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // Filter accidents based on user city
    List<Map<String, dynamic>> filteredAccidents = allAccidents
        .where((accident) => accident['location'] == userCity)
        .toList();

    setState(() {
      recentAccidents = filteredAccidents;
    });

    print("Filtered Accidents: ${recentAccidents.length}");
  }

  Future<void> _fetchCheckpointStatistics() async {
    setState(() {
      totalCheckpoints = 250;
      cityCheckpoints = 16;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
    _fetchUserCity(); // Fetch city before fetching accidents

    _requestLocationPermission();
  }

  // Future<void> _fetchNearestCheckpoints() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     double userLat = position.latitude;
  //     double userLon = position.longitude;
  //     print("User's Location: Latitude = $userLat, Longitude = $userLon");

  //     QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection('checkpoints-v2').get();

  //     List<Map<String, dynamic>> allCheckpoints = querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();

  //     allCheckpoints.sort((a, b) {
  //       double distanceA =
  //           _calculateDistance(userLat, userLon, a['latitude'], a['longitude']);
  //       double distanceB =
  //           _calculateDistance(userLat, userLon, b['latitude'], b['longitude']);
  //       return distanceA.compareTo(distanceB);
  //     });

  //     setState(() {
  //       nearestCheckpoints = allCheckpoints.take(3).toList();
  //     });
  //   } catch (e) {
  //     print("Error fetching location: $e");
  //   }
  // }
  Future<void> _fetchNearestCheckpoints() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double userLat = position.latitude;
      double userLon = position.longitude;
      print("User's Location: Latitude = $userLat, Longitude = $userLon");

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('checkpoints-v2').get();

      List<Map<String, dynamic>> allCheckpoints = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Convert latitude & longitude to double explicitly
        double lat = double.tryParse(data['latitude'].toString()) ?? 0.0;
        double lon = double.tryParse(data['longitude'].toString()) ?? 0.0;

        return {
          ...data,
          'latitude': lat,
          'longitude': lon,
        };
      }).toList();

      allCheckpoints.sort((a, b) {
        double distanceA =
            _calculateDistance(userLat, userLon, a['latitude'], a['longitude']);
        double distanceB =
            _calculateDistance(userLat, userLon, b['latitude'], b['longitude']);
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        nearestCheckpoints = allCheckpoints.take(3).toList();
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permission denied");
      return;
    }
    _fetchData();
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  Widget _buildButtonCard(String text, String status) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
      ),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            fontSize: 20,
            color: _getStatusColor(status),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'سالك':
        return Colors.green;
      case 'مغلق':
        return Colors.red;
      case 'أزمة شديدة':
        return Colors.orange;
      default:
        return const Color.fromARGB(166, 185, 105, 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        drawer: userRole == 'admin' ? const AdminNavBar() : const UserNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: screenHeight * 0.07,
                      width: screenWidth,
                      color: AppConstants.primaryColor,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).reports,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.insert_chart,
                            color: Colors.white,
                            size: screenWidth * 0.07,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dynamic image placement
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(16.0),
                    //   child: Image.asset(
                    //     'assets/images/news_image.png', // Replace with actual image
                    //     height: screenHeight * 0.3,
                    //     width: screenWidth * 0.9,
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: _buildButtonCard(
                                      "${S.of(context).totalNumberOfCheckpoints}$totalCheckpoints",
                                      " ")),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: _buildButtonCard(
                                      "${S.of(context).numOfCheclpointsInCity} $cityCheckpoints",
                                      "")),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              S.of(context).nearestCheckpoints,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...nearestCheckpoints.map(
                              (c) => _buildButtonCard(c['name'], c['status'])),
                          const SizedBox(height: 20),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     S.of(context).lastNews,
                          //     style: const TextStyle(
                          //         fontSize: 20, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          // ...recentAccidents.map((a) => _buildButtonCard(
                          //       "📍 المدينة: ${a.containsKey('city') ? a['city'] : a['location']}\n${a['description']}",
                          //       "",
                          //     )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              S.of(context).lastNews,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                          recentAccidents.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      "لا يوجد أخبار",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: recentAccidents
                                      .map((a) => _buildButtonCard(
                                            "📍 المدينة: ${a['location']}\n${a['description']}",
                                            "",
                                          ))
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
