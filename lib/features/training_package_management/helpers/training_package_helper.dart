import 'package:get/get.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/payment_management/screens/training_package_buy_coffee.dart';
import 'package:mrpace/features/training_package_management/controller/training_package_controller.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:flutter/material.dart';

class TrainingPackageHelper {
  final TrainingPackageController _trainingPackageController = Get.find();

  Future<bool> submitTrainingPackage({
    required String userId,
    required double pricePaid,
    required String trainingPackageId,
  }) async {
    // Get the selected package from controller

    Get.dialog(
      const CustomLoader(message: 'Submitting training package...'),
      barrierDismissible: true,
    );

    try {
      DevLogs("userId: $userId");
      DevLogs("pricePaid: $pricePaid");

      // Call createTrainingBought from the controller
      await _trainingPackageController.createTrainingBought(
        userId: userId,
        trainingProgramPackageId: trainingPackageId, // Using package id
        pricePaid: pricePaid,
      );

      Get.back(); // Close loader

      // Check controller's response state
      if (_trainingPackageController.errorMessage.isNotEmpty) {
        _showError(
          'Purchase Failed',
          _trainingPackageController.errorMessage.value,
        );
        return false;
      }

      final purchaseResponse =
          _trainingPackageController.trainingPurchaseResponse.value;
      if (purchaseResponse != null && purchaseResponse.id != null) {
        DevLogs.logInfo("Purchase successful: ${purchaseResponse.id}");

        // Show success dialog with the purchase ID
        Get.dialog(
          TrainingPackageBuyCoachCoffeeDialog(
            userId: userId,
            trainingProgramPackageId: purchaseResponse.id!, // ID from response
            pricePaid: pricePaid.toString(),
          ),
        );
        return true;
      }

      _showError('Error', 'Unexpected response. Please try again.');
      return false;
    } catch (e) {
      Get.back();
      _showError('Error', 'Failed to submit training package: ${e.toString()}');
      return false;
    }
  }

  bool _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    );
    return false;
  }

  bool _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primaryColor,
    );
    return false;
  }
}
