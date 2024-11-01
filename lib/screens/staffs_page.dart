import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/staffs.dart';

class StaffPage extends StatelessWidget {
  StaffPage({Key? key}) : super(key: key);

  final Staffs staffs = Get.put(Staffs());

  void _showStaffDialog({String? id}) {
    // Reset fields if adding new staff
    staffs.clearFields();

    Get.defaultDialog(
      title: id == null ? 'Add Staff Details' : 'Edit Staff Details',
      content: Column(
        children: [
          TextField(
            controller: staffs.nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: staffs.mobileController,
            decoration: const InputDecoration(labelText: 'Mobile No'),
            keyboardType: TextInputType.phone,
            maxLength: 10, // Limit to 10 digits
          ),
          TextField(
            controller: staffs.passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: staffs.addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 3,
          ),
          DropdownButton<String>(
            hint: const Text('Select Department'),
            value: staffs.selectedDepartment,
            onChanged: (value) {
              staffs.selectedDepartment = value;
            },
            items: [
              DropdownMenuItem(
                  value: 'Event Management', child: Text('Event Management')),
              DropdownMenuItem(
                  value: 'Chemical Management',
                  child: Text('Chemical Management')),
              DropdownMenuItem(
                  value: 'Marketing Department',
                  child: Text('Marketing Department')),
              DropdownMenuItem(
                  value: 'Account Department',
                  child: Text('Account Department')),
            ],
          ),
          DropdownButton<String>(
            hint: const Text('Select Position'),
            value: staffs.selectedPosition,
            onChanged: (value) {
              staffs.selectedPosition = value;
            },
            items: [
              DropdownMenuItem(value: 'Manager', child: Text('Manager')),
              DropdownMenuItem(value: 'Incharge', child: Text('Incharge')),
              DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
              DropdownMenuItem(value: 'Staff', child: Text('Staff')),
            ],
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Submit',
      onConfirm: () {
        if (id == null) {
          staffs.addStaff();
        } else {
          staffs.updateStaff(id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Details'),
      ),
      body: Obx(() {
        if (staffs.staffList.isEmpty) {
          return const Center(child: Text('No Staff Available'));
        }

        return ListView.builder(
          itemCount: staffs.staffList.length,
          itemBuilder: (context, index) {
            final doc = staffs.staffList[index];
            final name = doc['name'];
            final position = doc['position'];
            final department = doc['department'];
            final createdAt = doc['createdAt'];

            return ListTile(
              title: Text('$name, $position'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department: $department'),
                  Text('Created At: $createdAt'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showStaffDialog(id: doc.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => staffs.deleteStaff(doc.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStaffDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
