import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/model/checkpoint.dart';
import 'package:grad_app/pages/route_node.dart';
import 'package:grad_app/service/checkpoint_service.dart';

class RoadDetailsView extends StatelessWidget {
  final List<Node> roadDetails;

  const RoadDetailsView({Key? key, required this.roadDetails})
      : super(key: key);

  void _showCityCheckpoints(BuildContext context, String cityName) async {
    final CheckpointService _firebaseCheckpoint = CheckpointService();

    try {
      // Use the service method to fetch checkpoints
      List<Checkpoint> checkpoints =
          await _firebaseCheckpoint.getCheckpointsByCitiesAndType(
        namesOfCities: {cityName},
        type: 'داخلي',
      );

      // Map the results to a list of cards
      List<Widget> checkpointWidgets = checkpoints.map((checkpoint) {
        final statusStyle = _getStatusStyle(checkpoint.status);
        final lastUpdated = checkpoint.lastUpdated;
        String time = _timeSinceReported(lastUpdated);

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ListTile(
            leading: Image.asset(
              'assets/images/checkpoint.png',
              width: 40,
              height: 40,
            ),
            title: Text(
              checkpoint.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الحالة: ${checkpoint.status}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusStyle['color'], // Apply dynamic color
                    fontSize: 18,
                  ),
                ),
                Text(
                  'آخر تحديث: $time',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }).toList();

      // Show the results in a styled dialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppConstants.primaryColor, width: 5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'الحواجز في $cityName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: ListView(
                      children: checkpointWidgets,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during the query
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('خطأ'),
          content: Text('فشل تحميل الحواجز: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إغلاق', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  Map<String, dynamic> _getStatusStyle(String status) {
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

  String _timeSinceReported(Timestamp? timestamp) {
    if (timestamp == null) return 'وقت غير معروف';

    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم${difference.inDays > 1 ? "اً" : ""}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة${difference.inHours > 1 ? "" : " واحدة"}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة${difference.inMinutes > 1 ? "" : " واحدة"}';
    } else {
      return 'الآن';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: roadDetails.asMap().entries.map((entry) {
        final index = entry.key;
        final element = entry.value;

        return Column(
          children: [
            // If the element is a city, create a TextButton
            if (element.type == NodeType.city)
              TextButton(
                onPressed: () {
                  _showCityCheckpoints(context, element.name);
                },
                child: Text(
                  element.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 79, 131, 82),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            // If the element is a checkpoint, display its name and status
            if (element.type == NodeType.checkpoint)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  Text(
                    element.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Check if status is not empty and display it next to the name
                  if (element.status.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Builder(
                        builder: (context) {
                          final statusStyle = _getStatusStyle(element.status);
                          return Row(
                            children: [
                              Icon(
                                statusStyle['icon'],
                                color: statusStyle['color'],
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                element.status,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: statusStyle['color'],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            // Divider between nodes
            if (index < roadDetails.length - 1)
              Container(
                width: 4,
                height: 30,
                color: Colors.grey.shade400,
              ),
          ],
        );
      }).toList(),
    );
  }
}
