import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../controllers/monthendcontroller.dart';

class MonthEndClosingPage extends StatefulWidget {
  const MonthEndClosingPage({Key? key}) : super(key: key);

  @override
  State<MonthEndClosingPage> createState() => _MonthEndClosingPageState();
}

class _MonthEndClosingPageState extends State<MonthEndClosingPage> {
  final MonthEndController controller = Get.put(MonthEndController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month End Closing Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('month_end_closing')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text('${doc['month']}'),
                        subtitle: Text(
                          'CWD: ${doc['cwd']}\nCreated at: ${doc['created_at']?.toDate()}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Call the edit function with document ID and current data
                            _showEditMonthEndDialog(
                              doc.id, // Pass the document ID
                              doc['month'],
                              doc['cwd'],
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No data found.'));
              },
            ),
          ),
          FloatingActionButton(
            onPressed: _showAddMonthEndDialog,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showAddMonthEndDialog() {
    Get.defaultDialog(
      title: 'Month End Details',
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Get the current date
              final now = DateTime.now();
              // Use the current year and month for the picker
              final selected = await showMonthYearPicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(2019),
                lastDate: DateTime(now.year,
                    now.month), // Set the last date to the current month
              );

              if (selected != null) {
                // Format the selected month and year as "MMM YYYY"
                controller.month.value =
                    DateFormat('MMM yyyy').format(selected);
              }
            },
            child: Obx(() => Text(controller.month.value.isEmpty
                ? 'Choose Month'
                : controller.month.value)),
          ),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: 2,
            decoration:
                const InputDecoration(labelText: 'Company Working Days'),
            onChanged: (value) {
              if (value.length <= 2) {
                controller.companyWorkingDays.value =
                    value; // Update only if within limit
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              controller.submitData(); // Call submit function
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showEditMonthEndDialog(
      String docId, String currentMonth, String currentCWD) {
    // Reset values for editing
    controller.month.value = currentMonth;
    controller.companyWorkingDays.value = currentCWD;

    Get.defaultDialog(
      title: 'Edit Month End Details',
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final selected = await showMonthYearPicker(
                context: context,
                initialDate: DateFormat('MMM yyyy').parse(currentMonth),
                firstDate: DateTime(2019),
                lastDate: DateTime.now(),
              );

              if (selected != null) {
                controller.month.value =
                    DateFormat('MMM yyyy').format(selected);
              }
            },
            child: Obx(() => Text(controller.month.value.isEmpty
                ? 'Choose Month'
                : controller.month.value)),
          ),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: 2,
            decoration:
                const InputDecoration(labelText: 'Company Working Days'),
            onChanged: (value) {
              if (value.length <= 2) {
                controller.companyWorkingDays.value = value;
              }
            },
            controller:
                TextEditingController(text: currentCWD), // Pre-fill current CWD
          ),
          ElevatedButton(
            onPressed: () {
              // Update Firestore document using the docId
              FirebaseFirestore.instance
                  .collection('month_end_closing')
                  .doc(docId)
                  .update({
                'month': controller.month.value,
                'cwd': controller.companyWorkingDays.value,
                // 'created_at' can be kept the same, or you can update it to the current time
                // 'created_at': FieldValue.serverTimestamp(),
              }).then((_) {
                Get.back(); // Close dialog on success
                controller.month.value = '';
                controller.companyWorkingDays.value = '';
              }).catchError((error) {
                Get.snackbar('Error', 'Failed to update data: $error');
              });
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
