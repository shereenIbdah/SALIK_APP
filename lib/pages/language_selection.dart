import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/main.dart';
import 'package:grad_app/pages/guide_boxes.dart'; // Import MyApp to access the locale change method

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = "ar"; // Default selected language

  @override
  Widget build(BuildContext context) {
    double heightOfDevice = MediaQuery.of(context).size.height;
    double widthOfDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthOfDevice * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: widthOfDevice * 0.02),
                Text(
                  "Select a Language to continue",
                  style: TextStyle(
                    fontSize: heightOfDevice * 0.03, // Dynamic font size
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474F),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: heightOfDevice * 0.05),

            // Arabic Language Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = "ar";
                });
                MyApp.of(context).setLocale(
                    const Locale('ar')); // Change app language to Arabic
              },
              child: LanguageOption(
                isSelected: _selectedLanguage == "ar",
                languageCode: "AR",
                languageName: "العربية",
                heightOfDevice: heightOfDevice,
                widthOfDevice: widthOfDevice,
              ),
            ),
            SizedBox(height: heightOfDevice * 0.02),

            // English Language Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = "en";
                });
                MyApp.of(context).setLocale(
                    const Locale('en')); // Change app language to English
              },
              child: LanguageOption(
                isSelected: _selectedLanguage == "en",
                languageCode: "EN",
                languageName: "English",
                heightOfDevice: heightOfDevice,
                widthOfDevice: widthOfDevice,
              ),
            ),
            SizedBox(height: heightOfDevice * 0.05),

            // Next Button
            ElevatedButton(
              onPressed: () {
                // Proceed to the next screen with the selected language
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuideBoxes(fromMenu: false),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                minimumSize: Size(double.infinity, heightOfDevice * 0.07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(heightOfDevice * 0.01),
                ),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: heightOfDevice * 0.025,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: heightOfDevice * 0.02),
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final bool isSelected;
  final String languageCode;
  final String languageName;
  final double heightOfDevice;
  final double widthOfDevice;

  const LanguageOption({
    super.key,
    required this.isSelected,
    required this.languageCode,
    required this.languageName,
    required this.heightOfDevice,
    required this.widthOfDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: heightOfDevice * 0.02,
        horizontal: widthOfDevice * 0.05,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
        border: Border.all(
          color: isSelected
              ? const Color.fromARGB(255, 8, 82, 39)
              : const Color(0xFFE0E0E0),
          width: widthOfDevice * 0.005,
        ),
        borderRadius: BorderRadius.circular(widthOfDevice * 0.03),
      ),
      child: Row(
        children: [
          // Language Code Circle
          Container(
            width: widthOfDevice * 0.1,
            height: widthOfDevice * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color.fromARGB(255, 29, 126, 37)
                  : const Color(0xFFE0E0E0),
            ),
            child: Center(
              child: Text(
                languageCode,
                style: TextStyle(
                  fontSize: heightOfDevice * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: widthOfDevice * 0.05),

          // Language Name
          Expanded(
            child: Text(
              languageName,
              style: TextStyle(
                fontSize: heightOfDevice * 0.025,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF37474F),
              ),
            ),
          ),

          // Check Icon
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: const Color.fromARGB(255, 40, 95, 23),
              size: heightOfDevice * 0.03,
            ),
        ],
      ),
    );
  }
}
