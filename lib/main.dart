import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/app_pages.dart';
import 'package:mrpace/config/api_config/api_keys.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/auth_management/Controller/auth_controller.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/features/coaching_course_management/controller/coaching_course_controller.dart';
import 'package:mrpace/features/course_booking_management/controller/course_booking_controller.dart';
import 'package:mrpace/features/orders_management/controller/orders_controller.dart';
import 'package:mrpace/features/payment_management/controllers/payment_controller.dart';
import 'package:mrpace/features/products_management/controller/product_controller.dart';
import 'package:mrpace/features/profile_management/controller/profile_controller.dart';
import 'package:mrpace/features/race_management/controller/race_controller.dart';
import 'package:mrpace/features/registration_management/controller/registration_controller.dart';
import 'package:mrpace/features/sports_news/controllers/sports_news_controller.dart';
import 'package:mrpace/features/training_package_management/controller/training_package_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
    url: ApiKeys.supabaseUrl,
    anonKey: ApiKeys.supabaseKey,
  );
  // Initialize the controller
  Get.put(PaymentController());
  Get.put(RegistrationController());
  Get.put(AuthController());
  Get.put(RaceController());
  Get.put(ProductController());
  Get.put(ProductCartController());
  Get.put(OrderController());
  Get.put(SportNewsController());
  Get.put(ProfileController());
  Get.put(CoachingCourseController());
  Get.put(CourseBookingController());
  Get.put(TrainingPackageController());
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
