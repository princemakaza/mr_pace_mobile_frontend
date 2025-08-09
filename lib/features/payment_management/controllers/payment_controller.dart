import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/features/payment_management/services/payment_services.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  Future<APIResponse<String>> submitPayment(String registrationNumber, String phoneNumber) async {
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
      errorMessage.value = 'An error occurred while submitting payment: ${e.toString()}';
      return APIResponse<String>(
        success: false,
        message: errorMessage.value,
      );
    } finally {
      isLoading(false);
    }
  }
}
