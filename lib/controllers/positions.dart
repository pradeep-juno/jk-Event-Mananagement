import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Positions extends GetxController {
  final CollectionReference _positionsCollection =
      FirebaseFirestore.instance.collection('positions');
  final TextEditingController positionController = TextEditingController();

  var positions = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    _positionsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      positions.value = snapshot.docs;
    });
  }

  Future<void> addPosition() async {
    if (positionController.text.isEmpty) return;

    final String positionName = positionController.text.trim();
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Add a new document with an auto-generated ID
    DocumentReference docRef = await _positionsCollection.add({
      'name': positionName,
      'createdAt': formattedDateTime, // Store the formatted date-time
    });

    // Retrieve the auto-generated document ID
    String uniqueId = docRef.id;

    // Optionally, update the document to include the ID within the document's data
    await _positionsCollection.doc(uniqueId).update({
      'id': uniqueId,
    });

    positionController.clear();
    Get.back();
  }

  Future<void> updatePosition(String id) async {
    if (positionController.text.isEmpty) return;

    final String positionName = positionController.text.trim();
    await _positionsCollection.doc(id).update({
      'name': positionName,
      'updatedAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });

    positionController.clear();
    Get.back();
  }

  Future<void> deletePosition(String id) async {
    await _positionsCollection.doc(id).delete();
  }
}
