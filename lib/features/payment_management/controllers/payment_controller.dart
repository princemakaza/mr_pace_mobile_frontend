import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/payment_management/services/payment_services.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;
  var paymentStatus = ''.obs; // <-- Store "paid", "pending", etc.
  var registrationNumber = ''.obs; // <-- Store registration number if needed

  Future<APIResponse<String>> submitPayment(
    String registrationNumber,
    String phoneNumber,
  ) async {
    try {
      isLoading(true);
      final response = await PaymentService.submitPayment(
        registrationNumber: registrationNumber,
        phoneNumber: phoneNumber,
      );

      if (response.success) {
        successMessage.value = response.message!;
        return response;
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error submitting payment: ${e.toString()}');
      errorMessage.value =
          'An error occurred while submitting payment: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Method to check payment statusvar paymentStatus = ''.obs;

  Future<APIResponse<Map<String, dynamic>>> checkPaymentStatus(
    String pollUrl,
    String id, // <-- Add id parameter if needed
  ) async {
    try {
      isLoading(true);
      final response = await PaymentService.checkPaymentStatus(
        pollUrl: pollUrl,
        id: id, // <-- Pass id to the service method
      );

      if (response.success && response.data != null) {
        paymentStatus.value = response.data!['status'] ?? '';
        registrationNumber.value = response.data!['registration_number'] ?? '';
        successMessage.value = response.message ?? '';
        DevLogs.logInfo("Payment Status: ${paymentStatus.value}");
        DevLogs.logInfo("Registration Number: ${registrationNumber.value}");
        return response;
      } else {
        DevLogs.logError('Failed to check payment status: ${response.message}');
        errorMessage.value =
            response.message ?? 'Failed to check payment status';
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error checking payment status: ${e.toString()}');
      errorMessage.value =
          'An error occurred while checking payment status: ${e.toString()}';
      return APIResponse<Map<String, dynamic>>(
        success: false,
        message: errorMessage.value,
      );
    } finally {
      isLoading(false);
    }
  }
}
