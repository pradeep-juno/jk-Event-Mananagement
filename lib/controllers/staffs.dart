import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Staffs extends GetxController {
  // Controllers for text fields
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();

  // Reactive variables
  var dateOfBirth = Rx<DateTime?>(null);
  var joiningDate = Rx<DateTime?>(null);
  var selectedDepartment = 'Event Management'.obs; // Default value
  var selectedPosition = 'Manager'.obs; // Default value

  // Staff list for displaying data
  var staffList = <DocumentSnapshot>[].obs;

  // Clear fields
  void clearFields() {
    nameController.clear();
    mobileController.clear();
    passwordController.clear();
    addressController.clear();
    dateOfBirth.value = null;
    joiningDate.value = null;
    selectedDepartment.value = 'Event Management'; // Reset to default
    selectedPosition.value = 'Manager'; // Reset to default
  }

  // Add staff to Firestore
  Future<void> addStaff() async {
    if (_validateFields()) {
      var staffData = {
        'name': nameController.text,
        'mobileNo': mobileController.text,
        'password': passwordController.text,
        'address': addressController.text,
        'department': selectedDepartment.value,
        'position': selectedPosition.value,
        'dateOfBirth': dateOfBirth.value != null
            ? DateFormat('yyyy-MM-dd').format(dateOfBirth.value!)
            : null,
        'joiningDate': joiningDate.value != null
            ? DateFormat('yyyy-MM-dd').format(joiningDate.value!)
            : null,
        'createdAt': FieldValue.serverTimestamp(), // Store as Timestamp
      };

      await FirebaseFirestore.instance.collection('staffs').add(staffData);
      clearFields(); // Clear fields after adding
      Get.snackbar('Success', 'Staff added successfully');
    }
  }

  // Update staff in Firestore
  Future<void> updateStaff(String id) async {
    if (_validateFields()) {
      var staffData = {
        'name': nameController.text,
        'mobileNo': mobileController.text,
        'password': passwordController.text,
        'address': addressController.text,
        'department': selectedDepartment.value,
        'position': selectedPosition.value,
        'dateOfBirth': dateOfBirth.value != null
            ? DateFormat('yyyy-MM-dd').format(dateOfBirth.value!)
            : null,
        'joiningDate': joiningDate.value != null
            ? DateFormat('yyyy-MM-dd').format(joiningDate.value!)
            : null,
        // We don't update createdAt; it remains unchanged
      };

      await FirebaseFirestore.instance
          .collection('staffs')
          .doc(id)
          .update(staffData);
      clearFields(); // Clear fields after updating
      Get.snackbar('Success', 'Staff updated successfully');
    }
  }

  // Delete staff from Firestore
  Future<void> deleteStaff(String id) async {
    await FirebaseFirestore.instance.collection('staffs').doc(id).delete();
    Get.snackbar('Success', 'Staff deleted successfully');
  }

  // Validation function
  bool _validateFields() {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedDepartment.value.isEmpty ||
        selectedPosition.value.isEmpty ||
        dateOfBirth.value == null ||
        joiningDate.value == null) {
      Get.snackbar('Error', 'Please fill in all fields');
      return false;
    }
    return true;
  }

  // Fetch staff list from Firestore
  Future<void> fetchStaff() async {
    var snapshot = await FirebaseFirestore.instance.collection('staffs').get();
    staffList.assignAll(snapshot.docs);
  }
}
