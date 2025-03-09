// // // import 'package:flutter/material.dart';
// // // import 'package:grad_app/admin/accident_reports_screen.dart';
// // // import 'package:grad_app/admin/checkpoints_reports_screen.dart';
// // // import 'package:grad_app/admin/user_ideas_screen.dart';
// // // import 'package:grad_app/constants/constants.dart';
// // // import 'package:grad_app/admin/admin_nav_bar.dart';
// // // import 'package:grad_app/generated/l10n.dart';
// // // import 'package:grad_app/service/auth_service.dart';

// // // class UserSubmissions extends StatefulWidget {
// // //   const UserSubmissions({super.key});

// // //   @override
// // //   UserSubmissionsState createState() => UserSubmissionsState();
// // // }

// // // class UserSubmissionsState extends State<UserSubmissions> {
// // //   String? userRole;

// // //   // Method to initialize user role
// // //   Future<void> _initializeUserRole() async {
// // //     String? role = await AuthService().getUserRole();
// // //     setState(() {
// // //       userRole = role;
// // //     });
// // //   }

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializeUserRole();
// // //   }

// // //   Widget _buildOptionTile(
// // //     BuildContext context, {
// // //     required String title,
// // //     required IconData icon,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return ListTile(
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       tileColor: Colors.grey[200],
// // //       leading: Icon(
// // //         icon,
// // //         size: 30,
// // //         color: AppConstants.primaryColor,
// // //       ),
// // //       title: Text(
// // //         title,
// // //         textDirection: TextDirection.rtl,
// // //         style: const TextStyle(
// // //           fontSize: 20,
// // //           fontWeight: FontWeight.bold,
// // //           color: AppConstants.primaryColor,
// // //         ),
// // //       ),
// // //       onTap: onTap,
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SafeArea(
// // //       child: Scaffold(
// // //         drawer: const AdminNavBar(),
// // //         appBar: AppBar(
// // //           backgroundColor: AppConstants.primaryColor,
// // //           elevation: 0,
// // //           leading: Builder(
// // //             builder: (BuildContext context) {
// // //               return IconButton(
// // //                 icon: const Icon(
// // //                   Icons.menu,
// // //                   color: Colors.black,
// // //                   size: 30,
// // //                 ),
// // //                 onPressed: () {
// // //                   Scaffold.of(context).openDrawer();
// // //                 },
// // //               );
// // //             },
// // //           ),
// // //         ),
// // //         body: Stack(
// // //           children: [
// // //             Container(
// // //               height: 150,
// // //               color: AppConstants.primaryColor,
// // //             ),
// // //             SingleChildScrollView(
// // //               child: Align(
// // //                 alignment: Alignment.topCenter,
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // //                   child: Column(
// // //                     children: [
// // //                       const SizedBox(height: 20),
// // //                       Text(
// // //                         S.of(context).userReport, // User Submissions
// // //                         textAlign: TextAlign.center,
// // //                         style: TextStyle(
// // //                           color: Colors.white,
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 30,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 30),
// // //                       Container(
// // //                         padding: const EdgeInsets.all(16.0),
// // //                         width: MediaQuery.of(context).size.width * 0.9,
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.white,
// // //                           borderRadius: BorderRadius.circular(25),
// // //                         ),
// // //                         child: Column(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           mainAxisSize: MainAxisSize.min,
// // //                           children: [
// // //                             _buildOptionTile(
// // //                               context,
// // //                               title: S
// // //                                   .of(context)
// // //                                   .accidentReportss, // Reported Accidents
// // //                               icon: Icons
// // //                                   .report_problem, // Updated icon for accidents
// // //                               onTap: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         const AccidentReportsScreen(),
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                             const SizedBox(height: 20),
// // //                             _buildOptionTile(
// // //                               context,
// // //                               title: S
// // //                                   .of(context)
// // //                                   .checkpointAddedByUser, // User-added Checkpoints
// // //                               icon: Icons
// // //                                   .location_on, // Updated icon for checkpoints
// // //                               onTap: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         const CheckpointReportsScreen(), // The screen that displays the checkpoints
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                             const SizedBox(height: 20),
// // //                             _buildOptionTile(
// // //                               context,
// // //                               title: S
// // //                                   .of(context)
// // //                                   .userSuggestions, // User Suggestions
// // //                               icon: Icons
// // //                                   .lightbulb, // Updated icon for suggestions
// // //                               onTap: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         const UserIdeasScreen(), // Replace with your screen
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:grad_app/admin/accident_reports_screen.dart';
// // import 'package:grad_app/admin/checkpoints_reports_screen.dart';
// // import 'package:grad_app/admin/user_ideas_screen.dart';
// // import 'package:grad_app/constants/constants.dart';
// // import 'package:grad_app/admin/admin_nav_bar.dart';
// // import 'package:grad_app/generated/l10n.dart';
// // import 'package:grad_app/service/auth_service.dart';

