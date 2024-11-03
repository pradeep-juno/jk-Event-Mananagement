import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MonthEndController extends GetxController {
  var month = ''.obs;
  var companyWorkingDays = ''.obs;

  void submitData() async {
    if (month.value.isNotEmpty && companyWorkingDays.value.isNotEmpty) {
      // Create a new document with a unique ID
      String docId =
          FirebaseFirestore.instance.collection('month_end_closing').doc().id;

      await FirebaseFirestore.instance
          .collection('month_end_closing')
          .doc(docId)
          .set({
        'month': month.value,
        'cwd': companyWorkingDays.value,
        'created_at': FieldValue.serverTimestamp(),
        'doc_id':
            docId, // Store the unique document ID in the Firestore document
      }).then((_) {
        // Clear the values after submission
        month.value = '';
        companyWorkingDays.value = '';
        Get.snackbar('Success', 'Month end details added successfully.');
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to add month end details: $error');
      });
    } else {
      Get.snackbar('Error', 'Please fill in all fields.');
    }
  }
}
