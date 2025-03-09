import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/data_base_constants.dart';
import 'package:grad_app/model/checkpoint.dart';

class CheckpointService {
  final CollectionReference _checkpointsCollection =
      FirebaseFirestore.instance.collection(DataBaseConstants.checkpoints);

  Future<String> addCheckpoint(Checkpoint checkpoint) async {
    try {
      DocumentReference docRef =
          await _checkpointsCollection.add(checkpoint.toMap());
      return docRef.id; // Return the document ID
    } catch (e) {
      throw Exception('Error adding checkpoint: $e');
    }
  }

  Future<String?> findCheckpointByName(String checkpointName) async {
    try {
      QuerySnapshot querySnapshot = await _checkpointsCollection
          .where('name', isEqualTo: checkpointName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the ID of the first matching checkpoint
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error finding checkpoint by name: $e');
    }
  }

  Future<String> findCheckpointStatusByName(String checkpointName) async {
    try {
      QuerySnapshot querySnapshot = await _checkpointsCollection
          .where('name', isEqualTo: checkpointName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the ID of the first matching checkpoint
        return (querySnapshot.docs.first.data()! as Map<String, dynamic>) ['status'];
      } else {
        return "Unknown";
      }
    } catch (e) {
      throw Exception('Error finding checkpoint by name: $e');
    }
  }

  /// Fetch all checkpoints from the `checkpoints` collection.
  Future<List<Checkpoint>> getAllCheckpoints() async {
    try {
      QuerySnapshot querySnapshot = await _checkpointsCollection.get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> checkpointData =
            doc.data() as Map<String, dynamic>;
        checkpointData['id'] = doc.id; // Add checkpointId from document ID
        return Checkpoint.fromMap(checkpointData, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching checkpoints: $e');
    }
  }

  Future<List<Checkpoint>> getCheckpointsByType(String type) async {
    QuerySnapshot querySnapshot =
        await _checkpointsCollection.where('type', isEqualTo: type).get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> checkpointData = doc.data() as Map<String, dynamic>;
      checkpointData['id'] = doc.id;
      return Checkpoint.fromMap(checkpointData, doc.id);
    }).toList();
  }

  /// Fetches checkpoints of a specific type that are nearby a given city.
  Future<List<Checkpoint>> getCheckpointsByCitiesAndType({
    required Set<String> namesOfCities,
    required String type,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _checkpointsCollection
          .where('type', isEqualTo: type)
          .where('nearby_cities', arrayContainsAny: namesOfCities)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> checkpointData =
            doc.data() as Map<String, dynamic>;
        checkpointData['id'] = doc.id;
        return Checkpoint.fromMap(checkpointData, doc.id);
      }).toList();
    } catch (e) {
      throw Exception(
          'Error fetching checkpoints for cities "$namesOfCities" and type "$type": $e');
    }
  }
}
