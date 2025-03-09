import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';

class AccidentReportDialog extends StatefulWidget {
  const AccidentReportDialog({super.key});

  @override
  _AccidentReportDialogState createState() => _AccidentReportDialogState();
}

class _AccidentReportDialogState extends State<AccidentReportDialog> {
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            'التبليغ عن حادث',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting city
            DropdownButtonFormField<String>(
              value: selectedCity,
              decoration: InputDecoration(
                labelText: 'المدينة',
                labelStyle: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 18,
                ),
                hintText: 'اختر المدينة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
              items: List.generate(
                AppConstants.cities.length,
                (index) => DropdownMenuItem(
                  value: AppConstants.cities[index],
                  child: Text(AppConstants.cities[index]),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Description field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'الوصف',
                labelStyle: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 18,
                ),
                hintText: 'ماذا حدث؟',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
              maxLines: 6,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
          child: const Text(
            'إلغاء',
            style: TextStyle(fontSize: 18),
          ),
        ),
        // Submit button
        ElevatedButton(
          onPressed: () {
            String city = selectedCity ?? '';
            String description = descriptionController.text;

            if (city.isNotEmpty && description.isNotEmpty) {
              _submitAccidentReport(city, description, context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء ملء جميع الحقول')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'إرسال',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  // Function to handle submitting the accident report
  Future<void> _submitAccidentReport(
      String city, String description, BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference accidents =
            FirebaseFirestore.instance.collection('accidents');

        await accidents.add({
          'location': city,
          'description': description,
          'userName': user.displayName ?? user.email,
          'userId': user.uid,
          'date': FieldValue.serverTimestamp(),
          'status': 'Pending',
        });

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال الحادث بنجاح')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
        );
      }
    } catch (e) {
      print("Error submitting accident report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إرسال التقرير')),
      );
    }
  }
}
