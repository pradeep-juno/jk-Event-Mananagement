import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/staff_controller.dart';

class HrAddUpdateStaffPage extends StatefulWidget {
  @override
  _HrAddUpdateStaffPageState createState() => _HrAddUpdateStaffPageState();
}

class _HrAddUpdateStaffPageState extends State<HrAddUpdateStaffPage> {
  final StaffController controller = Get.put(StaffController());
  String? selectedDepartment;
  String? selectedPosition;
  bool isEditMode = false;

  String? docId; // ""

  @override
  void initState() {
    super.initState();

    docId = Get.arguments as String?; //"docid"

    if (docId != null) {
      isEditMode = true;
      _loadStaffData(docId!);
    }

    controller.mobileController.addListener(() {
      validateMobileNumber(controller.mobileController.text);
    });

    controller.passwordController.addListener(() {
      validatePassword(controller.passwordController.text);
    });
  }

  Future<void> _loadStaffData(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('Staffs').doc(id).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          controller.nameController.text = data['Name'] ?? '';
          controller.mobileController.text = data['Mobile Number'] ?? '';
          controller.passwordController.text = data['Password'] ?? '';
          controller.addressController.text = data['Address'] ?? '';
          controller.dobController.text = data['DOB'] ?? '';
          controller.dojController.text = data['Date of Joining'] ?? '';
          selectedDepartment = data['Department'];
          selectedPosition = data['Position'];
        });
      }
    }
  }

  Future<void> validateMobileNumber(String mobileNumber) async {
    if (mobileNumber.length == 10) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Staffs')
          .where('Mobile Number', isEqualTo: mobileNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty &&
          querySnapshot.docs.first.id != docId) {
        Get.snackbar(
            'Validation Error', 'This mobile number is already registered.');
      }
    }
  }

  void validatePassword(String password) {
    // Add your password validation logic here if needed
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    inputFormatters ??= [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickDate(
      BuildContext context, TextEditingController dateController) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      dateController.text = selectedDate.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Staff' : 'Add Staff'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField('Name', controller.nameController),
              GestureDetector(
                onTap: () => pickDate(context, controller.dobController),
                child: AbsorbPointer(
                  child: buildTextField('DOB', controller.dobController),
                ),
              ),
              buildTextField(
                'Mobile Number',
                controller.mobileController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              buildTextField(
                'Password',
                controller.passwordController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
              buildTextField('Address', controller.addressController,
                  maxLines: 3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildDropdown(
                  'Department',
                  selectedDepartment,
                  'departments',
                  (value) {
                    setState(() {
                      selectedDepartment = value;
                      controller.selectedDepartment.value = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildDropdown(
                  'Position',
                  selectedPosition,
                  'positions',
                  (value) {
                    setState(() {
                      selectedPosition = value;
                      controller.selectedPosition.value = value!;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () => pickDate(context, controller.dojController),
                child: AbsorbPointer(
                  child: buildTextField(
                      'Date of Joining', controller.dojController),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => isEditMode
                    ? controller.updateStaff(isEditMode, docId)
                    : controller.addStaff(),
                child: Text(isEditMode ? 'Update Staff' : 'Save Staff'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? selectedValue,
      String collectionName, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection(collectionName).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final items = snapshot.data!.docs
                .map((doc) => doc['name'].toString())
                .toList();
            return DropdownButton<String>(
              value: selectedValue,
              hint: Text('Select $label'),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              isExpanded: true,
            );
          },
        ),
      ],
    );
  }
}
