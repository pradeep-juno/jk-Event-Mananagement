import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this for global localization
import 'package:get/get.dart';
import 'package:jk_evnt_proj/routers/app_routers.dart';
import 'package:jk_evnt_proj/utils/app_constants.dart';
import 'package:month_year_picker/month_year_picker.dart'; // Import the package for localization

import 'controllers/staffs.dart';
import 'firebase_options.dart';

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
      title: AppConstants.projectName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // Remove 'const' from here
      ],
      initialRoute: AppRouters.LOGIN_PAGE, // Initial route
      getPages: AppRouters.routes,
    );
  }
}
