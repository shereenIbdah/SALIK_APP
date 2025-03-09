
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/pages/welcome.dart';
import 'package:grad_app/generated/l10n.dart';

class LogoutHandler {
  // Function to show confirmation dialog
  static Future<void> showLogoutDialog(BuildContext context) async {
    final bool shouldLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).logoutConfirmationTitle), // Localized title
          content: Text(S.of(context).logoutConfirmationMessage), // Localized message
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text(S.of(context).cancel), // Localized "Cancel" text
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm logout
              },
              child: Text(S.of(context).yes), // Localized "Yes" text
            ),
          ],
        );
      },
    );

    if (shouldLogout) {
      await logout(context);
    }
  }

  // Function to log out the user
  static Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).logoutError(e.toString())), // Localized error message
        ),
      );
    }
  }
}
