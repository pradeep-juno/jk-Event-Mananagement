import 'package:get/get.dart';
import 'package:jk_evnt_proj/screens/hr/hr_departments_page.dart';
import 'package:jk_evnt_proj/screens/hr/hr_month_end_closing_page.dart';
import 'package:jk_evnt_proj/screens/hr/hr_positions_page.dart';
import 'package:jk_evnt_proj/screens/jk_login_page.dart';

import '../screens/hr/hr_home_page.dart';
import '../screens/super_admin/hr_creation_page.dart';
import '../screens/super_admin/super_admin_homepage.dart';

class AppRouters {
  //SuperAdmin - HR - Accountants
  static const LOGIN_PAGE = "/jk-login-page";

  //Super Admin Routers

  static const SUPER_ADMIN_HOME_PAGE = "/sa-homepage";

  //HR Routers

  static const HR_HOME_PAGE = "/hr-homepage";
  static const HR_DEPARTMENT_PAGE = "/hr-department-page";
  static const HR_POSITION_PAGE = "/hr-position-page";
  static const HR_STAFF_CREATION = "/hr-staff-creation-page";
  static const HR_MONTH_END_CLOSING_PAGE = "/hr-month-end-closing-page";
  static const HR_CREATION_PAGE = "/hr-creation-page";

  static final routes = [
    GetPage(
      name: LOGIN_PAGE,
      page: () => JKLoginPage(),
    ),
    GetPage(
      name: SUPER_ADMIN_HOME_PAGE,
      page: () => SuperAdminHomePage(),
    ),
    GetPage(
      name: HR_HOME_PAGE,
      page: () => HRHomePage(),
    ),
    GetPage(
      name: HR_DEPARTMENT_PAGE,
      page: () => HRDepartmentsPage(),
    ),
    GetPage(
      name: HR_POSITION_PAGE,
      page: () => HRPositionsPage(),
    ),
    GetPage(
      name: HR_MONTH_END_CLOSING_PAGE,
      page: () => HRMonthEndClosingPage(),
    ),
    GetPage(
      name: HR_CREATION_PAGE, // Register the new HR Creation page
      page: () => HrCreationPage(),
    ),
  ];
}
