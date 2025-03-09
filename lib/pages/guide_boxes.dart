// import 'package:flutter/material.dart';
// import 'package:grad_app/constants/constants.dart';
// import 'package:grad_app/generated/l10n.dart';
// import 'package:grad_app/pages/welcome.dart';

// class GuideBoxes extends StatefulWidget {
//   final bool fromMenu; // Indicates if this is called from the menu

//   const GuideBoxes({super.key, this.fromMenu = false}); // Default to false

//   @override
//   State<GuideBoxes> createState() => _GuideBoxesState();
// }

// class _GuideBoxesState extends State<GuideBoxes> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   late List<Map<String, String>> onboardingData;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Initialize onboardingData here where S.of(context) is accessible
//     onboardingData = [
//       {
//         "image": "assets/images/guide1.png",
//         "title": S.of(context).welcomeTitle,
//         "description": S.of(context).welcomeDescription,
//       },
//       {
//         "image": "assets/images/guide2.png",
//         "title": S.of(context).statusTitle,
//         "description": S.of(context).statusDescription,
//       },
//       {
//         "image": "assets/images/guide3.png",
//         "title": S.of(context).feedbackTitle,
//         "description": S.of(context).feedbackDescription,
//       },
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               itemCount: onboardingData.length,
//               itemBuilder: (context, index) => OnboardingPage(
//                 image: onboardingData[index]["image"]!,
//                 title: onboardingData[index]["title"]!,
//                 description: onboardingData[index]["description"]!,
//               ),
//             ),
//           ),
//           // Page Indicator
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               onboardingData.length,
//               (index) => buildDot(index),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_currentPage == onboardingData.length - 1) {
//                   if (widget.fromMenu) {
//                     // Close the GuideBoxes and return to the menu
//                     Navigator.pop(context);
//                   } else {
//                     // Navigate to the Welcome screen as part of onboarding
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const MyHomePage()),
//                     );
//                   }
//                 } else {
//                   _pageController.nextPage(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: AppConstants.primaryColor,
//                 foregroundColor: const Color.fromARGB(255, 245, 242, 242),
//               ),
//               child: Text(
//                 _currentPage == onboardingData.length - 1
//                     ? (widget.fromMenu
//                         ? S.of(context).end
//                         : S.of(context).getStarted)
//                     : S.of(context).buttonContinue,
//               ),
//             ),
//           ),

//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   // Dot Indicator
//   AnimatedContainer buildDot(int index) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       margin: const EdgeInsets.only(right: 5),
//       height: 8,
//       width: _currentPage == index ? 20 : 8,
//       decoration: BoxDecoration(
//         color: _currentPage == index
//             ? const Color.fromARGB(69, 11, 167, 32)
//             : Colors.grey,
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }

// class OnboardingPage extends StatelessWidget {
//   final String image, title, description;

//   const OnboardingPage({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16.0),
//             child: Image.asset(
//               image,
//               height: 460,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 15, 15, 15),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               description,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Color.fromARGB(179, 22, 22, 22),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/welcome.dart';

class GuideBoxes extends StatefulWidget {
  final bool fromMenu;

  const GuideBoxes({super.key, this.fromMenu = false});

  @override
  State<GuideBoxes> createState() => _GuideBoxesState();
}

class _GuideBoxesState extends State<GuideBoxes> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late List<Map<String, String>> onboardingData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onboardingData = [
      {
        "image": "assets/images/guide1.png",
        "title": S.of(context).welcomeTitle,
        "description": S.of(context).welcomeDescription,
      },
      {
        "image": "assets/images/guide2.png",
        "title": S.of(context).statusTitle,
        "description": S.of(context).statusDescription,
      },
      {
        "image": "assets/images/guide3.png",
        "title": S.of(context).feedbackTitle,
        "description": S.of(context).feedbackDescription,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardingPage(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                ),
              ),
            ),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),

            const SizedBox(height: 20),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    if (widget.fromMenu) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      );
                    }
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _currentPage == onboardingData.length - 1
                      ? (widget.fromMenu
                          ? S.of(context).end
                          : S.of(context).getStarted)
                      : S.of(context).buttonContinue,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Dot Indicator
  AnimatedContainer buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color.fromARGB(69, 11, 167, 32)
            : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;

//     return SizedBox(
//       height: screenHeight,
//       width: screenWidth,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center, // Center content
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16.0),
//             child: Image.asset(
//               image,
//               height: screenHeight * 0.4, // Responsive image height
//               width: screenWidth * 0.9, // Responsive width
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               description,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Adjusted Image Size
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              image,
              height: screenHeight * 0.6, // 30% of screen height
              width: screenWidth * 0.85, // 85% of screen width
              fit: BoxFit.contain, // Prevents cropping
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
