// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jk_evnt_proj/screens/month_end_closing_page.dart';

import 'firebase_options.dart';
import 'screens/departments_page.dart';
import 'screens/positions_page.dart';
import 'screens/staffs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
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
      getPages: [
        GetPage(name: '/departments', page: () => DepartmentsPage()),
        GetPage(name: '/positions', page: () => PositionsPage()),
        GetPage(name: '/staffs', page: () => StaffPage()),
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
      appBar: AppBar(
        title: const Text('JK Event Management'),
      ),
      body: Center(
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
    );
  }
}

class EventCard extends StatelessWidget {
  final String name;
  final String route;

  const EventCard({required this.name, required this.route, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
