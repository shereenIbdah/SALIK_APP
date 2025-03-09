import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/constants/data_base_constants.dart';
import 'package:grad_app/user/guest_nav_bar.dart';
import 'package:grad_app/user/user_nav_bar.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/service/auth_service.dart'; // Make sure to import AuthService

class UserApprovedAccidentsScreen extends StatefulWidget {
  const UserApprovedAccidentsScreen({super.key});

  @override
  _UserApprovedAccidentsScreenState createState() =>
      _UserApprovedAccidentsScreenState();
}

class _UserApprovedAccidentsScreenState
    extends State<UserApprovedAccidentsScreen> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
  }

  Future<void> _initializeUserRole() async {
    // Retrieve user role using AuthService
    String? role = await AuthService().getUserRole();

    // Update the state with the retrieved role
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: userRole == 'admin'
            ? const AdminNavBar() // Show AdminNavBar for admin
            : userRole == 'user'
                ? const UserNavBar() // Show UserNavBar for regular user
                : const GuestNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30,
                ), // Menu icon
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Background color and header area
            Container(
              height: 100,
              color: AppConstants.primaryColor,
              child: Center(
                child: Text(
                  S.of(context).accidentNews,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                  ),
                ),
              ),
            ),
            Expanded(
              // Make the list scrollable
              child: _buildApprovedAccidentsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of approved accidents using StreamBuilder
  Widget _buildApprovedAccidentsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(DataBaseConstants.accidents)
          .where('status', isEqualTo: 'Approved')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No approved accidents available.'));
        }

        var accidents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: accidents.length,
          itemBuilder: (context, index) {
            var accident = accidents[index];
            return _buildAccidentCard(accident);
          },
        );
      },
    );
  }

  /// Builds the card for an individual accident report
  Widget _buildAccidentCard(QueryDocumentSnapshot accident) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                "",
                accident['description'] ?? 'No description provided',
              ),
              _buildDetailRow(
                S.of(context).ReportedAt,
                _timeSinceReported(accident['date']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to calculate time since the accident was reported
  String _timeSinceReported(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown Time';

    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
