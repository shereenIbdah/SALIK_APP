import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/constants/data_base_constants.dart';

class CheckpointReportsScreen extends StatelessWidget {
  const CheckpointReportsScreen({super.key});

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
                  'Checkpoint Reports', // Static text for title
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
              child: _buildCheckpointReportsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of checkpoint reports using StreamBuilder
  Widget _buildCheckpointReportsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('pending_checkpoints') // Fetch checkpoints
          .where('status',
              isEqualTo: 'Pending') // Filter for pending checkpoints
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No checkpoint reports available.'));
        }

        var checkpoints = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: checkpoints.length,
          itemBuilder: (context, index) {
            var checkpoint = checkpoints[index];
            return _buildCheckpointCard(context, checkpoint);
          },
        );
      },
    );
  }

  Widget _buildCheckpointCard(
      BuildContext context, QueryDocumentSnapshot checkpoint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for a modern look
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkpoint Title
              Row(
                children: [
                  Text(
                    'اسم الحاجز: ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    checkpoint['name'] ?? 'Unknown Name',
                    style: const TextStyle(
                      fontSize: 20, // Larger font size for the title
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Description Section
              Text(
                checkpoint['description'] ?? 'No description available.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black, // Lighter color for description
                ),
              ),
              const SizedBox(height: 12),
              // Location Section
              Row(
                children: [
                  Text(
                    ' الموقع:  ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    checkpoint['location'] ?? 'No cities provided',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Status Section
              Row(
                children: [
                  // Text(
                  //   'Status: ',
                  //   style: const TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   checkpoint['status'] ?? 'Unknown Status',
                  //   style: const TextStyle(
                  //     color: Colors.black, // Color for active status
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _approveCheckpoint(checkpoint);
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _deleteCheckpoint(checkpoint);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // /// Approves a checkpoint and notifies users in the same city
  // Future<void> _approveCheckpoint(QueryDocumentSnapshot checkpoint) async {
  //   await FirebaseFirestore.instance
  //       .collection('pending_checkpoints')
  //       .doc(checkpoint.id)
  //       .update({
  //     'status': 'Approved',
  //     'isApproved': true
  //   });

  // }
  Future<void> _approveCheckpoint(QueryDocumentSnapshot checkpoint) async {
    try {
      // Mark as approved in the 'pending_checkpoints' collection
      await FirebaseFirestore.instance
          .collection(DataBaseConstants.pendingCheckpoints)
          .doc(checkpoint.id)
          .update({
        'status': 'Approved',
        'isApproved': true,
      });

      // Now add to the 'checkpoints-v2' collection with necessary attributes
      await FirebaseFirestore.instance
          .collection('checkpoints-v2')
          .doc(checkpoint.id)
          .set({
        'latitude': 0.01, // Default to 0.0 if null
        'longitude': 0.01, // Default to 0.0 if null
        'status': 'سالك',
        'name': checkpoint['name'],
        'type': checkpoint['type'],
        'nearby_cities': checkpoint['nearby_cities'],
      });
    } catch (e) {
      print('Error approving checkpoint: $e');
    }
  }

  /// Deletes a checkpoint report from Firebase
  Future<void> _deleteCheckpoint(QueryDocumentSnapshot checkpoint) async {
    await FirebaseFirestore.instance
        .collection('pending_checkpoints')
        .doc(checkpoint.id)
        .delete();
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
