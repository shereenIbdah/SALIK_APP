import 'package:cloud_firestore/cloud_firestore.dart';

class Checkpoint {
  String id; // Unique document reference
  String name;
  double latitude;
  double longitude;
  String status;
  String type;
  List<String> nearbyCities;
  final Timestamp? lastUpdated; // Optional DateTime field

  Checkpoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.type,
    required this.nearbyCities,
    this.lastUpdated,
  });

  // Convert Checkpoint to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'type': type,
      'nearby_cities': nearbyCities,
      'lastUpdated': lastUpdated,
    };
  }

  // Create Checkpoint from a Map
  factory Checkpoint.fromMap(Map<String, dynamic> map, String id) {
    return Checkpoint(
      id: id,
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
      type: map['type'],
      nearbyCities: List<String>.from(map['nearby_cities']),
      lastUpdated: map['lastUpdated'],
    );
  }
}