// // class UserSubmissions extends StatefulWidget {
// //   const UserSubmissions({super.key});

// //   @override
// //   UserSubmissionsState createState() => UserSubmissionsState();
// // }

// // class UserSubmissionsState extends State<UserSubmissions> {
// //   String? userRole;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeUserRole();
// //   }

// //   Future<void> _initializeUserRole() async {
// //     final role = await AuthService().getUserRole();
// //     setState(() {
// //       userRole = role;
// //     });
// //   }

// //   Widget _buildOptionTile({
// //     required String title,
// //     required IconData icon,
// //     required VoidCallback onTap,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0), // Uniform spacing
// //       child: ListTile(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         tileColor: Colors.grey.shade100, // Subtle background
// //         leading: Icon(
// //           icon,
// //           size: 28,
// //           color: AppConstants.primaryColor,
// //         ),
// //         title: Text(
// //           title,
// //           textDirection: TextDirection.rtl,
// //           style: const TextStyle(
// //             fontSize: 18, // Smaller size for text balance
// //             fontWeight: FontWeight.bold,
// //             color: AppConstants.primaryColor,
// //           ),
// //         ),
// //         onTap: onTap,
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     const cardPadding = EdgeInsets.all(16.0); // Defined once for reuse

// //     return SafeArea(
// //       child: Scaffold(
// //         drawer: const AdminNavBar(),
// //         appBar: AppBar(
// //           backgroundColor: AppConstants.primaryColor,
// //           elevation: 0,
// //           leading: Builder(
// //             builder: (context) {
// //               return IconButton(
// //                 icon: const Icon(
// //                   Icons.menu,
// //                   color: Colors.white,
// //                   size: 28,
// //                 ),
// //                 onPressed: () {
// //                   Scaffold.of(context).openDrawer();
// //                 },
// //               );
// //             },
// //           ),
// //         ),
// //         body: Stack(
// //           children: [
// //             // Colored header background
// //             Container(
// //               height: 150,
// //               color: AppConstants.primaryColor,
// //             ),
// //             SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     const SizedBox(height: 20),
// //                     // Main Title
// //                     Text(
// //                       S.of(context).userReport,
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 28,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     // White Card Container
// //                     Container(
// //                       padding: cardPadding,
// //                       width: MediaQuery.of(context).size.width * 0.95,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(20),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 10,
// //                             offset: const Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           // Tile 1: Accident Reports
// //                           _buildOptionTile(
// //                             title: S.of(context).accidentReportss,
// //                             icon: Icons.report_problem,
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) =>
// //                                       const AccidentReportsScreen(),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           // Tile 2: Checkpoints
// //                           _buildOptionTile(
// //                             title: S.of(context).checkpointAddedByUser,
// //                             icon: Icons.location_on,
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) =>
// //                                       const CheckpointReportsScreen(),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           // Tile 3: User Suggestions
// //                           _buildOptionTile(
// //                             title: S.of(context).userSuggestions,
// //                             icon: Icons.lightbulb,
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => const UserIdeasScreen(),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:grad_app/admin/accident_reports_screen.dart';
// import 'package:grad_app/admin/checkpoints_reports_screen.dart';
// import 'package:grad_app/admin/user_ideas_screen.dart';
// import 'package:grad_app/constants/constants.dart';
// import 'package:grad_app/admin/admin_nav_bar.dart';
// import 'package:grad_app/generated/l10n.dart';
// import 'package:grad_app/service/auth_service.dart';

