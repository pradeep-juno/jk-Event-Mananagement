import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jk_evnt_proj/controllers/create_hr_controller.dart';

class AddUpdateHR extends StatefulWidget {
  @override
  _AddUpdateHRState createState() => _AddUpdateHRState();
}

class _AddUpdateHRState extends State<AddUpdateHR> {
  final HrCreateController controller = Get.put(HrCreateController());
  String? selectedDepartment = 'HR Department';
  String? selectedPosition = 'HR';
  bool isEditMode = false;
  String? docId;

  // Add this variable to toggle password visibility
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    docId = Get.arguments as String?;

    if (docId != null) {
      isEditMode = true;
      _loadHRData(docId!);
    }

    // controller.mobileController.addListener(() {
    //   validateMobileNumber(controller.mobileController.text);
    // });

    // controller.passwordController.addListener(() {
    //   validatePassword(controller.passwordController.text);
    // });
  }

  Future<void> _loadHRData(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('HrCreate').doc(id).get();
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
          selectedDepartment = data['Department'] ?? 'HR';
          selectedPosition = data['Position'] ?? 'HR';
        });
      }
    }
  }

  Future<void> validateMobileNumber(String mobileNumber) async {
    if (mobileNumber.length == 10) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('HrCreate')
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
    if (password.length < 8) {
      Get.snackbar(
          'Validation Error', 'Password must be at least 8 characters.');
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
    bool readOnly = false,
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
            obscureText: isPassword && !_isPasswordVisible,
            readOnly: readOnly, // Use readOnly here to make fields non-editable
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
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

  Future<void> _saveHRData() async {
    final data = {
      'Name': controller.nameController.text,
      'Mobile Number': controller.mobileController.text,
      'Password': controller.passwordController.text,
      'Address': controller.addressController.text,
      'DOB': controller.dobController.text,
      'Date of Joining': controller.dojController.text,
      'Department': selectedDepartment, // Save as 'HR'
      'Position': selectedPosition, // Save as 'HR'
    };

    if (isEditMode && docId != null) {
      // Update existing HR data
      await FirebaseFirestore.instance
          .collection('HrCreate')
          .doc(docId)
          .update(data);
      Get.snackbar("HR Updated", "HR details have been updated successfully.");
    } else {
      // Add new HR data
      await FirebaseFirestore.instance.collection('HrCreate').add(data);
      Get.snackbar("HR Added", "New HR has been added successfully.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit HR' : 'Add HR'),
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
                isPassword: true, // Enable password field
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
              buildTextField('Address', controller.addressController,
                  maxLines: 3),
              // Non-editable Department Field
              buildTextField(
                'Department',
                TextEditingController(text: selectedDepartment),
                readOnly: true, // Make the Department field non-editable
              ),
              // Non-editable Position Field
              buildTextField(
                'Position',
                TextEditingController(text: selectedPosition),
                readOnly: true, // Make the Position field non-editable
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
                onPressed: () {
                  print(isEditMode ? 'Updating HR' : 'Saving HR');
                  isEditMode
                      ? controller.updateHRCreate(isEditMode, docId)
                      : controller.addHrCreate();
                },
                child: Text(isEditMode ? 'Update HR' : 'Save HR'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
