import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrCreateController extends GetxController {
  // TextEditingControllers for form fields
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final dojController = TextEditingController();

  // Rx variables for dropdown selections, pre-set to 'HR'
  var selectedDepartment = 'HR'.obs;
  var selectedPosition = 'HR'.obs;

  // Firestore reference
  final firestore = FirebaseFirestore.instance;

  // Function to store data in Firestore with validations
  Future<void> addHrCreate() async {
    if (!await validateInputs()) return;

    final docRef = firestore.collection('HrCreate').doc();
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
      Get.snackbar('Success', 'HR entry added successfully!');
      clearForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add HR entry: $e');
    }
  }

  Future<void> updateHRCreate(bool isEditMode, String? docId) async {
    if (!await updateValidateInputs()) return;

    final data = {
      'Name': nameController.text,
      'Mobile Number': mobileController.text,
      'Password': passwordController.text,
      'Address': addressController.text,
      'DOB': dobController.text,
      'Date of Joining': dojController.text,
      'Department':
          selectedDepartment.value, // Use .value if using Rx variables
      'Position': selectedPosition.value, // Use .value if using Rx variables
    };

    if (isEditMode && docId != null) {
      try {
        // Update existing staff data
        await FirebaseFirestore.instance
            .collection('HrCreate')
            .doc(docId)
            .update(data);
        Get.snackbar(
            "HR Updated", "HR details have been updated successfully.");
      } catch (e) {
        Get.snackbar("Error", "Failed to update staff: $e");
      }
    }
  }

  Future<void> deleteHRCreate(String? docId) async {
    await FirebaseFirestore.instance.collection('HrCreate').doc(docId).delete();
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
    final QuerySnapshot existingMobiles = await firestore
        .collection('HrCreate')
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

  Future<bool> updateValidateInputs() async {
    if (nameController.text.length < 3) {
      Get.snackbar('Validation Error', 'Name must be at least 3 characters.');
      return false;
    }

    if (dobController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please select Date of Birth.');
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(mobileController.text)) {
      Get.snackbar('Validation Error', 'Mobile Number must be 10 digits.');
      return false;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
          'Validation Error', 'Password must be at least 8 characters.');
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
    selectedDepartment.value = 'HR';
    selectedPosition.value = 'HR';
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
