import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Staffs extends GetxController {
  final CollectionReference _staffCollection =
      FirebaseFirestore.instance.collection('staffs');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedDepartment;
  String? selectedPosition;

  var staffList = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _staffCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      staffList.value = snapshot.docs;
    });
  }

  Future<void> addStaff() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedDepartment == null ||
        selectedPosition == null) {
      Get.snackbar('Error', 'Please fill all the fields');
      return;
    }

    final String name = nameController.text.trim();
    final String mobileNo = mobileController.text.trim();
    final String password = passwordController.text.trim();
    final String address = addressController.text.trim();
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Add a new document with an auto-generated ID
    DocumentReference docRef = await _staffCollection.add({
      'name': name,
      'mobileNo': mobileNo,
      'password': password,
      'address': address,
      'department': selectedDepartment,
      'position': selectedPosition,
      'createdAt': formattedDateTime,
    });

    // Retrieve the auto-generated document ID
    String uniqueId = docRef.id;

    // Optionally, update the document to include the ID within the document's data
    await _staffCollection.doc(uniqueId).update({
      'id': uniqueId,
    });

    sendWhatsAppMessage(mobileNo,
        'Hello $name,\n\nWelcome to JK Event Management!\nYour MobileNo: $mobileNo\nPassword: $password');

    clearFields();
    Get.back();
  }

  void clearFields() {
    nameController.clear();
    mobileController.clear();
    passwordController.clear();
    addressController.clear();
    selectedDepartment = null;
    selectedPosition = null;
  }

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    final Uri url = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> deleteStaff(String id) async {
    await _staffCollection.doc(id).delete();
  }

  Future<void> updateStaff(String id) async {
    // Implement update logic
  }
}
