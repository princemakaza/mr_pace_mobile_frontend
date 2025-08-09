import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:mrpace/features/auth_management/Controller/auth_controller.dart';

class AuthHelper {
  static final AuthController _authController = Get.find<AuthController>();

  static Future<bool> validateAndSubmitForm({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.isEmpty) {
      showError('Email is required.');
      return false;
    }

    // Validate email format
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(email.trim())) {
      showError('Invalid email format.');
      return false;
    }

    if (password.isEmpty) {
      showError('Password is required.');
      return false;
    }

    if (password.length < 8) {
      showError('Password must be at least 8 characters long.');
      return false;
    }

    // Call the authentication service
    try {
      return await _authController.authSignInRequest(
        emailAddress: email,
        password: password,
      );
    } catch (e) {
      showError('An error occurred during login: ${e.toString()}');
      return false;
    }
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.errorColor,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}