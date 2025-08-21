import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/models/create_profile_model.dart';
import 'package:mrpace/models/profile_model.dart' show ProfileModel;
import '../../../core/utils/logs.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  Future<APIResponse<String>> createProfile(CreateProfileModel model) async {
    try {
      isLoading(true);
      final response = await ProfileService.createProfile(model);
      if (response.success) {
        successMessage.value = response.message!;
        return response; // Return the full response
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error creating profile: ${e.toString()}');
      errorMessage.value =
          'An error occurred while creating profile: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }


    Future<APIResponse<String>> updateProfile(ProfileModel model) async {
    try {
      isLoading(true);
      final response = await ProfileService.updateProfile(model);
      if (response.success) {
        successMessage.value = response.message!;
        return response; // Return the full response
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error Updating  profile: ${e.toString()}');
      errorMessage.value =
          'An error occurred while updating  profile: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Observable profile object
  var profile = Rxn<ProfileModel>();

  // Fetch profile by user ID
  Future<void> fetchProfileByUserId(String id) async {
    try {
      isLoading(true);
      final response = await ProfileService.fetchProfileByUserId(id);

      if (response.success) {
        profile.value = response.data;
        successMessage.value =
            response.message ?? 'Profile loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching profile: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching profile: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  // Optional: refresh method
  Future<void> refreshProfile(String id) async {
    await fetchProfileByUserId(id);
  }
}
