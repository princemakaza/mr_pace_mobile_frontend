// import 'package:care453/core/utils/colors/pallete.dart';
// import 'package:care453/features/auth/Screens/create_password.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// import '../Screens/contact_details_screen.dart';
// import '../Screens/medical_detail_screen.dart';

// class RegisterHelper {
//   void validateRegisterOne(
//       {required String first_name,
//       required String last_name,
//       required String date_of_birth,
//       required String gender}) async {
//     // Validation checks as before...

//     if (first_name.isEmpty) {
//       Get.snackbar('Validation Failed', 'First name is required',
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds

//           backgroundColor: Pallete.originBlue);
//       return;
//     }
//     if (last_name.isEmpty) {
//       Get.snackbar('Validation Failed', 'Last name is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (date_of_birth.isEmpty) {
//       Get.snackbar('Validation Failed', 'Date of birth is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds

//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     Get.to(ContactDetailsScreen(
//       first_name: first_name,
//       last_name: last_name,
//       date_of_birth: date_of_birth,
//       gender: gender,
//     ));
//   }

//   void validateRegisterTwo(
//       {required String address,
//       required String phone_number,
//       required String email,
//       required String profile_picture,
//       required String first_name,
//       required String last_name,
//       required String date_of_birth,
//       required String gender}) async {
//     // Validation checks...

//     if (address.isEmpty) {
//       Get.snackbar('Validation Failed', 'Address is required',
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (phone_number.isEmpty) {
//       Get.snackbar('Validation Failed', 'Phone number is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (phone_number.length > 13) {
//       Get.snackbar(
//           'Validation Failed', 'Phone number cannot exceed 13 characters.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (email.isEmpty) {
//       Get.snackbar('Validation Failed', 'Email is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (profile_picture.isEmpty) {
//       Get.snackbar('Validation Failed', 'Profile picture is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }
//     // Email validation using regex
//     final emailRegex =
//         RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
//     if (!emailRegex.hasMatch(email)) {
//       Get.snackbar('Validation Failed', 'Please enter a valid email address.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10),
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     Get.to(MedicalDetailScreen(
//         address: address,
//         phone_number: phone_number,
//         email: email,
//         profile_picture: profile_picture,
//         first_name: first_name,
//         last_name: last_name,
//         date_of_birth: date_of_birth,
//         gender: gender));
//   }

//   void validateRegisterThree(
//       {required String allergies,
//       required String medicalHistory,
//       required String medicalAidInfo,
//       required String address,
//       required String phone_number,
//       required String email,
//       required String profile_picture,
//       required String first_name,
//       required String last_name,
//       required String date_of_birth,
//       required String gender}) async {
//     // Validation checks as before...

//     if (allergies.isEmpty) {
//       Get.snackbar('Validation Failed', 'Allergies is required',
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds
//           backgroundColor: Pallete.originBlue);
//       return;
//     }
//     if (medicalHistory.isEmpty) {
//       Get.snackbar('Validation Failed', 'Medical History is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds
//           backgroundColor: Pallete.originBlue);
//       return;
//     }

//     if (medicalAidInfo.isEmpty) {
//       Get.snackbar('Validation Failed', 'Medical Aid Information is required.',
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 10), // Set the duration to 10 seconds

//           backgroundColor: Pallete.originBlue);
//       return;
//     }
//     Get.to(CreatePasswordScreen(email: email, first_name: first_name, last_name: last_name, date_of_birth: date_of_birth, gender: gender, address: address, phone_number: phone_number, profile_picture: profile_picture, allergies: allergies, medicalHistory: medicalHistory, medicalAidInfo: medicalAidInfo));
//   }
// }
