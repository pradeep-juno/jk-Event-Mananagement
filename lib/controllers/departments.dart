import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Departments extends GetxController {
  final CollectionReference _departmentsCollection =
      FirebaseFirestore.instance.collection('departments');
  final TextEditingController departmentController = TextEditingController();

  var departments = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _departmentsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      departments.value = snapshot.docs;
    });
  }

  Future<void> addDepartment() async {
    if (departmentController.text.isEmpty) return;

    final String departmentName = departmentController.text.trim();
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Add a new document with an auto-generated ID
    DocumentReference docRef = await _departmentsCollection.add({
      'name': departmentName,
      'createdAt': formattedDateTime,
    });

    // Retrieve the auto-generated document ID
    String uniqueId = docRef.id;

    // Optionally, update the document to include the ID within the document's data
    await _departmentsCollection.doc(uniqueId).update({
      'id': uniqueId,
    });

    departmentController.clear();
    Get.back();
  }

  Future<void> updateDepartment(String id) async {
    if (departmentController.text.isEmpty) return;

    final String departmentName = departmentController.text.trim();
    await _departmentsCollection.doc(id).update({
      'name': departmentName,
      'updatedAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });

    departmentController.clear();
    Get.back();
  }

  Future<void> deleteDepartment(String id) async {
    await _departmentsCollection.doc(id).delete();
  }
}
