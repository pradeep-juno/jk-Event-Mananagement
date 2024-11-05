import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/staffs.dart';

class HRStaffCreationPage extends StatelessWidget {
  HRStaffCreationPage({Key? key}) : super(key: key);

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

  void _showStaffDialog(BuildContext context, {String? id}) {
    // Reset fields if adding new staff
    staffs.clearFields();

    Get.defaultDialog(
      title: id == null ? 'Add Staff Details' : 'Edit Staff Details',
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: staffs.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    // Capitalize the first letter and ensure the rest are lowercase
                    String capitalized = value[0].toUpperCase() +
                        value.substring(1).toLowerCase();
                    // Update the text field only if the current input is different
                    if (value != capitalized) {
                      staffs.nameController.text = capitalized;
                      // Move the cursor to the end of the text
                      staffs.nameController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: capitalized.length),
                      );
                    }
                  }
                },
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

              // DropdownButton<String>(
              //   hint: const Text('Select Department'),
              //   value: staffs.selectedDepartment.value.isEmpty
              //       ? null
              //       : staffs.selectedDepartment.value,
              //   onChanged: (value) {
              //     if (value != null) {
              //       staffs.selectedDepartment.value = value;
              //     }
              //   },
              //   items: [
              //     const DropdownMenuItem(
              //       value: '', // Default static value
              //       child: Text('Select Department'),
              //     ),
              //     ...staffs.departmentsList
              //         .map((department) => DropdownMenuItem<String>(
              //               value: department,
              //               child: Text(department),
              //             ))
              //         .toSet()
              //         .toList(), // Convert to Set to ensure uniqueness
              //   ],
              // ),

              // DropdownButton<String>(
              //   hint: const Text('Select Department'),
              //   value: staffs.selectedDepartment.value,
              //   onChanged: (value) {
              //     if (value != null) {
              //       staffs.selectedDepartment.value = value;
              //     }
              //   },
              //   items: [
              //     DropdownMenuItem(
              //         value: 'Event Management',
              //         child: Text('Event Management')),
              //     DropdownMenuItem(
              //         value: 'Chemical Management',
              //         child: Text('Chemical Management')),
              //     DropdownMenuItem(
              //         value: 'Marketing Department',
              //         child: Text('Marketing Department')),
              //     DropdownMenuItem(
              //         value: 'Account Department',
              //         child: Text('Account Department')),
              //   ],
              // ),
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
                  DropdownMenuItem(
                      value: 'Supervisor', child: Text('Supervisor')),
                  DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                final dateOfBirth = staffs.dateOfBirth.value;
                return TextButton(
                  onPressed: () =>
                      _selectDate(Get.context!, staffs.dateOfBirth),
                  child: Text(
                    'Date of Birth: ${dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(dateOfBirth) : 'Select Date'}',
                  ),
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final joiningDate = staffs.joiningDate.value;
                return TextButton(
                  onPressed: () =>
                      _selectDate(Get.context!, staffs.joiningDate),
                  child: Text(
                    'Joining Date: ${joiningDate != null ? DateFormat('yyyy-MM-dd').format(joiningDate) : 'Select Date'}',
                  ),
                );
              }),
            ],
          ),
        ),
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
                    onPressed: () {
                      print("DOC ID : ${doc.id}");
                      _showStaffDialog(context, id: doc.id);
                    },
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
        onPressed: () {
          print("Dialog Clicked");
          _showStaffDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
