import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/constants/data_base_constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/service/notification_service.dart';

class AccidentReportsScreen extends StatelessWidget {
  const AccidentReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const AdminNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                // Use a reverse/back icon
                icon: const Icon(Icons.reply, // Updated icon
                    color: Color.fromARGB(255, 8, 8, 8),
                    size: 30),
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Background header area
            Container(
              height: 150,
              color: AppConstants.primaryColor,
              child: Center(
                child: Text(
                  S.of(context).accidentReports,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildAccidentReportsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of accident reports using StreamBuilder
  Widget _buildAccidentReportsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(DataBaseConstants.accidents)
          .where('status', isEqualTo: 'Pending') // Filter for pending accidents
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No accident reports available.'));
        }

        var accidents = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: accidents.length,
          itemBuilder: (context, index) {
            var accident = accidents[index];
            return _buildAccidentCard(context, accident);
          },
        );
      },
    );
  }

  Widget _buildAccidentCard(
      BuildContext context, QueryDocumentSnapshot accident) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accident['location'] ?? 'Unknown Location',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Description:',
                accident['description'] ?? 'No description provided',
              ),
              _buildDetailRow(
                'Reported:',
                _timeSinceReported(accident['date']),
              ),
              // _buildDetailRow(
              //   'Reported by:',
              //   accident['userName'] ?? 'Unknown User',
              // ),
              _buildDetailRow(
                'Status:',
                accident['status'] ?? 'Unknown Status',
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _approveAccident(accident);
                    },
                    child: Text(S.of(context).approve),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _deleteAccident(accident);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 236, 35, 24),
                    ),
                    child: Text(S.of(context).delete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Approves an accident and notifies users in the same city
  Future<void> _approveAccident(QueryDocumentSnapshot accident) async {
    await FirebaseFirestore.instance
        .collection(DataBaseConstants.accidents)
        .doc(accident.id)
        .update({
      'status': 'Approved',
      'isApproved': true
    }); // Mark as approved in DB

    // Notify users in the same city
    _notifyUsersInCity(accident['location'], accident['description']);
  }

  /// Deletes an accident report from Firebase
  Future<void> _deleteAccident(QueryDocumentSnapshot accident) async {
    await FirebaseFirestore.instance
        .collection(DataBaseConstants.accidents)
        .doc(accident.id)
        .delete();
  }

  Future<void> _notifyUsersInCity(String? city, String? description) async {
    if (city == null || description == null) return;

    final notificationService = NotificationService();

    try {
      AuthService auth = AuthService();
      String cityInEnglish = auth.convertCityToEnglish(city);

      // Initialize with the user's city topic
      await notificationService.initialize();

      // // Show notification locally for the current user
      // await notificationService.showNotification(
      //   cityInEnglish,
      //   'Accident in $city',
      //   description,
      // );

      // Send notification to users subscribed to the city topic
      await notificationService.sendTopicNotification(
        cityInEnglish,
        'Accident in $city',
        description,
      );
    } catch (e) {
      print('Error notifying users: $e');
    }
  }

  /// Helper method to calculate time since the accident was reported
  String _timeSinceReported(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown Time';

    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Helper method to build a row with a bold label and the value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
