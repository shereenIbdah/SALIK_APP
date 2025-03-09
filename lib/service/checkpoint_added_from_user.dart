import 'package:cloud_firestore/cloud_firestore.dart';

class CheckpointAddFromUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPendingCheckpoint({
    required String checkpointName,
    required String checkpointDescription,
    required String checkpointLocation,
  }) async {
    try {
      // Prepare the data for Firestore
      Map<String, dynamic> data = {
        'name': checkpointName,
        'description': checkpointDescription, // Store description
        'location': checkpointLocation, // Store location
        'status': 'Pending', // Assuming the status is "Pending"
        'created_at': FieldValue.serverTimestamp(),
      };

      // Add to the "pending_checkpoints" collection
      await _firestore.collection('pending_checkpoints').add(data);
      print('Checkpoint added successfully to pending_checkpoints');
    } catch (e) {
      print('Error adding checkpoint: $e');
      rethrow; // Rethrow the error for further handling if needed
    }
  }
}