// class UserSubmissions extends StatefulWidget {
//   const UserSubmissions({super.key});

//   @override
//   UserSubmissionsState createState() => UserSubmissionsState();
// }

// class UserSubmissionsState extends State<UserSubmissions> {
//   String? userRole;

//   @override
//   void initState() {
//     super.initState();
//     _initializeUserRole();
//   }

//   Future<void> _initializeUserRole() async {
//     final role = await AuthService().getUserRole();
//     setState(() {
//       userRole = role;
//     });
//   }

//   Widget _buildButtonCard({
//     required String image,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         elevation: 6,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Display the image
//               Image.asset(
//                 image,
//                 height: 80,
//               ),
//               const SizedBox(height: 10),
//               // Display the title
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 textDirection: TextDirection.rtl,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: const AdminNavBar(),
//         appBar: AppBar(
//           backgroundColor: AppConstants.primaryColor,
//           elevation: 0,
//           leading: Builder(
//             builder: (context) {
//               return IconButton(
//                 icon: const Icon(
//                   Icons.menu,
//                   color: Color.fromARGB(255, 7, 7, 7),
//                   size: 28,
//                 ),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//               );
//             },
//           ),
//         ),
//         body: Column(
//           children: [
//             // Header
//             Container(
//               height: 150,
//               width: double.infinity,
//               color: AppConstants.primaryColor,
//               alignment: Alignment.center,
//               child: Text(
//                 S.of(context).userReport, // Title
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 235, 229, 229),
//                   fontSize: 50,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             // Button Grid
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   children: [
//                     _buildButtonCard(
//                       image: 'assets/images/accident-report.png',
//                       title: S.of(context).accidentReportss, // Title text
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AccidentReportsScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildButtonCard(
//                       image: 'assets/images/checkpoint.png',
//                       title: S.of(context).checkpointAddedByUser, // Title text
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 const CheckpointReportsScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildButtonCard(
//                       image: 'assets/images/enlargement.png',
//                       title: S.of(context).userSuggestions, // Title text
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const UserIdeasScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:grad_app/admin/accident_reports_screen.dart';
import 'package:grad_app/admin/checkpoints_reports_screen.dart';
import 'package:grad_app/admin/user_ideas_screen.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/service/auth_service.dart';

class UserSubmissions extends StatefulWidget {
  const UserSubmissions({super.key});

  @override
  UserSubmissionsState createState() => UserSubmissionsState();
}

class UserSubmissionsState extends State<UserSubmissions> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
  }

  Future<void> _initializeUserRole() async {
    final role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  Widget _buildButtonCard({
    required String image,
    required String title,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height * 0.20, // Adjust button height
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: height * 0.08, // Adjust image size
                ),
                SizedBox(height: height * 0.015),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: width * 0.04, // Dynamically adjust font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2, // Allow multiple lines
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        drawer: const AdminNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 7, 7, 7),
                  size: 28,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Header Section
            Container(
              height: screenHeight * 0.18,
              width: screenWidth,
              color: AppConstants.primaryColor,
              alignment: Alignment.center,
              child: Text(
                S.of(context).userReport, // Title
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Button Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: screenHeight * 0.02,
                  crossAxisSpacing: screenWidth * 0.04,
                  children: [
                    _buildButtonCard(
                      image: 'assets/images/accident-report.png',
                      title: S.of(context).accidentReportss,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccidentReportsScreen(),
                          ),
                        );
                      },
                      width: screenWidth,
                      height: screenHeight,
                    ),
                    _buildButtonCard(
                      image: 'assets/images/checkpoint.png',
                      title: S.of(context).checkpointAddedByUser,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CheckpointReportsScreen(),
                          ),
                        );
                      },
                      width: screenWidth,
                      height: screenHeight,
                    ),
                    _buildButtonCard(
                      image: 'assets/images/enlargement.png',
                      title: S.of(context).userSuggestions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserIdeasScreen(),
                          ),
                        );
                      },
                      width: screenWidth,
                      height: screenHeight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
