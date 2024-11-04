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
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Capitalize the first letter and ensure the rest are lowercase
            String capitalized =
                value[0].toUpperCase() + value.substring(1).toLowerCase();
            // Update the text field only if the current input is different
            if (value != capitalized) {
              departments.departmentController.text = capitalized;
              // Move the cursor to the end of the text
              departments.departmentController.selection =
                  TextSelection.fromPosition(
                TextPosition(offset: capitalized.length),
              );
            }
          }
        },
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
