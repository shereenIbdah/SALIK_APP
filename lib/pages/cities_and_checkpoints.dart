// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:grad_app/constants/constants.dart';
// import 'package:grad_app/service/auth_service.dart';
// import 'package:grad_app/model/checkpoint.dart';
// import 'package:grad_app/pages/checkpoint_details.dart';
// import 'package:grad_app/admin/admin_nav_bar.dart';
// import 'package:grad_app/service/city_service.dart';
// import 'package:grad_app/user/guest_nav_bar.dart';
// import 'package:grad_app/user/user_nav_bar.dart';
// import 'package:grad_app/service/checkpoint_service.dart';
// import 'package:grad_app/generated/l10n.dart';

// const kAppBarColor = Color.fromARGB(255, 29, 100, 33); // Dark green for AppBar
// const kBoxShadowColor = Color.fromARGB(255, 15, 20, 14); // Subtle shadow

// class CitiesAndCheckpoints extends StatefulWidget {
//   const CitiesAndCheckpoints({super.key});

//   @override
//   _CitiesAndCheckpointsState createState() => _CitiesAndCheckpointsState();
// }

// class _CitiesAndCheckpointsState extends State<CitiesAndCheckpoints> {
//   final CheckpointService _firebaseCheckpoint = CheckpointService();
//   final CityService _firebaseCity = CityService();
//   String _searchQuery = '';
//   List<String> _filteredCities = [];
//   late List<String> _allCities;
//   late List<Checkpoint> _allCheckpoints;
//   final Map<String, bool> _expandedCities =
//       {}; // Tracks expanded state for cities
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     _initializeUserRole();
//     _allCities = [];
//     _allCheckpoints = [];
//     _fetchAllData();
//   }

//   Future<void> _fetchAllData() async {
//     try {
//       final cities = await _firebaseCity.getCitiesName();
//       final checkpoints = await _firebaseCheckpoint.getAllCheckpoints();
//       setState(() {
//         _allCities = cities;
//         _allCheckpoints = checkpoints;
//         _filterCities();
//       });
//     } catch (e) {
//       // Handle errors if needed
//       print('Error fetching data: $e');
//     }
//   }

//   // void _filterCities() {
//   //   final query = _searchQuery.toLowerCase();

//   //   setState(() {
//   //     // Filter cities based on query
//   //     _filteredCities = _allCities.where((city) {
//   //       // Checkpoints whose first city in nearbyCities matches the current city
//   //       final cityCheckpoints = _allCheckpoints.where((checkpoint) {
//   //         final isFirstCityMatch = checkpoint.nearbyCities.isNotEmpty &&
//   //             checkpoint.nearbyCities[0].toLowerCase() == city.toLowerCase();

//   //         // Include checkpoints where the first city matches and query matches name
//   //         final checkpointNameMatches =
//   //             checkpoint.name.toLowerCase().contains(query);

//   //         return isFirstCityMatch && checkpointNameMatches;
//   //       }).toList();

//   //       // Update expanded state and return true if city has relevant checkpoints
//   //       if (cityCheckpoints.isNotEmpty) {
//   //         _expandedCities[city] = true; // Auto-expand for matches
//   //         return true;
//   //       }
//   //       return false;
//   //     }).toList();
//   //   });
//   // }
//   void _filterCities() {
//     final query = _searchQuery.toLowerCase();

//     setState(() {
//       // Filter cities based on query matching city names or checkpoint names
//       _filteredCities = _allCities.where((city) {
//         // Check if the city name contains the query
//         final cityMatches = city.toLowerCase().contains(query);

//         // Check if any checkpoint in this city contains the query
//         final checkpointMatches = _allCheckpoints.any((checkpoint) {
//           return checkpoint.name.toLowerCase().contains(query) &&
//               checkpoint.nearbyCities.isNotEmpty &&
//               checkpoint.nearbyCities[0].toLowerCase() == city.toLowerCase();
//         });

