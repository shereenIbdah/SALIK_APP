import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/data_base_constants.dart';
import 'package:grad_app/model/city.dart';

class CityService {
  final CollectionReference _citiesCollection =
      FirebaseFirestore.instance.collection(DataBaseConstants.cities);

  Future<List<City>> getAllCities() async {
    try {
      QuerySnapshot querySnapshot = await _citiesCollection.get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> cityData = doc.data() as Map<String, dynamic>;
        cityData['id'] = doc.id; // Add cityId from document ID
        return City.fromMap(cityData, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<List<City>> getFilteredCitiesAndNeighborsByCityNames(Set<String> namesOfCities) async {
    try {
      QuerySnapshot querySnapshot = await _citiesCollection
          .where('neighbors', arrayContainsAny: namesOfCities)
          .get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> cityData = doc.data() as Map<String, dynamic>;
        cityData['id'] = doc.id; // Add cityId from document ID
        return City.fromMap(cityData, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<List<String>> getCitiesName() async {
    try {
      QuerySnapshot querySnapshot = await _citiesCollection.get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> cityData = doc.data() as Map<String, dynamic>;
        return cityData['city_name'] as String; // Return only the city name
      }).toList();
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }
}
