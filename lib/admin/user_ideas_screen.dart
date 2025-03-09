import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/admin/admin_nav_bar.dart';
import 'package:grad_app/constants/data_base_constants.dart';

class UserIdeasScreen extends StatelessWidget {
  const UserIdeasScreen({super.key});

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
                // Use a reverse/back icon
                icon: const Icon(Icons.reply, // Updated icon
                    color: Color.fromARGB(255, 8, 8, 8),
                    size: 30),
                onPressed: () {
                  // Navigate back to the previous page
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Background header area
            Container(
              height: 150,
              color: AppConstants.primaryColor,
              child: Center(
                child: const Text(
                  'User Ideas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildIdeasList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of user ideas using StreamBuilder
  Widget _buildIdeasList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              DataBaseConstants.suggestions) // Collection for user ideas
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No ideas submitted yet.'));
        }

        var ideas = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: ideas.length,
          itemBuilder: (context, index) {
            var idea = ideas[index];
            return _buildIdeaCard(context, idea);
          },
        );
      },
    );
  }

  Widget _buildIdeaCard(BuildContext context, QueryDocumentSnapshot idea) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                idea['name'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('', idea['description'] ?? 'No Description'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _deleteIdea(idea);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 184, 170, 170),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Deletes an idea
  Future<void> _deleteIdea(QueryDocumentSnapshot idea) async {
    await FirebaseFirestore.instance
        .collection(DataBaseConstants.suggestions)
        .doc(idea.id)
        .delete();
  }

  /// Helper method to build a row with a bold label and the value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
