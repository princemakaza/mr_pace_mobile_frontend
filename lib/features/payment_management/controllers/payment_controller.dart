import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/payment_management/services/payment_services.dart';
import 'package:mrpace/models/check_status_training_payment.dart';

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

  // 🚀 New function for course booking payments
  Future<APIResponse<String>> submitCoursebookingPayment(
    String courseBookingId,
    String phoneNumber,
  ) async {
    try {
      isLoading(true);
      final response = await PaymentService.submitCoursebookingPayment(
        courseBookingId: courseBookingId,
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
      DevLogs.logError(
        'Error submitting course booking payment: ${e.toString()}',
      );
      errorMessage.value =
          'An error occurred while submitting course booking payment: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<APIResponse<String>> submitTrainingPackageBuyCoffee(
    String training_package_bought_id,
    String phoneNumber,
  ) async {
    try {
      isLoading(true);
      final response = await PaymentService.submitTrainingPacakagePayment(
        purchaseId: training_package_bought_id,
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
      DevLogs.logError(
        'Error submitting course booking payment: ${e.toString()}',
      );
      errorMessage.value =
          'An error occurred while submitting course booking payment: ${e.toString()}';
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

  // Optional: Method to refresh payment status
  Future<APIResponse<String>> submitOrderPayment(
    String orderId,
    String phoneNumber,
  ) async {
    try {
      isLoading(true);
      final response = await PaymentService.submitOrderPayment(
        orderId: orderId,
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

  // Add observable for payment status checking
  var isCheckingPayment = false.obs;
  var paymentStatusResponse = Rxn<CheckStatusTrainingPaymentModel>();

  /// Check training package payment status
  Future<void> checkTrainingPackagePaymentStatus({
    required String pollUrl,
    required String trainingPackageBoughtId,
  }) async {
    try {
      isCheckingPayment(true);
      errorMessage.value = '';
      successMessage.value = '';

      final response = await PaymentService.checkTrainingPackageModelPaymentStatus(
        pollUrl: pollUrl,
        training_package_bought: trainingPackageBoughtId,
      );

      paymentStatusResponse.value = response;

      if (response.status == 'success' || response.status == 'completed') {
        successMessage.value = response.message ?? 'Payment verified successfully';
        DevLogs.logInfo('Payment status check success: ${response.purchaseId}');
      } else {
        errorMessage.value = response.message ?? 'Payment verification failed';
        DevLogs.logError('Payment status check failed: ${response.message}');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while checking payment status: ${e.toString()}';
      DevLogs.logError('Error in checkTrainingPackagePaymentStatus: $e');
    } finally {
      isCheckingPayment(false);
    }
  }

}
