import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/create_hr_controller.dart';
import 'sa_add_update_hr.dart';

class HrCreationPage extends StatefulWidget {
  const HrCreationPage({super.key});

  @override
  State<HrCreationPage> createState() => _HrCreationPageState();
}

class _HrCreationPageState extends State<HrCreationPage> {
  final HrCreateController controller = Get.put(HrCreateController());
  final CollectionReference hrcreateCollection =
      FirebaseFirestore.instance.collection('HrCreate');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR  Creations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: hrcreateCollection
            .orderBy('Date of Joining', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No HR data available.'));
          }

          final hrcreateDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hrcreateDocs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot doc = hrcreateDocs[index];
              final data = doc.data() as Map<String, dynamic>?;

              // Extract the required fields
              final name = data?['Name'] ?? 'N/A';
              final capitalized = name.isNotEmpty
                  ? '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}'
                  : 'N/A';

              final position = data?['Position'] ?? 'N/A';
              final department = data?['Department'] ?? 'N/A';
              final password = data?['Password'] ?? 'N/A';
              final createdAt = data?['createdAt'] != null
                  ? (data!['createdAt'] is Timestamp
                      ? (data['createdAt'] as Timestamp).toDate().toString()
                      : data['createdAt'] as String)
                  : 'N/A';
              final joiningDate = data?['Date of Joining'] ?? 'N/A';

              return ListTile(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: capitalized,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '($position)',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Department: $department'),
                    Text('Password: $password'),
                    Text('Date of Joining: $joiningDate'),
                    Text('Created At: $createdAt'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showHrCreateDialog(context, id: doc.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDeleteHrCreate(doc.id),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddUpdateHR());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showHrCreateDialog(BuildContext context, {required String id}) {
    Get.to(() => AddUpdateHR(), arguments: id);
  }

  Future<void> _deleteHrCreate(String id) async {
    await hrcreateCollection.doc(id).delete();
    Get.snackbar("HR Deleted", "The HR entry has been removed.");
  }

  Future<void> _confirmDeleteHrCreate(String id) async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this HR entry?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false to cancel
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true to confirm
              },
            ),
          ],
        );
      },
    );

    // If confirmed, proceed with deletion
    if (confirmDelete == true) {
      await controller.deleteHRCreate(id);
      Get.snackbar("HR Deleted", "The HR entry has been removed.");
    }
  }
}
