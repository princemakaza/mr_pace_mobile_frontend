import 'package:get/get.dart';
import 'package:mrpace/features/auth_management/Services/auth_services.dart';

import '../../../core/utils/logs.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Observable list for fetched trips
  Future<bool> authSignInRequest({
    required String emailAddress,
    required String password,
  }) async {
    try {
      isLoading(true);
      final response = await AuthServices.login(
        emailAddress: emailAddress,
        password: password,
      );
      if (response.success) {
        successMessage.value = response.message!;
        // await fetchAllShuttlesForClient();
        return true;
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return false;
      }
    } catch (e) {
      DevLogs.logError('Error logging in user: ${e.toString()}');
      errorMessage.value =
          'An error on logging on user  ${e.toString()}';
      return false;
    } finally {
      isLoading(false); // End loading
    }
  }
}
