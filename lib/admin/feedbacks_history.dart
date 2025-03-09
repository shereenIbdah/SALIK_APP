import 'package:flutter/material.dart';
import 'package:grad_app/admin/checkpoint_history.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/model/checkpoint.dart';
import 'package:grad_app/service/checkpoint_service.dart';

class CheckpointListScreen extends StatefulWidget {
  const CheckpointListScreen({super.key});

  @override
  _CheckpointListScreenState createState() => _CheckpointListScreenState();
}

class _CheckpointListScreenState extends State<CheckpointListScreen> {
  List<Map<String, dynamic>> checkpointData = [];
  List<Map<String, dynamic>> filteredCheckpoints = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCheckpoints();
    searchController.addListener(_filterCheckpoints);
  }

  final CheckpointService _checkpointService = CheckpointService();

  Future<void> fetchCheckpoints() async {
    try {
      List<Checkpoint> checkpoints =
          await _checkpointService.getAllCheckpoints();

      setState(() {
        // Map the fetched Checkpoint data into the desired format
        checkpointData = checkpoints
            .map((checkpoint) => {'id': checkpoint.id, 'name': checkpoint.name})
            .toList();
        filteredCheckpoints = checkpointData;
      });
    } catch (e) {
      print('Error fetching checkpoints: $e');
    }
  }

  void _filterCheckpoints() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredCheckpoints = checkpointData
          .where(
              (checkpoint) => checkpoint['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).feedbacksHistory,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: S.of(context).searchByName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: filteredCheckpoints.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredCheckpoints.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: AppConstants.primaryColor,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              filteredCheckpoints[index]['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).checkpointInfo,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckpointHistoryScreen(
                                    checkpointId: filteredCheckpoints[index]
                                        ['id'],
                                    checkpointName: filteredCheckpoints[index]
                                        ['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
