import 'package:flutter/material.dart';

class AppConstants {
  // Cities list in Arabic
  static const List<String> cities = [
    'الخليل',
    'رام الله والبيرة',
    'بيت لحم',
    'نابلس',
    'اريحا',
    'جنين',
    'طوباس',
    'القدس',
    'طولكرم',
    'سلفيت',
    'قلقيلية',
  ];

  static const List<String> statuses = [
    'سالك',
    'مغلق',
    'أزمة شديدة',
    'أزمة خفيفة',
  ];

  static String externalCheckpoint = "خارجي";
  static int limitForCheckpoint = 2;

  static Map<String, double> dangerWeight = {
    "سالك": 0,
    "أزمة خفيفة": 0.3,
    "أزمة شديدة": 0.6,
    "مغلق": 1
  };

  // Colors
  static const Color primaryColor = Color.fromARGB(255, 79, 131, 82);
  static const Color textColor = Colors.grey;

  // Strings
  static const String appName = 'Salik';
  static const String signUp = 'Sign Up';
  static const String createAccount = 'Create your Account:';
  static const String fullName = 'Full Name';
  static const String emailPhone = 'Email or Phone Number';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String selectCity = 'Select City';
  static const String frequentDriverQuestion = 'Are you a frequent driver?';
}
