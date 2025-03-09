import 'package:flutter/material.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/notifications_to_city.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/service/change_password_dialog.dart';
import 'package:grad_app/user/user_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? currentUser;
  String? userRole;

  String userName = "Loading...";
  String userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _initializeUserRole();
    fetchUserData();
  }

  Future<void> _initializeUserRole() async {
    // Retrieve user role using AuthService
    String? role = await AuthService().getUserRole();

    // Update the state with the retrieved role
    setState(() {
      userRole = role;
    });
  }

  Future<void> fetchUserData() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        setState(() {
          userEmail = currentUser!.email!;
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'];
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Widget buildProfileInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 90,
          width: 90,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 70,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          userEmail,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildOptions() {
    return Column(
      children: [
        buildOption(
          icon: Icons.lock,
          label: S.of(context).changePassword,
          onTap: () {
            // Show the password change dialog
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return const ChangePasswordDialog();
              },
            ).then((result) {
              if (result != null) {
                // Show a success/error message based on the result
                // _showDialog(result);
              }
            });
          },
        ),
        const SizedBox(height: 20),
        buildOption(
          icon: Icons.notifications,
          label: S.of(context).activeNotifications,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NotificationsInterface(), // Use 'const' if the widget is immutable
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        buildOption(
          icon: Icons.location_on,
          label: S.of(context).locationPermission,
          onTap: () {
            // Location access action
          },
        ),
      ],
    );
  }

  Widget buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: AppConstants.primaryColor),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userRole == 'admin'
          ? const AdminNavBar() // Show AdminNavBar for admin
          : const UserNavBar(), // Show UserNavBar for regular user
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 180,
            color: AppConstants.primaryColor,
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildProfileInfo(),
                    const SizedBox(height: 40),
                    buildOptions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
