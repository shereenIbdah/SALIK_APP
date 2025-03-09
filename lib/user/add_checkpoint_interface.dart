import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/service/checkpoint_added_from_user.dart';

class AddCheckpointInterface extends StatefulWidget {
  const AddCheckpointInterface({super.key});

  @override
  _AddCheckpointInterfaceState createState() => _AddCheckpointInterfaceState();
}

class _AddCheckpointInterfaceState extends State<AddCheckpointInterface> {
  final CheckpointAddFromUser _checkpointAddFromUser = CheckpointAddFromUser();
  final TextEditingController _checkpointNameController =
      TextEditingController();
  final TextEditingController _checkpointDescriptionController =
      TextEditingController();

  String? checkpointLocation;

  @override
  void dispose() {
    _checkpointNameController.dispose();
    _checkpointDescriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final checkpointName = _checkpointNameController.text.trim();
    final checkpointDescription = _checkpointDescriptionController.text.trim();

    // Check if checkpoint name is empty
    if (checkpointName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال اسم الحاجز',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    // Check if checkpoint description is empty
    if (checkpointDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال وصف الحاجز',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    // Check if location is empty
    if (checkpointLocation == null || checkpointLocation!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال موقع الحاجز',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    try {
      // Pass the details to the checkpointAddFromUser
      await _checkpointAddFromUser.addPendingCheckpoint(
        checkpointName: checkpointName,
        checkpointDescription: checkpointDescription,
        checkpointLocation: checkpointLocation!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إضافة الحاجز بنجاح! الموقع: $checkpointLocation',
            textDirection: TextDirection.rtl,
          ),
        ),
      );

      // Reset the form
      setState(() {
        checkpointLocation = null;
        _checkpointNameController.clear();
        _checkpointDescriptionController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء إضافة الحاجز. يرجى المحاولة مرة أخرى.',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintTextDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildLocationTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          checkpointLocation = value;
        });
      },
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: 'أدخل موقع الحاجز بالضبط',
        hintTextDirection: TextDirection.rtl,
      ),
    );
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
                      const Text(
                        'إضافة حاجز جديد',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('اسم الحاجز:'),
                            const SizedBox(height: 20),
                            _buildTextField(
                                'أدخل اسم الحاجز', _checkpointNameController),
                            const SizedBox(height: 20),
                            _buildSectionTitle(' وصف عن الحاجز:'),
                            const SizedBox(height: 20),
                            _buildTextField('أدخل وصف الحاجز',
                                _checkpointDescriptionController),
                            const SizedBox(height: 20),
                            _buildSectionTitle('موقع الحاجز:'),
                            const SizedBox(height: 20),
                            _buildLocationTextField(),
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
                                onPressed: _handleSubmit,
                                child: const Text(
                                  'إضافة الحاجز',
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}
