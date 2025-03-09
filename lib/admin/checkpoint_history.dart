// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:grad_app/constants/data_base_constants.dart';

// class CheckpointHistoryScreen extends StatefulWidget {
//   final String checkpointId;
//   final String checkpointName;

//   const CheckpointHistoryScreen({
//     super.key,
//     required this.checkpointId,
//     required this.checkpointName,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _CheckpointHistoryScreenState createState() =>
//       _CheckpointHistoryScreenState();
// }

// class _CheckpointHistoryScreenState extends State<CheckpointHistoryScreen> {
//   List<Map<String, dynamic>> feedbackList = [];
//   bool isLoading = true; // New loading state

//   @override
//   void initState() {
//     super.initState();
//     fetchCheckpointFeedback();
//   }

//   Future<void> fetchCheckpointFeedback() async {
//     try {
//       QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
//           .collection(DataBaseConstants.feedbacks)
//           .where('checkpointId', isEqualTo: widget.checkpointId)
//           .get();

//       List<Map<String, dynamic>> tempFeedbackList = [];

//       for (var feedbackDoc in feedbackSnapshot.docs) {
//         var feedbackData = feedbackDoc.data() as Map<String, dynamic>;
//         var userDoc = await FirebaseFirestore.instance
//             .collection(DataBaseConstants.users)
//             .doc(feedbackData['userId'])
//             .get();

//         if (userDoc.exists) {
//           var userData = userDoc.data() as Map<String, dynamic>;
//           tempFeedbackList.add({
//             'name': userData['name'],
//             'email': userData['email'],
//             'weight': userData['weight'],
//             'status': feedbackData['status'],
//             'timestamp': feedbackData['timestamp']
//           });
//         }
//       }

//       setState(() {
//         feedbackList = tempFeedbackList;
//         isLoading = false; // Mark loading as complete
//       });
//     } catch (e) {
//       print('Error fetching feedback: $e');
//       setState(() {
//         isLoading = false; // Stop loading even if there's an error
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(widget.checkpointName, style: TextStyle(fontSize: 24))),
//       body: isLoading
//           ? Center(
//               child:
//                   CircularProgressIndicator()) // Show loader only when fetching data
//           : feedbackList.isEmpty
//               ? Center(
//                   child: Text(
//                     "No feedbacks available",
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: feedbackList.length,
//                   itemBuilder: (context, index) {
//                     var feedback = feedbackList[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(16),
//                           leading: CircleAvatar(
//                             radius: 30,
//                             backgroundColor:
//                                 const Color.fromARGB(255, 197, 130, 30),
//                             child: Icon(Icons.person, color: Colors.white),
//                           ),
//                           title: Text(
//                             feedback['name'],
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 feedback['email'],
//                                 style: TextStyle(color: Colors.grey[700]),
//                               ),
//                               Text(
//                                 feedback['status'],
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           trailing: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Icon(Icons.access_time,
//                                   color:
//                                       const Color.fromARGB(255, 124, 184, 90)),
//                               Text(
//                                 formatTimestamp(feedback['timestamp']),
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }

//   String formatTimestamp(Timestamp timestamp) {
//     DateTime dateTime = timestamp.toDate();
//     return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/data_base_constants.dart';

class CheckpointHistoryScreen extends StatefulWidget {
  final String checkpointId;
  final String checkpointName;

  const CheckpointHistoryScreen({
    super.key,
    required this.checkpointId,
    required this.checkpointName,
  });

  @override
  _CheckpointHistoryScreenState createState() =>
      _CheckpointHistoryScreenState();
}

class _CheckpointHistoryScreenState extends State<CheckpointHistoryScreen> {
  List<Map<String, dynamic>> feedbackList = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchCheckpointFeedback();
  }

  Future<void> fetchCheckpointFeedback() async {
    try {
      QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
          .collection(DataBaseConstants.feedbacks)
          .where('checkpointId', isEqualTo: widget.checkpointId)
          .orderBy('timestamp', descending: true) // Sort by latest first
          .get();

      List<Map<String, dynamic>> tempFeedbackList = [];

      for (var feedbackDoc in feedbackSnapshot.docs) {
        var feedbackData = feedbackDoc.data() as Map<String, dynamic>;
        var userDoc = await FirebaseFirestore.instance
            .collection(DataBaseConstants.users)
            .doc(feedbackData['userId'])
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;

          // Check if user is frequent driver
          bool isFrequentDriver = userData.containsKey('isFrequentDriver') &&
              userData['isFrequentDriver'] == true;

          tempFeedbackList.add({
            'name': userData['name'],
            'email': userData['email'],
            'weight': userData['weight'],
            'status': feedbackData['status'],
            'timestamp': feedbackData['timestamp'],
            'userType': isFrequentDriver ? "🚗 سائق متكرر" : "👤 مستخدم عادي",
          });
        }
      }

      setState(() {
        feedbackList = tempFeedbackList;
        isLoading = false; // Mark loading as complete
      });
    } catch (e) {
      print('Error fetching feedback: $e');
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.checkpointName,
              style: const TextStyle(fontSize: 24))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : feedbackList.isEmpty
              ? const Center(
                  child: Text(
                    "No feedbacks available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    var feedback = feedbackList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromARGB(255, 197, 130, 30),
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            feedback['email'],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   feedback['email'],
                              //   style: TextStyle(color: Colors.grey[700]),
                              // ),
                              Text(feedback['status'],
                                  style: TextStyle(
                                      color:
                                          _getStatusColor(feedback['status']),
                                      fontSize: 22)),
                              Text(
                                feedback[
                                    'userType'], // Displays "Frequent Driver" or "Normal User"
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 124, 184, 90)),
                              Text(
                                formatTimestamp(feedback['timestamp']),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'سالك': // Clear road
        return Colors.green;
      case 'مغلق': // Closed road
        return Colors.red;
      case 'أزمة شديدة': // Heavy traffic
        return const Color.fromARGB(255, 133, 81, 3);
      case 'أزمة خفيفة': // Light traffic
        return const Color.fromARGB(255, 238, 149, 16);
      default:
        return Colors.grey; // Default color for unknown status
    }
  }
}
