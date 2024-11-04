// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this for global localization
import 'package:get/get.dart';
import 'package:jk_evnt_proj/page/designs.dart';
import 'package:jk_evnt_proj/screens/month_end_closing_page.dart';
import 'package:jk_evnt_proj/screens/staffs_page.dart';
import 'package:month_year_picker/month_year_picker.dart'; // Import the package for localization

import 'controllers/staffs.dart';
import 'firebase_options.dart';
import 'screens/departments_page.dart';
import 'screens/positions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase

  // Initialize the Staffs controller at the start of the app
  Get.put(Staffs());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JK Event Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // Remove 'const' from here
      ],
      getPages: [
        GetPage(name: '/departments', page: () => DepartmentsPage()),
        GetPage(name: '/positions', page: () => PositionsPage()),
        GetPage(name: '/staffs', page: () => StaffPage()), // Updated route
        GetPage(name: '/monthEnd', page: () => MonthEndClosingPage()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Replacing AppBar with a custom Container
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            color: Colors.blue, // Set background color
            width: double.infinity,
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
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EventCard(name: 'Departments', route: '/departments'),
                  EventCard(name: 'Positions', route: '/positions'),
                  EventCard(name: 'Create Staffs', route: '/staffs'),
                  EventCard(name: 'Month End Closing', route: '/monthEnd'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
