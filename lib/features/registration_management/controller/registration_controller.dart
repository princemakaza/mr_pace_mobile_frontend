import 'package:get/get.dart';
import 'package:mrpace/core/utils/api_response.dart';
import 'package:mrpace/models/registration_model.dart';
import 'package:mrpace/models/submit_registration_model.dart';
import '../../../core/utils/logs.dart';
import '../services/registration_service.dart';

class RegistrationController extends GetxController {
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  // Add these new properties for search functionality
  final RxString searchQuery = ''.obs;
  final RxString searchType = 'fullName'.obs; // 'fullName' or 'raceName'

  Future<APIResponse<String>> submitRegistration(
    SubmitRegistrationModel model,
  ) async {
    try {
      isLoading(true);
      final response = await RegistrationService.submitRaceRegistration(model);
      if (response.success) {
        successMessage.value = response.message!;
        return response; // Return the full response
      } else {
        errorMessage.value = response.message!;
        DevLogs.logError(errorMessage.value);
        return response;
      }
    } catch (e) {
      DevLogs.logError('Error submitting registration: ${e.toString()}');
      errorMessage.value =
          'An error occurred while submitting registration: ${e.toString()}';
      return APIResponse<String>(success: false, message: errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Observable list for registered races
  var registeredRaces = <RegistrationModel>[].obs;

  // Fetch registered races by user ID
  Future<void> fetchRegisteredRacesByUserId(String id) async {
    try {
      isLoading(true);
      final response = await RegistrationService.fetchRegisteredRacesByUserId(
        id,
      );

      if (response.success) {
        registeredRaces.value = response.data ?? [];
        successMessage.value =
            response.message ?? 'Registered races loaded successfully';
      } else {
        errorMessage.value = response.message!;
      }
    } catch (e) {
      DevLogs.logError('Error fetching registered races: ${e.toString()}');
      errorMessage.value =
          'An error occurred while fetching registered races: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  // Optional: refresh method
  Future<void> refreshRegisteredRaces(String id) async {
    await fetchRegisteredRacesByUserId(id);
  }

  // Computed property to get filtered registrations
  List<RegistrationModel> get filteredRegistrations {
    if (searchQuery.value.isEmpty) {
      return registeredRaces;
    }

    return registeredRaces.where((registration) {
      final query = searchQuery.value.toLowerCase();

      switch (searchType.value) {
        case 'fullName':
          final fullName = '${registration.firstName} ${registration.lastName}'
              .toLowerCase();
          return fullName.contains(query);
        case 'raceName':
          return registration.raceName.toLowerCase().contains(query);
        default:
          return false;
      }
    }).toList();
  }

  // Method to update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Method to update search type
  void updateSearchType(String type) {
    searchType.value = type;
    // Optionally clear search when switching types
    // searchQuery.value = '';
  }

  // Method to clear search
  void clearSearch() {
    searchQuery.value = '';
  }
}
