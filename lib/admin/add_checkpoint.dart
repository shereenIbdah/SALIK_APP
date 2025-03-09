import 'package:flutter/material.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/model/checkpoint.dart';
import 'package:grad_app/service/checkpoint_service.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';

class AddCheckpoint extends StatefulWidget {
  const AddCheckpoint({super.key});

  @override
  State<AddCheckpoint> createState() => _AddCheckpointState();
}

class _AddCheckpointState extends State<AddCheckpoint> {
  final CheckpointService _firebaseService = CheckpointService();

  String? selectedCity;
  String? selectedStatus;
  String? selectedType;
  final TextEditingController checkpointNameController =
      TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  // List to store selected cities in case of external checkpoints
  List<String> selectedNearbyCities = [];

  void _saveCheckpoint() async {
    // Validate the input
    if (checkpointNameController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        selectedStatus == null ||
        selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Parse latitude and longitude
    double? latitude = double.tryParse(latitudeController.text);
    double? longitude = double.tryParse(longitudeController.text);

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid coordinates')),
      );
      return;
    }

    // Create a new checkpoint instance
    Checkpoint checkpoint = Checkpoint(
      id: '', // ID will be generated when saving to Firebase
      name: checkpointNameController.text,
      latitude: latitude,
      longitude: longitude,
      status: selectedStatus!,
      type: selectedType!, // Use the selected type (internal or external)
      nearbyCities: selectedType == 'خارجي'
          ? selectedNearbyCities
          : [selectedCity!], // Add selected cities to nearbyCities
    );

    try {
      // Check if a checkpoint with the same name already exists
      String? existingCheckpointId =
          await _firebaseService.findCheckpointByName(checkpoint.name);

      if (existingCheckpointId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkpoint already exists '),
          ),
        );
      } else {
        String newCheckpointId =
            await _firebaseService.addCheckpoint(checkpoint);
        if (newCheckpointId.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                selectedType == 'داخلي'
                    ? S.of(context).checkpointAdded(selectedCity as Object)
                    : 'تمت إضافة النقطة الخارجية بنجاح إلى المدن المختارة',
              ),
            ),
          );
        }
      }

      // Clear form
      setState(() {
        selectedCity = null;
        selectedStatus = null;
        selectedType = null;
        selectedNearbyCities
            .clear(); // Clear the list of selected nearby cities
        checkpointNameController.clear();
        latitudeController.clear();
        longitudeController.clear();
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const AdminNavBar(),
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu,
                    color: Color.fromARGB(255, 8, 8, 8), size: 30),
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
                      Text(
                        S.of(context).addNewCheckpoint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dropdown for selecting checkpoint type (internal or external)
                            TextField(
                              controller: checkpointNameController,
                              decoration: InputDecoration(
                                labelText: S.of(context).checkpointName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: selectedType,
                              decoration: InputDecoration(
                                labelText: "Select Type",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: ['داخلي', 'خارجي']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value;
                                  selectedCity =
                                      null; // Clear city when type changes
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Conditionally display city input based on checkpoint type
                            if (selectedType == 'داخلي')
                              DropdownButtonFormField<String>(
                                value: selectedCity,
                                decoration: InputDecoration(
                                  labelText: S.of(context).selectCity,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                            if (selectedType == 'خارجي')
                              Column(
                                children: List.generate(
                                  AppConstants.cities.length,
                                  (index) => CheckboxListTile(
                                    title: Text(AppConstants.cities[index]),
                                    value: selectedNearbyCities
                                        .contains(AppConstants.cities[index]),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedNearbyCities
                                              .add(AppConstants.cities[index]);
                                        } else {
                                          selectedNearbyCities.remove(
                                              AppConstants.cities[index]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: latitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: S.of(context).latitude,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: longitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: S.of(context).Longitude,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedStatus,
                              decoration: InputDecoration(
                                labelText: S.of(context).status,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: AppConstants.statuses
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _saveCheckpoint,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                S.of(context).addCheckpoint,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
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
