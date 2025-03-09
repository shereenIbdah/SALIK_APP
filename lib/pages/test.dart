import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/data_base_constants.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double _currentPage = 0.0;
  String userName = "User"; // Default value
  final Color primaryColor = Color.fromARGB(255, 79, 131, 82);

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user's location
  Future<String> getUserLocation() async {
    try {
      // Fetch user data based on their user ID (email in this case)
      var userSnapshot = await _firestore.collection('users').get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        return userDoc['location']; // Assuming the field name is "location"
      } else {
        return ''; // Return empty string if no user found
      }
    } catch (e) {
      print("Error fetching user location: $e");
      return '';
    }
  }

  // Fetch statistics including number of checkpoints based on user's location
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      // Get the user's location
      String userLocation = await getUserLocation();
      if (userLocation.isEmpty)
        return {
          'checkpointsCount': 0,
          'closedCheckpointsPercentage': '0',
          'accidentsCount': 0,
        };

      // Get the checkpoints collection filtered by user's location
      var checkpointsSnapshot = await _firestore
          .collection('checkpoints')
          .where('nearby_cities',
              arrayContains: userLocation) // Filter by user's location
          .get();
      var checkpointsCount = checkpointsSnapshot.docs.length;

      // Get the accidents collection
      var accidentsSnapshot = await _firestore.collection('accidents').get();
      var accidentsCount = accidentsSnapshot.docs.length;

      // Calculate the percentage of closed checkpoints
      var closedCheckpointsCount = checkpointsSnapshot.docs
          .where((doc) => doc['status'] == 'closed')
          .length;
      var closedPercentage = (closedCheckpointsCount / checkpointsCount) * 100;

      return {
        'checkpointsCount': checkpointsCount,
        'closedCheckpointsPercentage': closedPercentage.toStringAsFixed(1),
        'accidentsCount': accidentsCount,
      };
    } catch (e) {
      print("Error fetching statistics: $e");
      return {
        'checkpointsCount': 0,
        'closedCheckpointsPercentage': '0',
        'accidentsCount': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الواجهة الرئيسية',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getStatistics(), // Get statistics data from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            // Extract data from the snapshot
            final stats = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: primaryColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      'مرحبا بك ',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    subtitle: Text('هنا اخر الاخبار والاحصائيات.',
                        style: TextStyle(color: Colors.white70)),
                    leading: Icon(Icons.account_circle, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Text('الاحصائيات',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.6),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index.toDouble();
                      });
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final isCenter = index == _currentPage;
                      final scale = isCenter ? 1.2 : 0.9;

                      return Transform.scale(
                        scale: scale,
                        child: StatCard(
                          title: index == 0
                              ? 'عدد الحواجز في مدينتك'
                              : index == 1
                                  ? 'نسبة الحواجز المغلقة'
                                  : 'عدد الحوادث اليوم في مدينتك',
                          value: index == 0
                              ? stats['checkpointsCount'].toString()
                              : index == 1
                                  ? stats['closedCheckpointsPercentage'] + '%'
                                  : stats['accidentsCount'].toString(),
                          color: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text('اخر الاحداث',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                SizedBox(height: 10),
                ActivityCard(
                    activity: 'اقرب الحواجز عليك',
                    time: '',
                    color: primaryColor),
                ActivityCard(
                    activity: 'اخر الاخبار في مدينتك',
                    time: '',
                    color: primaryColor),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String activity;
  final String time;
  final Color color;

  ActivityCard(
      {required this.activity, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(activity,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        leading: Icon(Icons.access_time, color: color),
      ),
    );
  }
}
