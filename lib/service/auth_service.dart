import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/firebase/firesbase_controller.dart';
import 'package:grad_app/pages/sign_in.dart';
import 'package:grad_app/pages/statistics.dart';
import 'package:grad_app/pages/verification_email.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<void> saveTokenToDatabase(String userId) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the token
    String? token = await messaging.getToken();

    if (token != null) {
      // Save the token to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'token': token,
      });
      print('Token saved: $token');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print('Device subscribed to topic: $topic');

      // Store the subscribed topic locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> topics = prefs.getStringList('subscribed_topics') ?? [];

      if (!topics.contains(topic)) {
        topics.add(topic);
        await prefs.setStringList('subscribed_topics', topics);
      }
    } on UnimplementedError {
      // Ignore the error
      print('UnimplementedError caught and ignored.');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      print('Device unsubscribed from topic: $topic');

      // Remove the topic from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> topics = prefs.getStringList('subscribed_topics') ?? [];

      if (topics.contains(topic)) {
        topics.remove(topic);
        await prefs.setStringList('subscribed_topics', topics);
      }
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String city,
    required bool isFrequentDriver,
    required double weight,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      await sendEmailVerification(user, context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerification()),
      );
      String? token = await FirebaseMessaging.instance.getToken();
      subscribeToTopic(city);

      await checkEmailVerification(user, email, fullName, city,
          isFrequentDriver, weight, token!, context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The email is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Attempt to sign in with email and password
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _firebaseAuth.currentUser;

      // Check if the email is verified
      if (user != null && user.emailVerified) {
        saveTokenToDatabase(user.uid);
        String city = await getUserCity(user.uid);
        subscribeToTopic(city);
        String? role = await getUserRole();
        if (role == 'admin') {
          subscribeToTopic("admin");
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NewsAndStatisticsScreen()),
        );
      } else if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please verify your email before signing in.')),
        );

        await user.sendEmailVerification();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerification()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Error Code: ${e.code}');
      print('Error Message: ${e.message}');

      String errorMessage;

      // Use lowercase checks to ensure case-insensitive matching
      final errorLowerCase = e.message?.toLowerCase() ?? '';

      if (e.code == 'user-not-found' ||
          errorLowerCase.contains('user') &&
              errorLowerCase.contains('not found')) {
        errorMessage = 'No user found with this email. Please sign up first.';
      } else if (e.code == 'wrong-password' ||
          errorLowerCase.contains('incorrect') ||
          errorLowerCase.contains('wrong')) {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email' ||
          errorLowerCase.contains('badly formatted')) {
        errorMessage = 'The email address is badly formatted.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      // Display the appropriate error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Catch-all for unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
      print('Error: $e');
    }
  }

  Future<void> _addUserToFirestore(
      String userId,
      String email,
      String username,
      String location,
      bool isFrequentDriver,
      double weight,
      String role,
      String token) async {
    try {
      await FireBaseController()
          .firebaseFirestore
          .collection('users')
          .doc(userId)
          .set({
        "user_id": userId,
        "email": email,
        "location": location,
        "name": username,
        "isFrequentDriver": isFrequentDriver,
        "weight": weight,
        "role": role,
        "token": token,
      });
    } catch (e) {
      print(e);
    }
  }

  // Method to send a verification email
  Future<void> sendEmailVerification(User? user, BuildContext context) async {
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        // ignore: use_build_context_synchronously
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending email: $e')),
        );
      }
    }
  }

  // Method to resend the verification email
  Future<void> resendVerificationEmail(BuildContext context) async {
    User? user = _firebaseAuth.currentUser; // Get the current user
    if (user != null && !user.emailVerified) {
      await sendEmailVerification(user, context);
    } else if (user?.emailVerified == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email is already verified.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not signed in.')),
      );
    }
  }

  Future<String?> getUserRole() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // If no user is signed in, return null
      if (user == null) return "guest";

      // Reference the Firestore 'users' collection
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Return the user's role
      return userDoc['role'] as String?;
    } catch (e) {
      print('Error retrieving user role: $e');
      return null;
    }
  }

  Future<void> checkEmailVerification(
      User? user,
      String email,
      String fullName,
      String city,
      bool isFrequentDriver,
      double weight,
      String token,
      BuildContext context) async {
    // List of admin emails
    const List<String> adminEmails = [
      'saja.shareef5@gmail.com',
      'shereenibdd@gmail.com',
    ];

    // Determine user role
    String role = adminEmails.contains(email) ? 'admin' : 'user';

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Reload the user to check if the email is verified
      if (user != null) {
        await user?.reload();
      }
      user = _firebaseAuth.currentUser;

      if (user?.emailVerified == true) {
        timer.cancel(); // Stop the timer

        if (role == 'admin') {
          weight = 1.0; // Admin weight
        } else if (isFrequentDriver) {
          weight = 0.5; // Frequent driver weight
        } else {
          weight = 0.4; // Normal user weight
        }

        // Add user to Firestore with the assigned role
        await _addUserToFirestore(
          user!.uid,
          email,
          fullName,
          city,
          isFrequentDriver,
          weight,
          role,
          token,
        );

        // The logic when the email is verified
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    });
  }

// Function to convert Arabic city names to English
  String convertCityToEnglish(String arabicCity) {
    switch (arabicCity) {
      case 'الخليل':
        return 'hebron';
      case 'رام الله والبيرة':
        return 'ramallah-al-bireh';
      case 'بيت لحم':
        return 'bethlehem';
      case 'نابلس':
        return 'nablus';
      case 'أريحا':
        return 'jericho';
      case 'جنين':
        return 'jenin';
      case 'طوباس':
        return 'tubas';
      case 'القدس':
        return 'jerusalem';
      case 'طولكرم':
        return 'tulkarm';
      case 'سلفيت':
        return 'salfit';
      case 'قلقيلية':
        return 'qalqilya';
      default:
        return "topic_not_found";
    }
  }

// Function to get the user's city and convert it
  Future<String> getUserCity(String uid) async {
    String city = '';
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: uid)
        .get();
    city = usersSnapshot.docs[0].data()['location'];

    city = convertCityToEnglish(city);
    print('City: $city');

    return city;
  }
  // Method to get current user ID
  Future<String?> getCurrentUserId() async {
    User? user = _firebaseAuth.currentUser; // Get the current user
    return user?.uid; // Return the user ID or null if not signed in
  }
}
