import 'package:flutter/material.dart';
import 'package:grad_app/admin/feedbacks_history.dart';
import 'package:grad_app/admin/user_submissions.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/main.dart';
import 'package:grad_app/pages/aproved_accidents.dart';
import 'package:grad_app/pages/cities_and_checkpoints.dart';
import 'package:grad_app/pages/city_to_city_checkpoints.dart';
import 'package:grad_app/pages/guide_boxes.dart';
import 'package:grad_app/pages/statistics.dart';
import 'package:grad_app/pages/test.dart';
import 'package:grad_app/user/contribution_interface.dart';
import 'package:grad_app/pages/map.dart';
import 'package:grad_app/admin/add_checkpoint.dart';
import 'package:grad_app/pages/profile.dart';
import 'package:grad_app/service/logout_service.dart';

class AdminNavBar extends StatelessWidget {
  const AdminNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine text direction based on locale
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Drawer(
      child: Container(
        color: Colors.white, // Background color for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer header
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu,
                    color: Color.fromARGB(255, 31, 100, 25),
                    size: 30,
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  // Expanded(
                  // child: Text(
                  //   S.of(context).title, // Localized app title
                  //   style: const TextStyle(
                  //     color: Color.fromARGB(255, 14, 13, 13),
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: textDirection == TextDirection.rtl
                  //       ? TextAlign.right
                  //       : TextAlign.left, // Adjust alignment dynamically
                  // ),
                  // ),
                ],
              ),
            ),
            const Divider(),
            //Stastical Report
            ListTile(
              leading: const Icon(
                Icons.calculate,
                size: 30,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).SalikStatistics,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewsAndStatisticsScreen()),
                );
              },
            ),
            // Interactive Map
            ListTile(
              leading: const Icon(
                Icons.location_on,
                size: 30,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).mapTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StreatMapAPI()),
                );
              },
            ),
            // Cities and Checkpoints
            ListTile(
              leading: const Icon(
                Icons.location_city,
                size: 30,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).citiesAndCheckpoints,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CitiesAndCheckpoints()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons
                    .route, // Icon representing routes or journeys between cities
                size: 30,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).checkpointBetweenCities,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CityToCityCheckpoints(), // Navigate to the CitiesAndCheckpoints page
                  ),
                );
              },
            ),

            // Add Checkpoint
            ListTile(
              leading: const Icon(
                Icons.add_box,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).addCheckpoint,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCheckpoint()),
                );
              },
            ),
            const Divider(),
            // Contribute to the App
            ListTile(
              leading: const Icon(
                Icons.edit,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).contribute,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContributionInterface(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.assignment, // Icon for user submissions
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99), // Matches theme
              ),
              title: Text(
                S.of(context).userReport,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const UserSubmissions() // Replace with your screen
                      ),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.car_crash, // New icon
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).accidentNews,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserApprovedAccidentsScreen(),
                  ),
                );
              },
            ),
            //add Divider
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).profile,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.history,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).feedbacksHistory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckpointListScreen(),
                  ),
                );
              },
            ),

            // ListTile(
            //   leading: const Icon(
            //     Icons.history,
            //     size: 24,
            //     color: Color.fromARGB(255, 57, 126, 99),
            //   ),
            //   title: Text(
            //     "test",
            //     style: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => TestScreen(),
            //       ),
            //     );
            //   },
            // ),

            ListTile(
              leading: const Icon(
                Icons.help,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).guideTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => const GuideBoxes(),
                    builder: (context) => const GuideBoxes(fromMenu: true),
                  ),
                );
              },
            ),
            // language
            const Divider(),
            // ListTile(
            //   leading: const Icon(
            //     Icons.account_circle,
            //     size: 24,
            //     color: Color.fromARGB(255, 57, 126, 99),
            //   ),
            //   title: Text(
            //     S.of(context).profile,
            //     style: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const Profile(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.translate,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                isRTL
                    ? S.of(context).switchToEnglish // Text when in Arabic
                    : S.of(context).switchToArabic, // Text when in English
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: isRTL
                    ? TextDirection.rtl
                    : TextDirection.ltr, // Adjust text direction
              ),
              onTap: () {
                // Toggle language
                if (isRTL) {
                  MyApp.of(context)
                      .setLocale(const Locale('en')); // Switch to English
                } else {
                  MyApp.of(context)
                      .setLocale(const Locale('ar')); // Switch to Arabic
                }
                // Refresh UI
                Navigator.pop(context);
              },
            ),
            // Logout
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).logout,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                LogoutHandler.showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
