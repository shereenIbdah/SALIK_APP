import 'package:flutter/material.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/aproved_accidents.dart';
import 'package:grad_app/pages/cities_and_checkpoints.dart';
import 'package:grad_app/pages/city_to_city_checkpoints.dart';
import 'package:grad_app/pages/guide_boxes.dart';
import 'package:grad_app/pages/sign_in.dart';
import 'package:grad_app/pages/map.dart';
import 'package:grad_app/main.dart'; // Import MyApp for locale changes

class GuestNavBar extends StatelessWidget {
  const GuestNavBar({Key? key});

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
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const Divider(),
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
                Icons.login,
                size: 24,
                color: Color.fromARGB(255, 57, 126, 99),
              ),
              title: Text(
                S.of(context).signInButton,
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
                    builder: (context) => const SignInPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
