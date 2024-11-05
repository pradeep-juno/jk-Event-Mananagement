import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatting
import 'package:get/get.dart';
import 'package:jk_evnt_proj/screens/super_admin/super_admin_homepage.dart';

import 'hr/hr_home_page.dart';

class JKLoginPage extends StatefulWidget {
  @override
  _JKLoginPageState createState() => _JKLoginPageState();
}

class _JKLoginPageState extends State<JKLoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String correctMobile = '1234567890';
  final String correctPassword = 'asdfghjkl';

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Static login check for Super Admin
      if (_mobileController.text == correctMobile &&
          _passwordController.text == correctPassword) {
        Get.to(() => SuperAdminHomePage()); // Navigate to SuperAdminLoginPage
        Get.snackbar(
          'SUCCESS',
          'Super Admin Login Successfully',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // Firestore instance to fetch staff data
      final firestore = FirebaseFirestore.instance;
      final staffCollection = firestore.collection('staffs');

      // Fetch document(s) with matching mobile number
      final querySnapshot = await staffCollection
          .where('mobileNo', isEqualTo: _mobileController.text)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final staffData = querySnapshot.docs.first.data();
        print("HR Login...");
        print("MobileNumber : ${_mobileController.text}");
        print("Password : ${_passwordController.text}");
        print("Firestore Password: ${staffData['password']}");

        if (staffData['password'] == _passwordController.text) {
          String position = staffData['position'];

          if (position == 'HR') {
            Get.to(() => HRHomePage());
            Get.snackbar(
              'SUCCESS',
              'HR Login Successfully',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Error',
              'Unauthorized position',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Invalid password',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Invalid mobile number',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
