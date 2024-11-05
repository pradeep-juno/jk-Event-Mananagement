import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffController extends GetxController {
  // TextEditingControllers for form fields
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final dojController = TextEditingController();

  // Rx variables for dropdown selections
  var selectedDepartment = ''.obs;
  var selectedPosition = ''.obs;

  // Firestore reference
  final firestore = FirebaseFirestore.instance;

  // Function to store data in Firestore with validations
  Future<void> addStaff() async {
    if (!await validateInputs()) return;

    final docRef = firestore.collection('Staffs').doc();
    String docID = docRef.id;
    try {
      await docRef.set({
        'docid': docID,
        'Name': nameController.text,
        'DOB': dobController.text,
        'Mobile Number': mobileController.text,
        'Password': passwordController.text,
        'Address': addressController.text,
        'Department': selectedDepartment.value,
        'Position': selectedPosition.value,
        'Date of Joining': dojController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Staff added successfully!');
      clearForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add staff: $e');
    }
  }

  // Validation function for all fields
  Future<bool> validateInputs() async {
    if (nameController.text.length < 3) {
      Get.snackbar('Validation Error', 'Name must be at least 3 characters.');
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(mobileController.text)) {
      Get.snackbar('Validation Error', 'Mobile Number must be 10 digits.');
      return false;
    }

    // Check if Mobile Number already exists
    final QuerySnapshot existingMobiles = await FirebaseFirestore.instance
        .collection('Staffs')
        .where('Mobile Number', isEqualTo: mobileController.text)
        .get();

    if (existingMobiles.docs.isNotEmpty) {
      Get.snackbar('Validation Error', 'Mobile Number is already registered.');
      return false;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
          'Validation Error', 'Password must be at least 8 characters.');
      return false;
    }
    if (selectedDepartment.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a department.');
      return false;
    }
    if (selectedPosition.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a position.');
      return false;
    }
    if (dobController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please select Date of Birth.');
      return false;
    }
    if (dojController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please select Date of Joining.');
      return false;
    }
    return true;
  }

  // Function to clear form fields
  void clearForm() {
    nameController.clear();
    dobController.clear();
    mobileController.clear();
    passwordController.clear();
    addressController.clear();
    dojController.clear();
    selectedDepartment.value = '';
    selectedPosition.value = '';
  }

  @override
  void onClose() {
    // Dispose controllers when not in use
    nameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    addressController.dispose();
    dojController.dispose();
    super.onClose();
  }
}
