import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/registration_management/controller/registration_controller.dart';
import 'package:mrpace/features/registration_management/screens/success_registraion.dart';
import 'package:mrpace/models/submit_registration_model.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';
import 'package:flutter/material.dart';

class RaceRegistrationHelper {
  final RegistrationController _registrationController = Get.find();

  Future<bool> submitRaceRegistration(SubmitRegistrationModel model) async {
    final data = model.toMap();

    // Validation
    if (data['firstName'].isEmpty) return _showError('First name is required');
    if (data['lastName'].isEmpty) return _showError('Last name is required');
    if (data['raceEvent'].isEmpty) return _showError('Race event is required');
    if (data['dateOfBirth'].isEmpty)
      return _showError('Date of birth is required');
    if (data['nationalID'].isEmpty)
      return _showError('National ID is required');
    if (data['Gender'].isEmpty) return _showError('Gender is required');
    if (data['phoneNumber'].isEmpty)
      return _showError('Phone number is required');
    if (data['email'].isEmpty) return _showError('Email is required');
    if (!GetUtils.isEmail(data['email']))
      return _showError('Please enter a valid email');
    if (data['t_shirt_size'].isEmpty)
      return _showError('T-shirt size is required');
    Get.dialog(
      const CustomLoader(message: 'Submitting registration...'),
      barrierDismissible: false,
    );

    try {
          DevLogs("userId: ${data['userId']}");

      final response = await _registrationController.submitRegistration(model);
      Get.back(); // Close loader

      if (response.success) {
        DevLogs.logInfo("Registration: "+response.data.toString());  
        Get.to(
          RaceRegistrationSuccess(
            raceName: model.raceName,
            raceEvent: model.raceEvent,
            registrationPrice: model.racePrice.toString(),
            registration_number:
                response.data ?? "", // Pass the registration number
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.back();
      return _showError('Failed to submit registration: ${e.toString()}');
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
