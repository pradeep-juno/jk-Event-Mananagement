import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/staffs.dart';

class StaffPage extends StatelessWidget {
  StaffPage({Key? key}) : super(key: key);

  final Staffs staffs = Get.put(Staffs());

  // Method to fetch staff data
  void _fetchStaff() {
    staffs.fetchStaff();
  }

  Future<void> _selectDate(BuildContext context, Rx<DateTime?> date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      date.value = picked;
    }
  }

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
            maxLength: 10,
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
            value: staffs.selectedDepartment.value,
            onChanged: (value) {
              if (value != null) {
                staffs.selectedDepartment.value = value;
              }
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
            value: staffs.selectedPosition.value,
            onChanged: (value) {
              if (value != null) {
                staffs.selectedPosition.value = value;
              }
            },
            items: [
              DropdownMenuItem(value: 'Manager', child: Text('Manager')),
              DropdownMenuItem(value: 'Incharge', child: Text('Incharge')),
              DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
              DropdownMenuItem(value: 'Staff', child: Text('Staff')),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final dateOfBirth = staffs.dateOfBirth.value;
            return TextButton(
              onPressed: () => _selectDate(Get.context!, staffs.dateOfBirth),
              child: Text(
                'Date of Birth: ${dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(dateOfBirth) : 'Select Date'}',
              ),
            );
          }),
          const SizedBox(height: 8),
          Obx(() {
            final joiningDate = staffs.joiningDate.value;
            return TextButton(
              onPressed: () => _selectDate(Get.context!, staffs.joiningDate),
              child: Text(
                'Joining Date: ${joiningDate != null ? DateFormat('yyyy-MM-dd').format(joiningDate) : 'Select Date'}',
              ),
            );
          }),
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
    // Fetch staff list when the page is built
    _fetchStaff();

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
            final DocumentSnapshot doc = staffs.staffList[index];
            final data = doc.data() as Map<String, dynamic>?;

            // Extract the required fields
            final name = data?['name'] ?? 'N/A';
            final position = data?['position'] ?? 'N/A';
            final department = data?['department'] ?? 'N/A';
            final password = data?['password'] ?? 'N/A';
            final createdAt = data?['createdAt'] != null
                ? (data!['createdAt'] is Timestamp
                    ? (data['createdAt'] as Timestamp).toDate().toString()
                    : data['createdAt']
                        as String) // Handle case where createdAt is a String
                : 'N/A';
            final joiningDate = data?['joiningDate'] ?? 'N/A';

            return ListTile(
              title: Text('$name, $position'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department: $department'),
                  Text('Password: $password'),
                  Text('Joining Date: $joiningDate'),
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
