import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/app_pages.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/auth_management/Controller/auth_controller.dart';
import 'package:mrpace/features/payment_management/controllers/payment_controller.dart';
import 'package:mrpace/features/race_management/controller/race_controller.dart';
import 'package:mrpace/features/registration_management/controller/registration_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the controller
  Get.put(PaymentController());
  Get.put(RegistrationController());
  Get.put(AuthController());
  Get.put(RaceController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotion Desktop App',
      theme: Pallete.appTheme,
      initialRoute: '/',
      getPages: AppPages.pages,
    );
  }
}
