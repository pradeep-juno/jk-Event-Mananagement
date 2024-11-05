import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_evnt_proj/screens/jk_login_page.dart';

import 'hr_creation_page.dart';

class SuperAdminHomePage extends StatelessWidget {
  const SuperAdminHomePage({super.key});

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
                        'Super Admin',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Login Page',
                        style: TextStyle(
                          fontSize: 20,
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
                          'Super Admin Logout',
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
              child: EventCard(
                name: 'Create HR',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EventCard widget without route parameter
class EventCard extends StatelessWidget {
  final String name;

  const EventCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => HrCreationPage()), // Navigate to HrCreationPage directly
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
