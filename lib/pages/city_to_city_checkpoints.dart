import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/pages/road_popup.dart';
import 'package:grad_app/pages/route_node.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/service/route_service.dart';
import 'package:grad_app/user/guest_nav_bar.dart';
import 'package:grad_app/user/user_nav_bar.dart'; // Assuming you have a user nav bar
import 'package:grad_app/generated/l10n.dart';

import '../service/route/city_route_finder.dart';

class CityToCityCheckpoints extends StatefulWidget {
  const CityToCityCheckpoints({super.key});

  @override
  _CityToCityCheckpointsState createState() => _CityToCityCheckpointsState();
}

class _CityToCityCheckpointsState extends State<CityToCityCheckpoints> {
  String? fromCity; // Selected "From" city
  String? toCity; // Selected "To" city
  String? userRole; // User role
  bool isLoading = false;
  bool showRoads = false; // Whether to show the route cards
  late List<Path> paths;
  int maxPathsToShow = 5;
  late RouteService routeService;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
    _initializeUserRole();
  }

  Future<void> _fetchAllData() async {
    CityRouteFinder cityRouteFinder = CityRouteFinder();
    await cityRouteFinder.populateCityData();
    routeService = RouteService(cityRouteFinder);
    print("Roads Initialization Done");
  }

  Future<void> _initializeUserRole() async {
    String? role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  Future<void> _fetchCheckpoints() async {
    if (isLoading) return; // Prevent multiple simultaneous clicks

    setState(() {
      isLoading = true; // Start loading
      paths = [];
      showRoads = false;
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text(
    //       'هذه العملية تأخد بعض الوقت الرجاء الانتظار',
    //       textDirection: TextDirection.rtl,
    //     ),
    //   ),
    // );

    List<Path> bestPaths = [];
    if (fromCity == null || toCity == null) {
      setState(() {
        isLoading = false; // Stop loading if validation fails
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار المدن',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    } else {
      try {
        bestPaths = await routeService.computeBestPaths(
            fromCity.toString(), toCity.toString(), maxPathsToShow);

        setState(() {
          paths = bestPaths;
          showRoads = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Stop loading after data fetch
        });
      }
    }
  }

  Widget _buildRoadCard(BuildContext context, Path road, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              index == 0 ? S.of(context).bestWay : S.of(context).anotherWay,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '${(road.safetyPercentage * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Text(
              S.of(context).pressoncity,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoadDetailsView(
              roadDetails: List<Node>.from(road.route),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String hint, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: AppConstants.cities.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(
            city,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: userRole == 'admin'
            ? const AdminNavBar()
            : userRole == 'user'
                ? const UserNavBar()
                : const GuestNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
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
        ),
        body: Stack(
          children: [
            Container(
              height: 150,
              color: AppConstants.primaryColor,
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        S.of(context).checkpointBetweenCities,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                S.of(context).selectCityToExit,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildDropdown(S.of(context).adaptedcity, fromCity,
                                (value) {
                              setState(() {
                                fromCity = value;
                              });
                            }),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                S.of(context).selectCityToEnter,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildDropdown(
                                S.of(context).destinationCity, toCity, (value) {
                              setState(() {
                                toCity = value;
                              });
                            }),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shadowColor: Colors.black.withOpacity(0.3),
                                  elevation: 5,
                                ),
                                onPressed: isLoading ? null : _fetchCheckpoints,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        S.of(context).displayCheckpoints,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    20), // Add space between the button and the card
                            if (isLoading)
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    S.of(context).wait,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),
                            if (showRoads)
                              ...paths.asMap().entries.map((entry) {
                                return _buildRoadCard(
                                    context, entry.value, entry.key);
                              }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
