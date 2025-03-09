// import 'package:flutter/material.dart';
// import 'package:grad_app/constants/constants.dart';
// import 'package:grad_app/generated/l10n.dart';
// import 'package:grad_app/pages/suggest_idea_screen.dart';
// import 'package:grad_app/service/accident_report_dialog.dart';
// import 'package:grad_app/admin/admin_nav_bar.dart';
// import 'package:grad_app/user/add_checkpoint_interface.dart';
// import 'package:grad_app/service/auth_service.dart';
// import 'package:grad_app/user/user_nav_bar.dart';

// class ContributionInterface extends StatefulWidget {
//   const ContributionInterface({super.key});

//   @override
//   _ContributionInterfaceState createState() => _ContributionInterfaceState();
// }

// class _ContributionInterfaceState extends State<ContributionInterface> {
//   String? userRole;

//   Future<void> _initializeUserRole() async {
//     String? role = await AuthService().getUserRole();
//     setState(() {
//       userRole = role;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeUserRole();
//   }

//   void _showAccidentDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AccidentReportDialog();
//       },
//     );
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
//               Image.asset(
//                 image,
//                 height: 80,
//               ),
//               const SizedBox(height: 10),
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
//         drawer: userRole == 'admin' ? const AdminNavBar() : const UserNavBar(),
//         appBar: AppBar(
//           backgroundColor: AppConstants.primaryColor,
//           elevation: 0,
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             // Header Section
//             Container(
//               height: 150,
//               width: double.infinity,
//               color: AppConstants.primaryColor,
//               alignment: Alignment.center,
//               child: Text(
//                 S.of(context).contributeTitle, // Title
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 35,
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
//                       image: 'assets/images/image-gallery.png',
//                       title: S.of(context).addCheckpoint,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 const AddCheckpointInterface(),
//                           ),
//                         );
//                       },
//                     ),
//                     _buildButtonCard(
//                       image: 'assets/images/incident-report.png',
//                       title: S.of(context).reportAccident,
//                       onTap: () {
//                         _showAccidentDialog(context);
//                       },
//                     ),
//                     _buildButtonCard(
//                       image: 'assets/images/idea.png',
//                       title: S.of(context).suggestIdea,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SuggestIdeaScreen(),
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
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/suggest_idea_screen.dart';
import 'package:grad_app/service/accident_report_dialog.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/user/add_checkpoint_interface.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/user/user_nav_bar.dart';

class ContributionInterface extends StatefulWidget {
  const ContributionInterface({super.key});

  @override
  _ContributionInterfaceState createState() => _ContributionInterfaceState();
}

class _ContributionInterfaceState extends State<ContributionInterface> {
  String? userRole;

  Future<void> _initializeUserRole() async {
    String? role = await AuthService().getUserRole();
    setState(() {
      userRole = role;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
  }

  void _showAccidentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AccidentReportDialog();
      },
    );
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
        height: height * 0.20, // Increase height for better text display
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
                  overflow: TextOverflow.ellipsis, // Prevents overflow issues
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
        drawer: userRole == 'admin' ? const AdminNavBar() : const UserNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          centerTitle: true,
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
                S.of(context).contributeTitle, // Title
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
                      image: 'assets/images/image-gallery.png',
                      title: S.of(context).addCheckpoint,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddCheckpointInterface(),
                          ),
                        );
                      },
                      width: screenWidth,
                      height: screenHeight,
                    ),
                    _buildButtonCard(
                      image: 'assets/images/incident-report.png',
                      title: S.of(context).reportAccident,
                      onTap: () {
                        _showAccidentDialog(context);
                      },
                      width: screenWidth,
                      height: screenHeight,
                    ),
                    _buildButtonCard(
                      image: 'assets/images/idea.png',
                      title: S.of(context).suggestIdea,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuggestIdeaScreen(),
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