//         // Include the city if either condition is true
//         return cityMatches || checkpointMatches;
//       }).toList();
//     });
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       setState(() {
//         _searchQuery = query;
//         _filterCities();
//       });
//     });
//   }

//   String? userRole;

//   Future<void> _initializeUserRole() async {
//     // Retrieve user role using AuthService
//     String? role = await AuthService().getUserRole();

//     // Update the state with the retrieved role
//     setState(() {
//       userRole = role;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       drawer: userRole == 'admin'
//           ? const AdminNavBar() // Show AdminNavBar for admin
//           : userRole == 'user'
//               ? const UserNavBar() // Show UserNavBar for regular user
//               : const GuestNavBar(),
//       appBar: buildAppBar(screenSize),
//       body: Column(
//         children: [
//           buildSearchBar(screenSize),
//           Expanded(child: buildBody()),
//         ],
//       ),
//     );
//   }

//   AppBar buildAppBar(Size screenSize) {
//     return AppBar(
//       title: Align(
//         alignment: Alignment.centerRight, // Align title to the right
//         child: Text(
//           S.of(context).citiesAndCheckpoints,
//           textDirection: TextDirection.rtl, // Ensure text direction is RTL
//           style: TextStyle(
//             color: const Color.fromARGB(255, 255, 255, 255),
//             // fontSize: 25,
//             fontSize: screenSize.width * 0.07, // Responsive Title

//             fontWeight: FontWeight.bold, // Make the text bold
//           ),
//         ),
//       ),
//       leading: Builder(
//         builder: (BuildContext context) {
//           return IconButton(
//             icon: const Icon(Icons.menu,
//                 color: Color.fromARGB(255, 255, 255, 255), size: 30),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           );
//         },
//       ),
//       backgroundColor:
//           AppConstants.primaryColor, // Use primary color for AppBar
//       elevation: 0, // Remove AppBar shadow
//     );
//   }

//   Widget buildSearchBar(Size screenSize) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: screenSize.width * 0.05,
//           vertical: 15), // Adjusted padding
//       child: Container(
//         height: screenSize.height * 0.07, // Increased height
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               spreadRadius: 1,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: TextField(
//           onChanged: _onSearchChanged,
//           textAlign: TextAlign.right, // Align text to the right
//           decoration: InputDecoration(
//             hintText: S.of(context).searchForCityOrChckpoint,
//             hintTextDirection: TextDirection.rtl,
//             hintStyle: TextStyle(
//               color: Colors.grey, // Lightened text color for better readability
//               fontSize: screenSize.width * 0.05,
//             ),
//             prefixIcon: const Icon(
//               // Search icon inside text field (leading)
//               Icons.search,
//               color: Color.fromARGB(255, 46, 110, 33),
//               size: 28,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 15), // Centers text
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           style: TextStyle(
//             color: Colors.black, // Changed from white to black for visibility
//             fontSize: screenSize.width * 0.055,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildBody() {
//     if (_filteredCities.isEmpty) {
//       return const Center(
//         child: CircularProgressIndicator(), // Firebase-like loading spinner
//       );
//     }
//     return buildCityList(_filteredCities, context);
//   }

//   ListView buildCityList(List<String> cities, BuildContext context) {
//     return ListView.builder(
//       itemCount: cities.length,
//       itemBuilder: (context, index) {
//         final city = cities[index];
//         // Filter checkpoints where the city's name matches the first city in the nearbyCities list
//         final cityCheckpoints = _allCheckpoints.where((checkpoint) {
//           return checkpoint.nearbyCities.isNotEmpty &&
//               checkpoint.nearbyCities[0].toLowerCase() == city.toLowerCase();
//         }).toList();

//         // Pass the city and filtered checkpoints to the tile builder
//         return buildCityTile(city, cityCheckpoints, context);
//       },
//     );
//   }

//   Widget buildCityTile(
//       String city, List<Checkpoint> checkpoints, BuildContext context) {
//     return AnimatedContainer(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         // gradient: const LinearGradient(
//         //   begin: Alignment.topLeft,
//         //   end: Alignment.bottomRight,
//         //   colors: [kDarkGreen, kLightGreen],
//         // ),
//         color: const Color.fromARGB(255, 196, 199, 195),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(5, 5),
//           ),
//         ],
//       ),
//       duration: const Duration(milliseconds: 300),
//       child: ExpansionTile(
//         key: PageStorageKey(city), // Use city name as key
//         leading: Icon(Icons.location_city,
//             color: AppConstants.primaryColor, size: 30),
//         title: Text(
//           city, // Directly use city name
//           style: const TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 0, 0, 0),
//           ),
//           textDirection: TextDirection.rtl,
//         ),
//         onExpansionChanged: (expanded) {
//           setState(() {
//             _expandedCities[city] = expanded;
//           });
//         },
//         children: checkpoints
//             .map((checkpoint) => buildCheckpointTile(checkpoint, context))
//             .toList(),
//       ),
//     );
//   }

//   Widget buildCheckpointTile(Checkpoint checkpoint, BuildContext context) {
//     return ListTile(
//       title: Text(
//         checkpoint.name,
//         textDirection: TextDirection.rtl,
//         style: const TextStyle(
//           color: Color.fromARGB(255, 0, 0, 0),
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CheckpointDetails(
//               checkpointName: checkpoint.name,
//               checkpointId: checkpoint.id,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/model/checkpoint.dart';
import 'package:grad_app/pages/checkpoint_details.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/service/city_service.dart';
import 'package:grad_app/user/guest_nav_bar.dart';
import 'package:grad_app/user/user_nav_bar.dart';
import 'package:grad_app/service/checkpoint_service.dart';
import 'package:grad_app/generated/l10n.dart';

// 🎨 Color Constants
const kAppBarColor = Color(0xFF1D6421); // Dark Green for AppBar
const kCardBackground =
    Color.fromARGB(255, 255, 255, 255); // Light Grayish Green
const kBoxShadowColor = Color(0xFF202830); // Shadow Effect
const kPrimaryIconColor = Color(0xFF1B5E20); // Dark Green for Icons

class CitiesAndCheckpoints extends StatefulWidget {
  const CitiesAndCheckpoints({super.key});

  @override
  _CitiesAndCheckpointsState createState() => _CitiesAndCheckpointsState();
}

class _CitiesAndCheckpointsState extends State<CitiesAndCheckpoints> {
  final CheckpointService _firebaseCheckpoint = CheckpointService();
  final CityService _firebaseCity = CityService();
  String _searchQuery = '';
  List<String> _filteredCities = [];
  late List<String> _allCities;
  late List<Checkpoint> _allCheckpoints;
  final Map<String, bool> _expandedCities = {};
  Timer? _debounce;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
    _allCities = [];
    _allCheckpoints = [];
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    try {
      final cities = await _firebaseCity.getCitiesName();
      final checkpoints = await _firebaseCheckpoint.getAllCheckpoints();
      setState(() {
        _allCities = cities;
        _allCheckpoints = checkpoints;
        _filterCities();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _filterCities() {
    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredCities = _allCities.where((city) {
        final cityMatches = city.toLowerCase().contains(query);
        final checkpointMatches = _allCheckpoints.any((checkpoint) {
          return checkpoint.name.toLowerCase().contains(query) &&
              checkpoint.nearbyCities.isNotEmpty &&
              checkpoint.nearbyCities[0].toLowerCase() == city.toLowerCase();
        });
        return cityMatches || checkpointMatches;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
        _filterCities();
      });
    });
  }

  Future<void> _initializeUserRole() async {
    String? role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: userRole == 'admin'
          ? const AdminNavBar()
          : userRole == 'user'
              ? const UserNavBar()
              : const GuestNavBar(),
      appBar: buildAppBar(screenSize),
      body: Column(
        children: [
          buildSearchBar(screenSize),
          Expanded(child: buildBody(screenSize)),
        ],
      ),
    );
  }

  // AppBar buildAppBar(Size screenSize) {
  //   return AppBar(
  //     title: Align(
  //       alignment: Alignment.centerRight,
  //       child: Text(
  //         S.of(context).citiesAndCheckpoints,
  //         textDirection: TextDirection.rtl,
  //         style: TextStyle(
  //           fontSize: screenSize.width * 0.07,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white, // Navbar Title in White
  //         ),
  //       ),
  //     ),
  //     backgroundColor: kAppBarColor,
  //     elevation: 4,
  //     leading: IconButton(
  //       icon: Icon(Icons.menu,
  //           color: Colors.white, size: screenSize.width * 0.08),
  //       onPressed: () {
  //         Scaffold.of(context).openDrawer();
  //       },
  //     ),
  //   );
  // }
  AppBar buildAppBar(Size screenSize) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          S.of(context).citiesAndCheckpoints,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: screenSize.width * 0.07,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: kAppBarColor,
      elevation: 4,
      leading: Builder(
        // ✅ Wrap in Builder to get correct context
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu,
                color: Colors.white, size: screenSize.width * 0.08),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // ✅ This will now work
            },
          );
        },
      ),
    );
  }

  Widget buildSearchBar(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05, vertical: 15),
      child: Container(
        height: screenSize.height * 0.08,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: _onSearchChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
            hintText: S.of(context).searchForCityOrChckpoint,
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
                fontSize: screenSize.width * 0.05, color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search,
                color: kPrimaryIconColor, size: screenSize.width * 0.08),
            border: InputBorder.none,
          ),
          style: TextStyle(
              color: Colors.black, fontSize: screenSize.width * 0.055),
        ),
      ),
    );
  }

  Widget buildBody(Size screenSize) {
    if (_filteredCities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return buildCityList(screenSize);
  }

  ListView buildCityList(Size screenSize) {
    return ListView.builder(
      itemCount: _filteredCities.length,
      itemBuilder: (context, index) {
        final city = _filteredCities[index];
        final cityCheckpoints = _allCheckpoints.where((checkpoint) {
          return checkpoint.nearbyCities.isNotEmpty &&
              checkpoint.nearbyCities[0].toLowerCase() == city.toLowerCase();
        }).toList();
        return buildCityTile(city, cityCheckpoints, screenSize);
      },
    );
  }

  Widget buildCityTile(
      String city, List<Checkpoint> checkpoints, Size screenSize) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      color: kCardBackground,
      child: ExpansionTile(
        leading: Icon(Icons.location_city,
            color: kPrimaryIconColor, size: screenSize.width * 0.08),
        title: Text(
          city,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: screenSize.width * 0.06, fontWeight: FontWeight.bold),
        ),
        children: checkpoints
            .map((checkpoint) => buildCheckpointTile(checkpoint, screenSize))
            .toList(),
      ),
    );
  }

  // Widget buildCheckpointTile(Checkpoint checkpoint, Size screenSize) {
  //   return ListTile(
  //     // leading: Icon(Icons.roundabout_left,
  //     //     color: kPrimaryIconColor, size: screenSize.width * 0.07),
  //     title: Text(
  //       checkpoint.name,
  //       textDirection: TextDirection.rtl,
  //       style: TextStyle(fontSize: screenSize.width * 0.055),
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CheckpointDetails(
  //             checkpointName: checkpoint.name,
  //             checkpointId: checkpoint.id,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget buildCheckpointTile(Checkpoint checkpoint, Size screenSize) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  checkpoint.name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: screenSize.width * 0.055),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusColor(checkpoint.status), // Status color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  checkpoint.status, // Display status
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Add spacing
          Text(
            "اضغط لتحديث الحالة", // Small instruction text
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: screenSize.width * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to update status page (or any functionality you want)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckpointDetails(
              checkpointName: checkpoint.name,
              checkpointId: checkpoint.id,
            ),
          ),
        );
      },
    );
  }

  // Widget buildCheckpointTile(Checkpoint checkpoint, Size screenSize) {
  //   return ListTile(
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           checkpoint.name,
  //           textDirection: TextDirection.rtl,
  //           style: TextStyle(fontSize: screenSize.width * 0.055),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //           decoration: BoxDecoration(
  //             color: _getStatusColor(
  //                 checkpoint.status), // Dynamic color based on status
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Text(
  //             checkpoint.status,
  //             style: const TextStyle(
  //                 color: Colors.white, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CheckpointDetails(
  //             checkpointName: checkpoint.name,
  //             checkpointId: checkpoint.id,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'سالك':
        return Colors.green;
      case 'مغلق':
        return Colors.red;
      case 'أزمة شديدة':
        return Colors.orange;
      default:
        return const Color.fromARGB(
            166, 185, 105, 40); // Default color for unknown statuses
    }
  }
}
