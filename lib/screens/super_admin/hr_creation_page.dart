import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_update_hr.dart';

class HrCreationPage extends StatefulWidget {
  const HrCreationPage({super.key});

  @override
  State<HrCreationPage> createState() => _HrCreationPageState();
}

class _HrCreationPageState extends State<HrCreationPage> {
  final CollectionReference staffsCollection =
      FirebaseFirestore.instance.collection('Staffs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Staff Creations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            staffsCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No staff data available.'));
          }

          final staffDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: staffDocs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot doc = staffDocs[index];
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
                        print("DOC ID : ${doc.id}");
                        print(
                            "Document Data : ${doc.data()}"); // Print all document data
                        _showStaffDialog(context, id: doc.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDeleteStaff(
                          doc.id), // Call the function directly
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
          Get.to(() => AddUpdateHrPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStaffDialog(BuildContext context, {required String id}) {
    Get.to(() => AddUpdateHrPage(), arguments: id);
  }

  Future<void> _deleteStaff(String id) async {
    await staffsCollection.doc(id).delete();
    Get.snackbar("Staff Deleted", "The staff entry has been removed.");
  }

  Future<void> _confirmDeleteStaff(String id) async {
    // Show confirmation dialog
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this staff?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false to cancel
              },
            ),
            TextButton(
              child: Text("Delete"),
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
      await staffsCollection.doc(id).delete();
      Get.snackbar("Staff Deleted", "The staff entry has been removed.");
    }
  }
}
