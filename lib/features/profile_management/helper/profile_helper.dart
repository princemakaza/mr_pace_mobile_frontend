import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/profile_management/controller/profile_controller.dart';
import 'package:mrpace/models/create_profile_model.dart';
import 'package:mrpace/models/profile_model.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:flutter/material.dart';

class ProfileHelper {
  final ProfileController _profileController = Get.find();

  Future<bool> createProfile(CreateProfileModel model) async {
    final data = model.toMap();

    // 🔒 Required fields validation based on your mongoose schema
    if (data['userId'] == null || data['userId'].toString().isEmpty) {
      return _showError('User ID is required');
    }
    if (data['firstName'] == null || data['firstName'].toString().isEmpty) {
      return _showError('First name is required');
    }
    if (data['lastName'] == null || data['lastName'].toString().isEmpty) {
      return _showError('Last name is required');
    }
    if (data['nationalId'] == null || data['nationalId'].toString().isEmpty) {
      return _showError('National ID is required');
    }
    if (data['phoneNumber'] == null || data['phoneNumber'].toString().isEmpty) {
      return _showError('Phone number is required');
    }
    if (data['tShirtSize'] == null || data['tShirtSize'].toString().isEmpty) {
      return _showError('T-shirt size is required');
    }

    Get.dialog(
      const CustomLoader(message: 'Creating profile...'),
      barrierDismissible: false,
    );

    try {
      DevLogs("userId: ${data['userId']}");

      final response = await _profileController.createProfile(model);
      Get.back(); // Close loader

      if (response.success) {
        DevLogs.logInfo("Profile created: ${response.data}");
        Get.snackbar(
          'Success',
          'Profile created successfully',
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: AppColors.primaryColor,
        );
        Get.toNamed(RoutesHelper.main_home_page);
        // TODO: Navigate to profile success screen
        // Example:
        // Get.to(ProfileSuccessScreen(profileId: response.data ?? ""));
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      return _showError('Failed to create profile: ${e.toString()}');
    }
  }



  Future<bool> updateProfile(ProfileModel model) async {
    final data = model.toMap();

    // 🔒 Required fields validation based on your mongoose schema
    if (data['userId'] == null || data['userId'].toString().isEmpty) {
      return _showError('User ID is required');
    }
    if (data['firstName'] == null || data['firstName'].toString().isEmpty) {
      return _showError('First name is required');
    }
    if (data['lastName'] == null || data['lastName'].toString().isEmpty) {
      return _showError('Last name is required');
    }
    if (data['nationalId'] == null || data['nationalId'].toString().isEmpty) {
      return _showError('National ID is required');
    }
    if (data['phoneNumber'] == null || data['phoneNumber'].toString().isEmpty) {
      return _showError('Phone number is required');
    }
    if (data['tShirtSize'] == null || data['tShirtSize'].toString().isEmpty) {
      return _showError('T-shirt size is required');
    }

    Get.dialog(
      const CustomLoader(message: 'Creating profile...'),
      barrierDismissible: false,
    );

    try {
      DevLogs("userId: ${data['userId']}");

      final response = await _profileController.updateProfile(model);
      Get.back(); // Close loader

      if (response.success) {
        DevLogs.logInfo("Profile updated: ${response.data}");
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: AppColors.primaryColor,
        );
        Get.toNamed(RoutesHelper.main_home_page);
        // TODO: Navigate to profile success screen
        // Example:
        // Get.to(ProfileSuccessScreen(profileId: response.data ?? ""));
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      return _showError('Failed to update profile: ${e.toString()}');
    }
  }

  bool _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primaryColor,
    );
    return false;
  }
}
