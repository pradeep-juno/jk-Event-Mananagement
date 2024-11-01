import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/departments.dart';

class DepartmentsPage extends StatelessWidget {
  DepartmentsPage({Key? key}) : super(key: key);

  final Departments departments = Get.put(Departments());

  // Function to show the add/edit department dialog
  void _showDepartmentDialog({String? id, String? existingName}) {
    departments.departmentController.text = existingName ?? '';

    Get.defaultDialog(
      title: id == null ? 'Add Department' : 'Edit Department',
      content: TextField(
        controller: departments.departmentController,
        decoration: const InputDecoration(labelText: 'Department Name'),
      ),
      textCancel: 'Cancel',
      textConfirm: 'Submit',
      onConfirm: () {
        if (id == null) {
          departments.addDepartment();
        } else {
          departments.updateDepartment(id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments Details'),
      ),
      body: Obx(() {
        if (departments.departments.isEmpty) {
          return const Center(child: Text('No Departments Available'));
        }

        return ListView.builder(
          itemCount: departments.departments.length,
          itemBuilder: (context, index) {
            final doc = departments.departments[index];
            final departmentName = doc['name'];
            final dateTime = doc['createdAt'];

            return ListTile(
              title: Text(departmentName),
              subtitle: Text(dateTime),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showDepartmentDialog(
                        id: doc.id, existingName: departmentName),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => departments.deleteDepartment(doc.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDepartmentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
