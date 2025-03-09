import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_app/generated/l10n.dart';
import 'package:grad_app/pages/sign_up.dart';
import 'dart:async'; // Import to use Timer

class CheckpointDetails extends StatefulWidget {
  final String checkpointId;
  final String checkpointName;

  const CheckpointDetails({
    required this.checkpointId,
    required this.checkpointName,
    super.key,
  });

  @override
  State<CheckpointDetails> createState() => _CheckpointDetailsState();
}

class _CheckpointDetailsState extends State<CheckpointDetails> {
  User? currentUser;
  late final ValueNotifier<DateTime> _currentTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  Timer? _timer; // Add a Timer variable to manage the periodic updates

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Fetch user on init
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the Timer to stop periodic updates

    _currentTimeNotifier.dispose(); // Dispose ValueNotifier
    super.dispose();
  }

  void _startTimer() {
    // Start a periodic timer to update the ValueNotifier every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _currentTimeNotifier.value = DateTime.now();
      }
    });
  }

  // Function to fetch current user
  void getCurrentUser() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<String> getCheckpointStatus(String checkpointId) async {
    try {
      // Fetch the document from the Firestore collection
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('checkpoints-v2')
          .doc(checkpointId)
          .get();

      // Check if the document exists and return the status field
      if (doc.exists) {
        return doc['status'] ??
            'not defined'; // Return status or a default value
      } else {
        return 'no availabe data'; // If document doesn't exist
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching status: $e');
      return 'try again ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('checkpoints-v2')
              .doc(widget.checkpointId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  S.of(context).errorOccurred,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text(
                  S.of(context).noDataAvailable,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final data = snapshot.data!;
            final status = data['status'] ?? 'غير معروف';
            final lastUpdated = data['lastUpdated'] as Timestamp?;

            final statusDetails = _getStatusDetails(status);
            final icon = statusDetails['icon'] as IconData;
            final iconColor = statusDetails['color'] as Color;

            return Stack(
              children: [
                // Background header
                Container(
                  height: 150,
                  color: Colors.green,
                ),
                SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'حاجز ${widget.checkpointName}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'الحالة',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Icon(
                                  icon,
                                  color: iconColor,
                                  size: 100,
                                ),
                                const SizedBox(height: 20),
                                // Here we will show the updated status of the checkpoint
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                //  Text(
                                //   'وقت النشر: منذ ساعة',
                                //   style: TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                // Text(
                                //   lastUpdated != null
                                //       ? 'وقت النشر: ${timeAgo(lastUpdated)}'
                                //       : 'وقت النشر غير متوفر',
                                //   style: const TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                ValueListenableBuilder<DateTime>(
                                  valueListenable: _currentTimeNotifier,
                                  builder: (context, currentTime, child) {
                                    return Text(
                                      lastUpdated != null
                                          ? 'وقت النشر: ${timeAgo(lastUpdated, currentTime)}'
                                          : 'وقت النشر غير متوفر',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle like
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(
                                        Icons.thumb_up,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle dislike
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(
                                        Icons.thumb_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  // onPressed: () => _showStatusUpdateSheet(
                                  //     context,
                                  //     widget.checkpointId,
                                  onPressed: () {
                                    if (currentUser == null) {
                                      // Show a dialog for guest users
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            title: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Text('Guest User'),
                                              ],
                                            ),
                                            content: Row(
                                              children: [
                                                Icon(Icons.warning,
                                                    color: Colors.orange),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    'Please log in to provide feedback',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actionsAlignment: MainAxisAlignment
                                                .center, // Center the buttons
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    icon: Icon(Icons.close),
                                                    label: Text('Cancel'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // Neutral color for Cancel
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignUpPage(),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                        Icons.app_registration),
                                                    label: Text('Sign up'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          251,
                                                          251), // Neutral color for Cancelcolor for Log In
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      // Call the function for authenticated users
                                      _showStatusUpdateSheet(
                                          context,
                                          widget.checkpointId,
                                          currentUser!.uid);
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                  ),
                                  child: const Text(
                                    'شاركنا بحالة الحاجز',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showStatusUpdateSheet(
      BuildContext context, String checkpointId, String? uid) {
    if (uid == null) {
      // User is not logged in (guest), show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يجب تسجيل الدخول لإرسال الحالة.',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Do not proceed further
    }

    // If user is logged in, show the bottom sheet
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'اختر الحالة الجديدة',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...[
                    'سالك',
                    'مغلق',
                    'أزمة شديدة',
                    'أزمة خفيفة'
                  ].map((newStatus) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => {
                              // Save feedback
                              saveFeedback(checkpointId, uid, newStatus),
                              // call the function to calculate the new status
                              Navigator.pop(context),
                              // Show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم تسجيل حالتك: $newStatus'),
                                  duration: const Duration(seconds: 2),
                                ),
                              ),
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: Icon(
                              _getStatusDetails(newStatus)['icon'],
                              color: _getStatusDetails(newStatus)['color'],
                            ),
                            label: Text(
                              newStatus,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> _getStatusDetails(String status) {
    switch (status) {
      case 'مغلق':
        return {'icon': Icons.error, 'color': Colors.red};
      case 'سالك':
        return {'icon': Icons.check_circle, 'color': Colors.green};
      case 'أزمة شديدة':
        return {'icon': Icons.warning_amber_rounded, 'color': Colors.orange};
      case 'أزمة خفيفة':
        return {
          'icon': Icons.info,
          'color': const Color.fromARGB(255, 154, 146, 70)
        };
      default:
        return {'icon': Icons.help, 'color': Colors.grey};
    }
  }

  Future<void> saveFeedback(
      String checkpointId, String userId, String status) async {
    try {
      final feedbackData = {
        'checkpointId': checkpointId, // Store checkpoint ID
        'userId': userId, // Store user ID
        'status': status, // Store status
        'timestamp': FieldValue.serverTimestamp(), // Use Firestore server time
      };

      await FirebaseFirestore.instance
          .collection('feedbacks')
          .add(feedbackData);

      print('Feedback saved successfully for checkpoint $checkpointId!');

      await calculateNewStatus(checkpointId);
    } catch (e) {
      print('Error saving feedback: $e');
    }
  }

  // Future<void> calculateNewStatus(String checkpointId) async {
  //   DateTime currentTime = DateTime.now();
  //   print('Calculating new status for checkpoint $checkpointId...');

  //   // Get the time 30 minutes ago from the current time
  //   DateTime thirtyMinutesAgo = currentTime.subtract(Duration(minutes: 30));

  //   // Fetch feedbacks from the last 30 minutes for the checkpoint
  //   final feedbacks = await FirebaseFirestore.instance
  //       .collection('feedbacks')
  //       .where('checkpointId', isEqualTo: checkpointId)
  //       .where('timestamp',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyMinutesAgo))
  //       .orderBy('timestamp', descending: true)
  //       .get();

  //   print('Found ${feedbacks.docs.length} feedbacks in the last 30 minutes.');

  //   // If there are no feedbacks, return early (no change to status)
  //   if (feedbacks.docs.isEmpty) {
  //     print('No feedbacks in the last 30 minutes.');
  //     return;
  //   }

  //   // Map to store the most recent feedback for each user
  //   Map<String, QueryDocumentSnapshot> userMostRecentFeedback = {};

  //   for (final feedback in feedbacks.docs) {
  //     final userId = feedback['userId'];
  //     final existingFeedback = userMostRecentFeedback[userId];
  //     final existingTimestamp = existingFeedback?['timestamp'] as Timestamp?;
  //     final newTimestamp = feedback['timestamp'] as Timestamp?;

  //     if (existingTimestamp == null ||
  //         (newTimestamp != null &&
  //             newTimestamp.seconds > existingTimestamp.seconds)) {
  //       userMostRecentFeedback[userId] = feedback;
  //     }
  //   }

  //   // Get the user IDs of the most recent feedbacks
  //   final userIds =
  //       userMostRecentFeedback.values.map((doc) => doc['userId']).toList();
  //   print('User IDs of most recent feedbacks: $userIds');

  //   // Get the user weights from the users collection
  //   final userWeights = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where(FieldPath.documentId, whereIn: userIds)
  //       .get();

  //   final Map<String, double> userWeightMap = {};
  //   for (final user in userWeights.docs) {
  //     userWeightMap[user.id] = user['role'] == 'admin'
  //         ? user['weight'] * 6 // Admin weight multiplied by 6
  //         : user['weight'];
  //   }

  //   // Initialize weighted sum for each status
  //   double salikWeight = 0.0,
  //       azmaKhafifaWeight = 0.0,
  //       azmaShadidaWeight = 0.0,
  //       maghloqWeight = 0.0;

  //   for (final feedback in userMostRecentFeedback.values) {
  //     final status = feedback['status'];
  //     final userId = feedback['userId'];
  //     final userWeight = userWeightMap[userId] ?? 0.4;

  //     switch (status) {
  //       case 'سالك':
  //         salikWeight += userWeight;
  //         break;
  //       case 'أزمة خفيفة':
  //         azmaKhafifaWeight += userWeight;
  //         break;
  //       case 'أزمة شديدة':
  //         azmaShadidaWeight += userWeight;
  //         break;
  //       case 'مغلق':
  //         maghloqWeight += userWeight;
  //         break;
  //       default:
  //         break;
  //     }
  //   }

  //   // Determine the new status
  //   String newStatus = 'سالك';
  //   double highestWeight = salikWeight;

  //   print(
  //       'Salik: $salikWeight, Azma Khafifa: $azmaKhafifaWeight, Azma Shadida: $azmaShadidaWeight, Maghloq: $maghloqWeight');

  //   if (azmaKhafifaWeight > highestWeight) {
  //     highestWeight = azmaKhafifaWeight;
  //     newStatus = 'أزمة خفيفة';
  //   }
  //   if (azmaShadidaWeight > highestWeight) {
  //     highestWeight = azmaShadidaWeight;
  //     newStatus = 'أزمة شديدة';
  //   }
  //   if (maghloqWeight > highestWeight) {
  //     highestWeight = maghloqWeight;
  //     newStatus = 'مغلق';
  //   }

  //   print('New status calculated: $newStatus');

  //   // Fetch current checkpoint status to avoid unnecessary updates
  //   final checkpointDoc = await FirebaseFirestore.instance
  //       .collection('checkpoints-v2')
  //       .doc(checkpointId)
  //       .get();

  //   final currentStatus =
  //       checkpointDoc.exists ? checkpointDoc['status'] ?? '' : '';

  //   if (currentStatus != newStatus) {
  //     await FirebaseFirestore.instance
  //         .collection('checkpoints-v2')
  //         .doc(checkpointId)
  //         .update({
  //       'status': newStatus,
  //       'lastUpdated':
  //           FieldValue.serverTimestamp(), // Only update if status changed
  //     });

  //     print('Updated checkpoint status to: $newStatus');
  //   } else {
  //     print('Status remains unchanged, no update needed.');
  //   }
  // }

  Future<void> calculateNewStatus(String checkpointId) async {
    DateTime currentTime = DateTime.now();
    print('Calculating new status for checkpoint $checkpointId...');

    DateTime thirtyMinutesAgo = currentTime.subtract(Duration(minutes: 30));

    final feedbacks = await FirebaseFirestore.instance
        .collection('feedbacks')
        .where('checkpointId', isEqualTo: checkpointId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyMinutesAgo))
        .orderBy('timestamp', descending: true)
        .get();

    print('Found ${feedbacks.docs.length} feedbacks in the last 30 minutes.');

    if (feedbacks.docs.isEmpty) {
      print('No feedbacks in the last 30 minutes.');
      return;
    }

    Map<String, QueryDocumentSnapshot> userMostRecentFeedback = {};

    for (final feedback in feedbacks.docs) {
      final userId = feedback['userId'];
      final existingFeedback = userMostRecentFeedback[userId];
      final existingTimestamp = existingFeedback?['timestamp'] as Timestamp?;
      final newTimestamp = feedback['timestamp'] as Timestamp?;

      if (existingTimestamp == null ||
          (newTimestamp != null &&
              newTimestamp.seconds > existingTimestamp.seconds)) {
        userMostRecentFeedback[userId] = feedback;
      }
    }

    final userIds =
        userMostRecentFeedback.values.map((doc) => doc['userId']).toList();
    print('User IDs of most recent feedbacks: $userIds');

    final userWeights = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    final Map<String, double> userWeightMap = {};
    for (final user in userWeights.docs) {
      userWeightMap[user.id] =
          user['role'] == 'admin' ? user['weight'] * 6 : user['weight'];
    }

    double salikWeight = 0.0,
        azmaKhafifaWeight = 0.0,
        azmaShadidaWeight = 0.0,
        maghloqWeight = 0.0;

    for (final feedback in userMostRecentFeedback.values) {
      final status = feedback['status'];
      final userId = feedback['userId'];
      final userBaseWeight = userWeightMap[userId] ?? 0.4;

      Timestamp feedbackTimestamp = feedback['timestamp'];
      double secondsSinceFeedback = currentTime
          .difference(feedbackTimestamp.toDate())
          .inSeconds
          .toDouble();

      // Calculate time decay weight (newer feedback has higher impact)
      double timeWeight = 1 - (secondsSinceFeedback / 1800);
      timeWeight =
          timeWeight.clamp(0.1, 1.0); // Ensure weight is within a valid range

      double finalWeight = userBaseWeight * timeWeight;

      switch (status) {
        case 'سالك':
          salikWeight += finalWeight;
          break;
        case 'أزمة خفيفة':
          azmaKhafifaWeight += finalWeight;
          break;
        case 'أزمة شديدة':
          azmaShadidaWeight += finalWeight;
          break;
        case 'مغلق':
          maghloqWeight += finalWeight;
          break;
        default:
          break;
      }
    }

    String newStatus = 'سالك';
    double highestWeight = salikWeight;

    print(
        'Salik: $salikWeight, Azma Khafifa: $azmaKhafifaWeight, Azma Shadida: $azmaShadidaWeight, Maghloq: $maghloqWeight');

    if (azmaKhafifaWeight > highestWeight) {
      highestWeight = azmaKhafifaWeight;
      newStatus = 'أزمة خفيفة';
    }
    if (azmaShadidaWeight > highestWeight) {
      highestWeight = azmaShadidaWeight;
      newStatus = 'أزمة شديدة';
    }
    if (maghloqWeight > highestWeight) {
      highestWeight = maghloqWeight;
      newStatus = 'مغلق';
    }

    print('New status calculated: $newStatus');

    final checkpointDoc = await FirebaseFirestore.instance
        .collection('checkpoints-v2')
        .doc(checkpointId)
        .get();

    final currentStatus =
        checkpointDoc.exists ? checkpointDoc['status'] ?? '' : '';

    if (currentStatus != newStatus) {
      await FirebaseFirestore.instance
          .collection('checkpoints-v2')
          .doc(checkpointId)
          .update({
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('Updated checkpoint status to: $newStatus');
    } else {
      print('Status remains unchanged, no update needed.');
    }
  }

  // Future<void> calculateNewStatus(String checkpointId) async {
  //   DateTime currentTime = DateTime.now();
  //   print('Calculating new status for checkpoint $checkpointId...');

  //   // Get the time 30 minutes ago from the current time
  //   DateTime thirtyMinutesAgo = currentTime.subtract(Duration(minutes: 30));

  //   // Fetch feedbacks from the last 30 minutes for the checkpoint, ordered by timestamp descending
  //   final feedbacks = await FirebaseFirestore.instance
  //       .collection('feedbacks')
  //       .where('checkpointId', isEqualTo: checkpointId)
  //       .where('timestamp',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyMinutesAgo))
  //       .orderBy('timestamp',
  //           descending: true) // Order by timestamp, most recent first
  //       .get();

  //   print('Found ${feedbacks.docs.length} feedbacks in the last 30 minutes.');

  //   // If there are no feedbacks, return early (no change to status)
  //   if (feedbacks.docs.isEmpty) {
  //     print('No feedbacks in the last 30 minutes.');
  //     return;
  //   }

  //   // Map to store the most recent feedback for each user
  //   Map<String, QueryDocumentSnapshot> userMostRecentFeedback = {};

  //   // Iterate over the feedbacks and store the most recent feedback for each user
  //   for (final feedback in feedbacks.docs) {
  //     final userId = feedback['userId'];

  //     // Get the timestamp of the current and existing feedbacks
  //     final existingFeedback = userMostRecentFeedback[userId];
  //     final existingTimestamp = existingFeedback != null
  //         ? existingFeedback['timestamp'] as Timestamp?
  //         : null;
  //     final newTimestamp = feedback['timestamp'] as Timestamp?;

  //     // Ensure both timestamps are non-null before comparison
  //     if (existingTimestamp != null && newTimestamp != null) {
  //       if (newTimestamp.seconds > existingTimestamp.seconds) {
  //         userMostRecentFeedback[userId] = feedback;
  //       }
  //     } else if (existingTimestamp == null) {
  //       // If there's no previous feedback for this user, add the new feedback
  //       userMostRecentFeedback[userId] = feedback;
  //     }
  //   }

  //   // Get the user IDs of the most recent feedbacks
  //   final userIds =
  //       userMostRecentFeedback.values.map((doc) => doc['userId']).toList();
  //   print('User IDs of most recent feedbacks: $userIds');

  //   // Get the user weights from the users collection
  //   final userWeights = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where(FieldPath.documentId, whereIn: userIds)
  //       .get();

  //   // Create a map for user weights for faster lookup
  //   final Map<String, double> userWeightMap = {};
  //   for (final user in userWeights.docs) {
  //     if (user['role'] == 'admin') {
  //       userWeightMap[user.id] =
  //           user['weight'] * 6; // Multiply admin's weight by 6
  //     } else {
  //       userWeightMap[user.id] = user['weight']; // Regular user weight
  //     }
  //   }

  //   // Initialize total weighted sum for each status
  //   double salikWeight = 0.0;
  //   double azmaKhafifaWeight = 0.0;
  //   double azmaShadidaWeight = 0.0;
  //   double maghloqWeight = 0.0;

  //   // Iterate through the most recent feedbacks to calculate the weighted sum for each status
  //   for (final feedback in userMostRecentFeedback.values) {
  //     final status = feedback['status']; // Get the feedback status
  //     final userId = feedback['userId']; // Get the user ID for the feedback

  //     print('Processing feedback with status: $status from user $userId');

  //     // Get the user weight from the map
  //     final userWeight =
  //         userWeightMap[userId] ?? 0.4; // Default to 0.4 if not found

  //     // Add the user's weight to the corresponding status
  //     switch (status) {
  //       case 'سالك':
  //         salikWeight += userWeight;
  //         break;
  //       case 'أزمة خفيفة':
  //         azmaKhafifaWeight += userWeight;
  //         break;
  //       case 'أزمة شديدة':
  //         azmaShadidaWeight += userWeight;
  //         break;
  //       case 'مغلق':
  //         maghloqWeight += userWeight;
  //         break;
  //       default:
  //         break;
  //     }
  //   }

  //   // Compare the weighted sums to determine the new status
  //   double highestWeight = salikWeight;
  //   String newStatus = 'سالك';

  //   print(
  //       'Salik: $salikWeight, Azma Khafifa: $azmaKhafifaWeight, Azma Shadida: $azmaShadidaWeight, Maghloq: $maghloqWeight');

  //   if (azmaKhafifaWeight > highestWeight) {
  //     highestWeight = azmaKhafifaWeight;
  //     newStatus = 'أزمة خفيفة';
  //   }
  //   if (azmaShadidaWeight > highestWeight) {
  //     highestWeight = azmaShadidaWeight;
  //     newStatus = 'أزمة شديدة';
  //   }
  //   if (maghloqWeight > highestWeight) {
  //     highestWeight = maghloqWeight;
  //     newStatus = 'مغلق';
  //   }

  //   print('New status calculated: $newStatus');

  //   // Update the checkpoint status in Firestore
  //   await FirebaseFirestore.instance
  //       .collection('checkpoints-v2')
  //       .doc(checkpointId)
  //       .update({
  //     'status': newStatus,
  //     'lastUpdated':
  //         FieldValue.serverTimestamp(), // Optional: store the update timestamp
  //   });

  //   print('Updated checkpoint status to: $newStatus');
  // }

  String timeAgo(Timestamp timestamp, DateTime currentTime) {
    final DateTime lastUpdatedTime = timestamp.toDate();
    final Duration difference = currentTime.difference(lastUpdatedTime);

    if (difference.inMinutes < 1) {
      return 'منذ لحظات';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
