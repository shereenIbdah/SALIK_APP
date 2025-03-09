import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/service/notification_service.dart';

class SuggestIdeaScreen extends StatefulWidget {
  const SuggestIdeaScreen({Key? key}) : super(key: key);

  @override
  _SuggestIdeaScreenState createState() => _SuggestIdeaScreenState();
}

class _SuggestIdeaScreenState extends State<SuggestIdeaScreen> {
  final TextEditingController _ideaNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitIdea() async {
    final notificationService = NotificationService();
    final String ideaName = _ideaNameController.text.trim();
    final String description = _descriptionController.text.trim();

    if (ideaName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      // Add the idea to Firestore
      await FirebaseFirestore.instance.collection('suggestions').add({
        'name': ideaName,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Initialize the notification service (general for all notifications)
      await notificationService.initialize();

      // Send a notification to the admin topic
      await notificationService.sendTopicNotification(
        'admin', // Send to 'admin' topic
        'New Idea Submitted',
        'A new idea "$ideaName" has been added. Check it out!',
      );

      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Idea submitted successfully!')),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting idea: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              height: 150,
              color: AppConstants.primaryColor,
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center alignment
                        children: [
                          Text(
                            S.of(context).suggestIdea,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Space between text and icon
                          const Icon(
                            Icons.lightbulb,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 40,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).ideaName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _ideaNameController,
                              decoration: InputDecoration(
                                hintText: S.of(context).enterIdeaName,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              S.of(context).Description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: S.of(context).enterdescription,
                                border: OutlineInputBorder(),
                              ),
                              textInputAction:
                                  TextInputAction.done, // Added "Done" action
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .unfocus(); // Dismiss the keyboard when "Done" is pressed
                              },
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _submitIdea,
                                child: Text(
                                  S.of(context).submitIdea,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
