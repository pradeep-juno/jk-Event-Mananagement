import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_evnt_proj/screens/hr/hr_departments_page.dart';
import 'package:jk_evnt_proj/screens/hr/hr_month_end_closing_page.dart';
import 'package:jk_evnt_proj/screens/hr/hr_positions_page.dart';
import 'package:jk_evnt_proj/screens/hr/hr_staff/hr_staff_creations_page.dart';
import 'package:jk_evnt_proj/screens/jk_login_page.dart';

import '../../ui_design/designs.dart';

class HRHomePage extends StatelessWidget {
  const HRHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            color: Colors.blue, // Set background color
            width: double.infinity,
            child: Stack(
              children: [
                // Centered title
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'JK',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Event Management',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Logout icon positioned in the top right corner
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      // Show a confirmation dialog before logging out
                      bool? confirmLogout = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Logout"),
                            content:
                                const Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // User canceled logout
                                },
                              ),
                              TextButton(
                                child: const Text("Logout"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // User confirmed logout
                                },
                              ),
                            ],
                          );
                        },
                      );

                      // If the user confirmed, proceed with logout
                      if (confirmLogout == true) {
                        Get.snackbar(
                          'HR Logout',
                          'You have successfully logged out',
                          backgroundColor: Colors.blueAccent,
                          colorText: Colors.white,
                        );
                        Get.offAll(() =>
                            JKLoginPage()); // Navigate to login page and clear stack
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EventCard(name: 'Departments', route: HRDepartmentsPage()),
                  EventCard(name: 'Positions', route: HRPositionsPage()),
                  EventCard(
                      name: 'Create Staffs', route: HrStaffCreationsPage()),
                  EventCard(
                      name: 'Month End Closing',
                      route: HRMonthEndClosingPage()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
