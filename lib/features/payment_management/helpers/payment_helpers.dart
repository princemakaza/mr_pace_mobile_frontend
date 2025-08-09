import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/controllers/payment_controller.dart';
import 'package:mrpace/features/payment_management/screens/payment_success.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';

class PaymentHelper {
  final PaymentController _paymentController = Get.find();

  Future<bool> submitPayment({
    required String registrationNumber,
    required String phoneNumber,
  }) async {
    if (registrationNumber.isEmpty) {
      return _showError('Registration number is required');
    }
    if (phoneNumber.isEmpty) {
      return _showError('Phone number is required');
    }

    Get.dialog(
      const CustomLoader(message: 'Submitting payment...'),
      barrierDismissible: false,
    );

    try {
      final response = await _paymentController.submitPayment(
        registrationNumber,
        phoneNumber,
      );
      Get.back(); // Close loader

      if (response.success) {
        DevLogs.logInfo("Payment: ${response.data}");
        DevLogs.logInfo("Registration: " + response.data.toString());
        Get.offNamed(
          RoutesHelper.paymentPage,
          arguments: {'phoneNumber': phoneNumber},
        );
        // Optionally navigate to a success page here
        return true;
      }
      return _showError(response.message ?? 'Payment failed');
    } catch (e) {
      Get.back();
      return _showError('Failed to submit payment: ${e.toString()}');
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
