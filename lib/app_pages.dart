import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/page_transitions_classes.dart';
import 'package:mrpace/features/auth_management/Screens/account_verfication.dart';
import 'package:mrpace/features/auth_management/Screens/confirm_email.dart';
import 'package:mrpace/features/auth_management/Screens/forgot_password.dart';
import 'package:mrpace/features/auth_management/Screens/sign_in.dart';
import 'package:mrpace/features/auth_management/Screens/sign_up_page.dart';
import 'package:mrpace/features/cart_management/controller/cart_controller.dart';
import 'package:mrpace/features/cart_management/screen/cart_item_detail.dart';
import 'package:mrpace/features/cart_management/screen/cart_screen.dart';
import 'package:mrpace/features/coaching_course_management/screen/all_coaching_courses_screen.dart';
import 'package:mrpace/features/coaching_course_management/screen/view_coaching_course_screen.dart';
import 'package:mrpace/features/course_booking_management/screens/all_course_booking.dart';
import 'package:mrpace/features/course_booking_management/screens/course_booking_success_screen.dart'; // Add this import
import 'package:mrpace/features/course_booking_management/screens/view_coaching_course_detail_screen.dart';
import 'package:mrpace/features/home_management/screens/home_screen.dart';
import 'package:mrpace/features/home_management/screens/main_home_page.dart'
    show MainHomePage;
import 'package:mrpace/features/orders_management/screeens/all_orders_screen.dart';
import 'package:mrpace/features/orders_management/screeens/order_detail_screen.dart';
import 'package:mrpace/features/orders_management/screeens/order_success_screen.dart';
import 'package:mrpace/features/payment_management/screens/payment_success.dart';
import 'package:mrpace/features/products_management/screens/all_products_screen.dart';
import 'package:mrpace/features/products_management/screens/product_details_screen.dart';
import 'package:mrpace/features/profile_management/screens/create_profile_screen.dart';
import 'package:mrpace/features/profile_management/screens/profile_screen.dart';
import 'package:mrpace/features/race_management/screen/all_races_screen.dart';
import 'package:mrpace/features/race_management/screen/race_details_screen.dart';
import 'package:mrpace/features/registration_management/screens/all_registration_screen.dart';
import 'package:mrpace/features/registration_management/screens/race_details_registration.dart';
import 'package:mrpace/features/registration_management/screens/success_registraion.dart';
import 'package:mrpace/features/sports_news/screen/sport_news_details_screen.dart';
import 'package:mrpace/features/sports_news/screen/sports_news_screen.dart';
import 'package:mrpace/features/training_package_management/screens/all_training_package_screen.dart';
import 'package:mrpace/features/welcome_page/splash_screen.dart';
import 'package:mrpace/models/all_order_model.dart';
import 'package:mrpace/models/all_races_model.dart';
import 'package:mrpace/models/coaching_course_model.dart';
import 'package:mrpace/models/course_booking_model.dart';
import 'package:mrpace/models/product_model.dart';
import 'package:mrpace/models/registration_model.dart';
import 'package:mrpace/models/sports_news_model.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RoutesHelper.initialScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.loginScreen,
      page: () => const Login(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.signUpScreen,
      page: () => const SignUp(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.ForgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.EmailVerificationScreen,
      page: () => const EmailVerificationScreen(email: 'uuuuuuu'),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.AccountVerificationSuccessful,
      page: () => const AccountVerificationSuccessful(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.HomePage,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.main_home_page,
      page: () => const MainHomePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.all_races_page,
      page: () => const AllRacesScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.raceDetailsPage,
      page: () {
        final race = Get.arguments as AllRacesModel;
        return RaceDetailsScreen(race: race);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.successRegistration,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return RaceRegistrationSuccess(
          raceName: args['raceName'],
          raceEvent: args['raceEvent'],
          registrationPrice: args['registrationPrice'],
          registration_number: args['registration_number'],
        );
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.paymentPage,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return PaymentSuccess(phoneNumber: args['phoneNumber']);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.profileScreen,
      page: () {
        final userId = Get.arguments as String;
        return ProfileScreen(id: userId);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.allRegistrationsPage,
      page: () => const RegisteredRacesScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.allProductsScreen,
      page: () => const AllProductsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.registrationDetailsPage,
      page: () {
        final registration = Get.arguments as RegistrationModel;
        return ViewRegistrationDetails(registration: registration);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.productDetailsScreen,
      page: () {
        final product = Get.arguments as ProductModel;
        return ProductDetailScreen(product: product);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.cartItemDetailsScreen,
      page: () {
        final product = Get.arguments as CartItem;
        return CartItemDetailsScreen(cartItem: product);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.cartScreen,
      page: () => const ProductsInCartScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.orderSuccessScreen,
      page: () => const OrderSuccessScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.allOrdersScreen,
      page: () => const AllOrderScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.orderDetailScreen,
      page: () {
        final order = Get.arguments as AllOrderModel;
        return AllOrderModelDetailScreen(order: order);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.allNewsScreen,
      page: () => const AllSportNewsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.newsDetailScreen,
      page: () {
        final newsModel = Get.arguments as SportNewsModel;
        return NewsDetailsScreen(newsModel: newsModel);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.allNewsScreen,
      page: () => const AllSportNewsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.createProfileScreen,
      page: () => const CreateProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.viewCoachingCourseDetails,
      page: () {
        final course = Get.arguments as CoachingCourseModel;
        return ViewCoachingCourseDetailsScreen(course: course);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.allCoachingCourseScreen,
      page: () => const AllCoachingCourseScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.viewCourseBookingDetails,
      page: () {
        final booking = Get.arguments as CourseBookingModel;
        return ViewCourseBookingDetailsScreen(booking: booking);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    GetPage(
      name: RoutesHelper.allCourseBookingsScreen,
      page: () => const AllCourseBookingsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),

    // Add the CourseBookingSuccess route
    GetPage(
      name: RoutesHelper.coachingCourseBookingSuccess,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return CourseBookingSuccess(
          courseName: args['courseName'],
          bookingPrice: args['bookingPrice'],
          courseBookingId: args['courseBookingId'],
        );
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
    GetPage(
      name: RoutesHelper.trainingPackagesScreen,
      page: () => const AllTrainingPackagesScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomPageTransition(),
    ),
  ];
}
