import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

      // Create a new document with an auto-generated ID
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('staffs').add(staffData);
      String uniqueId = docRef.id;

      // Update the document to include the ID within the document's data
      await FirebaseFirestore.instance
          .collection('staffs')
          .doc(uniqueId)
          .update({
        'id': uniqueId,
      });

      // Send WhatsApp message after adding staff
      await _sendWhatsAppMessage(
        mobileController.text,
        uniqueId,
        passwordController.text,
      );

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

  // Send WhatsApp message
  Future<void> _sendWhatsAppMessage(
      String phoneNumber, String memberID, String memberPassword) async {
    final String message = 'Hello $nameController.text,\n\n'
        'Welcome to JK EVENT MANAGEMENT! \n\n'
        'This is your MemberID and MemberPassword. \n\n'
        'Member ID: $memberID\n'
        'Member Password: $memberPassword\n\n'
        'Please do not share your MemberID and MemberPassword with anyone. \n\n';

    final Uri url = Uri.parse(
        'https://wa.me/+91$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
