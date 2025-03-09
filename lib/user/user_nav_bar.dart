import 'package:flutter/material.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/aproved_accidents.dart';
import 'package:grad_app/pages/cities_and_checkpoints.dart';
import 'package:grad_app/pages/city_to_city_checkpoints.dart';
import 'package:grad_app/pages/guide_boxes.dart';
import 'package:grad_app/pages/statistics.dart';
import 'package:grad_app/user/contribution_interface.dart';
import 'package:grad_app/pages/map.dart';
import 'package:grad_app/pages/profile.dart';
import 'package:grad_app/service/logout_service.dart';
import 'package:grad_app/main.dart'; // Import MyApp for locale changes

class UserNavBar extends StatelessWidget {
  const UserNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current text direction is RTL
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.black, size: 30),
                  // Text(S.of(context).title, // Localized app title
                  //     style: const TextStyle(
                  //       color: Color.fromARGB(255, 5, 5, 5),
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.bold,
                  //     )),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const Divider(),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                S
                    .of(context)
                    .cityToCityCheckpoints, // Title for the navigation option
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
            const Divider(),
            // Contribute to the App (only for authenticated users)
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
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
            // Language
            const Divider(),
            // Profile
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
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                Icons.translate,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                isRTL
                    ? S.of(context).switchToEnglish // Text for Arabic UI
                    : S.of(context).switchToArabic, // Text for English UI
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              onTap: () {
                // Toggle language
                if (isRTL) {
                  MyApp.of(context).setLocale(const Locale('en'));
                } else {
                  MyApp.of(context).setLocale(const Locale('ar'));
                }
                // Refresh UI after language switch
                Navigator.pop(context);
              },
            ),
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
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
