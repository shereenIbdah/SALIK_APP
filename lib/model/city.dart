class City {
  String id; // Document ID
  String name;
  List<String> neighbors; // Store neighboring cities

  City({
    required this.id,
    required this.name,
    required this.neighbors,
  });

  // Convert City to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'neighbors': neighbors,
    };
  }

  // Create City from a Map
  factory City.fromMap(Map<String, dynamic> map, String id) {
    return City(
      id: id,
      name: map['city_name'],
      neighbors: List<String>.from(map['neighbors'] ?? []),
    );
  }
}
