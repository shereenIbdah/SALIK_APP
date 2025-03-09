// import 'package:flutter/material.dart';
// import 'package:grad_app/pages/map.dart';
// import 'package:grad_app/pages/sign_in.dart';
// import 'package:grad_app/pages/sign_up.dart';

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get the device's height and width
//     double heightOfDevice = MediaQuery.of(context).size.height;
//     double widthOfDevice = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: widthOfDevice * 0.04), // Responsive padding
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: heightOfDevice * 0.05), // Responsive top space
//                 // Welcome Text with improved typography
//                 Text(
//                   "Welcome",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: heightOfDevice * 0.05, // Responsive font size
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(
//                     height: 8), // Spacing between welcome text and subtitle
//                 Text(
//                   "Discover the checkpoints, roads ahead!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: heightOfDevice * 0.025, // Responsive font size
//                     color: const Color.fromARGB(221, 116, 109, 109),
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 SizedBox(
//                     height:
//                         heightOfDevice * 0.03), // Space between text and logo

//                 // Logo at the top with padding and shadow
//                 Container(
//                   padding: EdgeInsets.all(widthOfDevice *
//                       0.03), // Responsive padding around the image
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20), // Rounded corners
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 5, // Adjusted blur radius
//                         offset: Offset(0, 4), // Position of the shadow
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(
//                         20), // Ensure the image is clipped within the rounded corners
//                     child: Image.asset(
//                       'assets/images/map.png',
//                       height: heightOfDevice *
//                           0.35, // Responsive height for the image
//                       width:
//                           widthOfDevice * 0.9, // Responsive width for the image
//                       fit: BoxFit
//                           .cover, // Ensures the image covers the entire container
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: heightOfDevice * 0.025),

//                 // Sign Up Button with Gradient
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: widthOfDevice * 0.02), // Responsive padding
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromARGB(255, 135, 160, 107),
//                           Colors.green,
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(12.0), // Rounded corners
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Navigate to Sign Up Page
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SignUpPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               vertical:
//                                   heightOfDevice * 0.02), // Responsive padding
//                         ),
//                         child: Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: heightOfDevice *
//                                 0.025, // Responsive font size for the button
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: heightOfDevice * 0.025),

//                 // Sign In Button with Border
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: widthOfDevice * 0.02), // Responsive padding
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignInPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         side: const BorderSide(
//                           width: 1.5,
//                           color: Color.fromARGB(255, 69, 128, 61),
//                         ),
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             vertical:
//                                 heightOfDevice * 0.02), // Responsive padding
//                       ),
//                       child: Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 69, 128, 61),
//                           fontSize: heightOfDevice *
//                               0.025, // Responsive font size for the button
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: heightOfDevice * 0.02),

//                 // Continue as Guest Button
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: heightOfDevice * 0.02), // Responsive padding
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>  const StreatMapAPI()),
//                       );
//                     },
//                     child: Text(
//                       'Continue as Guest',
//                       style: TextStyle(
//                         color: const Color.fromARGB(255, 57, 126, 99),
//                         fontSize:
//                             heightOfDevice * 0.025, // Responsive font size
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:grad_app/pages/map.dart';
import 'package:grad_app/pages/sign_in.dart';
import 'package:grad_app/pages/sign_up.dart';
import 'package:grad_app/generated/l10n.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the device's height and width
    double heightOfDevice = MediaQuery.of(context).size.height;
    double widthOfDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthOfDevice * 0.04), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: heightOfDevice * 0.05), // Responsive top space
                // Welcome Text
                Text(
                  S.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: heightOfDevice * 0.05, // Responsive font size
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                    height: 8), // Spacing between welcome text and subtitle
                Text(
                  S.of(context).welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: heightOfDevice * 0.025, // Responsive font size
                    color: const Color.fromARGB(221, 116, 109, 109),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                    height:
                        heightOfDevice * 0.03), // Space between text and logo

                // Logo at the top
                Container(
                  padding: EdgeInsets.all(widthOfDevice *
                      0.03), // Responsive padding around the image
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5, // Adjusted blur radius
                        offset: Offset(0, 4), // Position of the shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Ensure the image is clipped within the rounded corners
                    child: Image.asset(
                      'assets/images/map.png',
                      height: heightOfDevice *
                          0.35, // Responsive height for the image
                      width:
                          widthOfDevice * 0.9, // Responsive width for the image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: heightOfDevice * 0.025),

                // Sign Up Button
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthOfDevice * 0.02), // Responsive padding
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 135, 160, 107),
                          Colors.green,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  heightOfDevice * 0.02), // Responsive padding
                        ),
                        child: Text(
                          S.of(context).signUpButton,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: heightOfDevice *
                                0.025, // Responsive font size for the button
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: heightOfDevice * 0.025),

                // Sign In Button
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widthOfDevice * 0.02), // Responsive padding
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          width: 1.5,
                          color: Color.fromARGB(255, 69, 128, 61),
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical:
                                heightOfDevice * 0.02), // Responsive padding
                      ),
                      child: Text(
                        S.of(context).signInButton,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 69, 128, 61),
                          fontSize: heightOfDevice *
                              0.025, // Responsive font size for the button
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: heightOfDevice * 0.02),

                // Continue as Guest Button
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: heightOfDevice * 0.02), // Responsive padding
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StreatMapAPI(),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).continueAsGuest,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 57, 126, 99),
                        fontSize:
                            heightOfDevice * 0.025, // Responsive font size
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
