import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/checkpoint_details.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/service/checkpoint_service.dart';
import 'package:grad_app/user/guest_nav_bar.dart';
import 'package:grad_app/user/user_nav_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StreatMapAPI extends StatefulWidget {
  const StreatMapAPI({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StreatMapAPIState createState() => _StreatMapAPIState();
}

class _StreatMapAPIState extends State<StreatMapAPI> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  List<Marker> checkpointMarkers = [];
  bool showCheckpoints = false;
  bool enableRouting = false;
  bool isYourPlaceSelected = false;
  List<String> filteredCheckpointNames = [];

  final TextEditingController searchController = TextEditingController();
  StreamSubscription<LocationData>? _locationSubscription;

  final String orsApiKey =
      '5b3ce3597851110001cf6248557a792fb13647e3927aace409fc955c';

  @override
  void dispose() {
    // Cancel the location subscription
    _locationSubscription?.cancel();

    // Dispose of the TextEditingController
    searchController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
    _getCurrentLocation();
  }

  String? userRole;

  Future<void> _initializeUserRole() async {
    // Retrieve user role using AuthService
    String? role = await AuthService().getUserRole();

    // Update the state with the retrieved role
    setState(() {
      userRole = role;
    });
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      currentLocation = null;
    }

    _locationSubscription =
        location.onLocationChanged.listen((LocationData newLocation) {
      if (mounted) {
        setState(() {
          currentLocation = newLocation;
        });
      }
    });
  }

  void _goToYourPlace(bool isSelected) {
    if (currentLocation != null) {
      final userLocation =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      mapController.move(userLocation, 15.0);

      setState(() {
        markers.removeWhere((marker) => marker.point == userLocation);
        if (isSelected) {
          markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: userLocation,
              builder: (BuildContext context) => const Icon(
                Icons.person_pin_circle,
                color: Color.fromARGB(255, 138, 86, 143),
                size: 40.0,
              ),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).unableToDetermineLocation)),
      );

      setState(() {
        isYourPlaceSelected = false;
      });
    }
  }

  Widget userMarkerBuilder() {
    return const Icon(
      Icons.person_pin_circle,
      color: Color.fromARGB(255, 138, 86, 143),
      size: 40.0,
    );
  }

  Future<void> _loadCheckpointsFromFirebase() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('checkpoints-v2').get();

      if (mounted) {
        setState(() {
          for (var doc in querySnapshot.docs) {
            final data = doc.data();
            if (data.containsKey('latitude') &&
                data.containsKey('longitude') &&
                data.containsKey('name') &&
                data.containsKey('status')) {
              final double latitude = data['latitude'];
              final double longitude = data['longitude'];
              final String name = data['name']; // Get the checkpoint name
              final String status = data['status']; // Get the checkpoint status

              // Skip adding marker if latitude or longitude is 0.01 (default value)
              if (latitude != 0.01 && longitude != 0.01) {
                _addCheckpointMarker(latitude, longitude, name, status);
              }
            }
          }
        });
      }
    } catch (e) {
      print("Error loading checkpoints: $e");
    }
  }

  void _addCheckpointMarker(
      double latitude, double longitude, String name, String status) {
    final checkpointMarker = Marker(
      width: 80.0, // Adjust width for text visibility
      height: 80.0, // Adjust height for text visibility
      point: LatLng(latitude, longitude),
      builder: (BuildContext context) => GestureDetector(
        onTap: () {
          // Display the checkpoint name when marker is tapped
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).checkpoint(name)),
              duration: const Duration(milliseconds: 1500),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder<String?>(
                future: CheckpointService().findCheckpointByName(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(
                        child: Text('Error loading checkpoint details'));
                  } else {
                    return CheckpointDetails(
                      checkpointName: name,
                      checkpointId: snapshot.data!,
                    );
                  }
                },
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(
              Icons.location_on,
              color: _getStatusColor(status), // Set color based on status
              size: 50.0,
            ),
            Positioned(
              top: 40, // Adjust position to place text below the icon
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      markers.add(checkpointMarker);
      checkpointMarkers.add(checkpointMarker);
    });
  }

// Function to get color based on checkpoint status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'سالك': // Clear road
        return Colors.green;
      case 'مغلق': // Closed road
        return Colors.red;
      case 'أزمة شديدة': // Heavy traffic
        return const Color.fromARGB(255, 133, 81, 3);
      case 'أزمة خفيفة': // Light traffic
        return const Color.fromARGB(255, 238, 149, 16);
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  void _removeCheckpointMarkers() {
    setState(() {
      for (var marker in checkpointMarkers) {
        markers.remove(marker);
      }
      checkpointMarkers.clear();
    });
  }

  void _toggleCheckpoints(bool value) {
    if (value) {
      _loadCheckpointsFromFirebase();
    } else {
      _removeCheckpointMarkers();
    }
  }

  void _addDestinationMarker(LatLng point) {
    setState(() {
      // Remove any existing destination marker
      markers.removeWhere((marker) =>
          marker.builder(context).key == const ValueKey('destinationMarker'));
      markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: point,
          builder: (BuildContext context) => Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40.0,
            key: const ValueKey('destinationMarker'),
          ),
        ),
      );

      // Clear the previous route points
      routePoints.clear();
    });

    // Fetch and display the route to the new marker
    // _getRoute(point);
  }

  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;

    // Get the start point from the user's current location
    final start =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

    try {
      // Make a GET request to the OpenRouteService API
      final response = await http.get(
        Uri.parse(
            'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
      );

      if (response.statusCode == 200) {
        // Parse the API response
        final data = json.decode(response.body);

        // Extract the route coordinates
        final List<dynamic> coords =
            data['features'][0]['geometry']['coordinates'];

        setState(() {
          // Convert the coordinates to LatLng and save them to routePoints
          routePoints =
              coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        });
      } else {
        // Handle errors from the API
        print('Failed to fetch route: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error fetching route: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching route')),
      );
    }
  }

  Future<void> _searchCheckpoint(String checkpointName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('checkpoints-v2')
          .where('name', isEqualTo: checkpointName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];

        // Check if latitude and longitude are not the default value
        if (latitude != 0.01 && longitude != 0.01) {
          final LatLng checkpointLocation = LatLng(latitude, longitude);
          _addCheckpointMarker(
              latitude, longitude, checkpointName, data['status']);

          // Zoom to the checkpoint location
          mapController.move(checkpointLocation, 15.0);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).movedToCheckpoint(checkpointName))),
          );

          // Clear the suggestions list
          setState(() {
            filteredCheckpointNames.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).checkpointNotFound)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).checkpointNotFound)),
        );
      }
    } catch (e) {
      print("Error searching checkpoint: $e");
    }
  }

  Future<void> _fetchAndFilterCheckpointNames(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('checkpoints-v2')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        filteredCheckpointNames = querySnapshot.docs
            .where((doc) {
              final data = doc.data();
              final double latitude = data['latitude'];
              final double longitude = data['longitude'];

              // Filter out checkpoints with latitude or longitude equal to the default value (0.01)
              return latitude != 0.01 && longitude != 0.01;
            })
            .map((doc) => doc.data()['name'] as String)
            .toList();
      });
    } catch (e) {
      print('Error fetching checkpoint names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      drawer: userRole == 'admin'
          ? const AdminNavBar()
          : userRole == 'user'
              ? const UserNavBar()
              : const GuestNavBar(),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu,
                  color: Color.fromARGB(255, 8, 8, 8), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(S.of(context).mapTitle),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: const LatLng(31.5, 35.1),
                      zoom: 10.0,
                      maxZoom: 18.0,
                      minZoom: 6.0,
                      onTap: (tapPosition, point) {
                        _addDestinationMarker(point);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                            ),
                            title: Row(
                              children: [
                                Image.asset('assets/images/pin.png',
                                    width: screenWidth * 0.08,
                                    height: screenWidth * 0.08),
                                SizedBox(width: screenWidth * 0.03),
                                SizedBox(width: screenWidth * 0.03),
                                Text(
                                  S.of(context).SetDestination,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.05),
                                ),
                              ],
                            ),
                            // content: Text(
                            //   S.of(context).destinationConfirmation,
                            //   style: TextStyle(fontSize: screenWidth * 0.04),
                            // ),
                            // actions: [
                            //   TextButton(
                            //     style: TextButton.styleFrom(
                            //       foregroundColor: Colors.white,
                            //       backgroundColor: Colors.green,
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: screenWidth * 0.05,
                            //           vertical: screenHeight * 0.015),
                            //     ),
                            //     onPressed: () {
                            //       Navigator.of(context).pop();
                            //       _getRoute(point);
                            //     },
                            //     child: Text(S.of(context).getRoute,
                            //         style: TextStyle(
                            //             fontSize: screenWidth * 0.04)),
                            //   ),
                            //   TextButton(
                            //     style: TextButton.styleFrom(
                            //       foregroundColor: Colors.white,
                            //       backgroundColor: Colors.red,
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: screenWidth * 0.05,
                            //           vertical: screenHeight * 0.015),
                            //     ),
                            //     onPressed: () {
                            //       setState(() {
                            //         markers.removeWhere(
                            //             (marker) => marker.point == point);
                            //       });
                            //       Navigator.of(context).pop();
                            //     },
                            //     child: Text(S.of(context).RemoveMarker,
                            //         style: TextStyle(
                            //             fontSize: screenWidth * 0.04)),
                            //   ),
                            content: Text(
                              S.of(context).destinationConfirmation,
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Even spacing between buttons
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05,
                                          vertical: screenHeight * 0.015),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _getRoute(point);
                                    },
                                    child: Text(
                                      S.of(context).getRoute,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05,
                                          vertical: screenHeight * 0.015),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        markers.removeWhere(
                                            (marker) => marker.point == point);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      S.of(context).RemoveMarker,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: markers,
                      ),
                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              strokeWidth: screenWidth * 0.01,
                              color: const Color.fromARGB(255, 9, 131, 15),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      _fetchAndFilterCheckpointNames(query);
                    } else {
                      setState(() {
                        filteredCheckpointNames.clear();
                        FocusScope.of(context).unfocus();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: S.of(context).searchCheckpoint,
                    hintText: S.of(context).enterCheckpointName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final checkpointName = searchController.text.trim();
                        if (checkpointName.isNotEmpty) {
                          _searchCheckpoint(checkpointName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(S.of(context).enterValidName)),
                          );
                        }
                      },
                    ),
                  ),
                ),
                if (filteredCheckpointNames.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.25),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCheckpointNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredCheckpointNames[index]),
                          onTap: () {
                            searchController.text =
                                filteredCheckpointNames[index];
                            _searchCheckpoint(filteredCheckpointNames[index]);
                            setState(() {
                              filteredCheckpointNames.clear();
                            });
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Row(
              children: [
                Expanded(
                  child: _buildRoundedButton(
                    imagePath: 'assets/images/my_location.png',
                    label: S.of(context).yourPlace,
                    onTap: () {
                      setState(() {
                        isYourPlaceSelected = !isYourPlaceSelected;
                      });
                      _goToYourPlace(isYourPlaceSelected);
                    },
                    isSelected: isYourPlaceSelected,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: _buildRoundedButton(
                    imagePath: 'assets/images/checkpoint.png',
                    label: S.of(context).showAllCheckpoints,
                    onTap: () {
                      setState(() {
                        showCheckpoints = !showCheckpoints;
                        _toggleCheckpoints(showCheckpoints);
                      });
                    },
                    isSelected: showCheckpoints,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015,
            horizontal: MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    Color.fromARGB(255, 116, 187, 219),
                    Color.fromARGB(255, 72, 149, 182)
                  ]
                : [backgroundColor, backgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color.fromARGB(255, 248, 248, 248)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 30, height: 30),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Text(label,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
